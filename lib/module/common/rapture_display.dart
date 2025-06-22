import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nikke_einkk/model/battle/utils.dart' as utils;
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/skill_display.dart';

class RaptureLeveledDataDisplay extends StatelessWidget {
  final bool useGlobal;
  final MonsterData data;
  final int stageLv;
  final int stageLvChangeGroup;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  const RaptureLeveledDataDisplay({
    super.key,
    required this.useGlobal,
    required this.data,
    required this.stageLv,
    required this.stageLvChangeGroup,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.decimalPattern();
    final statEnhanceData = db.monsterStatEnhanceData[data.statEnhanceId]?[stageLv];

    final List<Widget> children = [
      Row(
        spacing: 3,
        children: [
          Tooltip(
            message:
                'Target Id: ${data.id}'
                '\nModel Id: ${data.monsterModelId}'
                '\nNormal Stage AI: ${data.spotAi}'
                '\nDefence Stage AI: ${data.spotAiDefense}'
                '\nBase Defence Stage AI: ${data.spotAiBaseDefense}',
            child: Text(locale.getTranslation(data.nameKey) ?? data.nameKey),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 16,
            constraints: BoxConstraints(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => RaptureDataDisplayPage(useGlobal: useGlobal, data: data)),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),

      Text('Element: ${data.elementIds.map((eleId) => NikkeElement.fromId(eleId).name.toUpperCase()).join(', ')}'),
    ];
    if (statEnhanceData != null) {
      children.addAll([
        Text('HP: ${format.format((utils.toModifier(data.hpRatio) * statEnhanceData.levelHp).round())}'),
        Text('ATK: ${format.format((utils.toModifier(data.attackRatio) * statEnhanceData.levelAttack).round())}'),
        Text('DEF: ${format.format((utils.toModifier(data.defenceRatio) * statEnhanceData.levelDefence).round())}'),
      ]);

      final parts = db.rapturePartData[data.monsterModelId] ?? [];
      for (final part in parts) {
        if (part.partsNameKey == null && part.hpRatio == 10000) continue;

        children.add(
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Tooltip(
                  message: 'Type: ${part.partsType}',
                  child: Text(locale.getTranslation(part.partsNameKey) ?? part.partsNameKey ?? 'Unknown Part'),
                ),
                Row(
                  spacing: 3,
                  children: [
                    Text('HP: ${format.format((utils.toModifier(part.hpRatio) * statEnhanceData.levelHp).round())}'),
                    Tooltip(
                      message:
                          'Damage Ratio HP: '
                          '${format.format((utils.toModifier(part.damageHpRatio) * statEnhanceData.levelHp).round())}'
                          '\n'
                          '(${(part.damageHpRatio / 100).toStringAsFixed(2)}%)',
                      child: Icon(Icons.info_outline, size: 16),
                    ),
                  ],
                ),
                Text('(${(part.hpRatio / 100).toStringAsFixed(2)}%)'),
                if (part.defenceRatio != 10000)
                  Text(
                    'DEF: '
                    '${format.format((utils.toModifier(part.defenceRatio) * statEnhanceData.levelDefence).round())}',
                  ),
              ],
            ),
          ),
        );
      }
    }

    if (stageLvChangeGroup != 0) {
      final stageLvChanges =
          db.monsterStageLvChangeData[stageLvChangeGroup]?.sorted((a, b) => a.step.compareTo(b.step)).toList() ?? [];

      for (final stageLvChange in stageLvChanges) {
        final changedStat = db.monsterStatEnhanceData[data.statEnhanceId]?[stageLvChange.monsterStageLv];
        final hasChange =
            changedStat?.levelAttack != statEnhanceData?.levelAttack ||
            changedStat?.levelDefence != statEnhanceData?.levelDefence;
        if (changedStat == null || !hasChange) continue;

        children.add(
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Text('Stat Change: ${shortenConditionType(stageLvChange.conditionType)}'),
                Text(
                  'Range: ${format.format(stageLvChange.conditionValueMin)}-'
                  '${stageLvChange.conditionValueMax == 0 ? '∞' : format.format(stageLvChange.conditionValueMax)}',
                ),
                Text('ATK: ${format.format((utils.toModifier(data.attackRatio) * changedStat.levelAttack).round())}'),
                Text('DEF: ${format.format((utils.toModifier(data.defenceRatio) * changedStat.levelDefence).round())}'),
              ],
            ),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: NikkeElement.fromId(data.elementIds.firstOrNull).color, width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children),
    );
  }

  String shortenConditionType(String condition) {
    if (condition == 'DamageDoneToTargetMonster') {
      return 'Damage';
    }

    return condition;
  }
}

class RaptureDataDisplayPage extends StatefulWidget {
  final bool useGlobal;
  final MonsterData data;

  const RaptureDataDisplayPage({super.key, required this.useGlobal, required this.data});

  @override
  State<RaptureDataDisplayPage> createState() => _RaptureDataDisplayPageState();
}

class _RaptureDataDisplayPageState extends State<RaptureDataDisplayPage> {
  int tab = 0;
  NikkeDatabaseV2 get db => widget.useGlobal ? global : cn;
  MonsterData get data => widget.data;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locale.getTranslation(data.nameKey) ?? data.nameKey, style: TextStyle(fontSize: 20)),
          Tooltip(
            message:
                'Normal Stage AI: ${data.spotAi}\n'
                'Defence Stage AI: ${data.spotAiDefense}\n'
                'Base Defence Stage AI: ${data.spotAiBaseDefense}',
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
      Text(locale.getTranslation(data.descriptionKey) ?? data.descriptionKey, style: TextStyle(fontSize: 20)),
      Text(
        'Target ID: ${data.id}   '
        'Model ID: ${data.monsterModelId}   '
        'Element: ${data.elementIds.map((eleId) => NikkeElement.fromId(eleId).name.toUpperCase()).join(', ')}',
      ),
      buildTabs(),
      Divider(),
      getTab(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Rapture Data')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (ctx, idx) => Align(child: Padding(padding: const EdgeInsets.all(2.0), child: children[idx])),
          itemCount: children.length,
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(() => setState(() {})),
    );
  }

  List<String> get tabTitle => ['Parts', 'Skills'];

  Widget buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabTitle.length, (idx) {
        return TextButton(
          onPressed: () {
            tab = idx;
            setState(() {});
          },
          child: Text(tabTitle[idx], style: TextStyle(fontWeight: tab == idx ? FontWeight.bold : null)),
        );
      }),
    );
  }

  Widget getTab() {
    switch (tab) {
      case 0:
        return buildPartsTab();
      case 1:
        return buildSkillsTab();
      default:
        return Text('Not implemented');
    }
  }

  Widget buildSkillsTab() {
    final skills = data.validSkillData;

    final List<Widget> children = [];
    for (final skill in skills) {
      final skillData = db.monsterSkillTable[skill.skillId];
      final funcs = skill.validFunctionIds;
      if (skillData != null) {
        children.add(
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              spacing: 3,
              children: [
                MonsterSkillDataDisplay(data: skillData, useGlobal: widget.useGlobal),
                for (final funcId in funcs)
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SimpleFunctionDisplay(functionId: funcId, useGlobal: widget.useGlobal),
                  ),
              ],
            ),
          ),
        );
      }
    }

    return Column(spacing: 3, children: children);
  }

  Widget buildPartsTab() {
    final parts = db.rapturePartData[data.monsterModelId] ?? [];
    final List<Widget> children = [];
    for (final part in parts) {
      final partName = locale.getTranslation(part.partsNameKey) ?? part.partsNameKey;
      children.add(
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              if (partName != null) Text(partName),
              Text('Part Type: ${part.partsType}'),
              Text('Is Main Part: ${part.isMainPart}'),
              Text('Can Damage: ${part.isPartsDamageable}'),
              Text('HP Ratio: ${(part.hpRatio / 100).toStringAsFixed(2)}%'),
              Text('Damage HP Ratio: ${(part.damageHpRatio / 100).toStringAsFixed(2)}%'),
              Text('ATK Ratio: ${(part.attackRatio / 100).toStringAsFixed(2)}%'),
              Text('DEF Ratio: ${(part.defenceRatio / 100).toStringAsFixed(2)}%'),
              if (part.passiveSkillId != 0 && db.stateEffectTable[part.passiveSkillId] != null)
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: StateEffectDataDisplay(
                    data: db.stateEffectTable[part.passiveSkillId]!,
                    useGlobal: widget.useGlobal,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Column(spacing: 3, children: children);
  }
}
