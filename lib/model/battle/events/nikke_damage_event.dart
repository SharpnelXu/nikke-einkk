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
  // just record these for processing
  final bool isStickyCollision;
  final int stickyDamageRate;

  int get targetId => targetIds.first;

  NikkeDamageEvent._(
    super.activatorId,
    super.targetIds, {
    required this.source,
    required this.damageParameter,
    required this.invalid,
    this.chargePercent = 0,
    this.shotCount = 1,
    this.partId,
    this.shareCount = 0,
    this.isStickyCollision = false,
    this.stickyDamageRate = 0,
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
    final isParts = pierce == 0 && partId != null; // pierce won't hit rapture body as parts
    final isPierce = pierce > 0;
    final isCharge = chargePercent > 0;
    final isBreakDamage = partId == null && rapture.hasRedCircle;
    final isStickyCollision = weaponData.fireType == FireType.stickyProjectileDirect;
    final isProjectileExplosion = weaponData.weaponType == WeaponType.rl && !isStickyCollision;
    final damageParameter = NikkeDamageParameter(
      attack: nikke.getFinalAttack(simulation),
      ignoreDefence: ignoreDef,
      defence: ignoreDef ? 0 : rapture.getFinalDefence(simulation),
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChange(simulation),
      hitRate: pelletHitRate,
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreShotDamageChange(simulation),
      criticalRate: nikke.getCriticalRate(simulation) + nikke.getNormalStatCritical(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getStatCriticalDamage(simulation),
      isBonusRange: nikke.isBonusRange(simulation, rapture.distance),
      bonusRangeDamageBuff: nikke.getBonusRangeDamageChange(simulation),
      outBonusRangeDamageBuff: nikke.getOutBonusRangeDamageChange(simulation),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncElementDmg(simulation) : 0,
      chargeDamageRate: isCharge ? weaponData.fullChargeDamage : 0,
      chargeDamageBuff: isCharge ? nikke.getChargeDamageBuffs(simulation) : 0,
      chargePercent: chargePercent,
      addDamageBuff: nikke.getAddDamage(simulation),
      defIgnoreDamageBuff: ignoreDef ? nikke.getDefIgnoreDamageRatio(simulation) : 0,
      isPartsDamage: isParts,
      partDamageBuff: isParts ? nikke.getPartsDamage(simulation) : 0,
      isPierceDamage: isPierce,
      pierceDamageBuff: isPierce ? nikke.getPenetrationDamage(simulation) : 0,
      isBreakDamage: isBreakDamage,
      breakDamageBuff: isBreakDamage ? nikke.getBreakDamage(simulation) : 0,
      isProjectileExplosion: isProjectileExplosion,
      projectileExplosionBuff: isProjectileExplosion ? nikke.getProjectileExplosionDamage(simulation) : 0,
      isStickyCollision: isStickyCollision,
      stickyCollisionBuff: isStickyCollision ? nikke.getStickyProjectileCollisionDamage(simulation) : 0,
      damageReductionBuff: rapture.getDamageReduction(simulation),
    );

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      chargePercent: chargePercent,
      shotCount: nikke.getShotCount(simulation) * weaponData.muzzleCount,
      partId: partId,
      isStickyCollision: isStickyCollision,
      stickyDamageRate: isStickyCollision ? weaponData.damage * weaponData.muzzleCount : 0,
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
    final isParts = pierce == 0 && partId != null; // pierce won't hit rapture body as parts
    final isPierce = pierce > 0;
    final damageParameter = NikkeDamageParameter(
      attack: nikke.getFinalAttack(simulation),
      defence: rapture.getFinalDefence(simulation),
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChange(simulation),
      hitRate: pelletHitRate,
      coreHitRate: calculateCoreHitRate(simulation, nikke, rapture),
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreShotDamageChange(simulation),
      criticalRate: nikke.getCriticalRate(simulation) + nikke.getNormalStatCritical(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getStatCriticalDamage(simulation),
      isBonusRange: false,
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncElementDmg(simulation) : 0,
      isPartsDamage: isParts,
      partDamageBuff: isParts ? nikke.getPartsDamage(simulation) : 0,
      isPierceDamage: isPierce,
      pierceDamageBuff: isPierce ? nikke.getPenetrationDamage(simulation) : 0,
      addDamageBuff: nikke.getAddDamage(simulation),
      damageReductionBuff: rapture.getDamageReduction(simulation),
    );

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      shotCount: nikke.getShotCount(simulation) * weaponData.muzzleCount,
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
      ignoreDefence: ignoreDef,
      defence: ignoreDef ? 0 : rapture.getFinalDefence(simulation),
      damageRate: weaponData.damage * weaponData.muzzleCount,
      damageRateBuff: nikke.getNormalDamageRatioChange(simulation),
      coreHitRate: part.isCore ? 10000 : 0,
      coreDamageRate: weaponData.coreDamageRate,
      coreDamageBuff: nikke.getCoreShotDamageChange(simulation),
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getStatCriticalDamage(simulation),
      isBonusRange: nikke.isBonusRange(simulation, rapture.distance),
      bonusRangeDamageBuff: nikke.getBonusRangeDamageChange(simulation),
      outBonusRangeDamageBuff: nikke.getOutBonusRangeDamageChange(simulation),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncElementDmg(simulation) : 0,
      chargeDamageRate: weaponData.fullChargeDamage,
      chargeDamageBuff: nikke.getChargeDamageBuffs(simulation),
      chargePercent: chargePercent,
      addDamageBuff: nikke.getAddDamage(simulation),
      defIgnoreDamageBuff: ignoreDef ? nikke.getDefIgnoreDamageRatio(simulation) : 0,
      isPartsDamage: true,
      partDamageBuff: nikke.getPartsDamage(simulation),
      isPierceDamage: true,
      pierceDamageBuff: nikke.getPenetrationDamage(simulation),
      damageReductionBuff: rapture.getDamageReduction(simulation),
    );

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      chargePercent: chargePercent,
      shotCount: nikke.getShotCount(simulation) * weaponData.muzzleCount,
      partId: part.id,
    );
  }

  factory NikkeDamageEvent.skill({
    required BattleSimulation simulation,
    required BattleNikke nikke,
    required BattleRapture rapture,
    required int damageRate,
    required Source source,
    CharacterSkillType? skillType,
    bool isShareDamage = false,
    bool isDurationDamage = false,
    bool isIgnoreDefence = false,
    bool isProjectileExplosion = false,
    int? partId,
  }) {
    final bool isStrongEle = nikke.getEffectiveElements().any(
      (nEle) => rapture.baseElements.any((rEle) => nEle.strongAgainst(rEle)),
    );
    // TODO: confirm if this is in addDamage
    final rateIncrease =
        Source.burst == source
            ? [CharacterSkillType.instantAllParts, CharacterSkillType.instantAll].contains(skillType)
                ? nikke.getInstantAllBurstDamage(simulation)
                : nikke.getSingleBurstDamage(simulation)
            : 0;
    final damageParameter = NikkeDamageParameter(
      attack: nikke.getFinalAttack(simulation),
      ignoreDefence: isIgnoreDefence,
      defence: isIgnoreDefence ? 0 : rapture.getFinalDefence(simulation),
      damageRate: damageRate,
      coreHitRate: 0,
      criticalRate: nikke.getCriticalRate(simulation),
      criticalDamageRate: nikke.characterData.criticalDamage,
      criticalDamageBuff: nikke.getStatCriticalDamage(simulation),
      isFullBurst: simulation.burstStage == 4,
      isStrongElement: isStrongEle,
      elementDamageBuff: isStrongEle ? nikke.getIncElementDmg(simulation) : 0,
      addDamageBuff: nikke.getAddDamage(simulation),
      defIgnoreDamageBuff: isIgnoreDefence ? nikke.getDefIgnoreDamageRatio(simulation) : 0,
      isPartsDamage: partId != null,
      partDamageBuff: partId != null ? nikke.getPartsDamage(simulation) : 0,
      isDurationDamage: isDurationDamage,
      durationDamageBuff: isDurationDamage ? nikke.getDurationDamageRatio(simulation) : 0,
      isSkillDamage: true,
      skillDamageBuff: rateIncrease,
      isProjectileExplosion: isProjectileExplosion,
      projectileExplosionBuff: isProjectileExplosion ? nikke.getProjectileExplosionDamage(simulation) : 0,
      damageReductionBuff: rapture.getDamageReduction(simulation),
      isSharedDamage: isShareDamage,
      sharedDamageBuff: isShareDamage ? nikke.getShareDamageIncrease(simulation) : 0,
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

      if (source == Source.bullet &&
          chargePercent >= 10000 &&
          nikke.hasBuff(simulation, FunctionType.fullChargeHitDamageRepeat)) {
        final expectedDamage = damageParameter.calculateExpectedDamage();
        for (final repeat in nikke.buffs.where((b) => b.data.functionType == FunctionType.fullChargeHitDamageRepeat)) {
          final repeatDamage = (expectedDamage * (toModifier(repeat.data.functionValue) * repeat.count)).round();
          simulation.registerEvent(
            simulation.currentFrame,
            NikkeFixDamageEvent.create(nikke, rapture, repeat.source, repeatDamage),
          );
        }
      }

      if (isStickyCollision) {
        rapture.addStickyProjectile(simulation, nikke, this);
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
