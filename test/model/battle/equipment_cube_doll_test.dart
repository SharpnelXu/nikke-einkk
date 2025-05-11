import 'package:flutter_test/flutter_test.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

import '../../test_helper.dart';

void main() async {
  await TestHelper.loadData();

  group('Equipment Stat Calculation Test', () {
    test('Attacker Head piece t10 lv5', () {
      final equip = BattleEquipment(
        type: EquipType.head,
        equipClass: NikkeClass.attacker,
        rarity: EquipRarity.t10,
        corporation: Corporation.none,
        level: 5,
      );

      expect(equip.getStat(StatType.hp, Corporation.none), moreOrLessEquals(73771, epsilon: 1));
      expect(equip.getStat(StatType.atk, Corporation.none), moreOrLessEquals(9021, epsilon: 1));
    });

    test('Support leg piece t9 lv5', () {
      final equip = BattleEquipment(
        type: EquipType.leg,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t9,
        corporation: Corporation.tetra,
        level: 5,
      );

      expect(equip.getStat(StatType.hp, Corporation.tetra), moreOrLessEquals(39663, epsilon: 1));
      expect(equip.getStat(StatType.defence, Corporation.tetra), moreOrLessEquals(1055, epsilon: 1));

      expect(equip.getStat(StatType.hp, Corporation.missilis), moreOrLessEquals(33053, epsilon: 1));
      expect(equip.getStat(StatType.defence, Corporation.missilis), moreOrLessEquals(879, epsilon: 1));
    });
  });

  test('Equip Line Exists', () {
    final line = EquipLine.none();
    for (final type in EquipLineType.values) {
      if (type == EquipLineType.none) continue;

      line.type = type;
      for (int level = 1; level <= 15; level += 1) {
        line.level = level;
        final stateEffectId = line.getStateEffectId();

        expect(stateEffectId, isNonZero);
        expect(gameData.stateEffectTable.containsKey(stateEffectId), true);
      }
    }
  });

  test('Cube Effect Exists', () {
    for (final cubeId in gameData.harmonyCubeTable.keys) {
      for (int level = 1; level <= 15; level += 1) {
        final cube = BattleHarmonyCube(cubeId, level);

        final stateEffectIds = cube.getCubeStateEffectIds();
        expect(stateEffectIds.length, isNonZero);
        for (final stateEffectId in stateEffectIds) {
          expect(stateEffectId, isNonZero);
          expect(gameData.stateEffectTable.containsKey(stateEffectId), true);
        }
      }
    }
  });

  test('Favorite Item Effect Exists', () {
    for (final favoriteItemData in gameData.favoriteItemTable.values) {
      for (int level = 0; level <= 15; level += 1) {
        if (level > 2 && favoriteItemData.favoriteRare == Rarity.ssr) break;

        final doll = BattleFavoriteItem(favoriteItemData.id, level);

        final stateEffectIds = doll.getCollectionItemStateEffectIds();
        expect(stateEffectIds.length, isNonZero);
        for (final stateEffectId in stateEffectIds) {
          expect(stateEffectId, isNonZero);
          expect(gameData.stateEffectTable.containsKey(stateEffectId), true);
        }
      }
    }
  });
}
