import 'package:flutter/material.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';
import 'package:nikke_einkk/module/battle/battle_setup.dart';

class EinkkHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
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
