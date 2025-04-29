import 'dart:math';

class BattleUtils {
  static const rangeCorrection = 3000;
  static const fullBurstCorrection = 5000;

  BattleUtils._();

  static double toModifier(int ratio) {
    return ratio / 10000;
  }

  static int correction(int damageRate) {
    return damageRate - 10000;
  }

  // for display
  static int frameToTimeData(int frame, int fps) {
    return (frame * 100 / fps).round();
  }

  // 230 = 2.3 seconds
  static int timeDataToFrame(int timeData, int fps) {
    return (timeData * fps / 100).round();
  }
}

class NikkeDamageParameter {
  // base
  int attack = 0;
  int defence = 0;
  int attackBuff = 0;
  int defenceBuff = 0;
  int damageRate = 10000; // 100%
  int damageRateBuff = 0;

  // correction
  int coreHitRate = 0;
  int coreDamageRate = 10000; // 100%
  int criticalRate = 1500; // 15%
  int criticalDamageRate = 10000;
  bool isBonusRange = false;
  bool isFullBurst = false;

  // element
  bool isStrongElement = false;
  int elementDamageBuff = 0;

  // full charge
  int chargeDamageRate = 10000;

  // add damage, parts, sustain, pierce
  int addDamageBuff = 0;
  int partDamageBuff = 0;
  int interruptionPartDamageBuff = 0;
  int sustainedDamageBuff = 0;
  int pierceDamageBuff = 0;

  // receive damage, distribute
  int receiveDamageBuff = 0;
  int distributedDamageBuff = 0;

  NikkeDamageParameter({
    this.attack = 0,
    this.defence = 0,
    this.attackBuff = 0,
    this.defenceBuff = 0,
    this.damageRate = 10000,
    this.damageRateBuff = 0,
    this.coreHitRate = 0,
    this.coreDamageRate = 10000,
    this.criticalRate = 1500,
    this.criticalDamageRate = 10000,
    this.isBonusRange = false,
    this.isFullBurst = false,
    this.isStrongElement = false,
    this.elementDamageBuff = 0,
    this.chargeDamageRate = 10000,
    this.addDamageBuff = 0,
    this.partDamageBuff = 0,
    this.interruptionPartDamageBuff = 0,
    this.sustainedDamageBuff = 0,
    this.pierceDamageBuff = 0,
    this.receiveDamageBuff = 0,
    this.distributedDamageBuff = 0,
  });

  @override
  String toString() {
    return 'NikkeDamageParameter{'
        'attack: $attack, '
        'defence: $defence, '
        'attackBuff: $attackBuff, '
        'defenceBuff: $defenceBuff, '
        'damageRate: $damageRate, '
        'damageRateBuff: $damageRateBuff, '
        'coreHitRate: $coreHitRate, '
        'coreDamageRate: $coreDamageRate, '
        'criticalRate: $criticalRate, '
        'criticalDamageRate: $criticalDamageRate, '
        'isBonusRange: $isBonusRange, '
        'isFullBurst: $isFullBurst, '
        'isStrongElement: $isStrongElement, '
        'elementDamageBuff: $elementDamageBuff, '
        'chargeDamageRate: $chargeDamageRate, '
        'addDamageBuff: $addDamageBuff, '
        'partDamageBuff: $partDamageBuff, '
        'interruptionPartDamageBuff: $interruptionPartDamageBuff, '
        'sustainedDamageBuff: $sustainedDamageBuff, '
        'pierceDamageBuff: $pierceDamageBuff, '
        'receiveDamageBuff: $receiveDamageBuff, '
        'distributedDamageBuff: $distributedDamageBuff'
        '}';
  }

  NikkeDamageParameter copy() {
    return NikkeDamageParameter(
      attack: attack,
      defence: defence,
      attackBuff: attackBuff,
      defenceBuff: defenceBuff,
      damageRate: damageRate,
      damageRateBuff: damageRateBuff,
      coreHitRate: coreHitRate,
      coreDamageRate: coreDamageRate,
      criticalRate: criticalRate,
      criticalDamageRate: criticalDamageRate,
      isBonusRange: isBonusRange,
      isFullBurst: isFullBurst,
      isStrongElement: isStrongElement,
      elementDamageBuff: elementDamageBuff,
      chargeDamageRate: chargeDamageRate,
      addDamageBuff: addDamageBuff,
      partDamageBuff: partDamageBuff,
      interruptionPartDamageBuff: interruptionPartDamageBuff,
      sustainedDamageBuff: sustainedDamageBuff,
      pierceDamageBuff: pierceDamageBuff,
      receiveDamageBuff: receiveDamageBuff,
      distributedDamageBuff: distributedDamageBuff,
    );
  }

  int calculateExpectedDamage() {
    final baseDamage = calculateDamage();
    final critDamage = calculateDamage(critical: true);
    final coreDamage = calculateDamage(core: true);
    final critCoreDamage = calculateDamage(critical: true, core: true);

    final criticalPercent = BattleUtils.toModifier(criticalRate);
    final corePercent = BattleUtils.toModifier(coreHitRate);
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
    final finalAttack = attack + attackBuff - defence - defenceBuff;
    final finalRate = BattleUtils.toModifier(damageRate + damageRateBuff);

    final coreCorrection = core ? BattleUtils.correction(coreDamageRate) : 0;
    final critCorrection = critical ? BattleUtils.correction(criticalDamageRate) : 0;
    final rangeCorrection = isBonusRange ? BattleUtils.rangeCorrection : 0;
    final fullBurstCorrection = isFullBurst ? BattleUtils.fullBurstCorrection : 0;
    final finalCorrection = BattleUtils.toModifier(
      10000 + coreCorrection + critCorrection + rangeCorrection + fullBurstCorrection,
    );

    final elementRate = BattleUtils.toModifier(isStrongElement ? 11000 + elementDamageBuff : 10000);

    final chargeRate = BattleUtils.toModifier(chargeDamageRate);

    final addDamageRate = BattleUtils.toModifier(
      10000 + addDamageBuff + partDamageBuff + interruptionPartDamageBuff + sustainedDamageBuff + pierceDamageBuff,
    );

    final receiveDamage = BattleUtils.toModifier(10000 + receiveDamageBuff + distributedDamageBuff);

    final totalDamage =
        finalAttack * finalRate * finalCorrection * elementRate * chargeRate * addDamageRate * receiveDamage;

    return max(totalDamage.round(), 1);
  }
}
