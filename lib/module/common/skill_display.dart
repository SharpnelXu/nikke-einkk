import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/monster.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class StateEffectDataDisplay extends StatelessWidget {
  final bool useGlobal;
  final StateEffectData data;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  const StateEffectDataDisplay({super.key, required this.data, required this.useGlobal});

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final functionIds = data.allValidFuncIds;

    final skillInfo = db.skillInfoTable[data.id];

    return Column(
      spacing: 3,
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
        for (final functionId in functionIds)
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SimpleFunctionDisplay(functionId: functionId, useGlobal: useGlobal),
          ),
      ],
    );
  }
}

class SimpleFunctionDisplay extends StatelessWidget {
  final bool useGlobal;
  final int functionId;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  const SimpleFunctionDisplay({super.key, required this.functionId, required this.useGlobal});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              Text(locale.getTranslation(func.nameLocalkey) ?? func.nameLocalkey!),
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
      children.addAll([
        Text('Function ID: $functionId'),
        Text('Type: ${func.rawFunctionType}'),
        Text('Duration: ${func.durationValue} (${func.rawDurationType})'),
      ]);

      final funcValueString = valueString(func.functionValue, func.functionValueType);
      if (funcValueString != null) {
        children.add(Text('Value: $funcValueString'));
      }
    }

    return Column(spacing: 3, children: children);
  }
}

class MonsterSkillDataDisplay extends StatelessWidget {
  final bool useGlobal;
  final MonsterSkillData data;

  NikkeDatabaseV2 get db => useGlobal ? global : cn;

  const MonsterSkillDataDisplay({super.key, required this.data, required this.useGlobal});

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
    final skillValue1Str = valueString(data.skillValue1, data.skillValueType1);
    final skillValue2Str = valueString(data.skillValue2, data.skillValueType2);
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
          Text('Locking: ${data.showLockOn}'),
          Text('Casting Time: ${(data.castingTime / 100).toStringAsFixed(2)} s'),
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
            Text('HP: ${toPercentString(data.projectileHpRatio)}'),
            Text('Destroyable: ${data.isDestroyableProjectile}'),
          ],
        ),
      );
    }

    return Column(spacing: 3, children: children);
  }
}
