import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

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
      children: [Text('Passive Skill ID: ${data.id}'), for (final functionId in functionIds) buildFunction(functionId)],
    );
  }

  Widget buildFunction(int functionId) {
    final func = db.functionTable[functionId];
    final List<Widget> children = [Text('Function ID: $functionId')];
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
        Text('Type: ${func.rawFunctionType}'),
        Text('Duration: ${func.durationValue} (${func.rawDurationType})'),
      ]);
    }

    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(spacing: 3, children: children),
    );
  }
}
