import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class HpChangeEvent extends BattleEvent {
  bool isHeal;

  late int afterChangeHp;
  late int maxHp;
  bool isMaxHpOnly;
  int changeAmount;

  HpChangeEvent(
    super.activatorId, {
    required this.changeAmount,
    required this.afterChangeHp,
    required this.maxHp,
    this.isHeal = false,
    this.isMaxHpOnly = false,
  });

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    final hpPercent = (afterChangeHp / maxHp * 100).toStringAsFixed(2);
    return CustomTable(
      children: [
        CustomTableRow(
          children: [
            battleHeaderData.copyWith(text: '${isMaxHpOnly ? 'Max ' : ''}HP Change', flex: 2),
            battleHeaderData.copyWith(text: 'Activator', flex: 1),
            battleHeaderData.copyWith(text: 'Is Heal', flex: 1),
          ],
        ),
        CustomTableRow(
          children: [
            TableCellData(
              text:
                  '${changeAmount >= 0 ? '+' : ''}'
                  '${changeAmount.decimalPattern}'
                  ' (${afterChangeHp.decimalPattern} / ${maxHp.decimalPattern}, $hpPercent%)',
              flex: 2,
            ),
            TableCellData(text: '${simulation.getEntityName(activatorId)}', flex: 1),
            TableCellData(text: '$isHeal', flex: 1),
          ],
        ),
      ],
    );
  }
}
