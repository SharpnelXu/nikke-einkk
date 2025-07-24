import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/module/common/custom_table.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

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

    final damageParameter = NikkeDamageParameter(
      attack: nikke.baseAttack,
      attackBuff: nikke.getAttackBuffValues(simulation),
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

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      chargePercent: chargePercent,
      shotCount: weaponData.shotCount,
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

    final damageParameter = NikkeDamageParameter(
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

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: Source.bullet,
      damageParameter: damageParameter,
      invalid: !rapture.validateBulletDamage(nikke),
      chargePercent: chargePercent,
      shotCount: weaponData.shotCount,
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
  }) {
    final damageParameter = NikkeDamageParameter(
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

    return NikkeDamageEvent._(
      nikke.uniqueId,
      [rapture.uniqueId],
      source: source,
      damageParameter: damageParameter,
      invalid: !rapture.validateSkillDamage(nikke),
      shareCount: isShareDamage ? simulation.raptures.length : 0,
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
              text:
                  '${damageParameter.calculateExpectedDamage().decimalPattern}${invalid ? ' (Invalid)' : ''}'
                  '${shotCount > 1 ? ' ($shotCount shots)' : ''}'
                  '${damageParameter.criticalRate > 0 ? ' Crit: ${damageParameter.criticalRate.percentString}' : ''}'
                  '${damageParameter.coreHitRate > 0 ? ' Core: ${damageParameter.coreHitRate.percentString}' : ''}'
                  '${shareCount > 0 ? ' (Shared by $shareCount targets)' : ''}',
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
