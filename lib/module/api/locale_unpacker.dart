import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nikke_einkk/model/data_path.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:path/path.dart';
import 'package:pointycastle/export.dart' as crypto;
import 'package:sqflite/sqflite.dart';

class LocaleUnpackerPage extends StatelessWidget {
  const LocaleUnpackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locale Unpacker')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text('Select the locale directory', style: TextStyle(fontSize: 20)),
            Text(
              '- If on windows, locale files are located in LocalLow folder of appdata: '
              '`%USERPROFILE%/AppData/LocalLow/com_proximabeta/NIKKE/saus/saus/lss`',
            ),
            FilledButton(
              onPressed: () async {
                final localeFolderPath = join(
                  Platform.environment['USERPROFILE'] ?? '.',
                  'AppData',
                  'LocalLow',
                  'com_proximabeta',
                  'NIKKE',
                  'saus',
                  'saus',
                  'lss',
                );

                final localeDir = Directory(localeFolderPath);
                final selectResult = await FilePicker.platform.getDirectoryPath(
                  dialogTitle: 'Select Locale Directory',
                  initialDirectory: localeDir.existsSync() ? localeFolderPath : null,
                );

                if (selectResult == null) {
                  return;
                }

                final path = selectResult;
                final outputPath = join(appPath, 'data', 'Locale');
                final dir = Directory.fromUri(Uri.file(path));
                if (!dir.existsSync()) {
                  EasyLoading.showInfo('Input folder $path does not exist');
                  return;
                }

                final allFilePaths = dir.listSync(recursive: true);
                final archive = Archive();
                for (final (i, filePath) in dir.listSync(recursive: true).indexed) {
                  EasyLoading.showProgress(
                    (i + 1) / allFilePaths.length,
                    status: 'Reading Locale ${i + 1}/${allFilePaths.length}',
                    maskType: EasyLoadingMaskType.clear,
                  );
                  await Future.delayed(const Duration(milliseconds: 5));
                  final inputFile = File(filePath.path);
                  if (!filePath.path.endsWith('lsc') || inputFile.statSync().type != FileSystemEntityType.file) {
                    continue;
                  }

                  final fileName = inputFile.uri.pathSegments.last.split('.').first;
                  final outputFile = File(join(outputPath, fileName, '$fileName.db'));
                  if (!outputFile.parent.existsSync()) {
                    outputFile.parent.createSync(recursive: true);
                  }
                  final unpacker = LocaleUnpacker(inputFile: inputFile, outputFile: outputFile);
                  unpacker.unpack();

                  logger.d('Output: ${outputFile.absolute.path}');
                  final db = await openReadOnlyDatabase(outputFile.absolute.path);
                  final tables = await db.query('sqlite_master');
                  for (final table in tables) {
                    if (table['type'] == 'table') {
                      final tableName = table['tbl_name']! as String;
                      final result = await db.query(tableName);

                      final jsonFile = File(join(outputPath, fileName, '$tableName.json'));
                      final jsonEncoder = JsonEncoder.withIndent('  ');
                      final json = jsonEncoder.convert(result);
                      await jsonFile.writeAsString(json);

                      final bytes = utf8.encode(json);
                      archive.addFile(ArchiveFile('$fileName/$tableName.json', bytes.length, bytes));
                    }
                  }
                  await db.close();
                  await outputFile.delete();
                }
                final zipData = ZipEncoder().encode(archive);
                final zipPath = join(appPath, 'data', 'global', 'Locale.zip');
                final zipFile = File(zipPath);
                if (zipFile.existsSync()) zipFile.deleteSync();
                if (zipData != null) {
                  zipFile.writeAsBytesSync(zipData);
                }

                await EasyLoading.dismiss();
                locale.init();
                await EasyLoading.showInfo('Success');
              },
              child: Text('Select Directory And Unpack'),
            ),
          ],
        ),
      ),
    );
  }
}

class LocaleUnpacker {
  final File inputFile;
  final File outputFile;
  final Uint8List bytes;
  int position = 32;
  late NikkeLocaleHeader header;
  int get lengthByteCount => (header.segmentSize * header.segmentCount > 0xFFFFFFFF) ? 5 : 4;

  LocaleUnpacker({required this.inputFile, required this.outputFile}) : bytes = inputFile.readAsBytesSync() {
    final reader = ByteData.sublistView(bytes, 0, position);
    header = NikkeLocaleHeader(
      magic: bytes.sublist(0, 4),
      version: reader.getInt32(4),
      aesKey: bytes.sublist(8, 24),
      segmentSize: reader.getInt32(24),
      segmentCount: reader.getInt32(28),
    );
  }

  int readOffset() {
    var offset = 0;
    for (var i = 0; i < lengthByteCount; i++) {
      offset = (offset << 8) | bytes[position++];
    }
    return offset;
  }

  bool unpack() {
    if (header.magic != 'NKDB') {
      throw Exception('File ${inputFile.path} has invalid magic: ${header.magic}');
    }

    int currentOffset = readOffset();
    final segments = List<(int, int, int)>.generate(header.segmentCount, (i) {
      final nextOffset = readOffset();
      final segment = (currentOffset, nextOffset - currentOffset, i);
      currentOffset = nextOffset;
      return segment;
    });

    final output = outputFile.openSync(mode: FileMode.write);

    for (final (offset, length, index) in segments) {
      final segment = bytes.sublist(offset, offset + length);

      final iv = Uint8List(16);
      final indexBytes = ByteData(4)..setUint32(0, index, Endian.little);
      final offsetBytes = ByteData(4)..setUint32(0, offset, Endian.little);
      iv.setRange(0, 4, indexBytes.buffer.asUint8List());
      iv.setRange(4, 8, offsetBytes.buffer.asUint8List());

      final decrypted = decryptAESOFB(header.aesKey, iv, segment);
      final decompressed = ZLibDecoder().decodeBytes(decrypted);
      output.writeFromSync(decompressed);
    }

    output.closeSync();

    return true;
  }

  Uint8List decryptAESOFB(Uint8List key, Uint8List iv, Uint8List input) {
    final engine = crypto.AESEngine();
    final cipher = crypto.OFBBlockCipher(engine, engine.blockSize)
      ..init(false, crypto.ParametersWithIV(crypto.KeyParameter(key), iv));

    final output = Uint8List(input.length);
    for (int offset = 0; offset < input.length; offset += cipher.blockSize) {
      final chunkEnd = offset + cipher.blockSize;
      final isLastChunk = chunkEnd >= input.length;

      if (isLastChunk) {
        // Handle PKCS#7 padding for the last block
        final finalInputBlock = Uint8List(cipher.blockSize);
        final finalOutputBlock = Uint8List(cipher.blockSize);
        final remaining = input.length - offset;
        finalInputBlock.setRange(0, remaining, input, offset);
        final padValue = cipher.blockSize - remaining;
        for (int i = remaining; i < cipher.blockSize; i++) {
          finalInputBlock[i] = padValue;
        }
        cipher.processBlock(finalInputBlock, 0, finalOutputBlock, 0);
        output.setRange(offset, input.length, finalOutputBlock);
      } else {
        cipher.processBlock(input, offset, output, offset);
      }
    }
    return output;
  }
}

class NikkeLocaleHeader {
  String magic;
  int version;
  Uint8List aesKey;
  int segmentSize;
  int segmentCount;

  NikkeLocaleHeader({
    required Uint8List magic,
    required this.version,
    required this.aesKey,
    required this.segmentSize,
    required this.segmentCount,
  }) : magic = String.fromCharCodes(magic);

  @override
  String toString() {
    return 'NikkeLocaleHeader: { '
        'magic: $magic, '
        'version: $version, '
        'aesKey: ${base64Encode(aesKey)}, '
        'segmentSize: $segmentSize, '
        'segmentCount: $segmentCount '
        '}';
  }
}
