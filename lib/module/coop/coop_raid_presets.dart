import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/model/stages.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/monsters/rapture_display.dart';

class CoopRaidPresetPage extends StatefulWidget {
  const CoopRaidPresetPage({super.key});

  @override
  State<CoopRaidPresetPage> createState() => _CoopRaidPresetPageState();
}

class _CoopRaidPresetPageState extends State<CoopRaidPresetPage> {
  int? coopId;

  bool get useGlobal => userDb.useGlobal;
  NikkeDatabase get db => userDb.gameDb;

  @override
  Widget build(BuildContext context) {
    final coopIdsDropdowns =
        db.coopRaidData.keys
            .sorted((a, b) => a.compareTo(b))
            .map(
              (id) => DropdownMenuEntry(
                value: id,
                label: 'Coop $id: ${locale.getTranslation(db.coopRaidData[id]?.name) ?? 'Unknown'}',
              ),
            )
            .toList();

    final raidData = db.coopRaidData[coopId ?? coopIdsDropdowns.lastOrNull?.value];

    final List<Widget> children = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text('Server Select: ', style: TextStyle(fontSize: 20)),
          Radio(value: true, groupValue: useGlobal, onChanged: serverRadioChange),
          Text('Global', style: TextStyle(fontWeight: useGlobal ? FontWeight.bold : null)),
          Radio(value: false, groupValue: useGlobal, onChanged: serverRadioChange),
          Text('CN', style: TextStyle(fontWeight: !useGlobal ? FontWeight.bold : null)),
          SizedBox(width: 15),
          Text('Select Coop: ', style: TextStyle(fontSize: 20)),
          DropdownMenu(
            width: 250,
            textStyle: TextStyle(fontSize: 20),
            initialSelection: coopId ?? coopIdsDropdowns.lastOrNull?.value,
            onSelected: (v) {
              coopId = v;
              setState(() {});
            },
            dropdownMenuEntries: coopIdsDropdowns,
          ),
        ],
      ),
      if (!db.initialized)
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white)),
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (ctx) => StaticDataDownloadPage()));
            setState(() {});
          },
          child: Text('Data not initialized! Click to download'),
        ),
      if (raidData != null) Align(child: CoopRaidBossDisplay(data: raidData)),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Coop Raid Data')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (ctx, idx) => children[idx],
          separatorBuilder: (ctx, idx) => SizedBox(height: 10),
          itemCount: children.length,
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
    );
  }

  void serverRadioChange(bool? v) {
    userDb.useGlobal = v ?? useGlobal;
    if (!db.coopRaidData.keys.contains(coopId)) {
      coopId = null;
    }
    if (mounted) setState(() {});
  }
}

class CoopRaidBossDisplay extends StatelessWidget {
  final MultiplayerRaidData data;
  NikkeDatabase get db => userDb.gameDb;

  const CoopRaidBossDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final easyWaveData = db.getWaveData(data.spotIdEasy);
    final easyTargets = easyWaveData?.targetList.map((targetId) => db.raptureData[targetId]).nonNulls;
    final hardWaveData = db.getWaveData(data.spotId);
    final hardTargets = hardWaveData?.targetList.map((targetId) => db.raptureData[targetId]).nonNulls;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 100,
      children: [
        if (easyWaveData != null)
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Text('Normal Boss: ${locale.getTranslation(data.name) ?? data.name}', style: TextStyle(fontSize: 20)),
                Text('Time Limit: ${easyWaveData.battleTime} s'),
                for (final target in easyTargets ?? <MonsterData>[])
                  RaptureLeveledDataDisplay(
                    data: target,
                    stageLv: data.monsterStageLevel,
                    stageLvChangeGroup: data.monsterStageLvChangeGroupEasy ?? 0,
                  ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 3),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Text('Challenge Boss: ${locale.getTranslation(data.name) ?? data.name}', style: TextStyle(fontSize: 20)),
              Text('Time Limit: ${hardWaveData?.battleTime} s'),
              for (final target in hardTargets ?? <MonsterData>[])
                RaptureLeveledDataDisplay(
                  data: target,
                  stageLv: data.monsterStageLevel,
                  stageLvChangeGroup: data.monsterStageLevelChangeGroup,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
