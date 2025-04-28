import 'dart:math';

class BattleUtils {
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

  static int calculateDamage(NikkeDamageParameter params) {
    final finalAttack = params.attack + params.attackBuff - params.defence - params.defenceBuff;
    final finalRate = toModifier(params.damageRate + params.damageRateBuff);

    final coreCorrection = correction(params.coreDamageRate);
    final critCorrection = correction(params.criticalDamageRate);
    final rangeCorrection = params.isBonusRange ? 3000 : 0; // didn't find data, hardcoding for now
    final fullBurstCorrection = params.isFullBurst ? 5000 : 0;
    final finalCorrection = toModifier(10000 + coreCorrection + critCorrection + rangeCorrection + fullBurstCorrection);

    final elementRate = toModifier(params.isStrongElement ? 11000 + params.elementDamageBuff : 10000);

    final chargeRate = toModifier(params.chargeDamageRate);

    final addDamageRate = toModifier(
      10000 +
          params.addDamageBuff +
          params.partDamageBuff +
          params.interruptionPartDamageBuff +
          params.sustainedDamageBuff +
          params.pierceDamageBuff,
    );

    final receiveDamage = toModifier(10000 + params.receiveDamageBuff + params.distributedDamageBuff);

    final totalDamage =
        finalAttack * finalRate * finalCorrection * elementRate * chargeRate * addDamageRate * receiveDamage;

    return max(totalDamage.round(), 1);
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
  int coreDamageRate = 10000; // 100%
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
    this.coreDamageRate = 10000,
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
        'coreDamageRate: $coreDamageRate, '
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
      coreDamageRate: coreDamageRate,
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
}
