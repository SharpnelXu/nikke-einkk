import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';

class UnionRaidPresetPage extends StatefulWidget {
  const UnionRaidPresetPage({super.key});

  @override
  State<UnionRaidPresetPage> createState() => _UnionRaidPresetPageState();
}

class _UnionRaidPresetPageState extends State<UnionRaidPresetPage> {
  bool useGlobal = true;
  int? urPreset;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  @override
  Widget build(BuildContext context) {
    final urNumberDropdowns = db.unionRaidData.keys
        .sorted((a, b) => a.compareTo(b))
        .map((presetId) => DropdownMenuEntry(value: presetId, label: 'UR ${presetId - 10000}'))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Union Raid Data')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Text('Server Select: ', style: TextStyle(fontSize: 20),),
                Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
                Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
                Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
                Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
                SizedBox(width: 15,),
                Text('Select UR: ', style: TextStyle(fontSize: 20),),
                DropdownMenu(
                  textStyle: TextStyle(fontSize: 20),
                  initialSelection: urPreset ?? urNumberDropdowns.lastOrNull?.value,
                  onSelected: (v) {
                    urPreset = v!;
                    setState(() {});
                  },
                  dropdownMenuEntries: urNumberDropdowns,
                ),
              ],
            ),
            if (!db.initialized) FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white)),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (ctx) => StaticDataDownloadPage()));
                setState(() {});
              },
              child: Text('Data not initialized! Click to download'),
            ),
          ],
        ),
      ),
    );
  }

  void serverRadioChange(bool? v) {
    useGlobal = v ?? useGlobal;
    if (!db.unionRaidData.keys.contains(urPreset)) {
      urPreset = null;
    }
    if (mounted) setState(() {});
  }
}