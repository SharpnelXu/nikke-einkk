import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';

import 'nikke.dart';

abstract class BattleEvent {
  Widget buildDisplay();

  int getActivatorUniqueId() {
    return -1;
  }

  int getTargetUniqueId() {
    return -1;
  }
}

// or replace these with an enum type if no real use case
class NikkeFireEvent extends BattleEvent {
  String name;
  int currentAmmo;
  int maxAmmo;
  int ownerUniqueId;

  NikkeFireEvent({required this.name, required this.currentAmmo, required this.maxAmmo, required this.ownerUniqueId});

  @override
  buildDisplay() {
    return Text('$name (Pos $ownerUniqueId) attack (Ammo: ${currentAmmo - 1}/$maxAmmo)');
  }

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }
}

class NikkeReloadStartEvent extends BattleEvent {
  String name;
  num reloadTimeData;
  int reloadFrames;
  int ownerUniqueId;

  NikkeReloadStartEvent({
    required this.name,
    required this.reloadTimeData,
    required this.reloadFrames,
    required this.ownerUniqueId,
  });

  @override
  int getActivatorUniqueId() {
    return ownerUniqueId;
  }

  @override
  Widget buildDisplay() {
    return Text(
      '$name (Pos $ownerUniqueId) reloading: '
      '${(reloadTimeData / 100).toStringAsFixed(2)}s ($reloadFrames frames)',
    );
  }
}

class NikkeDamageEvent extends BattleEvent {
  NikkeDamageType type;
  late WeaponData weaponData;
  late String name;
  late int attackerUniqueId;
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
    attackerUniqueId = nikke.uniqueId;
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
      defence: rapture.baseDefence,
      damageRate: weaponData.damage,
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
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
  int getActivatorUniqueId() {
    return attackerUniqueId;
  }

  @override
  int getTargetUniqueId() {
    return targetUniqueId;
  }

  @override
  Widget buildDisplay() {
    final criticalPercent = min(BattleUtils.toModifier(damageParameter.criticalRate), 1);
    final corePercent = min(BattleUtils.toModifier(damageParameter.coreHitRate), 1);
    final nonCriticalPercent = 1 - criticalPercent;
    final nonCorePercent = 1 - corePercent;

    return Text(
      '$name (Pos $attackerUniqueId) ${type.name} damage: ${damageParameter.calculateExpectedDamage()}'
      '${weaponData.shotCount > 1 ? ' (${weaponData.shotCount} Shots)' : ''}'
      '${chargePercent > 0 ? ' Charge: ${(chargePercent / 100).toStringAsFixed(2)}%' : ''}'
      ' (Base: ${damageParameter.calculateDamage()} ${((nonCriticalPercent * nonCorePercent) * 100).toStringAsFixed(2)}%'
      ' Core: ${damageParameter.calculateDamage(core: true)} ${(corePercent * 100).toStringAsFixed(2)}%,'
      ' Crit: ${damageParameter.calculateDamage(critical: true)} ${(criticalPercent * 100).toStringAsFixed(2)}%)'
      ' Core + Crit: ${damageParameter.calculateDamage(core: true, critical: true)} ${(criticalPercent * corePercent).toStringAsFixed(2)}%',
    );
  }
}

enum NikkeDamageType { bullet }

class BurstGenerationEvent extends BattleEvent {
  String name = '';
  late WeaponData weaponData;
  late int attackerUniqueId;
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
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(weaponData.weaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    currentMeter = simulation.burstMeter;
    final bonusBurst =
        simulation.currentNikke == nikke.uniqueId &&
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponData.weaponType);

    positionBurstBonus = bonusBurst ? 10000 + (15000 * BattleUtils.toModifier(chargePercent)).round() : 10000;

    final baseBurst = nikke.getBurstGen(simulation, rapture.isStageTarget);

    burst = (baseBurst * BattleUtils.toModifier(positionBurstBonus)).round();
  }

  @override
  int getActivatorUniqueId() {
    return attackerUniqueId;
  }

  @override
  int getTargetUniqueId() {
    return targetUniqueId;
  }

  @override
  Widget buildDisplay() {
    final updatedBurst = min(currentMeter + burst, BattleSimulation.burstMeterCap);

    return Text(
      '$name (Pos $attackerUniqueId) Burst Gen: ${(updatedBurst / 10000).toStringAsFixed(4)}%'
      ' (+${(burst / 10000).toStringAsFixed(4)}%)'
      '${positionBurstBonus > 10000 ? ' Bonus: ${(positionBurstBonus / 100).toStringAsFixed(2)}%' : ''}',
    );
  }
}

class BattleStartEvent extends BattleEvent {
  static BattleStartEvent battleStartEvent = BattleStartEvent._();

  BattleStartEvent._();

  @override
  Widget buildDisplay() {
    return Text('Battle Start');
  }
}
