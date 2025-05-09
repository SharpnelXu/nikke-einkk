import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';

import '../../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Nikke Stat Calculation Test', () {
    test('Dorothy resourceId 233', () {
      final simulation = BattleSimulation(
        playerOptions: BattlePlayerOptions(personalRecycleLevel: 0, corpRecycleLevels: {}, classRecycleLevels: {}),
        nikkeOptions: [],
      );
      final dorothy = BattleNikke(
        simulation: simulation,
        option: BattleNikkeOptions(nikkeResourceId: 233, coreLevel: 1),
      );

      // default lv1 lb0
      expect(dorothy.baseHp, 15000);
      expect(dorothy.baseAttack, 500);
      expect(dorothy.baseDefence, 100);

      // lv2 lb0
      dorothy.option.syncLevel = 2;
      expect(dorothy.baseHp, 15750);
      expect(dorothy.baseAttack, 525);
      expect(dorothy.baseDefence, 105);

      // lv1 lb1
      dorothy.option.syncLevel = 1;
      dorothy.option.coreLevel = 2;
      expect(dorothy.baseHp, 18300);
      expect(dorothy.baseAttack, 530);
      expect(dorothy.baseDefence, 202);

      // lv1 lbmax
      dorothy.option.coreLevel = 4;
      expect(dorothy.baseHp, 24900);
      expect(dorothy.baseAttack, 590);
      expect(dorothy.baseDefence, 406);

      simulation.playerOptions.personalRecycleLevel = 410;
      simulation.playerOptions.corpRecycleLevels[Corporation.pilgrim] = 392;
      simulation.playerOptions.classRecycleLevels[NikkeClass.supporter] = 187;
      dorothy.option.attractLevel = 40;
      dorothy.option.coreLevel = 5;
      expect(dorothy.baseHp, 416313);
      expect(dorothy.baseAttack, moreOrLessEquals(12587, epsilon: 1));
      expect(dorothy.baseDefence, moreOrLessEquals(3765, epsilon: 1));
    });

    test('Rosanna: Chic Ocean resourceId 283', () {
      final simulation = BattleSimulation(
        playerOptions: BattlePlayerOptions(
          personalRecycleLevel: 410,
          corpRecycleLevels: {Corporation.tetra: 217},
          classRecycleLevels: {NikkeClass.supporter: 187},
        ),
        nikkeOptions: [],
      );

      final rosanna = BattleNikke(
        simulation: simulation,
        option: BattleNikkeOptions(nikkeResourceId: 283, coreLevel: 5, syncLevel: 866, attractLevel: 29),
      );

      expect(rosanna.baseHp, moreOrLessEquals(18537879, epsilon: 1));
      expect(rosanna.baseAttack, moreOrLessEquals(612174, epsilon: 1));
      expect(rosanna.baseDefence, moreOrLessEquals(123687, epsilon: 1));
    });

    test('Mica: Snow Buddy resourceId 62', () {
      final simulation = BattleSimulation(
        playerOptions: BattlePlayerOptions(
          personalRecycleLevel: 410,
          corpRecycleLevels: {Corporation.tetra: 217},
          classRecycleLevels: {NikkeClass.supporter: 187},
        ),
        nikkeOptions: [],
      );

      final mica = BattleNikke(
        simulation: simulation,
        option: BattleNikkeOptions(nikkeResourceId: 62, coreLevel: 9, syncLevel: 866, attractLevel: 22),
      );

      expect(mica.baseHp, moreOrLessEquals(19979208, epsilon: 1));
      expect(mica.baseAttack, moreOrLessEquals(659768, epsilon: 1));
      expect(mica.baseDefence, moreOrLessEquals(115173, epsilon: 1));
    });
  });
}
