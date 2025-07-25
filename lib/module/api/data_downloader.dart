import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:nikke_einkk/generated/proto/nikke-models.pb.dart';
import 'package:nikke_einkk/model/data_path.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/api/data_unpacker.dart';

/// Downloader logic copied from EpinelPS
class StaticDataDownloadPage extends StatefulWidget {
  const StaticDataDownloadPage({super.key});

  @override
  State<StaticDataDownloadPage> createState() => _StaticDataDownloadPageState();
}

class _StaticDataDownloadPageState extends State<StaticDataDownloadPage> {
  final TextEditingController downloadHtmlController = TextEditingController();
  bool useGlobal = true;
  bool downloadedGlobal = true;
  String? errorText;
  bool staticDataDownloaded = false;
  ResStaticDataPackInfo? pack;
  GameDataUnpacker? unpacker;
  static const globalStaticDataUrl = "https://global-lobby.nikke-kr.com/v1/staticdatapack";
  static const cnStaticDataUrl = "https://qq.nikkecn.qq.com:12001/v1/staticdatapack";

  @override
  void initState() {
    super.initState();
    downloadHtmlController.text = globalStaticDataUrl;
  }

  @override
  void dispose() {
    super.dispose();
    downloadHtmlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Static Data Download')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Row(
              spacing: 5,
              children: [
                Text('Download URL: '),
                Expanded(
                  child: TextField(
                    controller: downloadHtmlController,
                    decoration: InputDecoration(border: const OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            Row(spacing: 5, children: [Text('Save Location: '), Text(getStaticDataPath(useGlobal))]),
            Row(
              spacing: 5,
              children: [
                Text('Server Select: '),
                Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
                Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
                Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
                Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
                FilledButton.icon(
                  onPressed: () async {
                    await EasyLoading.show(status: 'Downloading', maskType: EasyLoadingMaskType.clear);
                    await downloadStaticData();
                    await EasyLoading.dismiss();

                    await EasyLoading.showInfo('Extracting...', maskType: EasyLoadingMaskType.clear);

                    unpacker = GameDataUnpacker(
                      getStaticDataPath(downloadedGlobal, pack!.version),
                      Uint8List.fromList(pack!.salt1),
                      Uint8List.fromList(pack!.salt2),
                    );
                    unpacker!.loadGameData();
                    unpacker!.extractFiles(getExtractDataFolderPath(downloadedGlobal));

                    if (downloadedGlobal) {
                      global.init();
                    } else {
                      cn.init();
                    }

                    await EasyLoading.dismiss();
                    setState(() {});
                  },
                  label: Text('Download'),
                  icon: Icon(Icons.download),
                ),
              ],
            ),
            if (errorText != null) Text(errorText!, style: TextStyle(color: Colors.red)),
            if (pack != null) ...showDownloadResult(),
            if (staticDataDownloaded) ...showPackResult(),
          ],
        ),
      ),
    );
  }

  List<Widget> showPackResult() {
    return [
      const Divider(),
      Text('StaticData Saved', style: TextStyle(fontSize: 20)),
      if (unpacker != null) Text('Extracted ${unpacker!.totalFileCount} files to saved folder'),
    ];
  }

  List<Widget> showDownloadResult() {
    final pack = this.pack!;
    return [
      const Divider(),
      Text('Download Result (${downloadedGlobal ? 'global' : 'cn'})', style: TextStyle(fontSize: 20)),
      clipboardText('Url: ${pack.url}', pack.url),
      clipboardText('Salt1: ${base64Encode(pack.salt1)}', base64Encode(pack.salt1)),
      clipboardText('Salt2: ${base64Encode(pack.salt2)}', base64Encode(pack.salt2)),
      clipboardText('sha256Sum: ${base64Encode(pack.sha256Sum)}', base64Encode(pack.sha256Sum)),
      Text('Version: ${pack.version}'),
      Text('Size: ${pack.size}'),
    ];
  }

  Widget clipboardText(String text, String clipboardText) {
    return TextButton.icon(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: clipboardText));
        await EasyLoading.showToast('Copied to Clipboard');
      },
      label: Text(text),
      icon: Icon(Icons.copy),
    );
  }

  Future<void> downloadStaticData() async {
    staticDataDownloaded = false;
    final packUri = Uri.tryParse(downloadHtmlController.text);
    if (packUri == null) {
      errorText = 'Link is invalid';
      return;
    }

    http.Response packResponse;
    http.Client client;
    try {
      client = http.Client();
      packResponse = await client.post(
        packUri,
        headers: {'Accept': 'application/octet-stream+protobuf', 'Content-Type': 'application/octet-stream+protobuf'},
      );
    } catch (e) {
      errorText = 'Error sending request: $e';
      return;
    }

    try {
      pack = ResStaticDataPackInfo.fromBuffer(packResponse.bodyBytes);
      downloadedGlobal = useGlobal;
    } catch (e) {
      errorText = 'Error parsing response: $e';
      return;
    }

    final staticDataUri = Uri.tryParse(pack!.url);
    if (staticDataUri == null) {
      errorText = 'Parsed URL is invalid: ${pack!.url}';
      return;
    }

    try {
      http.Response dataResponse = await client.get(staticDataUri);
      File dataFile = await File(getStaticDataPath(downloadedGlobal, pack!.version)).create(recursive: true);
      await dataFile.writeAsBytes(dataResponse.bodyBytes);
    } catch (e) {
      errorText = 'Error parsing data response: $e';
      return;
    }

    staticDataDownloaded = true;
    errorText = null;
    unpacker = null;
  }

  void serverRadioChange(bool? v) {
    useGlobal = v ?? useGlobal;
    downloadHtmlController.text = useGlobal ? globalStaticDataUrl : cnStaticDataUrl;
    if (mounted) setState(() {});
  }
}
