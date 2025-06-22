import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/data_path.dart' as data;
import 'package:pointycastle/export.dart';
import 'package:path/path.dart' as path;

/// Decrypt & Extract logic copied from EpinelPS
class GameDataUnpacker {
  final String filePath;
  final Uint8List salt1;
  final Uint8List salt2;
  Archive? _mainZip;

  // Pre-shared values from the C# code
  static final Uint8List preSharedValue = Uint8List.fromList([
    0xCB,
    0xC2,
    0x1C,
    0x6F,
    0xF3,
    0xF5,
    0x07,
    0xF5,
    0x05,
    0xBA,
    0xCA,
    0xD4,
    0x98,
    0x28,
    0x84,
    0x1F,
    0xF0,
    0xD1,
    0x38,
    0xC7,
    0x61,
    0xDF,
    0xD6,
    0xE6,
    0x64,
    0x9A,
    0x85,
    0x13,
    0x3E,
    0x1A,
    0x6A,
    0x0C,
    0x68,
    0x0E,
    0x2B,
    0xC4,
    0xDF,
    0x72,
    0xF8,
    0xC6,
    0x55,
    0xE4,
    0x7B,
    0x14,
    0x36,
    0x18,
    0x3B,
    0xA7,
    0xD1,
    0x20,
    0x81,
    0x22,
    0xD1,
    0xA9,
    0x18,
    0x84,
    0x65,
    0x13,
    0x0B,
    0xED,
    0xA3,
    0x00,
    0xE5,
    0xD9,
  ]);

  static Uint8List rsaExponent = Uint8List.fromList([0x01, 0x00, 0x01]);
  static Uint8List rsaModulus = Uint8List.fromList([
    0x89,
    0xD6,
    0x66,
    0x00,
    0x7D,
    0xFC,
    0x7D,
    0xCE,
    0x83,
    0xA6,
    0x62,
    0xE3,
    0x1A,
    0x5E,
    0x9A,
    0x53,
    0xC7,
    0x8A,
    0x27,
    0xF3,
    0x67,
    0xC1,
    0xF3,
    0xD4,
    0x37,
    0xFE,
    0x50,
    0x6D,
    0x38,
    0x45,
    0xDF,
    0x7E,
    0x73,
    0x5C,
    0xF4,
    0x9D,
    0x40,
    0x4C,
    0x8C,
    0x63,
    0x21,
    0x97,
    0xDF,
    0x46,
    0xFF,
    0xB2,
    0x0D,
    0x0E,
    0xDB,
    0xB2,
    0x72,
    0xB4,
    0xA8,
    0x42,
    0xCD,
    0xEE,
    0x48,
    0x06,
    0x74,
    0x4F,
    0xE9,
    0x56,
    0x6E,
    0x9A,
    0xB1,
    0x60,
    0x18,
    0xBC,
    0x86,
    0x0B,
    0xB6,
    0x32,
    0xA7,
    0x51,
    0x00,
    0x85,
    0x7B,
    0xC8,
    0x72,
    0xCE,
    0x53,
    0x71,
    0x3F,
    0x64,
    0xC2,
    0x25,
    0x58,
    0xEF,
    0xB0,
    0xC9,
    0x1D,
    0xE3,
    0xB3,
    0x8E,
    0xFC,
    0x55,
    0xCF,
    0x8B,
    0x02,
    0xA5,
    0xC8,
    0x1E,
    0xA7,
    0x0E,
    0x26,
    0x59,
    0xA8,
    0x33,
    0xA5,
    0xF1,
    0x11,
    0xDB,
    0xCB,
    0xD3,
    0xA7,
    0x1F,
    0xB1,
    0xC6,
    0x10,
    0x39,
    0xC8,
    0x31,
    0x1D,
    0x60,
    0xDB,
    0x0D,
    0xA4,
    0x13,
    0x4B,
    0x2B,
    0x0E,
    0xF3,
    0x6F,
    0x69,
    0xCB,
    0xA8,
    0x62,
    0x03,
    0x69,
    0xE6,
    0x95,
    0x6B,
    0x8D,
    0x11,
    0xF6,
    0xAF,
    0xD9,
    0xC2,
    0x27,
    0x3A,
    0x32,
    0x12,
    0x05,
    0xC3,
    0xB1,
    0xE2,
    0x81,
    0x4B,
    0x40,
    0xF8,
    0x8B,
    0x8D,
    0xBA,
    0x1F,
    0x55,
    0x60,
    0x2C,
    0x09,
    0xC6,
    0xED,
    0x73,
    0x96,
    0x32,
    0xAF,
    0x5F,
    0xEE,
    0x8F,
    0xEB,
    0x5B,
    0x93,
    0xCF,
    0x73,
    0x13,
    0x15,
    0x6B,
    0x92,
    0x7B,
    0x27,
    0x0A,
    0x13,
    0xF0,
    0x03,
    0x4D,
    0x6F,
    0x5E,
    0x40,
    0x7B,
    0x9B,
    0xD5,
    0xCE,
    0xFC,
    0x04,
    0x97,
    0x7E,
    0xAA,
    0xA3,
    0x53,
    0x2A,
    0xCF,
    0xD2,
    0xD5,
    0xCF,
    0x52,
    0xB2,
    0x40,
    0x61,
    0x28,
    0xB1,
    0xA6,
    0xF6,
    0x78,
    0xFB,
    0x69,
    0x9A,
    0x85,
    0xD6,
    0xB9,
    0x13,
    0x14,
    0x6D,
    0xC4,
    0x25,
    0x36,
    0x17,
    0xDB,
    0x54,
    0x0C,
    0xD8,
    0x77,
    0x80,
    0x9A,
    0x00,
    0x62,
    0x83,
    0xDD,
    0xB0,
    0x06,
    0x64,
    0xD0,
    0x81,
    0x5B,
    0x0D,
    0x23,
    0x9E,
    0x88,
    0xBD,
  ]);

  GameDataUnpacker(this.filePath, this.salt1, this.salt2) {
    if (!File(filePath).existsSync()) {
      throw ArgumentError("File not found: $filePath");
    }
  }

  void _doTransformation(Uint8List key, Uint8List salt, Uint8List input, Uint8List output) {
    const blockSize = 16; // AES block size

    if (salt.length != blockSize) {
      throw ArgumentError("Salt size must be same as block size (actual: ${salt.length}, expected: $blockSize)");
    }

    // Clone the counter (salt)
    var counter = Uint8List.fromList(salt);
    var xorMask = <int>[];

    // Create AES cipher in ECB mode

    final ecbBlockCipher = ECBBlockCipher(AESEngine())..init(true, KeyParameter(key));

    // Process input byte by byte
    for (var i = 0; i < input.length; i++) {
      if (xorMask.isEmpty) {
        // Generate a new counter block
        var counterBlock = Uint8List(blockSize);
        ecbBlockCipher.processBlock(counter, 0, counterBlock, 0);

        // Increment counter (from right to left)
        for (var j = counter.length - 1; j >= 0; j--) {
          counter[j] = (counter[j] + 1) & 0xFF;
          if (counter[j] != 0) break;
        }

        // Add bytes to mask queue
        xorMask.addAll(counterBlock);
      }

      // XOR with next mask byte
      var mask = xorMask.removeAt(0);
      output[i] = input[i] ^ mask;
    }
  }

  static Uint8List generateKey(Uint8List salt, Uint8List passphrase) {
    final iterations = 10000;
    final keySize = 32;
    final derivator = KeyDerivator('SHA-256/HMAC/PBKDF2')..init(Pbkdf2Parameters(salt, iterations, keySize));
    final output = Uint8List(keySize);
    derivator.deriveKey(passphrase, 0, output, 0);
    return output;
  }

  static String toHexString(Uint8List bytes) =>
      bytes.fold<String>('', (str, byte) => str + byte.toRadixString(16).padLeft(2, '0'));

  bool loadGameData() {
    try {
      final file = File(filePath);
      final fileData = file.readAsBytesSync();
      logger.d('File size: ${fileData.length} bytes');

      final firstKey = generateKey(salt2, preSharedValue);
      final decryptionKey = firstKey.sublist(0, 16);
      final iv = firstKey.sublist(16, 32);

      logger.d('First decryption key: ${toHexString(decryptionKey)}\nFirst IV: ${toHexString(iv)}');

      final cipher = CBCBlockCipher(AESEngine())..init(false, ParametersWithIV(KeyParameter(decryptionKey), iv));
      final decryptedData = _processBlocks(cipher, fileData);

      final zipFile = ZipDecoder().decodeBytes(decryptedData);
      logger.d('ZIP contents: ${zipFile.files.map((file) => file.name)}');

      final signEntry = zipFile.files.firstWhere(
        (file) => file.name == 'sign',
        orElse: () => throw Exception('sign entry not found in ZIP'),
      );

      final dataEntry = zipFile.files.firstWhere(
        (file) => file.name == 'data',
        orElse: () => throw Exception('data entry not found in ZIP'),
      );

      final signBytes = signEntry.content as Uint8List;
      final dataBytes = dataEntry.content as Uint8List;

      final rsaKey = RSAPublicKey(
        BigInt.parse(toHexString(rsaModulus), radix: 16),
        BigInt.parse(toHexString(rsaExponent), radix: 16),
      );

      final verifier = Signer('SHA-256/RSA')..init(false, PublicKeyParameter<RSAPublicKey>(rsaKey));
      if (!verifier.verifySignature(dataBytes, RSASignature(signBytes))) {
        throw Exception('Signature verification failed');
      }
      logger.d('Signature verification passed');

      final secondKey = generateKey(salt1, preSharedValue);
      final val2 = secondKey.sublist(0, 16);
      final iv2 = secondKey.sublist(16, 32);

      logger.d('Second decryption key: ${toHexString(val2)}\nSecond IV: ${toHexString(iv2)}');

      final outputData = Uint8List(dataBytes.length);
      _doTransformation(val2, iv2, dataBytes, outputData);
      _mainZip = ZipDecoder().decodeBytes(outputData);

      logger.d("Final ZIP contains ${_mainZip!.files.length} files");

      return true;
    } catch (e, stackTrace) {
      logger.e('Error in LoadGameData.', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Uint8List _processBlocks(BlockCipher cipher, Uint8List input) {
    final output = Uint8List(input.length);
    for (var offset = 0; offset < input.length; offset += cipher.blockSize) {
      final chunkEnd = offset + cipher.blockSize;
      final isLastChunk = chunkEnd >= input.length;

      if (isLastChunk) {
        // Handle PKCS#7 padding for the last block
        final block = Uint8List(cipher.blockSize);
        final remaining = input.length - offset;
        block.setRange(0, remaining, input, offset);
        final padValue = cipher.blockSize - remaining;
        for (var i = remaining; i < cipher.blockSize; i++) {
          block[i] = padValue;
        }
        cipher.processBlock(block, 0, output, offset);
        // Remove padding
        final padCount = output[offset + cipher.blockSize - 1];
        return output.sublist(0, output.length - padCount);
      } else {
        cipher.processBlock(input, offset, output, offset);
      }
    }
    return output;
  }

  bool extractFiles(String outputDir) {
    if (_mainZip == null) {
      return false;
    }

    final zip = _mainZip!;
    final dir = Directory(outputDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    for (var i = 0; i < zip.files.length; i++) {
      final file = zip.files[i];

      // Create directory structure if needed
      final filePath = data.getDesignatedDirectory(outputDir, file.name);
      final directory = path.dirname(filePath);
      if (directory.isNotEmpty) {
        Directory(directory).createSync(recursive: true);
      }

      // Skip if it's a directory
      if (file.name.endsWith('/')) {
        continue;
      }

      // Extract the file
      File(filePath).writeAsBytesSync(file.content as Uint8List);
    }

    return true;
  }

  int get totalFileCount => _mainZip?.files.length ?? 0;
}
