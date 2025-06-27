import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
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
    final Map<EquipType, Map<NikkeClass, Map<EquipRarity, Map<StatType, Map<int, Pair<int, int>>>>>> expectedStats = {
      EquipType.head: {
        NikkeClass.attacker: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(49181, 0),
              1: Pair(54099, 0),
              2: Pair(59017, 0),
              3: Pair(63935, 0),
              4: Pair(68853, 0),
              5: Pair(73771, 0),
            },
            StatType.atk: {
              0: Pair(6014, 0),
              1: Pair(6615, 0),
              2: Pair(7217, 0),
              3: Pair(7818, 0),
              4: Pair(8420, 0),
              5: Pair(9021, 0),
            },
            StatType.defence: {
              0: Pair(0, 0),
              1: Pair(0, 0),
              2: Pair(0, 0),
              3: Pair(0, 0),
              4: Pair(0, 0),
              5: Pair(0, 0),
            },
          },
        },
        NikkeClass.defender: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(60111, 0),
              1: Pair(60111 + 6011, 0),
              2: Pair(60111 + 12022, 0),
              3: Pair(60111 + 18033, 0),
              4: Pair(60111 + 24044, 0),
              5: Pair(60111 + 30056, 0),
            },
            StatType.atk: {
              0: Pair(4010, 0),
              1: Pair(4010 + 401, 0),
              2: Pair(4010 + 802, 0),
              3: Pair(4010 + 1203, 0),
              4: Pair(4010 + 1604, 0),
              5: Pair(4010 + 2005, 0),
            },
            StatType.defence: {
              0: Pair(0, 0),
              1: Pair(0, 0),
              2: Pair(0, 0),
              3: Pair(0, 0),
              4: Pair(0, 0),
              5: Pair(0, 0),
            },
          },
        },
        NikkeClass.supporter: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(54646, 0),
              1: Pair(54646 + 5465, 0),
              2: Pair(54646 + 10929, 0),
              3: Pair(54646 + 16394, 0),
              4: Pair(54646 + 21858, 0),
              5: Pair(54646 + 27323, 0),
            },
            StatType.atk: {
              0: Pair(5012, 0),
              1: Pair(5012 + 501, 0),
              2: Pair(5012 + 1002, 0),
              3: Pair(5012 + 1504, 0),
              4: Pair(5012 + 2005, 0),
              5: Pair(5012 + 2506, 0),
            },
            StatType.defence: {
              0: Pair(0, 0),
              1: Pair(0, 0),
              2: Pair(0, 0),
              3: Pair(0, 0),
              4: Pair(0, 0),
              5: Pair(0, 0),
            },
          },
        },
      },
      EquipType.body: {
        NikkeClass.attacker: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(159840, 0),
              1: Pair(159840 + 15984, 0),
              2: Pair(159840 + 31968, 0),
              3: Pair(159840 + 47952, 0),
              4: Pair(159840 + 63936, 0),
              5: Pair(159840 + 79920, 0),
            },
            StatType.atk: {
              0: Pair(1093, 0),
              1: Pair(1093 + 109, 0),
              2: Pair(1093 + 219, 0),
              3: Pair(1093 + 328, 0),
              4: Pair(1093 + 437, 0),
              5: Pair(1093 + 546, 0),
            },
            StatType.defence: {
              0: Pair(0, 0),
              1: Pair(0, 0),
              2: Pair(0, 0),
              3: Pair(0, 0),
              4: Pair(0, 0),
              5: Pair(0, 0),
            },
          },
        },
        NikkeClass.defender: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(195360, 0),
              1: Pair(195360 + 19536, 0),
              2: Pair(195360 + 39072, 0),
              3: Pair(195360 + 58608, 0),
              4: Pair(195360 + 78144, 0),
              5: Pair(195360 + 97680, 0),
            },
            StatType.atk: {
              0: Pair(729, 0),
              1: Pair(729 + 73, 0),
              2: Pair(729 + 146, 0),
              3: Pair(729 + 219, 0),
              4: Pair(729 + 292, 0),
              5: Pair(729 + 364, 0),
            },
            StatType.defence: {
              0: Pair(0, 0),
              1: Pair(0, 0),
              2: Pair(0, 0),
              3: Pair(0, 0),
              4: Pair(0, 0),
              5: Pair(0, 0),
            },
          },
        },
        NikkeClass.supporter: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(177600, 0),
              1: Pair(177600 + 17760, 0),
              2: Pair(177600 + 35520, 0),
              3: Pair(177600 + 53280, 0),
              4: Pair(177600 + 71040, 0),
              5: Pair(177600 + 88800, 0),
            },
            StatType.atk: {
              0: Pair(911, 0),
              1: Pair(911 + 91, 0),
              2: Pair(911 + 182, 0),
              3: Pair(911 + 273, 0),
              4: Pair(911 + 364, 0),
              5: Pair(911 + 456, 0),
            },
            StatType.defence: {
              0: Pair(0, 0),
              1: Pair(0, 0),
              2: Pair(0, 0),
              3: Pair(0, 0),
              4: Pair(0, 0),
              5: Pair(0, 0),
            },
          },
        },
      },
      EquipType.arm: {
        NikkeClass.attacker: {
          EquipRarity.t10: {
            StatType.hp: {0: Pair(0, 0), 1: Pair(0, 0), 2: Pair(0, 0), 3: Pair(0, 0), 4: Pair(0, 0), 5: Pair(0, 0)},
            StatType.atk: {
              0: Pair(3827, 0),
              1: Pair(3827 + 383, 0),
              2: Pair(3827 + 765, 0),
              3: Pair(3827 + 1148, 0),
              4: Pair(3827 + 1531, 0),
              5: Pair(3827 + 1914, 0),
            },
            StatType.defence: {
              0: Pair(654, 0),
              1: Pair(654 + 65, 0),
              2: Pair(654 + 131, 0),
              3: Pair(654 + 196, 0),
              4: Pair(654 + 262, 0),
              5: Pair(654 + 327, 0),
            },
          },
        },
        NikkeClass.defender: {
          EquipRarity.t10: {
            StatType.hp: {0: Pair(0, 0), 1: Pair(0, 0), 2: Pair(0, 0), 3: Pair(0, 0), 4: Pair(0, 0), 5: Pair(0, 0)},
            StatType.atk: {
              0: Pair(2551, 0),
              1: Pair(2551 + 255, 0),
              2: Pair(2551 + 510, 0),
              3: Pair(2551 + 765, 0),
              4: Pair(2551 + 1020, 0),
              5: Pair(2551 + 1276, 0),
            },
            StatType.defence: {
              0: Pair(800, 0),
              1: Pair(800 + 80, 0),
              2: Pair(800 + 160, 0),
              3: Pair(800 + 240, 0),
              4: Pair(800 + 320, 0),
              5: Pair(800 + 400, 0),
            },
          },
        },
        NikkeClass.supporter: {
          EquipRarity.t10: {
            StatType.hp: {0: Pair(0, 0), 1: Pair(0, 0), 2: Pair(0, 0), 3: Pair(0, 0), 4: Pair(0, 0), 5: Pair(0, 0)},
            StatType.atk: {
              0: Pair(3189, 0),
              1: Pair(3189 + 319, 0),
              2: Pair(3189 + 638, 0),
              3: Pair(3189 + 957, 0),
              4: Pair(3189 + 1276, 0),
              5: Pair(3189 + 1594, 0),
            },
            StatType.defence: {
              0: Pair(727, 0),
              1: Pair(727 + 73, 0),
              2: Pair(727 + 145, 0),
              3: Pair(727 + 218, 0),
              4: Pair(727 + 291, 0),
              5: Pair(727 + 364, 0),
            },
          },
        },
      },
      EquipType.leg: {
        NikkeClass.attacker: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(36887, 0),
              1: Pair(36887 + 3689, 0),
              2: Pair(36887 + 7377, 0),
              3: Pair(36887 + 11066, 0),
              4: Pair(36887 + 14755, 0),
              5: Pair(36887 + 18444, 0),
            },
            StatType.atk: {0: Pair(0, 0), 1: Pair(0, 0), 2: Pair(0, 0), 3: Pair(0, 0), 4: Pair(0, 0), 5: Pair(0, 0)},
            StatType.defence: {
              0: Pair(981, 0),
              1: Pair(981 + 98, 0),
              2: Pair(981 + 196, 0),
              3: Pair(981 + 294, 0),
              4: Pair(981 + 392, 0),
              5: Pair(981 + 490, 0),
            },
          },
        },
        NikkeClass.defender: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(45084, 0),
              1: Pair(45084 + 4508, 0),
              2: Pair(45084 + 9017, 0),
              3: Pair(45084 + 13525, 0),
              4: Pair(45084 + 18034, 0),
              5: Pair(45084 + 22542, 0),
            },
            StatType.atk: {0: Pair(0, 0), 1: Pair(0, 0), 2: Pair(0, 0), 3: Pair(0, 0), 4: Pair(0, 0), 5: Pair(0, 0)},
            StatType.defence: {
              0: Pair(1199, 0),
              1: Pair(1199 + 120, 0),
              2: Pair(1199 + 240, 0),
              3: Pair(1199 + 360, 0),
              4: Pair(1199 + 480, 0),
              5: Pair(1199 + 600, 0),
            },
          },
        },
        NikkeClass.supporter: {
          EquipRarity.t10: {
            StatType.hp: {
              0: Pair(40985, 0),
              1: Pair(40985 + 4098, 0),
              2: Pair(40985 + 8197, 0),
              3: Pair(40985 + 12296, 0),
              4: Pair(40985 + 16394, 0),
              5: Pair(40985 + 20492, 0),
            },
            StatType.atk: {0: Pair(0, 0), 1: Pair(0, 0), 2: Pair(0, 0), 3: Pair(0, 0), 4: Pair(0, 0), 5: Pair(0, 0)},
            StatType.defence: {
              0: Pair(1090, 0),
              1: Pair(1090 + 109, 0),
              2: Pair(1090 + 218, 0),
              3: Pair(1090 + 327, 0),
              4: Pair(1090 + 436, 0),
              5: Pair(1090 + 545, 0),
            },
          },
        },
      },
    };

    test('The Ultimate Test', () {
      final logger = Logger(printer: SimplePrinter());
      bool allExpected = true;
      for (final nikkeClass in [NikkeClass.attacker, NikkeClass.defender, NikkeClass.supporter]) {
        for (final equipType in [EquipType.head, EquipType.body, EquipType.arm, EquipType.leg]) {
          final expectedValues = expectedStats[equipType]![nikkeClass]![EquipRarity.t10]!;
          for (final level in [0, 1, 2, 3, 4, 5]) {
            final equip = BattleEquipmentOption(
              type: equipType,
              equipClass: nikkeClass,
              rarity: EquipRarity.t10,
              level: level,
            );

            final expectedHp = expectedValues[StatType.hp]![level]!.value1;
            final expectedAtk = expectedValues[StatType.atk]![level]!.value1;
            final expectedDef = expectedValues[StatType.defence]![level]!.value1;

            final actualHp = equip.getStat(StatType.hp);
            final actualAtk = equip.getStat(StatType.atk);
            final actualDef = equip.getStat(StatType.defence);

            String output = '${nikkeClass.name} ${equipType.name} level $level:';
            bool print = false;
            final diffHp = actualHp - expectedHp;
            if (diffHp != 0) {
              print = true;
              output += ' [hp: $diffHp, ${equip.getLevelStat(StatType.hp)}]';
            }

            final diffAtk = actualAtk - expectedAtk;
            if (diffAtk != 0) {
              print = true;
              output += ' [atk: $diffAtk, ${equip.getLevelStat(StatType.atk)}]';
            }

            final diffDef = actualDef - expectedDef;
            if (diffDef != 0) {
              print = true;
              output += ' [def: $diffDef, ${equip.getLevelStat(StatType.defence)}]';
            }

            if (print) {
              allExpected = false;
              logger.i(output);
            }
          }
        }
      }
      expect(allExpected, isTrue);
    });
    // round(), half round up
    // [I]  attacker head level 5: [hp: 1, 24590.5]
    // [I]  attacker body level 5: [atk: 1, 546.5]
    // [I]  attacker leg level 5: [def: 1, 490.5]
    // [I]  defender body level 5: [atk: 1, 364.5]
    // [I]  supporter arm level 5: [atk: 1, 1594.5]
    // [I]  supporter leg level 1: [hp: 1, 4098.5]
    // [I]  supporter leg level 5: [hp: 1, 20492.5]

    // round() - 0.05, half round down
    // [I]  attacker arm level 5: [atk: -1, 1913.5]
    // [I]  attacker leg level 5: [hp: -1, 18443.5]
    // [I]  defender head level 5: [hp: -1, 30055.5]
    // [I]  defender arm level 5: [atk: -1, 1275.5]
    // [I]  defender leg level 5: [def: -1, 599.5]
    // [I]  supporter body level 5: [atk: -1, 455.5]
    // [I]  supporter arm level 5: [def: -1, 363.5]
    // [I]  supporter leg level 3: [hp: -1, 12295.5]

    test('Support leg piece t9 lv5', () {
      final equip = BattleEquipmentOption(
        type: EquipType.leg,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t9,
        corporation: Corporation.tetra,
        level: 5,
      );

      expect(equip.getStat(StatType.hp, Corporation.tetra), 39663);
      expect(equip.getStat(StatType.defence, Corporation.tetra), 1055);

      expect(equip.getStat(StatType.hp, Corporation.missilis), 33053);
      expect(equip.getStat(StatType.defence, Corporation.missilis), 879);
    });

    test('Support head piece t9 lv1 corp', () {
      final equip = BattleEquipmentOption(
        type: EquipType.head,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t9,
        corporation: Corporation.tetra,
        level: 1,
      );

      expect(equip.getStat(StatType.hp, Corporation.tetra), 41132);
      expect(equip.getStat(StatType.atk, Corporation.tetra), 3771);

      expect(equip.getStat(StatType.hp, Corporation.missilis), 32318);
      expect(equip.getStat(StatType.atk, Corporation.missilis), 2963);

      equip.level = 4;
      expect(equip.getStat(StatType.hp, Corporation.missilis), 32318 + 8814);
      expect(equip.getStat(StatType.atk, Corporation.missilis), 2963 + 809);
    });

    test('Defender body & arm piece t9 lv1 corp', () {
      final body = BattleEquipmentOption(
        type: EquipType.body,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t9,
        corporation: Corporation.tetra,
        level: 1,
      );

      expect(body.getStat(StatType.hp, Corporation.tetra), 147047);
      expect(body.getStat(StatType.atk, Corporation.tetra), 549);

      expect(body.getStat(StatType.hp, Corporation.missilis), 115537);
      expect(body.getStat(StatType.atk, Corporation.missilis), 431);

      body.level = 4;
      expect(body.getStat(StatType.hp, Corporation.missilis), 115537 + 31511);
      expect(body.getStat(StatType.atk, Corporation.missilis), 431 + 118);

      final arm = BattleEquipmentOption(
        type: EquipType.arm,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t9,
        corporation: Corporation.tetra,
        level: 1,
      );

      expect(arm.getStat(StatType.defence, Corporation.tetra), 602);
      expect(arm.getStat(StatType.atk, Corporation.tetra), 1921);

      expect(arm.getStat(StatType.defence, Corporation.missilis), 473);
      expect(arm.getStat(StatType.atk, Corporation.missilis), 1509);

      arm.level = 4;
      expect(arm.getStat(StatType.defence, Corporation.missilis), 473 + 129);
      expect(arm.getStat(StatType.atk, Corporation.missilis), 1509 + 412);
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
        expect(dbLegacy.stateEffectTable.containsKey(stateEffectId), true);
      }
    }
  });

  test('Cube Effect Exists', () {
    for (final cubeType in HarmonyCubeType.values) {
      for (int level = 1; level <= 15; level += 1) {
        final cube = BattleHarmonyCube(cubeType, level);

        final stateEffectIds = cube.getCubeStateEffectIds();
        expect(stateEffectIds.length, isNonZero);
        for (final stateEffectId in stateEffectIds) {
          expect(stateEffectId, isNonZero);
          expect(dbLegacy.stateEffectTable.containsKey(stateEffectId), true);
        }
      }
    }
  });

  test('Favorite Item Effect Exists', () {
    for (final groupedData in dbLegacy.dollTable.values) {
      for (final favoriteItemData in groupedData.values) {
        for (int level = 0; level <= 15; level += 1) {
          final doll = BattleFavoriteItem(
            weaponType: favoriteItemData.weaponType,
            rarity: favoriteItemData.favoriteRare,
            level: level,
          );

          final stateEffectIds = doll.getCollectionItemStateEffectIds();
          expect(stateEffectIds.length, isNonZero);
          for (final stateEffectId in stateEffectIds) {
            expect(stateEffectId, isNonZero);
            expect(dbLegacy.stateEffectTable.containsKey(stateEffectId), true);
          }
        }
      }
    }

    for (final favoriteItemData in dbLegacy.nameCodeFavItemTable.values) {
      for (int level = 0; level <= 2; level += 1) {
        final doll = BattleFavoriteItem(
          weaponType: favoriteItemData.weaponType,
          rarity: favoriteItemData.favoriteRare,
          level: level,
          nameCode: favoriteItemData.nameCode,
        );

        final stateEffectIds = doll.getCollectionItemStateEffectIds();
        expect(stateEffectIds.length, isNonZero);
        for (final stateEffectId in stateEffectIds) {
          expect(stateEffectId, isNonZero);
          expect(dbLegacy.stateEffectTable.containsKey(stateEffectId), true);
        }
      }
    }
  });
}
