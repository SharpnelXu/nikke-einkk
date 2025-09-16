import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

class NikkeFixDamageEvent extends BattleEvent {
  final Source source;
  final int damage;
  final bool invalid;

  int get targetId => targetIds.first;

  NikkeFixDamageEvent._(super.activatorId, super.targetIds, this.source, this.damage, this.invalid);

  factory NikkeFixDamageEvent.create(BattleNikke nikke, BattleRapture rapture, Source source, int damage) {
    return NikkeFixDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source,
      damage,
      !rapture.validateBulletDamage(nikke),
    );
  }

  @override
  void processNikke(BattleSimulation simulation, BattleNikke nikke) {
    if (activatorId == nikke.uniqueId) {
      final rapture = simulation.getRaptureByUniqueId(targetId);
      if (rapture == null) return;

      final drainHp = nikke.getDrainHpBuff(simulation);
      if (drainHp > 0) {
        nikke.changeHp(simulation, (toModifier(drainHp) * damage).round(), true);
      }
    }
  }

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow(
          children: [
            battleHeaderData.copyWith(text: 'Nikke Damage', flex: 4),
            battleHeaderData.copyWith(text: 'Activator', flex: 2),
            battleHeaderData.copyWith(text: 'Target', flex: 2),
            battleHeaderData.copyWith(text: 'Source', flex: 1),
          ],
        ),
        CustomTableRow(
          children: [
            TableCellData(text: '${damage.decimalPattern}${invalid ? ' (Invalid)' : ''}', flex: 4),
            TableCellData(text: '${simulation.getEntityName(activatorId)}', flex: 2),
            TableCellData(text: '${simulation.getEntityName(targetId)}', flex: 2),
            TableCellData(text: source.name.pascal, flex: 1),
          ],
        ),
      ],
    );
  }
}

class NikkeDamageEvent extends BattleEvent {
  final NikkeDamageParameter damageParameter;
  final Source source;
  final bool invalid;
  final int chargePercent;
  final int shotCount;
  final int shareCount;
  final int? partId;

  int get targetId => targetIds.first;

  NikkeDamageEvent._(
    super.activatorId,
    super.targetIds, {
    required this.source,
    required this.damageParameter,
    required this.invalid,
    this.chargePercent = 10000,
    this.shotCount = 1,
    this.partId,
    this.shareCount = 0,
  });

  factory NikkeDamageEvent.bullet({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
  }) {
    final weaponData = nikke.currentWeaponData;
    int chargePercent =
        nikke.currentWeaponType.isCharge
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);
    final pierce = nikke.getPierce(simulation);
    final partId = rapture.getPartsInFront();
    final customHitRateThreshold = nikke.option.customHitRateThreshold;
    final customHitRate = nikke.option.customHitRate;
    int pelletHitRate = 10000;
    if (customHitRateThreshold != null &&
        customHitRate != null &&
        customHitRateThreshold <= nikke.getAccuracyCircleScale(simulation)) {
      pelletHitRate = (customHitRate * 100).round();
    }

    final isStrongEle = nikke.getEffectiveElements().any(
      (nEle) => rapture.baseElements.any((rEle) => nEle.strongAgainst(rEle)),
    );
    final ignoreDef = nikke.hasChangeNormalDefIgnoreDamage(simulation);
    final damageParameter = NikkeDamageParameter(
      attack: nikke.getFinalAttack(simulation),
      defence: ignoreDef ? 0 : rapture.baseDefence,
      defenceBuff: ignoreDef ? 0 : rapture.getDefenceBuffValues(simulation),
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChangeBuffValues(simulation),
      hitRate: pelletHitRate,
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreDamageBuffValues(simulation),
      criticalRate: nikke.getCriticalRate(simulation) + nikke.getNormalCriticalBuff(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isBonusRange: nikke.isBonusRange(rapture.distance),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncreaseElementDamageBuffValues(simulation) : 0,
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      chargePercent: chargePercent,
      // pierce won't hit rapture body as parts
      partDamageBuff: pierce == 0 && partId != null ? nikke.getPartsDamageBuffValues(simulation) : 0,
      pierceDamageBuff: pierce > 0 ? nikke.getPierceDamageBuffValues(simulation) : 0,
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      breakDamageBuff: partId == null && rapture.hasRedCircle ? nikke.getBreakDamageBuff(simulation) : 0,
      defIgnoreDamageBuff: ignoreDef ? nikke.getDefIgnoreDamageBuffValues(simulation) : 0,
      damageReductionBuff: rapture.getDamageReductionBuffValues(simulation),
    );

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      chargePercent: chargePercent,
      shotCount: weaponData.shotCount * weaponData.muzzleCount,
      partId: partId,
    );
  }

  factory NikkeDamageEvent.launchWeapon({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required WeaponData weaponData,
    required BattleRapture rapture,
  }) {
    final pierce = weaponData.penetration;
    final partId = rapture.getPartsInFront();
    final customHitRateThreshold = nikke.option.customHitRateThreshold;
    final customHitRate = nikke.option.customHitRate;
    int pelletHitRate = 10000;
    if (customHitRateThreshold != null &&
        customHitRate != null &&
        customHitRateThreshold <= nikke.getAccuracyCircleScale(simulation)) {
      pelletHitRate = (customHitRate * 100).round();
    }

    final bool isStrongEle = nikke.getEffectiveElements().any(
      (nEle) => rapture.baseElements.any((rEle) => nEle.strongAgainst(rEle)),
    );
    final damageParameter = NikkeDamageParameter(
      attack: nikke.getFinalAttack(simulation),
      defence: rapture.baseDefence,
      defenceBuff: rapture.getDefenceBuffValues(simulation),
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChangeBuffValues(simulation),
      hitRate: pelletHitRate,
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreDamageBuffValues(simulation),
      criticalRate: nikke.getCriticalRate(simulation) + nikke.getNormalCriticalBuff(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isBonusRange: false,
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncreaseElementDamageBuffValues(simulation) : 0,
      // pierce won't hit rapture body as parts
      partDamageBuff: pierce == 0 && partId != null ? nikke.getPartsDamageBuffValues(simulation) : 0,
      pierceDamageBuff: pierce > 0 ? nikke.getPierceDamageBuffValues(simulation) : 0,
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      damageReductionBuff: rapture.getDamageReductionBuffValues(simulation),
    );

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      shotCount: weaponData.shotCount * weaponData.muzzleCount,
      partId: partId,
    );
  }

  factory NikkeDamageEvent.piercePart({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required BattleRaptureParts part,
  }) {
    final weaponData = nikke.currentWeaponData;
    int chargePercent =
        weaponData.weaponType.isCharge
            ? (10000 * nikke.chargeFrames / nikke.getFramesToFullCharge(simulation)).round()
            : 0;
    chargePercent = chargePercent.clamp(0, 10000);

    final isStrongEle = nikke.getEffectiveElements().any(
      (nEle) => rapture.baseElements.any((rEle) => nEle.strongAgainst(rEle)),
    );
    final ignoreDef = nikke.hasChangeNormalDefIgnoreDamage(simulation);
    final damageParameter = NikkeDamageParameter(
      attack: nikke.getFinalAttack(simulation),
      defence: ignoreDef ? 0 : rapture.baseDefence,
      defenceBuff: ignoreDef ? 0 : rapture.getDefenceBuffValues(simulation),
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
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncreaseElementDamageBuffValues(simulation) : 0,
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffValues(simulation),
      chargePercent: chargePercent,
      partDamageBuff: nikke.getPartsDamageBuffValues(simulation),
      pierceDamageBuff: nikke.getPierceDamageBuffValues(simulation),
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      damageReductionBuff: rapture.getDamageReductionBuffValues(simulation),
      defIgnoreDamageBuff: ignoreDef ? nikke.getDefIgnoreDamageBuffValues(simulation) : 0,
    );

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      chargePercent: chargePercent,
      shotCount: weaponData.shotCount * weaponData.muzzleCount,
      partId: part.id,
    );
  }

  factory NikkeDamageEvent.skill({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required int damageRate,
    required Source source,
    bool isShareDamage = false,
    bool isDurationDamage = false,
    bool isIgnoreDefence = false,
    int? partId,
  }) {
    final bool isStrongEle = nikke.getEffectiveElements().any(
      (nEle) => rapture.baseElements.any((rEle) => nEle.strongAgainst(rEle)),
    );
    final damageParameter = NikkeDamageParameter(
      attack: nikke.getFinalAttack(simulation),
      defence: isIgnoreDefence ? 0 : rapture.baseDefence,
      defenceBuff: isIgnoreDefence ? 0 : rapture.getDefenceBuffValues(simulation),
      damageRate: damageRate,
      coreHitRate: 0,
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getCriticalDamageBuffValues(simulation),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncreaseElementDamageBuffValues(simulation) : 0,
      addDamageBuff: nikke.getAddDamageBuffValues(simulation),
      distributedDamageBuff: isShareDamage ? nikke.getShareDamageBuffValues(simulation) : 0,
      damageReductionBuff: rapture.getDamageReductionBuffValues(simulation),
      sustainedDamageBuff: isDurationDamage ? nikke.getDurationDamageRatioBuffValues(simulation) : 0,
      defIgnoreDamageBuff: isIgnoreDefence ? nikke.getDefIgnoreDamageBuffValues(simulation) : 0,
      partDamageBuff: partId != null ? nikke.getPartsDamageBuffValues(simulation) : 0,
    );

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: source,
      damageParameter: damageParameter,
      invalid: !rapture.validateSkillDamage(simulation, nikke),
      shareCount: isShareDamage ? simulation.raptures.length : 0,
      partId: partId,
    );
  }

  static int calculateCoreHitRate(BattleSimulation simulation, BattleNikke nikke, BattleRapture rapture) {
    if (rapture.coreSize == 0) {
      // no core
      return 0;
    }

    if (nikke.option.coreHitRate != null) {
      return (nikke.option.coreHitRate! * 100).round();
    }

    if (nikke.currentWeaponType.isCharge) {
      return 10000;
    }

    // just a wild guess for now
    return (50 * rapture.coreSize / max(1, nikke.getAccuracyCircleScale(simulation) * rapture.distance) * 10000)
        .round();
  }

  @override
  void processNikke(BattleSimulation simulation, BattleNikke nikke) {
    if (activatorId == nikke.uniqueId) {
      final rapture = simulation.getRaptureByUniqueId(targetId);
      if (rapture == null) return;

      if (source == Source.bullet) {
        nikke.totalBulletsHit += 1;
      }

      final drainHp = nikke.getDrainHpBuff(simulation);
      if (drainHp > 0) {
        final expectedDamage = damageParameter.calculateExpectedDamage();
        nikke.changeHp(simulation, (toModifier(drainHp) * expectedDamage).round(), true);
      }

      rapture.hitMonsterGetBuffData?.applyBuff(simulation, this);
      rapture.targetHitCountGetBuffData?.applyBuff(simulation, this);
      rapture.stigmaData?.accumulateDamage(simulation, this);
      final explosiveCircuitData = rapture.explosiveCircuitData;
      if (explosiveCircuitData != null) {
        explosiveCircuitData.accumulateDamage(simulation, this);
        if (explosiveCircuitData.maxAccumulation <= explosiveCircuitData.currentAccumulation) {
          explosiveCircuitData.releaseAccumulationDamage(simulation);
          rapture.explosiveCircuitData = null;
        }
      }
    }
  }

  @override
  Widget buildDisplayV2(BattleSimulation simulation) {
    return CustomTable(
      children: [
        CustomTableRow(
          children: [
            battleHeaderData.copyWith(text: 'Nikke Damage', flex: 4),
            battleHeaderData.copyWith(text: 'Activator', flex: 2),
            battleHeaderData.copyWith(text: 'Target', flex: 2),
            battleHeaderData.copyWith(text: 'Source', flex: 1),
          ],
        ),
        CustomTableRow(
          children: [
            TableCellData(
              child: Tooltip(
                message:
                    'Damage Rate: ${damageParameter.damageRate.percentString}\n'
                    'Shot Count: $shotCount\n'
                    'Crit: ${damageParameter.criticalRate.percentString}\n'
                    'Core: ${damageParameter.coreHitRate.percentString}\n'
                    'Share Count: $shareCount\n'
                    'Charge Damage Rate: ${damageParameter.chargeDamageRate.percentString}\n'
                    'Charge Damage Buff: ${damageParameter.chargeDamageBuff.percentString}',
                child: Wrap(
                  spacing: 4,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(CupertinoIcons.info_circle, size: 16),
                    Text('${damageParameter.calculateExpectedDamage().decimalPattern}${invalid ? ' (Invalid)' : ''}'),
                  ],
                ),
              ),
              flex: 4,
            ),
            TableCellData(text: '${simulation.getEntityName(activatorId)}', flex: 2),
            TableCellData(text: '${simulation.getEntityName(targetId)}', flex: 2),
            TableCellData(text: source.name.pascal, flex: 1),
          ],
        ),
      ],
    );
  }
}
