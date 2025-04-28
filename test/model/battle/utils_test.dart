import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/utils.dart';

void main() async {
  group('Damage Calculation Test', () {
    test('Summer Helm damage test', () {
      final param = NikkeDamageParameter(attack: 802736, defence: 100, damageRate: 1365, isBonusRange: false);

      expect(BattleUtils.calculateDamage(param), 109560);
      expect(BattleUtils.calculateDamage(param.copy()..coreDamageRate = 20000), 219120);
      expect(
        BattleUtils.calculateDamage(
          param.copy()
            ..coreDamageRate = 20000
            ..criticalDamageRate = 15000,
        ),
        273900,
      );

      expect(BattleUtils.calculateDamage(param.copy()..isBonusRange = true), 142428);
      expect(
        BattleUtils.calculateDamage(
          param.copy()
            ..isBonusRange = true
            ..criticalDamageRate = 15000,
        ),
        197208,
      );

      final bossParam =
          param.copy()
            ..defence = 140
            ..isBonusRange = true;
      expect(BattleUtils.calculateDamage(bossParam), 142421);
      expect(BattleUtils.calculateDamage(bossParam.copy()..criticalDamageRate = 15000), 197198);
      expect(BattleUtils.calculateDamage(bossParam.copy()..coreDamageRate = 20000), 251975);
      expect(
        BattleUtils.calculateDamage(
          bossParam.copy()
            ..coreDamageRate = 20000
            ..criticalDamageRate = 15000,
        ),
        306752,
      );

      // liter buff
      final literBurstParam =
          bossParam.copy()
            ..attackBuff = (param.attack * 0.66).round()
            ..isFullBurst = true;
      expect(BattleUtils.calculateDamage(literBurstParam), 327371);
      expect(BattleUtils.calculateDamage(literBurstParam.copy()..criticalDamageRate = 15000), 418308);
      expect(BattleUtils.calculateDamage(literBurstParam.copy()..coreDamageRate = 20000), 509244);

      // liter & helm (favorite item helm) buff
      final literHelmBurstParam = literBurstParam.copy()..addDamageBuff = 2787;
      expect(BattleUtils.calculateDamage(literHelmBurstParam), 418610);
      expect(BattleUtils.calculateDamage(literHelmBurstParam.copy()..coreDamageRate = 20000), 651170);

      // liter & helm (favorite item helm) & blanc buff
      final literHelmBlancBurstParam = literHelmBurstParam.copy()..receiveDamageBuff = 3926;
      expect(BattleUtils.calculateDamage(literHelmBlancBurstParam), 582956);
      expect(BattleUtils.calculateDamage(literHelmBlancBurstParam.copy()..criticalDamageRate = 15000), 744888);
      expect(BattleUtils.calculateDamage(literHelmBlancBurstParam.copy()..coreDamageRate = 20000), 906820);
      expect(
        BattleUtils.calculateDamage(
          literHelmBlancBurstParam.copy()
            ..criticalDamageRate = 15000
            ..coreDamageRate = 20000,
        ),
        1068752,
      );
    });
  });
}
