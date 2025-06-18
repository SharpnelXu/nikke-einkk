import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';
import 'package:nikke_einkk/module/battle/battle_setup.dart';
import 'package:nikke_einkk/module/soloraid/solo_raid_presets.dart';
import 'package:nikke_einkk/module/unionraid/union_raid_presets.dart';

class EinkkHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      if (kDebugMode)
        TextButton.icon(
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            iconAlignment: IconAlignment.start,
            textStyle: TextStyle(fontSize: 30),
            iconSize: 30,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => BattleSetupPage()));
          },
          icon: Icon(Icons.calculate),
          label: Text('Battle Simulation'),
        ),
      TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          iconAlignment: IconAlignment.start,
          textStyle: TextStyle(fontSize: 30),
          iconSize: 30,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => StaticDataDownloadPage()));
        },
        icon: Icon(Icons.download),
        label: Text('Static Data Download'),
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          iconAlignment: IconAlignment.start,
          textStyle: TextStyle(fontSize: 30),
          iconSize: 30,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => UnionRaidPresetPage()));
        },
        icon: Icon(Icons.groups),
        label: Text('Union Raid Data'),
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          iconAlignment: IconAlignment.start,
          textStyle: TextStyle(fontSize: 30),
          iconSize: 30,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => SoloRaidPresetPage()));
        },
        icon: Icon(Icons.person),
        label: Text('Solo Raid Data'),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Einkk\' Simulation Room')),
      body: ListView.separated(
        itemBuilder: (ctx, idx) => items[idx],
        separatorBuilder: (ctx, idx) => const Divider(),
        itemCount: items.length,
      ),
    );
  }
}
