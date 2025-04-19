import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';

import '../../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Nikke Stat Calculation Test', () {
    test('Dorothy resourceId 233', () {
      final dorothyData = gameData.characterResourceGardeTable[233]!;

      final dorothy = BattleNikkeData(characterData: dorothyData[1]!, options: BattleNikkeOptions());

      // default lv1 lb0
      expect(dorothy.baseHp, 15000);
      expect(dorothy.baseAttack, 500);
      expect(dorothy.baseDefence, 100);

      // lv2 lb0
      dorothy.options.syncLevel = 2;
      expect(dorothy.baseHp, 15750);
      expect(dorothy.baseAttack, 525);
      expect(dorothy.baseDefence, 105);

      // lv1 lb1
      dorothy.options.syncLevel = 1;
      dorothy.characterData = dorothyData[2]!;
      expect(dorothy.baseHp, 18300);
      expect(dorothy.baseAttack, 530);
      expect(dorothy.baseDefence, 202);

      // lv1 lbmax
      dorothy.characterData = dorothyData[4]!;
      expect(dorothy.baseHp, 24900);
      expect(dorothy.baseAttack, 590);
      expect(dorothy.baseDefence, 406);

      dorothy.options.battlePlayerOptions = BattlePlayerOptions(
        personalRecycleLevel: 410,
        corpRecycleLevels: {Corporation.pilgrim: 392},
        classRecycleLevels: {NikkeClass.supporter: 187},
      );
      dorothy.options.attractLevel = 40;
      dorothy.characterData = dorothyData[5]!;
      expect(dorothy.baseHp, 416313);
      expect(dorothy.baseAttack, moreOrLessEquals(12587, epsilon: 1));
      expect(dorothy.baseDefence, moreOrLessEquals(3765, epsilon: 1));
    });

    test('Rosanna: Chic Ocean resourceId 283', () {
      final rosanna = BattleNikkeData(
        characterData: gameData.characterResourceGardeTable[283]![5]!,
        options: BattleNikkeOptions(
          syncLevel: 866,
          attractLevel: 29,
          battlePlayerOptions: BattlePlayerOptions(
            personalRecycleLevel: 410,
            corpRecycleLevels: {Corporation.tetra: 217},
            classRecycleLevels: {NikkeClass.supporter: 187},
          ),
        ),
      );

      expect(rosanna.baseHp, moreOrLessEquals(18537879, epsilon: 1));
      expect(rosanna.baseAttack, 612174);
      expect(rosanna.baseDefence, 123687);
    });

    test('Mica: Snow Buddy resourceId 62', () {
      final mica = BattleNikkeData(
        characterData: gameData.characterResourceGardeTable[62]![9]!,
        options: BattleNikkeOptions(
          syncLevel: 866,
          attractLevel: 22,
          battlePlayerOptions: BattlePlayerOptions(
            personalRecycleLevel: 410,
            corpRecycleLevels: {Corporation.tetra: 217},
            classRecycleLevels: {NikkeClass.supporter: 187},
          ),
        ),
      );

      expect(mica.baseHp, moreOrLessEquals(19979208, epsilon: 1));
      expect(mica.baseAttack, moreOrLessEquals(659768, epsilon: 1));
      expect(mica.baseDefence, moreOrLessEquals(115173, epsilon: 1));
    });
  });
}
