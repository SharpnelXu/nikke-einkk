import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class CharacterSkillDataDisplay extends StatelessWidget {
  final SkillData data;

  const CharacterSkillDataDisplay({super.key, required this.data});

  NikkeDatabase get db => userDb.gameDb;

  static final boldStyle = TextStyle(fontWeight: FontWeight.bold);
  static final headerData = TableCellData(isHeader: true, style: boldStyle);

  @override
  Widget build(BuildContext context) {
    final skillInfo = db.skillInfoTable[data.id];
    final List<Widget> children = [
      if (skillInfo != null)
        Text(locale.getTranslation(skillInfo.nameLocalkey) ?? skillInfo.nameLocalkey, style: TextStyle(fontSize: 18)),
      Text('Active Skill ID: ${data.id}', style: skillInfo == null ? TextStyle(fontSize: 18) : null),
      if (skillInfo != null) DescriptionTextWidget(formatSkillInfoDescription(skillInfo)),
      const Divider(),
      Text('Parameters', style: TextStyle(fontSize: 16)),
    ];

    final List<Widget> dataRows = [
      CustomTableRow.fromTexts(texts: ['Skill Type', 'CD', 'Duration'], defaults: headerData),
      CustomTableRow.fromTexts(
        texts: [
          data.rawSkillType,
          (data.skillCooltime.timeString),
          durationString(data.durationValue, data.durationType) ?? 'N/A',
        ],
      ),
      CustomTableRow.fromTexts(texts: ['Target', 'Condition'], defaults: headerData),
      CustomTableRow.fromTexts(texts: [data.rawPreferTarget, data.rawPreferTargetCondition]),
      CustomTableRow.fromTexts(texts: ['Skill Values'], defaults: headerData),
      CustomTableRow.fromTexts(
        texts:
            data.skillValueData
                .map((valueData) => skillValueString(valueData.skillValue, valueData.skillValueType) ?? 'None')
                .toList(),
      ),
    ];

    children.add(Container(constraints: BoxConstraints(maxWidth: 700), child: CustomTable(children: dataRows)));

    if (data.skillType == CharacterSkillType.changeWeapon || data.skillType == CharacterSkillType.laserBeam) {
      children.addAll([
        const Divider(),
        Text('↓↓↓ Equip This Weapon  ↓↓↓', style: TextStyle(fontSize: 16)),
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: WeaponDataDisplay(weaponId: data.getSkillValue(2)),
        ),
      ]);
    } else if (data.skillType == CharacterSkillType.launchWeapon) {
      children.addAll([
        const Divider(),
        Text('↓↓↓ Launch This Weapon  ↓↓↓', style: TextStyle(fontSize: 16)),
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: WeaponDataDisplay(weaponId: data.getSkillValue(2)),
        ),
      ]);
    } else if (data.skillType == CharacterSkillType.hitMonsterGetBuff) {
      final hitMonsterFuncId = data.getSkillValue(0);
      final hitPartFuncId = data.getSkillValue(1);
      children.addAll([
        const Divider(),
        Text('↓↓↓ Hit Raptures Function ↓↓↓', style: TextStyle(fontSize: 16)),
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: buffTypeColor(db.functionTable[hitMonsterFuncId]?.buff), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text('Hit Raptures Function', style: TextStyle(fontSize: 16)),
              SimpleFunctionDisplay(functionId: hitMonsterFuncId),
            ],
          ),
        ),
        Text('↓↓↓ Hit Parts Function ↓↓↓', style: TextStyle(fontSize: 16)),
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: buffTypeColor(db.functionTable[hitPartFuncId]?.buff), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text('Hit Parts Function', style: TextStyle(fontSize: 16)),
              SimpleFunctionDisplay(functionId: hitPartFuncId),
            ],
          ),
        ),
      ]);
    } else if (data.skillType == CharacterSkillType.targetHitCountGetBuff) {
      final hitFuncId = data.getSkillValue(0);
      final hitCount = data.getSkillValue(1);
      children.addAll([
        const Divider(),
        Text('↓↓↓ Hit $hitCount shots for Function ↓↓↓', style: TextStyle(fontSize: 16)),
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: buffTypeColor(db.functionTable[hitFuncId]?.buff), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text('Hit $hitCount shots for Function', style: TextStyle(fontSize: 16)),
              SimpleFunctionDisplay(functionId: hitFuncId),
            ],
          ),
        ),
      ]);
    }

    final preFunctionIds = data.validPreFuncIds;
    final preFunctions = [
      for (int idx = 0; idx < preFunctionIds.length; idx += 1)
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: buffTypeColor(db.functionTable[preFunctionIds[idx]]?.buff), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text(
                'Pre ${data.beforeUseFunctionIdList.contains(preFunctionIds[idx]) ? 'Skill' : 'Damage'} Function ${idx + 1}',
                style: TextStyle(fontSize: 16),
              ),
              SimpleFunctionDisplay(functionId: preFunctionIds[idx], connectFuncPrefix: '${idx + 1}-'),
            ],
          ),
        ),
    ];
    if (preFunctions.isNotEmpty) {
      children.addAll([
        const Divider(),
        Text('↓↓↓ Pre Skill Functions ↓↓↓', style: TextStyle(fontSize: 16)),
        ...preFunctions,
      ]);
    }

    final postFunctionIds = data.validPostFuncIds;
    final postFunctions = [
      for (int idx = 0; idx < postFunctionIds.length; idx += 1)
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: buffTypeColor(db.functionTable[postFunctionIds[idx]]?.buff), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text(
                'Post ${data.afterUseFunctionIdList.contains(postFunctionIds[idx]) ? 'Skill' : 'Damage'} Function ${idx + 1}',
                style: TextStyle(fontSize: 16),
              ),
              SimpleFunctionDisplay(functionId: postFunctionIds[idx], connectFuncPrefix: '${idx + 1}-'),
            ],
          ),
        ),
    ];
    if (postFunctions.isNotEmpty) {
      children.addAll([
        const Divider(),
        Text('↓↓↓ Post Skill Functions ↓↓↓', style: TextStyle(fontSize: 16)),
        ...postFunctions,
      ]);
    }

    return Column(spacing: 5, mainAxisSize: MainAxisSize.min, children: children);
  }
}

class StateEffectDataDisplay extends StatelessWidget {
  final StateEffectData data;

  NikkeDatabase get db => userDb.gameDb;

  const StateEffectDataDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final functionIds = data.allValidFuncIds;
    final skillInfo = db.skillInfoTable[data.id];
    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (skillInfo != null)
          Text(locale.getTranslation(skillInfo.nameLocalkey) ?? skillInfo.nameLocalkey, style: TextStyle(fontSize: 18)),
        Text('Passive Skill ID: ${data.id}', style: skillInfo == null ? TextStyle(fontSize: 18) : null),
        if (skillInfo != null) DescriptionTextWidget(formatSkillInfoDescription(skillInfo)),
        if (functionIds.isNotEmpty) const Divider(),
        if (functionIds.isNotEmpty) Text('↓↓↓ Functions ↓↓↓', style: TextStyle(fontSize: 16)),
        for (int idx = 0; idx < functionIds.length; idx += 1)
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: buffTypeColor(db.functionTable[functionIds[idx]]?.buff), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                Text('Function ${idx + 1}', style: TextStyle(fontSize: 16)),
                SimpleFunctionDisplay(functionId: functionIds[idx], connectFuncPrefix: '${idx + 1}-'),
              ],
            ),
          ),
      ],
    );
  }
}

class SimpleFunctionDisplay extends StatelessWidget {
  final int functionId;
  final String? connectFuncPrefix;

  NikkeDatabase get db => userDb.gameDb;

  const SimpleFunctionDisplay({super.key, required this.functionId, this.connectFuncPrefix});

  static final boldStyle = TextStyle(fontWeight: FontWeight.bold);
  static final headerData = TableCellData(isHeader: true, style: boldStyle);

  @override
  Widget build(BuildContext context) {
    final func = db.functionTable[functionId];
    if (func == null) {
      return Text('Function not found!');
    }

    final List<Widget> children = [];
    final List<Widget> dataRows = [
      CustomTableRow.fromTexts(texts: [if (func.nameLocalkey != null) 'Name', 'Function ID'], defaults: headerData),
      CustomTableRow.fromTexts(
        texts: [
          if (func.nameLocalkey != null) locale.getTranslation(func.nameLocalkey) ?? func.nameLocalkey!,
          '${func.id}',
        ],
      ),
      if (func.descriptionLocalkey != null) CustomTableRow.fromTexts(texts: ['Description'], defaults: headerData),
      if (func.descriptionLocalkey != null)
        CustomTableRow.fromChildren(children: [DescriptionTextWidget(formatFunctionDescription(func))]),
      CustomTableRow.fromTexts(texts: ['Function Type', 'Target', 'Buff Type', 'Remove Type'], defaults: headerData),
      CustomTableRow.fromTexts(
        texts: [func.rawFunctionType, func.rawFunctionTarget, func.rawBuffType, func.rawBuffRemove],
      ),
      CustomTableRow.fromTexts(texts: ['Value', 'Standard', 'Duration', 'Delay'], defaults: headerData),
      CustomTableRow(
        children: [
          TableCellData(
            child: Tooltip(
              message: func.rawFunctionValueType,
              child: Text(functionValueString(func.functionType, func.functionValue, func.functionValueType) ?? 'N/A'),
            ),
          ),
          TableCellData(text: functionStandardString(func.functionStandard) ?? 'N/A'),
          TableCellData(
            child: Tooltip(
              message: func.rawDurationType,
              child: Text(durationString(func.durationValue, func.durationType) ?? 'N/A'),
            ),
          ),
          TableCellData(
            child: Tooltip(
              message: func.rawDelayType,
              child: Text(durationString(func.delayValue, func.delayType) ?? 'N/A'),
            ),
          ),
        ],
      ),
      CustomTableRow.fromTexts(
        texts: ['Max Stack', 'Group ID', 'Lv', 'Use Limit', if (func.functionBattlepower != null) 'BP Mult'],
        defaults: headerData,
      ),
      CustomTableRow.fromTexts(
        texts: [
          '${func.fullCount}',
          '${func.groupId}',
          '${func.level}',
          func.limitValue != 0 ? '${func.limitValue}' : 'None',
          if (func.functionBattlepower != null) '${func.functionBattlepower}',
        ],
      ),
      if (func.timingTriggerType != TimingTriggerType.none)
        CustomTableRow.fromTexts(texts: ['Timing Trigger', 'Value', 'Standard'], defaults: headerData),
      if (func.timingTriggerType != TimingTriggerType.none)
        CustomTableRow.fromTexts(
          texts: [
            func.rawTimingTriggerType,
            timingValueDisplay(func.timingTriggerType, func.timingTriggerValue),
            func.rawTimingTriggerStandard,
          ],
        ),
      if (func.statusTriggerType != StatusTriggerType.none)
        CustomTableRow.fromTexts(texts: ['Status Trigger 1', 'Value', 'Standard'], defaults: headerData),
      if (func.statusTriggerType != StatusTriggerType.none)
        CustomTableRow.fromTexts(
          texts: [
            func.rawStatusTriggerType,
            statusValueDisplay(func.statusTriggerType, func.statusTriggerValue),
            func.rawStatusTriggerStandard,
          ],
        ),
      if (func.statusTrigger2Type != StatusTriggerType.none)
        CustomTableRow.fromTexts(texts: ['Status Trigger 2', 'Value', 'Standard'], defaults: headerData),
      if (func.statusTrigger2Type != StatusTriggerType.none)
        CustomTableRow.fromTexts(
          texts: [
            func.rawStatusTrigger2Type,
            statusValueDisplay(func.statusTrigger2Type, func.statusTrigger2Value),
            func.rawStatusTrigger2Standard,
          ],
        ),
      CustomTableRow.fromTexts(texts: ['Is Cancel', 'Keeping Type'], defaults: headerData),
      CustomTableRow.fromTexts(texts: ['${func.isCancel}', func.rawKeepingType]),
    ];

    children.add(Container(constraints: BoxConstraints(maxWidth: 700), child: CustomTable(children: dataRows)));

    final validFuncIds = func.connectedFunction.where((funcId) => funcId != 0).toList();
    final connectedFuncs = [
      if (validFuncIds.isNotEmpty) const Divider(),
      if (validFuncIds.isNotEmpty) Text('↓↓↓ Connected Functions ↓↓↓', style: TextStyle(fontSize: 16)),
      for (int idx = 0; idx < validFuncIds.length; idx += 1)
        Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: buffTypeColor(db.functionTable[validFuncIds[idx]]?.buff), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text('Connected Function ${connectFuncPrefix ?? ''}${idx + 1}', style: TextStyle(fontSize: 16)),
              SimpleFunctionDisplay(
                functionId: validFuncIds[idx],
                connectFuncPrefix: '${connectFuncPrefix ?? ''}${idx + 1}-',
              ),
            ],
          ),
        ),
    ];

    if (func.functionType == FunctionType.useCharacterSkillId) {
      final skillData = db.characterSkillTable[func.functionValue];
      children.add(Text('↓↓↓ Invoke This Skill ↓↓↓', style: TextStyle(fontSize: 16)));
      final skillColumn = Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: skillData == null ? Text('Not Found!') : CharacterSkillDataDisplay(data: skillData),
      );
      children.add(skillColumn);
    }

    children.addAll(connectedFuncs);

    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}

class MonsterSkillDataDisplay extends StatelessWidget {
  final MonsterSkillData data;
  final MonsterStatEnhanceData? statEnhanceData;

  NikkeDatabase get db => userDb.gameDb;

  static final boldStyle = TextStyle(fontWeight: FontWeight.bold);
  static final headerData = TableCellData(isHeader: true, style: boldStyle);

  const MonsterSkillDataDisplay({super.key, required this.data, this.statEnhanceData});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      if (data.nameKey != null)
        Text(locale.getTranslation(data.nameKey) ?? data.nameKey!, style: TextStyle(fontSize: 18)),
      Text('Monster Skill ID: ${data.id}', style: data.nameKey == null ? TextStyle(fontSize: 18) : null),
      if (data.descriptionKey != null) Text(locale.getTranslation(data.descriptionKey) ?? data.descriptionKey!),
      const Divider(),
      Text('Parameters', style: TextStyle(fontSize: 16)),
    ];

    final extraRate =
        data.fireType.isDamageType && statEnhanceData != null ? toModifier(statEnhanceData!.levelStatDamageRatio) : 1;

    final List<Widget> dataRows = [
      CustomTableRow.fromTexts(texts: ['Skill Type', 'Target', 'Shots'], defaults: headerData),
      CustomTableRow.fromTexts(texts: [data.rawFireType, data.rawPreferTarget, '${data.shotCount}']),
      CustomTableRow.fromTexts(texts: ['Show Locking', 'Casting Time', 'Delay', 'Shot Timing'], defaults: headerData),
      CustomTableRow.fromTexts(
        texts: ['${data.showLockOn}', data.castingTime.timeString, data.delayTime.timeString, data.shotTiming],
      ),
      CustomTableRow.fromTexts(
        texts: ['Penetration', 'Hit Character', 'Hit Cover', 'Hit Nothing'],
        defaults: headerData,
      ),
      CustomTableRow.fromTexts(
        texts: [
          '${data.penetration}',
          (data.targetCharacterRatio * 100).percentString,
          (data.targetCoverRatio * 100).percentString,
          (data.targetNothingRatio * 100).percentString,
        ],
      ),
      CustomTableRow.fromTexts(texts: ['Skill Values'], defaults: headerData),
      CustomTableRow.fromTexts(
        texts: [
          skillValueString(data.skillValue1, data.skillValueType1, extraRate) ?? 'None',
          skillValueString(data.skillValue2, data.skillValueType2, extraRate) ?? 'None',
        ],
      ),
      if (data.projectileHpRatio != 0)
        CustomTableRow.fromTexts(texts: ['Projectile HP', 'Explosion Range', 'Destroyable'], defaults: headerData),
      if (data.projectileHpRatio != 0)
        CustomTableRow.fromTexts(
          texts: [
            if (statEnhanceData == null) data.projectileHpRatio.percentString,
            if (statEnhanceData != null)
              (toModifier(data.projectileHpRatio) * statEnhanceData!.levelProjectileHp).decimalPattern,
            '${data.explosionRange}',
            '${data.isDestroyableProjectile}',
          ],
        ),
    ];

    children.add(Container(constraints: BoxConstraints(maxWidth: 700), child: CustomTable(children: dataRows)));

    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}
