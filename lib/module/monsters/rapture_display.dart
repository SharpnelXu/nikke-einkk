import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/utils.dart' as utils;
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/module/common/custom_widgets.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/common/skill_display.dart';

class RaptureLeveledDataDisplay extends StatelessWidget {
  final MonsterData data;
  final int stageLv;
  final int stageLvChangeGroup;

  NikkeDatabaseV2 get db => userDb.gameDb;

  const RaptureLeveledDataDisplay({
    super.key,
    required this.data,
    required this.stageLv,
    required this.stageLvChangeGroup,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Text(locale.getTranslation(data.nameKey) ?? data.nameKey, style: TextStyle(fontSize: 20)),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 16,
            constraints: BoxConstraints(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => RaptureDataDisplayPage(data: data, stageLv: stageLv)),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      Text('Lv: $stageLv'),
      Text('Element: ${data.elementIds.map((eleId) => NikkeElement.fromId(eleId).name.toUpperCase()).join(', ')}'),
    ];
    if (statEnhanceData != null) {
      children.addAll([
        Text('HP: ${(utils.toModifier(data.hpRatio) * statEnhanceData.levelHp).decimalPattern}'),
        Text('ATK: ${(utils.toModifier(data.attackRatio) * statEnhanceData.levelAttack).decimalPattern}'),
        Text('DEF: ${(utils.toModifier(data.defenceRatio) * statEnhanceData.levelDefence).decimalPattern}'),
        Text('Damage Ratio: ${statEnhanceData.levelStatDamageRatio.percentString}'),
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
                  message: 'NameKey: ${part.partsNameKey}\nType: ${part.partsType}',
                  child: Text(locale.getTranslation(part.partsNameKey) ?? part.partsNameKey ?? 'Unknown Part'),
                ),
                Text(
                  'HP: ${(utils.toModifier(part.hpRatio) * statEnhanceData.levelBrokenHp).decimalPattern}'
                  ' (${part.hpRatio.percentString})',
                ),
                if (part.damageHpRatio != 0)
                  Text(
                    'Break Bonus: ${(utils.toModifier(part.damageHpRatio) * statEnhanceData.levelBrokenHp).decimalPattern}'
                    ' (${part.damageHpRatio.percentString})',
                  ),
                if (part.defenceRatio != 10000)
                  Text(
                    'DEF: '
                    '${(utils.toModifier(part.defenceRatio) * statEnhanceData.levelDefence).decimalPattern}',
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
        if (stageLvChange.monsterStageLv == stageLv) continue;
        final changedStat = db.monsterStatEnhanceData[data.statEnhanceId]?[stageLvChange.monsterStageLv];
        final hasChange =
            changedStat?.levelAttack != statEnhanceData?.levelAttack ||
            changedStat?.levelDefence != statEnhanceData?.levelDefence ||
            changedStat?.levelStatDamageRatio != statEnhanceData?.levelStatDamageRatio;
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
                Row(
                  spacing: 3,
                  children: [
                    Text('Stat Change: ${shortenConditionType(stageLvChange.conditionType)}'),
                    IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => RaptureDataDisplayPage(data: data, stageLv: stageLvChange.monsterStageLv),
                          ),
                        );
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
                Text(
                  'Range: ${stageLvChange.conditionValueMin.decimalPattern}-'
                  '${stageLvChange.conditionValueMax == 0 ? '∞' : stageLvChange.conditionValueMax.decimalPattern}',
                ),
                Text('Lv: ${stageLvChange.monsterStageLv}'),
                Text('ATK: ${(utils.toModifier(data.attackRatio) * changedStat.levelAttack).decimalPattern}'),
                Text('DEF: ${(utils.toModifier(data.defenceRatio) * changedStat.levelDefence).decimalPattern}'),
                Text('Damage Ratio: ${changedStat.levelStatDamageRatio.percentString}'),
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
  final MonsterData data;
  final int? stageLv;

  const RaptureDataDisplayPage({super.key, required this.data, this.stageLv});

  @override
  State<RaptureDataDisplayPage> createState() => _RaptureDataDisplayPageState();
}

class _RaptureDataDisplayPageState extends State<RaptureDataDisplayPage> {
  int tab = 0;
  NikkeDatabaseV2 get db => userDb.gameDb;
  MonsterData get data => widget.data;
  int? get stageLv => widget.stageLv;
  MonsterStatEnhanceData? get statEnhanceData => db.monsterStatEnhanceData[data.statEnhanceId]?[stageLv];

  @override
  Widget build(BuildContext context) {
    final stat = statEnhanceData;
    final List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          if (stageLv != null) Text('Lv $stageLv'),
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
      Wrap(
        spacing: 15,
        alignment: WrapAlignment.center,
        children: [
          Text('Target ID: ${data.id}'),
          Text('Model ID: ${data.monsterModelId}'),
          Text('Element: ${data.elementIds.map((eleId) => NikkeElement.fromId(eleId).name.toUpperCase()).join(', ')}'),
        ],
      ),
      if (stat != null)
        Wrap(
          spacing: 15,
          alignment: WrapAlignment.center,
          children: [
            Text('HP: ${(utils.toModifier(data.hpRatio) * stat.levelHp).decimalPattern}'),
            Text('ATK: ${(utils.toModifier(data.attackRatio) * stat.levelAttack).decimalPattern}'),
            Text('DEF: ${(utils.toModifier(data.defenceRatio) * stat.levelDefence).decimalPattern}'),
            Text('Damage Ratio: ${stat.levelStatDamageRatio.percentString}'),
          ],
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
                MonsterSkillDataDisplay(data: skillData, statEnhanceData: statEnhanceData),
                for (final funcId in funcs)
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: buffTypeColor(db.functionTable[funcId]?.buff), width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SimpleFunctionDisplay(functionId: funcId),
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
    final stat = statEnhanceData;
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
              if (partName != null) Text(partName, style: TextStyle(fontSize: 20)),
              Wrap(
                spacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  Text('Type: ${part.partsType}'),
                  Text('Main Part: ${part.isMainPart}'),
                  Text('Damageable: ${part.isPartsDamageable}'),
                ],
              ),
              if (stat == null)
                Wrap(
                  spacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    Text('HP: ${part.hpRatio.percentString}'),
                    Text('Break Bonus: ${part.damageHpRatio.percentString}'),
                    Text('ATK: ${part.attackRatio.percentString}'),
                    Text('DEF: ${part.defenceRatio.percentString}'),
                  ],
                ),
              if (stat != null)
                Wrap(
                  spacing: 15,
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'HP: ${(utils.toModifier(part.hpRatio) * (part.isMainPart ? stat.levelHp : stat.levelBrokenHp)).decimalPattern}',
                    ),
                    if (!part.isMainPart)
                      Text(
                        'Break Bonus: ${(utils.toModifier(part.damageHpRatio) * stat.levelBrokenHp).decimalPattern}',
                      ),
                    Text('ATK: ${(utils.toModifier(part.attackRatio) * stat.levelAttack).decimalPattern}'),
                    Text('DEF: ${(utils.toModifier(part.defenceRatio) * stat.levelDefence).decimalPattern}'),
                  ],
                ),
              if (part.passiveSkillId != 0 && db.stateEffectTable[part.passiveSkillId] != null)
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: StateEffectDataDisplay(data: db.stateEffectTable[part.passiveSkillId]!),
                ),
            ],
          ),
        ),
      );
    }

    return Column(spacing: 3, children: children);
  }
}
