import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

Widget simpleBuffIcon(BattleSimulation simulation, BattleBuff buff) {
  final borderColor =
      buff.data.buff.isBuff
          ? Colors.green
          : buff.data.buff.isDeBuff
          ? Colors.red
          : Colors.grey;
  final funcTypeAbbr = buff.data.functionType.name.pascal.replaceAll(RegExp(r'[a-z\d]+'), '');
  final name = funcTypeAbbr.length > 1 ? '${funcTypeAbbr[0]}${funcTypeAbbr[funcTypeAbbr.length - 1]}' : funcTypeAbbr;
  return Container(
    padding: EdgeInsets.all(2),
    constraints: BoxConstraints(minWidth: 30, maxWidth: 40),
    decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(3)),
    child: Center(
      child: Tooltip(
        message:
            '${buff.data.functionType.name.pascal}'
            ' ${simulation.getEntityName(buff.buffGiverId)}'
            ': ${buff.source.name.pascal}',
        child: Wrap(
          children: [
            Text(name),
            if (buff.count > 1) Text('${buff.count}', style: TextStyle(fontFeatures: [FontFeature.superscripts()])),
          ],
        ),
      ),
    ),
  );
}
