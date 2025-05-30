import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/utils.dart';

void main() async {
  group('Damage Calculation Test', () {
    test('Summer Helm damage test', () {
      final param = NikkeDamageParameter(
        attack: 802736,
        defence: 100,
        damageRate: 1365,
        coreDamageRate: 20000,
        criticalDamageRate: 15000,
        isBonusRange: false,
      );

      expect(param.calculateDamage(), 109560);
      expect(param.calculateDamage(core: true), 219120);
      expect(param.calculateDamage(core: true, critical: true), 273900);

      final rangeParam = param.copy()..isBonusRange = true;
      expect(rangeParam.calculateDamage(), 142428);
      expect(rangeParam.calculateDamage(critical: true), 197208);

      final bossParam =
          param.copy()
            ..defence = 140
            ..isBonusRange = true;
      expect(bossParam.calculateDamage(), 142421);
      expect(bossParam.calculateDamage(critical: true), 197198);
      expect(bossParam.calculateDamage(core: true), 251975);
      expect(bossParam.calculateDamage(core: true, critical: true), 306752);

      // liter buff
      final literBurstParam =
          bossParam.copy()
            ..attackBuff = (param.attack * 0.66).round()
            ..isFullBurst = true;
      expect(literBurstParam.calculateDamage(), 327371);
      expect(literBurstParam.calculateDamage(critical: true), 418308);
      expect(literBurstParam.calculateDamage(core: true), 509244);

      // liter & helm (favorite item helm) buff
      final literHelmBurstParam = literBurstParam.copy()..addDamageBuff = 2787;
      expect(literHelmBurstParam.calculateDamage(), 418610);
      expect(literHelmBurstParam.calculateDamage(core: true), 651170);

      // liter & helm (favorite item helm) & blanc buff
      final literHelmBlancBurstParam = literHelmBurstParam.copy()..damageReductionBuff = -3926;
      expect(literHelmBlancBurstParam.calculateDamage(), 582956);
      expect(literHelmBlancBurstParam.calculateDamage(critical: true), 744888);
      expect(literHelmBlancBurstParam.calculateDamage(core: true), 906820);
      expect(literHelmBlancBurstParam.calculateDamage(core: true, critical: true), 1068752);
    });

    test('Blanc ele damage', () {
      final param = NikkeDamageParameter(
        attack: (596416 * 1.1181).round(),
        defence: 100,
        damageRate: 1365,
        coreDamageRate: 20000 + 567,
        criticalDamageRate: 15000 + 1644,
        elementDamageBuff: 2356 * 2,
        isBonusRange: false,
      );

      expect(param.calculateDamage(), 91012);
      expect(param.calculateDamage(core: true), 187184);
      expect(param.calculateDamage(core: true, critical: true), 247652);

      final eleParam = param.copy()..isStrongElement = true;
      expect(eleParam.calculateDamage(), 142998);
      expect(eleParam.calculateDamage(core: true), 294103);
    });

    test('Rapunzel: Pure Grace attack damage', () {
      final param = NikkeDamageParameter(
        attack: 590713,
        defence: 100,
        damageRate: 6904,
        coreDamageRate: 20000,
        criticalDamageRate: 15000,
        chargeDamageRate: 25000,
        chargePercent: 10000,
        isBonusRange: false,
      );

      expect(param.calculateDamage(core: true), 2038796);
      expect(param.calculateDamage(core: true, critical: true), 2548495);

      final bossParam = param.copy()..defence = 140;
      expect(bossParam.calculateDamage(core: true), 2038658);

      // this shows it's impossible to track in game charge percent, it's probably real time
      // final notFullChargeParam1 = param.copy()..chargePercent = (10000 * 69 / 150).round();
      // expect(notFullChargeParam1.calculateDamage(core: true), 1377003);
    });

    test('Shotgun doll attack damage', () {
      final dollParam = NikkeDamageParameter(
        attack: 738792,
        defence: 100,
        damageRate: 23160,
        damageRateBuff: (23160 * 0.0473).round(),
        coreDamageRate: 20000,
        criticalDamageRate: 15000,
        isStrongElement: true,
        isBonusRange: true,
      );

      // with doll
      expect(dollParam.calculateDamage() / 10, moreOrLessEquals(256213, epsilon: 1));

      final normalParam = NikkeDamageParameter(
        attack: 728489,
        defence: 100,
        damageRate: 10075 * 2,
        coreDamageRate: 20000,
        criticalDamageRate: 15000,
        isStrongElement: true,
        isBonusRange: true,
      );

      // with doll
      expect(normalParam.calculateDamage() / 10, moreOrLessEquals(209882, epsilon: 1));
    });

    test('Scarlet attack damage', () {
      final baseAtk = 904831;
      final defence = 140;
      final equip1Percent = 1111;
      final equip2Percent = 1393;
      final skillPercent = 2315;
      final element = 3984;
      final equipAtkTotal = (BattleUtils.toModifier(equip1Percent + equip2Percent) * baseAtk).round();
      final param = NikkeDamageParameter(
        attack: baseAtk,
        attackBuff: equipAtkTotal.round(),
        defence: defence,
        damageRate: 2708,
        coreDamageRate: 20000,
        criticalDamageRate: 15000,
        isStrongElement: true,
        elementDamageBuff: element,
        isBonusRange: true,
      );

      expect(param.calculateDamage(), 596736);
      expect(param.calculateDamage(critical: true), 826250);

      final paramSkill1 =
          param.copy()..attackBuff = equipAtkTotal + (BattleUtils.toModifier(skillPercent) * baseAtk).round();
      expect(paramSkill1.calculateDamage(), 707230);
      expect(paramSkill1.calculateDamage(critical: true), 979242);

      final paramSkill2 =
          param.copy()..attackBuff = equipAtkTotal + (BattleUtils.toModifier(skillPercent * 2) * baseAtk).round();
      expect(paramSkill2.calculateDamage(), 817724);
      expect(paramSkill2.calculateDamage(critical: true), 1132234);

      final paramSkill3 =
          param.copy()..attackBuff = equipAtkTotal + (BattleUtils.toModifier(skillPercent * 3) * baseAtk).round();
      expect(paramSkill3.calculateDamage(), 928218);
      expect(paramSkill3.calculateDamage(critical: true), 1285225);

      final paramSkill4 =
          param.copy()..attackBuff = equipAtkTotal + (BattleUtils.toModifier(skillPercent * 4) * baseAtk).round();
      expect(paramSkill4.calculateDamage(), 1038712);
      expect(paramSkill4.calculateDamage(critical: true), 1438217);

      final paramSkill5 =
          param.copy()..attackBuff = equipAtkTotal + (BattleUtils.toModifier(skillPercent * 5) * baseAtk).round();
      expect(paramSkill5.calculateDamage(), 1149206);
      expect(paramSkill5.calculateDamage(critical: true), 1591208);
    });

    test('Scarlet burst damage', () {
      final baseAtk = 904831;
      final defence = 140;
      final equip1Percent = 1111;
      final equip2Percent = 1393;
      final skill1Percent = 2315;
      final literPercent = 6600;
      final dollarSkill1Percent = 1373;
      final element = 3984;
      final equipAtkTotal = (BattleUtils.toModifier(equip1Percent + equip2Percent) * baseAtk).round();
      final param = NikkeDamageParameter(
        attack: baseAtk,
        attackBuff: equipAtkTotal.round(),
        defence: defence,
        damageRate: 84915,
        coreDamageRate: 20000,
        criticalDamageRate: 15000,
        isStrongElement: true,
        elementDamageBuff: element,
        isBonusRange: false, // burst skill doesn't benefit from this
      );

      final totalSkillPercent = skill1Percent * 5 + literPercent + dollarSkill1Percent;
      final totalBuffAtk = BattleUtils.toModifier(totalSkillPercent) * baseAtk;

      final paramSkill1NonBoss =
          param.copy()
            ..attackBuff = equipAtkTotal + totalBuffAtk.round()
            ..defence = 100;
      expect(paramSkill1NonBoss.calculateDamage(), 36899451);
      expect(paramSkill1NonBoss.calculateDamage(critical: true), 55349176 + 1);

      final paramSkill1Boss = param.copy()..attackBuff = equipAtkTotal + totalBuffAtk.round();
      // if attack differs a little bit this would now vary by a lot since damageRate * elementRate is very high,
      // which proves that Scarlet's Skill 1 buffs & Liter Burst Skill & Dollar Skill 1 are summed first then round.
      expect(paramSkill1Boss.calculateDamage(), moreOrLessEquals(36898941, epsilon: 1));

      final paramSkill1BossExtra =
          param.copy()
            ..attackBuff = equipAtkTotal + totalBuffAtk.round()
            ..addDamageBuff = 3624;
      expect(paramSkill1BossExtra.calculateDamage(), moreOrLessEquals(50271120, epsilon: 1));

      final paramSkill1NonBoss2 =
          param.copy()
            ..attackBuff = equipAtkTotal + totalBuffAtk.round()
            ..addDamageBuff = 3624
            ..defence = 100;
      expect(paramSkill1NonBoss2.calculateDamage(), moreOrLessEquals(50271814, epsilon: 1));

      final paramSkill1BossExtra2 =
          param.copy()
            ..attackBuff = equipAtkTotal + totalBuffAtk.round()
            ..addDamageBuff = 3624
            ..damageReductionBuff = -1256;
      expect(paramSkill1BossExtra2.calculateDamage(), 56585172);
    });

    test('Snow white burst damage', () {
      final baseAtk = 900648;
      final defence = 140;
      final equipPercents = 759 + 970 + 759 + 1181;
      final maxwellPercent = 4310;
      final crownPercent = 6451;
      final redHoodPercent = 7755;
      final element = 1909;

      final crownBuffAtk = BattleUtils.toModifier(crownPercent) * 614492;
      final redHoodBuffAtk = BattleUtils.toModifier(redHoodPercent) * 906918;
      final maxwellBuffAtk = BattleUtils.toModifier(maxwellPercent) * baseAtk;
      final equipAtkTotal = (BattleUtils.toModifier(equipPercents) * baseAtk);
      final param = NikkeDamageParameter(
        attack: baseAtk,
        attackBuff: equipAtkTotal.round() + maxwellBuffAtk.round() + redHoodBuffAtk.round() + crownBuffAtk.round(),
        defence: defence,
        damageRate: 49950,
        coreDamageRate: 20000,
        coreDamageBuff: 567,
        criticalDamageRate: 15000,
        chargePercent: 10000,
        chargeDamageRate: 100000,
        isStrongElement: true,
        elementDamageBuff: element,
        isBonusRange: true,
        isFullBurst: true,
        addDamageBuff: 3624,
        damageReductionBuff: -1256,
      );
      expect(param.calculateDamage(critical: true, core: true), moreOrLessEquals(902435165, epsilon: 35));
    });
  });
}
