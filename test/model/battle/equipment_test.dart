import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

import '../../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Equipment Stat Calculation Test', () {
    test('Attacker Head piece t10 lv5', () {
      final equip = BattleEquipmentData(
        equipData: gameData.groupedEquipTable[EquipType.head]![NikkeClass.attacker]![EquipRarity.t10]!,
        corporation: Corporation.none,
        level: 5,
      );

      expect(equip.getStat(StatType.hp, Corporation.none), moreOrLessEquals(73771, epsilon: 1));
      expect(equip.getStat(StatType.atk, Corporation.none), moreOrLessEquals(9021, epsilon: 1));
    });

    test('Support leg piece t9 lv5', () {
      final equip = BattleEquipmentData(
        equipData: gameData.groupedEquipTable[EquipType.leg]![NikkeClass.supporter]![EquipRarity.t9]!,
        corporation: Corporation.tetra,
        level: 5,
      );

      expect(equip.getStat(StatType.hp, Corporation.tetra), moreOrLessEquals(39663, epsilon: 1));
      expect(equip.getStat(StatType.defence, Corporation.tetra), moreOrLessEquals(1055, epsilon: 1));

      expect(equip.getStat(StatType.hp, Corporation.missilis), moreOrLessEquals(33053, epsilon: 1));
      expect(equip.getStat(StatType.defence, Corporation.missilis), moreOrLessEquals(879, epsilon: 1));
    });
  });
}
