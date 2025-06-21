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
    final functionIds = data.allValidFuncIds;

    return Column(
      spacing: 3,
      children: [
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
        children.add(
          Tooltip(
            message: locale.getTranslation(func.descriptionLoaclkey) ?? func.descriptionLoaclkey ?? 'No Description',
            child: Text(locale.getTranslation(func.nameLocalkey) ?? func.nameLocalkey!),
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
      children.add(
        Tooltip(
          message: locale.getTranslation(data.descriptionKey) ?? data.descriptionKey ?? 'No Description',
          child: Text(locale.getTranslation(data.nameKey) ?? data.nameKey!),
        ),
      );
    }
    children.addAll([
      Text('Skill ID: ${data.id}'),
      Text('Type: ${data.rawFireType}'),
      Text('Target: ${data.rawPreferTarget} (${data.shotCount} shots)'),
      Text('Locking: ${data.showLockOn}'),
      Text('Casting Time: ${(data.castingTime / 100).toStringAsFixed(2)} s'),
    ]);
    if (data.projectileHpRatio != 0) {
      children.addAll([
        Text('Projectile HP Ratio: ${toPercentString(data.projectileHpRatio)}'),
        Text('Projectile Destroyable: ${data.isDestroyableProjectile}'),
      ]);
    }

    final skillValue1Str = valueString(data.skillValue1, data.skillValueType1);
    if (skillValue1Str != null) {
      children.add(Text('Value: $skillValue1Str'));
    }

    final skillValue2Str = valueString(data.skillValue2, data.skillValueType2);
    if (skillValue2Str != null) {
      children.add(Text('Value: $skillValue2Str'));
    }

    return Column(spacing: 3, children: children);
  }
}
