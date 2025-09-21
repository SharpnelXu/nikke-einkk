import 'dart:math';

import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

double toModifier(int ratio) {
  return ratio / 10000;
}

int correction(int damageRate) {
  return damageRate - 10000;
}

int timeDataToFrame(num timeData, int fps) {
  return (timeData * fps / 100).round();
}

// for display
int frameToTimeData(int frame, int fps) {
  return (frame * 100 / fps).round();
}

// CharacterStatTable[statEnhanceId = groupId][lv] to get baseStat
// CharacterStateEnhanceTable[statEnhanceId = id] to get gradeEnhanceStat
// grade is [1, 4]
// gradeStat = baseStat * gradeRatio (usually 2%) * (grade - 1) + gradeStat * (grade - 1)
// MLBStat = baseStat + gradeStat
// core is [1, 7]
// coreStat = (MLBStat (which is gradeStat + baseStat) + bond stat + console stat) * coreRatio (2%)
// finalStat = baseStat + gradeStat + coreStat + bondStat + consoleStat + cubeStat + gearStat + dollStat
// However, it is unclear if this value is stored as int or double
int getBaseStat({
  required int coreLevel,
  required int baseStat,
  required int gradeRatio,
  required int gradeEnhanceBase,
  required int coreEnhanceBaseRatio,
  required int consoleStat,
  required int bondStat,
  required int equipStat,
  required int cubeStat,
  required int dollStat,
}) {
  final gradeLevel = min(4, coreLevel) - 1;
  final gradeFlat = gradeLevel * gradeEnhanceBase;
  final gradeRatioStat = baseStat * gradeLevel * toModifier(gradeRatio);
  final gradeAddStat = gradeRatioStat + gradeFlat;
  final gradeStat = baseStat + consoleStat + bondStat + gradeAddStat.floor();

  final coreActualLevel = coreLevel - 4;
  final coreStat = coreActualLevel > 0 ? gradeStat * coreActualLevel * toModifier(coreEnhanceBaseRatio) : 0;

  // here it seems to be a simple rounding without roundHalfToEven, tested via Brid's HP stat
  final result = gradeStat + coreStat.round() + equipStat + cubeStat + dollStat;

  return result;
}

Source getSource(int skillNum) {
  return skillNum == 1
      ? Source.skill1
      : skillNum == 2
      ? Source.skill2
      : Source.burst;
}

double getBpStatMult({required int hp, required int atk, required int def}) {
  final statMult = (1.075 * atk * 18 + (def * 100 + hp) * 0.7) / 100;
  return statMult;
}

/// credit: https://ngabbs.com/read.php?tid=40380218
int getBattlePoint({
  required int hp,
  required int atk,
  required int def,
  required List<int> skillLvs,
  required int funcBpSum,
}) {
  final statMult = (1.075 * atk * 18 + (def * 100 + hp) * 0.7) / 100;
  final skillPoint = 0.01 * (skillLvs[0] + skillLvs[1] + 2 * skillLvs[2]) + funcBpSum / 10000;
  return (statMult * (1.3 + skillPoint)).round();
}

class NikkeDamageParameter {
  // base
  int attack = 0;
  bool ignoreDefence = false;
  int defence = 0;

  int damageRate = 10000; // 100%
  int damageRateBuff = 0;
  int hitRate = 10000;

  // correction
  int coreHitRate = 0;
  int coreDamageRate = 10000; // 100%
  int coreDamageBuff = 0;
  int criticalRate = 1500; // 15%
  int criticalDamageRate = 10000;
  int criticalDamageBuff = 0;
  bool isBonusRange = false;
  // unclear if this is in correction or add damage
  int bonusRangeDamageBuff = 0;
  int outBonusRangeDamageBuff = 0;
  bool isFullBurst = false;

  // element
  bool isStrongElement = false;
  int elementDamageBuff = 0;

  // full charge
  bool get isCharge => chargePercent > 0;
  int chargePercent = 0;
  int chargeDamageRate = 10000;
  int chargeDamageBuff = 0;

  // add damage, parts, sustain, pierce
  int addDamageBuff = 0;
  int defIgnoreDamageBuff = 0;
  bool isPartsDamage = false;
  int partDamageBuff = 0;
  bool isDurationDamage = false;
  int durationDamageBuff = 0;
  bool isPierceDamage = false;
  int pierceDamageBuff = 0;
  bool isBreakDamage = false;
  int breakDamageBuff = 0;
  bool isProjectileDamage = false;
  int projectileDamageBuff = 0;

  // receive damage, distribute
  int damageReductionBuff = 0;
  bool isSharedDamage = false;
  int sharedDamageBuff = 0;

  NikkeDamageParameter({
    this.attack = 0,
    this.ignoreDefence = false,
    this.defence = 0,
    this.damageRate = 10000,
    this.damageRateBuff = 0,
    this.hitRate = 10000,
    this.coreHitRate = 0,
    this.coreDamageRate = 10000,
    this.coreDamageBuff = 0,
    this.criticalRate = 1500,
    this.criticalDamageRate = 10000,
    this.criticalDamageBuff = 0,
    this.isBonusRange = false,
    this.bonusRangeDamageBuff = 0,
    this.outBonusRangeDamageBuff = 0,
    this.isFullBurst = false,
    this.isStrongElement = false,
    this.elementDamageBuff = 0,
    this.chargePercent = 0,
    this.chargeDamageRate = 10000,
    this.chargeDamageBuff = 0,
    this.addDamageBuff = 0,
    this.defIgnoreDamageBuff = 0,
    this.isPartsDamage = false,
    this.partDamageBuff = 0,
    this.isDurationDamage = false,
    this.durationDamageBuff = 0,
    this.isPierceDamage = false,
    this.pierceDamageBuff = 0,
    this.isBreakDamage = false,
    this.breakDamageBuff = 0,
    this.isProjectileDamage = false,
    this.projectileDamageBuff = 0,
    this.damageReductionBuff = 0,
    this.isSharedDamage = false,
    this.sharedDamageBuff = 0,
  });

  @override
  String toString() {
    return 'NikkeDamageParameter{'
        'attack: $attack, '
        'ignoreDefence: $ignoreDefence, '
        'defence: $defence, '
        'damageRate: $damageRate, '
        'damageRateBuff: $damageRateBuff, '
        'hitRate: $hitRate, '
        'coreHitRate: $coreHitRate, '
        'coreDamageRate: $coreDamageRate, '
        'coreDamageBuff: $coreDamageBuff, '
        'criticalRate: $criticalRate, '
        'criticalDamageRate: $criticalDamageRate, '
        'criticalDamageBuff: $criticalDamageBuff, '
        'isBonusRange: $isBonusRange, '
        'bonusRangeDamageBuff: $bonusRangeDamageBuff, '
        'outBonusRangeDamageBuff: $outBonusRangeDamageBuff, '
        'isFullBurst: $isFullBurst, '
        'isStrongElement: $isStrongElement, '
        'elementDamageBuff: $elementDamageBuff, '
        'chargePercent: $chargePercent, '
        'chargeDamageRate: $chargeDamageRate, '
        'chargeDamageBuff: $chargeDamageBuff, '
        'addDamageBuff: $addDamageBuff, '
        'defIgnoreDamageBuff: $defIgnoreDamageBuff, '
        'isPartsDamage: $isPartsDamage, '
        'partDamageBuff: $partDamageBuff, '
        'isDurationDamage: $isDurationDamage, '
        'durationDamageBuff: $durationDamageBuff, '
        'isPierceDamage: $isPierceDamage, '
        'pierceDamageBuff: $pierceDamageBuff, '
        'isBreakDamage: $isBreakDamage, '
        'breakDamageBuff: $breakDamageBuff, '
        'isProjectileDamage: $isProjectileDamage, '
        'projectileDamageBuff: $projectileDamageBuff, '
        'damageReductionBuff: $damageReductionBuff, '
        'isSharedDamage: $isSharedDamage, '
        'sharedDamageBuff: $sharedDamageBuff'
        '}';
  }

  NikkeDamageParameter copy() {
    return NikkeDamageParameter(
      attack: attack,
      defence: defence,
      ignoreDefence: ignoreDefence,
      damageRate: damageRate,
      damageRateBuff: damageRateBuff,
      hitRate: hitRate,
      coreHitRate: coreHitRate,
      coreDamageRate: coreDamageRate,
      coreDamageBuff: coreDamageBuff,
      criticalRate: criticalRate,
      criticalDamageRate: criticalDamageRate,
      criticalDamageBuff: criticalDamageBuff,
      isBonusRange: isBonusRange,
      bonusRangeDamageBuff: bonusRangeDamageBuff,
      outBonusRangeDamageBuff: outBonusRangeDamageBuff,
      isFullBurst: isFullBurst,
      isStrongElement: isStrongElement,
      elementDamageBuff: elementDamageBuff,
      chargeDamageRate: chargeDamageRate,
      chargeDamageBuff: chargeDamageBuff,
      chargePercent: chargePercent,
      addDamageBuff: addDamageBuff,
      defIgnoreDamageBuff: defIgnoreDamageBuff,
      isPartsDamage: isPartsDamage,
      partDamageBuff: partDamageBuff,
      isDurationDamage: isDurationDamage,
      durationDamageBuff: durationDamageBuff,
      isPierceDamage: isPierceDamage,
      pierceDamageBuff: pierceDamageBuff,
      isBreakDamage: isBreakDamage,
      breakDamageBuff: breakDamageBuff,
      isProjectileDamage: isProjectileDamage,
      projectileDamageBuff: projectileDamageBuff,
      damageReductionBuff: damageReductionBuff,
      isSharedDamage: isSharedDamage,
      sharedDamageBuff: sharedDamageBuff,
    );
  }

  int calculateExpectedDamage() {
    final baseDamage = calculateDamage();
    final critDamage = calculateDamage(critical: true);
    final coreDamage = calculateDamage(core: true);
    final critCoreDamage = calculateDamage(critical: true, core: true);

    final criticalPercent = min(toModifier(criticalRate), 1);
    final corePercent = min(toModifier(coreHitRate), 1);
    final nonCriticalPercent = 1 - criticalPercent;
    final nonCorePercent = 1 - corePercent;

    final result =
        baseDamage * nonCriticalPercent * nonCorePercent +
        critDamage * criticalPercent * nonCorePercent +
        coreDamage * corePercent * nonCriticalPercent +
        critCoreDamage * corePercent * criticalPercent;

    return result.round();
  }

  int calculateDamage({bool critical = false, bool core = false}) {
    final finalAttack = attack - (ignoreDefence ? 0 : defence);
    final finalRate = toModifier(damageRate + damageRateBuff) * toModifier(hitRate);

    final coreCorrection = core ? correction(coreDamageRate + coreDamageBuff) : 0;
    final critCorrection = critical ? correction(criticalDamageRate + criticalDamageBuff) : 0;
    final rangeCorrection = isBonusRange ? constData.rangeCorrection : 0;
    final fullBurstCorrection = isFullBurst ? constData.fullBurstCorrection : 0;
    final finalCorrection = toModifier(10000 + coreCorrection + critCorrection + rangeCorrection + fullBurstCorrection);

    final elementRate = toModifier(isStrongElement ? constData.baseElementRate + elementDamageBuff : 10000);

    final fullChargeRate = chargeDamageRate + chargeDamageBuff;
    final actualCharge = chargePercent > 0 ? (fullChargeRate - 10000) * toModifier(chargePercent) : 0;
    final chargeRate = toModifier(10000 + actualCharge.round());

    final addDamageRate = toModifier(
      10000 +
          addDamageBuff +
          (isPartsDamage ? partDamageBuff : 0) +
          (isBreakDamage ? breakDamageBuff : 0) +
          (isDurationDamage ? durationDamageBuff : 0) +
          (isPierceDamage ? pierceDamageBuff : 0) +
          (ignoreDefence ? defIgnoreDamageBuff : 0) +
          (isProjectileDamage ? projectileDamageBuff : 0),
    );

    final receiveDamage = toModifier(10000 - damageReductionBuff + (isSharedDamage ? sharedDamageBuff : 0));

    final nonAttackMultipliers = finalRate * finalCorrection * elementRate * chargeRate * addDamageRate * receiveDamage;
    final totalDamage = finalAttack * nonAttackMultipliers;

    final adjustedDamage = ((totalDamage * 10).floor() / 10).roundHalfToEven();
    return max(adjustedDamage, 1);
  }
}

extension NumUtils on num {
  int roundHalfToEven() {
    int rounded = round();
    return (this - rounded).abs() == 0.5 && rounded.isOdd ? rounded - 1 : rounded;
  }

  int roundHalfToEvenByFirstDecimal() {
    return ((this * 10).floor() / 10).roundHalfToEven();
  }

  int roundHalfToOdd() {
    int rounded = round();
    return (this - rounded).abs() == 0.5 && rounded.isEven ? rounded - 1 : rounded;
  }
}
