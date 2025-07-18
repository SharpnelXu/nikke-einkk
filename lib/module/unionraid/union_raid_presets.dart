import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/stages.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/monsters/rapture_display.dart';

class UnionRaidPresetPage extends StatefulWidget {
  const UnionRaidPresetPage({super.key});

  @override
  State<UnionRaidPresetPage> createState() => _UnionRaidPresetPageState();
}

class _UnionRaidPresetPageState extends State<UnionRaidPresetPage> {
  int? urPreset;

  bool get useGlobal => userDb.useGlobal;
  NikkeDatabase get db => userDb.gameDb;

  @override
  Widget build(BuildContext context) {
    final urNumberDropdowns =
        db.unionRaidData.keys
            .sorted((a, b) => a.compareTo(b))
            .map((presetId) => DropdownMenuEntry(value: presetId, label: 'UR ${presetId - 10000}'))
            .toList();

    final unionRaidData = db.unionRaidData[urPreset ?? urNumberDropdowns.lastOrNull?.value];
    final Map<String, Map<int, List<UnionRaidWaveData>>> difficultyToWaveChangeStep = {};
    if (unionRaidData != null) {
      for (final data in unionRaidData) {
        difficultyToWaveChangeStep.putIfAbsent(data.difficultyType, () => {});
        difficultyToWaveChangeStep[data.difficultyType]!.putIfAbsent(data.waveChangeStep, () => []);
        difficultyToWaveChangeStep[data.difficultyType]![data.waveChangeStep]!.add(data);
      }
    }

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
          Text('Select UR: ', style: TextStyle(fontSize: 20)),
          DropdownMenu(
            textStyle: TextStyle(fontSize: 20),
            initialSelection: urPreset ?? urNumberDropdowns.lastOrNull?.value,
            onSelected: (v) {
              urPreset = v;
              setState(() {});
            },
            dropdownMenuEntries: urNumberDropdowns,
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
      for (final difficulty in difficultyToWaveChangeStep.keys)
        UnionRaidDataDisplay(difficulty: difficulty, raidData: difficultyToWaveChangeStep[difficulty]!),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Union Raid Data')),
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
    if (!db.unionRaidData.keys.contains(urPreset)) {
      urPreset = null;
    }
    if (mounted) setState(() {});
  }
}

class UnionRaidDataDisplay extends StatefulWidget {
  final String difficulty;
  // grouped by waveChangeStep
  final Map<int, List<UnionRaidWaveData>> raidData;

  const UnionRaidDataDisplay({super.key, required this.difficulty, required this.raidData});

  @override
  State<UnionRaidDataDisplay> createState() => _UnionRaidDataDisplayState();
}

class _UnionRaidDataDisplayState extends State<UnionRaidDataDisplay> {
  int? currentWave;
  Map<int, List<UnionRaidWaveData>> get raidData => widget.raidData;

  @override
  Widget build(BuildContext context) {
    final waveDropDowns =
        raidData.keys
            .sorted((a, b) => a.compareTo(b))
            .map((waveChangeStep) => DropdownMenuEntry(value: waveChangeStep, label: 'Wave $waveChangeStep'))
            .toList();
    if (currentWave != null && !raidData.containsKey(currentWave)) {
      currentWave = waveDropDowns.lastOrNull?.value;
    }
    final selectedWave = currentWave ?? waveDropDowns.lastOrNull?.value;
    final sortedCurrentWave = raidData[selectedWave]!.sorted((a, b) => a.waveOrder.compareTo(b.waveOrder)).toList();

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${widget.difficulty}: ', style: TextStyle(fontSize: 20)),
              SizedBox(width: 15),
              Text('Select Wave: ', style: TextStyle(fontSize: 20)),
              DropdownMenu(
                width: 150,
                textStyle: TextStyle(fontSize: 20),
                initialSelection: selectedWave,
                onSelected: (v) {
                  currentWave = v;
                  setState(() {});
                },
                dropdownMenuEntries: waveDropDowns,
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 5,
            children: [for (final data in sortedCurrentWave) UnionRaidBossDisplay(data: data)],
          ),
        ],
      ),
    );
  }
}

class UnionRaidBossDisplay extends StatelessWidget {
  final UnionRaidWaveData data;
  NikkeDatabase get db => userDb.gameDb;

  const UnionRaidBossDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final waveData = db.getWaveData(data.wave);
    final targets = waveData?.targetList.map((targetId) => db.raptureData[targetId]).nonNulls.toList() ?? [];

    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text(
                'Boss ${data.waveOrder}: ${locale.getTranslation(data.waveName) ?? data.waveName}',
                style: TextStyle(fontSize: 20),
              ),
              Tooltip(
                message: 'Wave: ${data.wave}\n${locale.getTranslation(data.waveDescription) ?? data.waveDescription}',
                child: Icon(Icons.info_outline, size: 16),
              ),
            ],
          ),
          Text('Time Limit: ${waveData?.battleTime} s'),
          for (final target in targets)
            RaptureLeveledDataDisplay(
              data: target,
              stageLv: data.monsterStageLevel,
              stageLvChangeGroup: data.monsterStageLevelChangeGroup,
            ),
        ],
      ),
    );
  }
}
