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
      final literHelmBlancBurstParam = literHelmBurstParam.copy()..receiveDamageBuff = 3926;
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
  });
}
