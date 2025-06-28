import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/common/slider.dart';

class GlobalSettingPage extends StatefulWidget {
  final BattlePlayerOptions playerOptions;
  final int maxSync;
  final void Function(int) onGlobalSyncChange;
  final Map<int, int> cubeLvs;
  final NikkeDatabaseV2 db;

  const GlobalSettingPage({
    super.key,
    required this.playerOptions,
    required this.maxSync,
    required this.onGlobalSyncChange,
    required this.cubeLvs,
    required this.db,
  });

  @override
  State<GlobalSettingPage> createState() => _GlobalSettingPageState();
}

class _GlobalSettingPageState extends State<GlobalSettingPage> {
  BattlePlayerOptions get option => widget.playerOptions;
  NikkeDatabaseV2 get db => widget.db;

  @override
  Widget build(BuildContext context) {
    final sliderWidth = 80.0;
    final maxResearchSync = maxResearchLevel(widget.maxSync);
    final cubeIds = db.harmonyCubeTable.keys.toList();
    final List<Widget> children = [
      Text('Set Global Sync Lv', style: TextStyle(fontSize: 20)),
      SliderWithPrefix(
        constraint: false,
        titled: false,
        leadingWidth: sliderWidth,
        label: 'Sync',
        min: 1,
        max: widget.maxSync,
        value: option.globalSync,
        valueFormatter: (v) => 'Lv$v',
        onChange: (newValue) {
          option.globalSync = newValue.round();
          widget.onGlobalSyncChange(newValue.round());
          if (mounted) setState(() {});
        },
      ),
      Divider(),
      Text('Personal Research Lv', style: TextStyle(fontSize: 20)),
      SliderWithPrefix(
        constraint: false,
        titled: false,
        leadingWidth: sliderWidth,
        label: 'Recycle Lv',
        min: 0,
        max: maxResearchSync,
        value: option.personalRecycleLevel,
        valueFormatter: (v) => 'Lv$v',
        onChange: (newValue) {
          option.personalRecycleLevel = newValue.round();
          if (mounted) setState(() {});
        },
      ),
      Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 14),
          Text('Max research level for current global sync is ${maxResearchLevel(option.globalSync)}'),
        ],
      ),
      Divider(),
      Text('Class Research Lv', style: TextStyle(fontSize: 20)),
      ...List.generate(3, (index) {
        final type = [NikkeClass.attacker, NikkeClass.defender, NikkeClass.supporter][index];
        return SliderWithPrefix(
          constraint: false,
          titled: false,
          leadingWidth: sliderWidth,
          label: type.name.toUpperCase(),
          min: 0,
          max: maxResearchSync,
          value: option.classRecycleLevels[type] ?? 0,
          valueFormatter: (v) => 'Lv$v',
          onChange: (newValue) {
            option.classRecycleLevels[type] = newValue.round();
            if (mounted) setState(() {});
          },
        );
      }),
      Divider(),
      Text('Corporation Research Lv', style: TextStyle(fontSize: 20)),
      ...List.generate(5, (index) {
        final type =
            [
              Corporation.elysion,
              Corporation.missilis,
              Corporation.tetra,
              Corporation.pilgrim,
              Corporation.abnormal,
            ][index];
        return SliderWithPrefix(
          constraint: false,
          titled: false,
          leadingWidth: sliderWidth,
          label: type.name.toUpperCase(),
          min: 0,
          max: maxResearchSync,
          value: option.corpRecycleLevels[type] ?? 0,
          valueFormatter: (v) => 'Lv$v',
          onChange: (newValue) {
            option.corpRecycleLevels[type] = newValue.round();
            if (mounted) setState(() {});
          },
        );
      }),
      Divider(),
      Text('Cube Lv', style: TextStyle(fontSize: 20)),
      ...List.generate(cubeIds.length, (idx) {
        final cubeId = cubeIds[idx];
        final cubeData = db.harmonyCubeTable[cubeId]!;
        final cubeEnhanceData = db.harmonyCubeEnhanceLvTable[cubeData.levelEnhanceId];
        return SliderWithPrefix(
          constraint: false,
          titled: false,
          leadingWidth: sliderWidth,
          label: locale.getTranslation(cubeData.nameLocalkey) ?? cubeData.nameLocalkey,
          min: 1,
          max: cubeEnhanceData == null ? 1 : cubeEnhanceData.keys.fold(1, max),
          value: widget.cubeLvs[cubeId] ?? 1,
          valueFormatter: (v) => 'Lv$v',
          onChange: (newValue) {
            widget.cubeLvs[cubeId] = newValue.round();
            if (mounted) setState(() {});
          },
        );
      }),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Global Settings')),
      body: Align(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (ctx, idx) => Align(child: Padding(padding: const EdgeInsets.all(2.0), child: children[idx])),
            itemCount: children.length,
          ),
        ),
      ),
    );
  }
}
