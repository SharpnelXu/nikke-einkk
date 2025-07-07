import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';

class NikkeDamageEvent extends BattleEvent {
  late NikkeDamageType type;
  late String name;
  late int attackerUniqueId;
  late int targetUniqueId;
  late int chargePercent;
  late int shotCount;
  bool isShareDamage = false;
  int shareCount = 0;
  int? partId;

  bool invalid = true;

  late NikkeDamageParameter damageParameter;

  NikkeDamageEvent.bullet({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
  }) {
    name = nikke.name;
    type = NikkeDamageType.bullet;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;
    final weaponData = nikke.currentWeaponData;
    shotCount = weaponData.shotCount;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    final pierce = nikke.getPierce(simulation);
    partId = rapture.getPartsInFront();

    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
      defence: rapture.baseDefence,
      defenceBuff: rapture.getDefenceBuffValues(simulation),
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChangeBuffValues(simulation),
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreDamageBuffValues(simulation),
      criticalRate: nikke.getCriticalRate(simulation) + nikke.getNormalCriticalBuff(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isBonusRange: nikke.isBonusRange(rapture.distance),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: nikke.effectiveElements.any((ele) => ele.strongAgainst(rapture.element)),
      elementDamageBuff: nikke.getIncreaseElementDamageBuffValues(simulation),
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      chargePercent: chargePercent,
      // pierce won't hit rapture body as parts
      partDamageBuff: pierce == 0 && partId != null ? nikke.getPartsDamageBuffValues(simulation) : 0,
      pierceDamageBuff: pierce > 0 ? nikke.getPierceDamageBuffValues(simulation) : 0,
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      breakDamageBuff: partId == null && rapture.hasRedCircle ? nikke.getBreakDamageBuff(simulation) : 0,
      damageReductionBuff: rapture.getDamageReductionBuffValues(simulation),
    );

    invalid =
        rapture.invincible ||
        rapture.outsideScreen ||
        nikke.effectiveElements.every((ele) => !rapture.elementalShield.contains(ele));
  }

  NikkeDamageEvent.piercePart({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required BattleRaptureParts part,
  }) {
    name = nikke.name;
    type = NikkeDamageType.piercePart;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;
    final weaponData = nikke.currentWeaponData;
    shotCount = weaponData.shotCount;
    chargePercent =
        WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponType)
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    partId = part.id;

    // TODO: fill in other buff params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
      defence: rapture.baseDefence,
      defenceBuff: rapture.getDefenceBuffValues(simulation),
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChangeBuffValues(simulation),
      coreHitRate: part.isCore ? 10000 : 0,
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreDamageBuffValues(simulation),
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isBonusRange: nikke.currentWeaponType != WeaponType.rl ? nikke.isBonusRange(rapture.distance) : false,
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: nikke.element.strongAgainst(rapture.element),
      elementDamageBuff: nikke.getIncreaseElementDamageBuffValues(simulation),
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      chargePercent: chargePercent,
      partDamageBuff: nikke.getPartsDamageBuffValues(simulation),
      pierceDamageBuff: nikke.getPierceDamageBuffValues(simulation),
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      damageReductionBuff: rapture.getDamageReductionBuffValues(simulation),
    );

    invalid =
        rapture.invincible ||
        rapture.outsideScreen ||
        nikke.effectiveElements.every((ele) => !rapture.elementalShield.contains(ele));
  }

  NikkeDamageEvent.skill({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required int damageRate,
    this.isShareDamage = false,
  }) {
    name = nikke.name;
    type = NikkeDamageType.skill;
    attackerUniqueId = nikke.uniqueId;
    targetUniqueId = rapture.uniqueId;

    shotCount = 1;
    shareCount = simulation.raptures.length; // just share damage to all enemies
    chargePercent = 0;

    // TODO: fill in other buff params
    damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
      defence: rapture.baseDefence,
      defenceBuff: rapture.getDefenceBuffValues(simulation),
      damageRate: damageRate,
      coreHitRate: 0,
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: nikke.element.strongAgainst(rapture.element),
      elementDamageBuff: nikke.getIncreaseElementDamageBuffValues(simulation),
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      distributedDamageBuff: isShareDamage ? nikke.getShareDamageBuffValues(simulation) : 0,
      damageReductionBuff: rapture.getDamageReductionBuffValues(simulation),
    );

    invalid = rapture.invincible || nikke.effectiveElements.every((ele) => !rapture.elementalShield.contains(ele));
  }

  int calculateCoreHitRate(BattleSimulation simulation, BattleNikke nikke, BattleRapture rapture) {
    if (rapture.coreSize == 0) {
      // no core
      return 0;
    }

    if (rapture.coreRequiresPierce && nikke.getPierce(simulation) == 0) {
      // cannot hit core
      return 0;
    }

    if (WeaponType.chargeWeaponTypes.contains(nikke.currentWeaponType)) {
      return 10000;
    }

    // just a wild guess for now
    return (50 * rapture.coreSize / max(1, nikke.getAccuracyCircleScale(simulation) * rapture.distance) * 10000)
        .round();
  }

  @override
  int getActivatorUniqueId() {
    return attackerUniqueId;
  }

  @override
  List<int> getTargetUniqueIds() {
    return [targetUniqueId];
  }

  @override
  Widget buildDisplay() {
    final criticalPercent = min(toModifier(damageParameter.criticalRate), 1);
    final corePercent = min(toModifier(damageParameter.coreHitRate), 1);
    final nonCritPercent = 1 - criticalPercent;
    final nonCorePercent = 1 - corePercent;
    final basePercent = nonCritPercent * nonCorePercent;
    final coreCritPercent = criticalPercent * corePercent;

    final nameText = '$name (Pos $attackerUniqueId) ${type.name} damage: ${damageParameter.calculateExpectedDamage()}';
    final shotText = shotCount > 1 ? ' ($shotCount Shots)' : '';
    final chargeText = chargePercent > 0 ? ' Charge: ${(chargePercent / 100).toStringAsFixed(2)}%' : '';
    final baseText =
        basePercent > 0 ? ' Base: ${damageParameter.calculateDamage()} ${(basePercent * 100).toStringAsFixed(2)}%' : '';
    final coreText =
        corePercent > 0
            ? ' Core: ${damageParameter.calculateDamage(core: true)} ${(corePercent * 100).toStringAsFixed(2)}%'
            : '';
    final critText =
        criticalPercent > 0
            ? ' Crit: ${damageParameter.calculateDamage(critical: true)} ${(criticalPercent * 100).toStringAsFixed(2)}%'
            : '';
    final coreCritText =
        coreCritPercent > 0
            ? ' Core + Crit: ${damageParameter.calculateDamage(core: true, critical: true)}'
                ' ${(criticalPercent * 100).toStringAsFixed(2)}%'
            : '';
    final shareText = isShareDamage ? ' Shared by $shotCount targets' : '';

    return Text('$nameText$shotText$chargeText$baseText$coreText$critText$coreCritText$shareText');
  }
}

enum NikkeDamageType { bullet, skill, piercePart }
