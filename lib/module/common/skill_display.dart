import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
import 'package:nikke_einkk/module/nikkes/nikke_widgets.dart';

class CharacterSkillDataDisplay extends StatelessWidget {
  final SkillData data;

  const CharacterSkillDataDisplay({super.key, required this.data});

  NikkeDatabaseV2 get db => userDb.gameDb;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final functionIds = data.allValidFuncIds;

    final skillInfo = db.skillInfoTable[data.id];

    final durationStr = durationString(data.durationValue, data.durationType);
    final valueStr = data.skillValueData
        .map((valueData) => valueString(valueData.skillValue, valueData.skillValueType))
        .join(', ');
    final List<Widget> children = [
      if (skillInfo != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 3,
          children: [
            Text(
              locale.getTranslation(skillInfo.nameLocalkey) ?? skillInfo.nameLocalkey,
              style: TextStyle(fontSize: 18),
            ),
            Tooltip(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              richMessage: TextSpan(
                children: buildDescriptionTextSpans(formatSkillInfoDescription(skillInfo), defaultStyle, db),
              ),
              child: Icon(Icons.info_outline, size: 16),
            ),
          ],
        ),
      Text('Active Skill ID: ${data.id}'),
      Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Type: ${data.rawSkillType}'),
          if (data.preferTarget != PreferTarget.none) Text('Target: ${data.rawPreferTarget}'),
          if (data.preferTargetCondition != PreferTargetCondition.none) Text('(${data.rawPreferTargetCondition})'),
        ],
      ),
      if (valueStr.isNotEmpty) Text('Skill Values: $valueStr'),
      Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (durationStr != null) Text('Duration: $durationStr'),
          Text('CD: ${data.skillCooltime.timeString}'),
        ],
      ),
    ];

    if (data.skillType == CharacterSkillType.changeWeapon) {
      final skillColumn = Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('↓↓↓ Equip This Weapon  ↓↓↓', style: TextStyle(fontSize: 16)),
            WeaponDataDisplay(weaponId: data.skillValueData[2].skillValue),
          ],
        ),
      );
      children.add(skillColumn);
    }

    if (data.skillType == CharacterSkillType.launchWeapon) {
      final skillColumn = Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('↓↓↓ Launch This Weapon  ↓↓↓', style: TextStyle(fontSize: 16)),
            WeaponDataDisplay(weaponId: data.skillValueData[2].skillValue),
          ],
        ),
      );
      children.add(skillColumn);
    }

    final connectedFunctions = [
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
            children: [Text('Function ${idx + 1}'), SimpleFunctionDisplay(functionId: functionIds[idx])],
          ),
        ),
    ];
    if (connectedFunctions.isNotEmpty) {
      children.add(Text('↓↓↓ Connected Functions ↓↓↓', style: TextStyle(fontSize: 16)));
      children.addAll(connectedFunctions);
    }

    return Column(spacing: 5, mainAxisSize: MainAxisSize.min, children: children);
  }
}

class StateEffectDataDisplay extends StatelessWidget {
  final StateEffectData data;

  NikkeDatabaseV2 get db => userDb.gameDb;

  const StateEffectDataDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final functionIds = data.allValidFuncIds;

    final skillInfo = db.skillInfoTable[data.id];

    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (skillInfo != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text(
                locale.getTranslation(skillInfo.nameLocalkey) ?? skillInfo.nameLocalkey,
                style: TextStyle(fontSize: 18),
              ),
              Tooltip(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                richMessage: TextSpan(
                  children: buildDescriptionTextSpans(formatSkillInfoDescription(skillInfo), defaultStyle, db),
                ),
                child: Icon(Icons.info_outline, size: 16),
              ),
            ],
          ),
        Text('Passive Skill ID: ${data.id}'),
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
              children: [Text('Function ${idx + 1}'), SimpleFunctionDisplay(functionId: functionIds[idx])],
            ),
          ),
      ],
    );
  }
}

class SimpleFunctionDisplay extends StatelessWidget {
  final int functionId;

  NikkeDatabaseV2 get db => userDb.gameDb;

  const SimpleFunctionDisplay({super.key, required this.functionId});

  @override
  Widget build(BuildContext context) {
    final func = db.functionTable[functionId];
    final List<Widget> children = [];
    if (func == null) {
      children.add(Text('Function not found!'));
    } else {
      if (func.nameLocalkey != null) {
        final description = formatFunctionDescription(func);
        children.add(
          Wrap(
            spacing: 5,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(func.rawBuffType, style: TextStyle(fontSize: 16)),
              Text(locale.getTranslation(func.nameLocalkey) ?? func.nameLocalkey!, style: TextStyle(fontSize: 16)),
              if (description.isNotEmpty)
                Tooltip(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  textStyle: TextStyle(fontSize: 14, color: Colors.black),
                  message: description,
                  child: Icon(Icons.info_outline, size: 16),
                ),
            ],
          ),
        );
      }
      final funcValueString = valueString(func.functionValue, func.functionValueType);
      final funcStandardString = functionStandardString(func.functionStandard);
      final durationStr = durationString(func.durationValue, func.durationType);
      final delayStr = durationString(func.delayValue, func.delayType);
      final miscRow = [
        if (delayStr != null) Text('Delay: $delayStr'),
        if (durationStr != null) Text('Remove: ${func.rawBuffRemove}'),
        if (durationStr != null) Text('Duration: $durationStr'),
        if (func.limitValue != 0) Text('Use Limit Per Battle: ${func.limitValue}'),
      ];

      final List<Widget> triggerRow = [];
      if (func.timingTriggerType != TimingTriggerType.none) {
        triggerRow.addAll([
          Text('Trigger: ${func.rawTimingTriggerType}'),
          if (func.timingTriggerValue != 0) Text('${func.timingTriggerValue}'),
          if (func.timingTriggerStandard != StandardType.none) Text('(of ${func.rawTimingTriggerStandard})'),
        ]);
      }

      final List<Widget> statusRow = [];
      if (func.statusTriggerType != StatusTriggerType.none) {
        statusRow.addAll([
          Text('Check: ${func.rawStatusTriggerType}'),
          if (func.statusTriggerValue != 0) Text('${func.statusTriggerValue}'),
          if (func.statusTriggerStandard != StandardType.none) Text('(of ${func.rawStatusTriggerStandard})'),
        ]);
      }
      if (func.statusTrigger2Type != StatusTriggerType.none) {
        statusRow.addAll([
          Text('Check: ${func.rawStatusTrigger2Type}'),
          if (func.statusTrigger2Value != 0) Text('${func.statusTrigger2Value}'),
          if (func.statusTrigger2Standard != StandardType.none) Text('(of ${func.rawStatusTrigger2Standard})'),
        ]);
      }
      final connectedFuncs = [
        for (final connectedFunc in func.connectedFunction.where((funcId) => funcId != 0))
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: buffTypeColor(db.functionTable[connectedFunc]?.buff), width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SimpleFunctionDisplay(functionId: connectedFunc),
          ),
      ];
      children.addAll([
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [Text('Function ID: $functionId'), if (func.fullCount != 1) Text('Max Stack: ${func.fullCount}')],
        ),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            Text('Target: ${func.rawFunctionTarget}'),
            Text('Type: ${func.rawFunctionType}'),
            if (funcValueString != null) Text('Value: $funcValueString'),
            if (funcStandardString != null) Text('(of $funcStandardString)'),
          ],
        ),
        if (triggerRow.isNotEmpty) Wrap(spacing: 5, alignment: WrapAlignment.center, children: triggerRow),
        if (statusRow.isNotEmpty) Wrap(spacing: 5, alignment: WrapAlignment.center, children: statusRow),
        if (miscRow.isNotEmpty) Wrap(spacing: 10, alignment: WrapAlignment.center, children: miscRow),
      ]);

      if (func.functionType == FunctionType.useCharacterSkillId) {
        final skillData = db.characterSkillTable[func.functionValue];
        final skillColumn = Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('↓↓↓ Invoke This Skill ↓↓↓', style: TextStyle(fontSize: 16)),
              skillData == null ? Text('Not Found!') : CharacterSkillDataDisplay(data: skillData),
            ],
          ),
        );
        children.add(skillColumn);
      }

      if (connectedFuncs.isNotEmpty) {
        children.add(Text('↓↓↓ Connected Functions ↓↓↓', style: TextStyle(fontSize: 16)));
        children.addAll(connectedFuncs);
      }
    }

    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}

class MonsterSkillDataDisplay extends StatelessWidget {
  final MonsterSkillData data;
  final MonsterStatEnhanceData? statEnhanceData;

  NikkeDatabaseV2 get db => userDb.gameDb;

  const MonsterSkillDataDisplay({super.key, required this.data, this.statEnhanceData});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (data.nameKey != null) {
      final description = locale.getTranslation(data.descriptionKey) ?? data.descriptionKey;
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 3,
          children: [
            Text(locale.getTranslation(data.nameKey) ?? data.nameKey!, style: TextStyle(fontSize: 18)),
            if (description != null)
              Tooltip(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                textStyle: TextStyle(fontSize: 14, color: Colors.black),
                message: description,
                child: Icon(Icons.info_outline, size: 16),
              ),
          ],
        ),
      );
    }
    final extraRate =
        data.fireType.isDamageType && statEnhanceData != null ? toModifier(statEnhanceData!.levelStatDamageRatio) : 1;
    final skillValue1Str = valueString(data.skillValue1 * extraRate, data.skillValueType1);
    final skillValue2Str = valueString(data.skillValue2 * extraRate, data.skillValueType2);
    final valueStr = [skillValue1Str, skillValue2Str].where((s) => s != null).join(', ');
    children.addAll([
      Text('Skill ID: ${data.id}'),
      Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        children: [
          Text('Type: ${data.rawFireType}'),
          if (valueStr.isNotEmpty) Text('($valueStr)'),
          Text('Target: ${data.rawPreferTarget} (${data.shotCount} shots)'),
        ],
      ),
      Wrap(
        spacing: 10,
        alignment: WrapAlignment.center,
        children: [
          Text('Penetration: ${data.penetration}'),
          Text('Locking: ${data.showLockOn}'),
          Text('Casting Time: ${data.castingTime.timeString}'),
        ],
      ),
    ]);
    if (data.projectileHpRatio != 0) {
      children.add(
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            Text('Projectile: '),
            if (statEnhanceData == null) Text('HP Ratio: ${data.projectileHpRatio.percentString}'),
            if (statEnhanceData != null)
              Text('HP: ${(toModifier(data.projectileHpRatio) * statEnhanceData!.levelProjectileHp).decimalPattern}'),
            Text('Destroyable: ${data.isDestroyableProjectile}'),
          ],
        ),
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, spacing: 3, children: children);
  }
}
