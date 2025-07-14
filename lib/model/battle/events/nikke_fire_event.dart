import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';

class NikkeFireEvent extends BattleEvent {
  final int currentAmmo;
  final int maxAmmo;
  final bool isFullCharge;

  NikkeFireEvent(super.activatorId, {required this.isFullCharge, required this.currentAmmo, required this.maxAmmo});

  // minus 1 since ammo is subtracted at end of frame
  int get afterAmmo => currentAmmo - 1;

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow.fromTexts(texts: ['Bullets Fired', 'Activator'], defaults: battleHeaderData),
        CustomTableRow.fromTexts(texts: ['$afterAmmo / $maxAmmo', '${simulation.getEntityName(activatorId)}']),
      ],
    );
  }
}
