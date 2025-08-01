import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';

class NikkeFireEvent extends BattleEvent {
  final int currentAmmo;
  final int maxAmmo;
  final bool isFullCharge;

  NikkeFireEvent(super.activatorId, {required this.isFullCharge, required this.currentAmmo, required this.maxAmmo});

  // minus 1 since ammo is subtracted at end of frame
  int get afterAmmo => currentAmmo - 1;

  @override
  void processNikke(BattleSimulation simulation, BattleNikke nikke) {
    if (nikke.uniqueId == activatorId) {
      nikke.currentAmmo = max(0, currentAmmo - 1);
      nikke.totalBulletsFired += 1;

      if (isFullCharge) {
        nikke.totalFullChargeFired += 1;
      }

      for (final buff in nikke.buffs) {
        if (buff.data.durationType.isShots && simulation.db.onShotFunctionTypes.contains(buff.data.functionType)) {
          buff.duration -= 1;
        }
      }

      if (nikke.changeWeaponSkill != null && nikke.changeWeaponSkill?.durationType == DurationType.shots) {
        nikke.changeWeaponDuration -= 1;
      }

      // auto would still perform retreat behind cover animation
      if (currentAmmo == 0) {
        nikke.spotLastDelayFrameCount = timeDataToFrame(nikke.currentWeaponData.spotLastDelay, simulation.fps);
      }
    }
  }

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
