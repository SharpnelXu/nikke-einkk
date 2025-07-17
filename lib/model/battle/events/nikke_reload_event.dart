import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';

class NikkeReloadStartEvent extends BattleEvent {
  final int reloadFrames;

  NikkeReloadStartEvent(super.activatorId, this.reloadFrames);

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(texts: ['Reloading', 'Activator'], defaults: battleHeaderData),
        CustomTableRow.fromTexts(
          texts: [
            '${(reloadFrames / simulation.fps).toStringAsFixed(2)} s ($reloadFrames Frames)',
            '${simulation.getEntityName(activatorId)}',
          ],
        ),
      ],
    );
  }
}

class NikkeReloadEndEvent extends BattleEvent {
  NikkeReloadEndEvent(super.activatorId);

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(texts: ['Reload Complete'], defaults: battleHeaderData),
        CustomTableRow.fromTexts(texts: ['${simulation.getEntityName(activatorId)}']),
      ],
    );
  }
}
