import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/module/about/about.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';
import 'package:nikke_einkk/module/api/locale_unpacker.dart';
import 'package:nikke_einkk/module/battle/battle_setup.dart';
import 'package:nikke_einkk/module/monsters/monster_list.dart';
import 'package:nikke_einkk/module/nikkes/nikke_list.dart';
import 'package:nikke_einkk/module/soloraid/solo_raid_presets.dart';
import 'package:nikke_einkk/module/unionraid/union_raid_presets.dart';

class EinkkHomePage extends StatelessWidget {
  const EinkkHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      // if (kDebugMode)
      //   TextButton.icon(
      //     style: TextButton.styleFrom(
      //       alignment: Alignment.centerLeft,
      //       iconAlignment: IconAlignment.start,
      //       textStyle: TextStyle(fontSize: 30),
      //       iconSize: 30,
      //     ),
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (ctx) => BattleSetupPage()));
      //     },
      //     icon: Icon(Icons.calculate),
      //     label: Text('Battle Simulation'),
      //   ),
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
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => LocaleUnpackerPage()));
        },
        icon: Icon(Icons.language),
        label: Text('Locale Unpack'),
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
      TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          iconAlignment: IconAlignment.start,
          textStyle: TextStyle(fontSize: 30),
          iconSize: 30,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => NikkeListPage()));
        },
        icon: Icon(Icons.face_outlined),
        label: Text('Nikke Data'),
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          iconAlignment: IconAlignment.start,
          textStyle: TextStyle(fontSize: 30),
          iconSize: 30,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => MonsterListPage()));
        },
        icon: Icon(Icons.catching_pokemon),
        label: Text('Rapture Data'),
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          iconAlignment: IconAlignment.start,
          textStyle: TextStyle(fontSize: 30),
          iconSize: 30,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => AboutPage()));
        },
        icon: Icon(Icons.info_outline),
        label: Text('About'),
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
