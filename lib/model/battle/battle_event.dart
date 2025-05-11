import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';

import 'nikke.dart';

abstract class BattleEvent {
  Widget buildDisplay();

  int getUserPosition();
}

// or replace these with an enum type if no real use case
class NikkeFireEvent implements BattleEvent {
  String name;
  int currentAmmo;
  int maxAmmo;
  int ownerPosition; // this is basically uniqueId

  NikkeFireEvent({required this.name, required this.currentAmmo, required this.maxAmmo, required this.ownerPosition});

  @override
  buildDisplay() {
    return Text('$name (Pos $ownerPosition) attack (Ammo: $currentAmmo/$maxAmmo)');
  }

  @override
  int getUserPosition() {
    return ownerPosition;
  }
}

class NikkeReloadStartEvent implements BattleEvent {
  String name;
  num reloadTimeData;
  int reloadFrames;
  int ownerPosition; // this is basically uniqueId

  NikkeReloadStartEvent({
    required this.name,
    required this.reloadTimeData,
    required this.reloadFrames,
    required this.ownerPosition,
  });

  @override
  int getUserPosition() {
    return ownerPosition;
  }

  @override
  Widget buildDisplay() {
    return Text(
      '$name (Pos $ownerPosition) reloading: '
      '${(reloadTimeData / 100).toStringAsFixed(2)}s ($reloadFrames frames)',
    );
  }
}

class NikkeDamageEvent implements BattleEvent {
  NikkeDamageType type;
  late WeaponData weaponData;
  late String name;
  late int attackerPosition; // this is basically uniqueId for Nikke
  late int targetUniqueId;
  late int chargePercent;

  late NikkeDamageParameter damageParameter;

  NikkeDamageEvent({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required this.type,
  }) {
    name = nikke.name;
    attackerPosition = nikke.position;
    targetUniqueId = rapture.uniqueId;
    weaponData = nikke.currentWeaponData;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(weaponData.weaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);

    // TODO: fill in other buff params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
      defence: rapture.defence,
      damageRate: weaponData.damage,
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      isBonusRange: nikke.isBonusRange(rapture.distance),
      isFullBurst: simulation.fullBurst,
      isStrongElement: nikke.element.strongAgainst(rapture.element),
      elementDamageBuff: nikke.getIncreaseElementDamageBuffValues(simulation),
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      chargePercent: chargePercent,
      partDamageBuff: rapture.hasParts() ? nikke.getPartsDamageBuffValues(simulation) : 0,
    );
  }

  int calculateCoreHitRate(BattleSimulation simulation, BattleNikke nikke, BattleRapture rapture) {
    if (WeaponType.chargeWeaponTypes.contains(weaponData.weaponType)) return 10000;

    // just a wild guess for now
    return (50 * rapture.coreSize / max(1, nikke.getAccuracyCircleScale(simulation) * rapture.distance) * 10000)
        .round();
  }

  @override
  int getUserPosition() {
    return attackerPosition;
  }

  @override
  Widget buildDisplay() {
    return Text(
      '$name (Pos $attackerPosition) ${type.name} damage: ${damageParameter.calculateExpectedDamage()}'
      '${weaponData.shotCount > 1 ? ' (${weaponData.shotCount} Shots)' : ''}'
      '${chargePercent > 0 ? ' Charge: ${(chargePercent / 100).toStringAsFixed(2)}%' : ''}'
      ' (Core: ${(damageParameter.coreHitRate / 100).toStringAsFixed(2)}%,'
      ' Crit: ${(damageParameter.criticalRate / 100).toStringAsFixed(2)}%)',
    );
  }
}

enum NikkeDamageType { bullet }

class BurstGenerationEvent implements BattleEvent {
  String name = '';
  late WeaponData weaponData;
  late int attackerPosition; // this is basically uniqueId for Nikke
  late int targetUniqueId;
  int chargePercent = 0;
  int currentMeter = 0;
  int burst = 0;
  int positionBurstBonus = 10000;

  BurstGenerationEvent({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
  }) {
    name = nikke.name;
    weaponData = nikke.currentWeaponData;
    attackerPosition = nikke.position;
    targetUniqueId = rapture.uniqueId;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(weaponData.weaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    currentMeter = simulation.burstMeter;
    final bonusBurst =
        simulation.currentNikke == nikke.position &&
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponData.weaponType);

    positionBurstBonus = bonusBurst ? 10000 + (15000 * BattleUtils.toModifier(chargePercent)).round() : 10000;

    final baseBurst = nikke.getBurstGen(simulation, rapture.isStageTarget);

    burst = (baseBurst * BattleUtils.toModifier(positionBurstBonus)).round();
  }

  @override
  int getUserPosition() {
    return attackerPosition;
  }

  @override
  Widget buildDisplay() {
    final updatedBurst = min(currentMeter + burst, BattleSimulation.burstMeterCap);

    return Text(
      '$name (Pos $attackerPosition) Burst Gen: ${(updatedBurst / 10000).toStringAsFixed(4)}%'
      ' (+${(burst / 10000).toStringAsFixed(4)}%)'
      '${positionBurstBonus > 10000 ? ' Bonus: ${(positionBurstBonus / 100).toStringAsFixed(2)}%' : ''}',
    );
  }
}

class BattleStartEvent implements BattleEvent {
  final int userPosition;

  BattleStartEvent(this.userPosition);

  @override
  Widget buildDisplay() {
    return Text('Battle Start');
  }

  @override
  int getUserPosition() {
    return userPosition;
  }
}
