import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';

class BurstGenerationEvent extends BattleEvent {
  String name = '';
  late int attackerUniqueId;
  int targetUniqueId = -1;
  int chargePercent = 0;
  int currentMeter = 0;
  int burst = 0;
  int positionBurstBonus = 10000;
  bool isBullet = true;

  BurstGenerationEvent({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
  }) {
    name = nikke.name;
    final weaponData = nikke.currentWeaponData;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(weaponData.weaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    currentMeter = simulation.burstMeter;
    final bonusBurst =
        (nikke.option.alwaysFocus || simulation.currentNikke == nikke.uniqueId) &&
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponData.weaponType);

    positionBurstBonus = bonusBurst ? 10000 + (15000 * toModifier(chargePercent)).round() : 10000;

    final baseBurst = nikke.getBurstGen(simulation, rapture.isStageTarget);

    burst = (baseBurst * weaponData.shotCount * toModifier(positionBurstBonus)).round();
  }

  BurstGenerationEvent.fill({required BattleSimulation simulation, required BattleNikke nikke, required this.burst}) {
    name = nikke.name;
    attackerUniqueId = nikke.uniqueId;
    isBullet = false;
  }

  @override
  int getActivatorId() {
    return attackerUniqueId;
  }

  @override
  List<int> getTargetIds() {
    return [targetUniqueId];
  }

  @override
  Widget buildDisplay() {
    final updatedBurst = min(currentMeter + burst, constData.burstMeterCap);

    return Text(
      '$name (Pos $attackerUniqueId) Burst Gen: ${(updatedBurst / 10000).toStringAsFixed(4)}%'
      ' (+${(burst / 10000).toStringAsFixed(4)}%)'
      '${positionBurstBonus > 10000 && isBullet ? ' Bonus: ${(positionBurstBonus / 100).toStringAsFixed(2)}%' : ''}',
    );
  }
}
