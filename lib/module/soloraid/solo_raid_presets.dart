import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/stages.dart';
import 'package:nikke_einkk/module/api/data_downloader.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/rapture_display.dart';

class SoloRaidPresetPage extends StatefulWidget {
  const SoloRaidPresetPage({super.key});

  @override
  State<SoloRaidPresetPage> createState() => _SoloRaidPresetPageState();
}

class _SoloRaidPresetPageState extends State<SoloRaidPresetPage> {
  bool useGlobal = true;
  int? srPreset;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  @override
  Widget build(BuildContext context) {
    final srNumDropdowns =
        db.soloRaidData.keys
            .sorted((a, b) => a.compareTo(b))
            .map((presetId) => DropdownMenuEntry(value: presetId, label: 'SR ${presetId - 10000}'))
            .toList();

    final srRaidData = db.soloRaidData[srPreset ?? srNumDropdowns.lastOrNull?.value];
    final Map<String, Map<int, List<SoloRaidWaveData>>> difficultyToWaveOrder = {};
    if (srRaidData != null) {
      for (final data in srRaidData) {
        difficultyToWaveOrder.putIfAbsent(data.difficultyType, () => {});
        difficultyToWaveOrder[data.difficultyType]!.putIfAbsent(data.waveOrder, () => []);
        difficultyToWaveOrder[data.difficultyType]![data.waveOrder]!.add(data);
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
          Text('Select SR: ', style: TextStyle(fontSize: 20)),
          DropdownMenu(
            textStyle: TextStyle(fontSize: 20),
            initialSelection: srPreset ?? srNumDropdowns.lastOrNull?.value,
            onSelected: (v) {
              srPreset = v;
              setState(() {});
            },
            dropdownMenuEntries: srNumDropdowns,
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
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [
          for (final difficulty in difficultyToWaveOrder.keys)
            SoloRaidDataDisplay(
              difficulty: difficulty,
              raidData: difficultyToWaveOrder[difficulty]!,
              useGlobal: useGlobal,
            ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Solo Raid Data')),
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
    useGlobal = v ?? useGlobal;
    if (!db.soloRaidData.keys.contains(srPreset)) {
      srPreset = null;
    }
    if (mounted) setState(() {});
  }
}

class SoloRaidDataDisplay extends StatefulWidget {
  final String difficulty;
  final bool useGlobal;
  // grouped by waveChangeStep
  final Map<int, List<SoloRaidWaveData>> raidData;

  const SoloRaidDataDisplay({super.key, required this.difficulty, required this.raidData, required this.useGlobal});

  @override
  State<SoloRaidDataDisplay> createState() => _SoloRaidDataDisplayState();
}

class _SoloRaidDataDisplayState extends State<SoloRaidDataDisplay> {
  int? currentWave;
  Map<int, List<SoloRaidWaveData>> get raidData => widget.raidData;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              for (final data in sortedCurrentWave) SoloRaidBossDisplay(data: data, useGlobal: widget.useGlobal),
            ],
          ),
        ],
      ),
    );
  }
}

class SoloRaidBossDisplay extends StatelessWidget {
  final SoloRaidWaveData data;
  final bool useGlobal;
  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  const SoloRaidBossDisplay({super.key, required this.data, required this.useGlobal});

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
            spacing: 3,
            children: [
              Text('Boss: ${locale.getTranslation(data.waveName) ?? data.waveName}'),
              Tooltip(
                message: locale.getTranslation(data.waveDescription) ?? '',
                child: Icon(Icons.info_outline, size: 16),
              ),
            ],
          ),
          Text('Time Limit: ${waveData?.battleTime} s'),
          for (final target in targets)
            RaptureDataDisplay(
              useGlobal: useGlobal,
              data: target,
              stageLv: data.monsterStageLevel,
              stageLvChangeGroup: data.monsterStageLevelChangeGroup,
            ),
        ],
      ),
    );
  }
}
