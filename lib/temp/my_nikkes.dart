import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

final BattleNikkeOptions scarletOption = BattleNikkeOptions(
  nikkeResourceId: 222,
  coreLevel: 11,
  syncLevel: 884,
  attractLevel: 40,
  skillLevels: [10, 10, 10],
  equips: [
    BattleEquipment(
      type: EquipType.head,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAmmo, 9), EquipLine(EquipLineType.increaseElementalDamage, 9)],
    ),
    BattleEquipment(
      type: EquipType.body,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [
        EquipLine(EquipLineType.statChargeTime, 2),
        EquipLine(EquipLineType.statAmmo, 5),
        EquipLine(EquipLineType.statDef, 9),
      ],
    ),
    BattleEquipment(
      type: EquipType.arm,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 10), EquipLine(EquipLineType.statAmmo, 3)],
    ),
    BattleEquipment(
      type: EquipType.leg,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [
        EquipLine(EquipLineType.statChargeDamage, 1),
        EquipLine(EquipLineType.statAtk, 14),
        EquipLine(EquipLineType.statAmmo, 5),
      ],
    ),
  ],
  cube: null,
);

final BattleNikkeOptions aliceOption = BattleNikkeOptions(
  nikkeResourceId: 191,
  coreLevel: 11,
  syncLevel: 884,
  attractLevel: 30,
  skillLevels: [10, 6, 10],
  equips: [
    BattleEquipment(
      type: EquipType.head,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [
        EquipLine(EquipLineType.statAtk, 9),
        EquipLine(EquipLineType.statChargeTime, 7),
        EquipLine(EquipLineType.statAmmo, 13),
      ],
    ),
    BattleEquipment(
      type: EquipType.body,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.statAtk, 5)],
    ),
    BattleEquipment(
      type: EquipType.arm,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statChargeTime, 9)],
    ),
    BattleEquipment(
      type: EquipType.leg,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 11), EquipLine(EquipLineType.statAmmo, 7)],
    ),
  ],
  cube: null,
);

final BattleNikkeOptions snowWhiteOption = BattleNikkeOptions(
  nikkeResourceId: 220,
  coreLevel: 11,
  syncLevel: 884,
  attractLevel: 40,
  skillLevels: [7, 10, 10],
  equips: [
    BattleEquipment(
      type: EquipType.head,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 5)],
    ),
    BattleEquipment(
      type: EquipType.body,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 8)],
    ),
    BattleEquipment(
      type: EquipType.arm,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 5)],
    ),
    BattleEquipment(
      type: EquipType.leg,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 1,
      equipLines: [EquipLine(EquipLineType.statAtk, 11)],
    ),
  ],
  cube: null,
);

final BattleNikkeOptions literOption = BattleNikkeOptions(
  nikkeResourceId: 82,
  coreLevel: 11,
  syncLevel: 884,
  attractLevel: 30,
  skillLevels: [10, 6, 10],
  equips: [
    BattleEquipment(
      type: EquipType.head,
      equipClass: NikkeClass.supporter,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.increaseElementalDamage, 11)],
    ),
    BattleEquipment(
      type: EquipType.body,
      equipClass: NikkeClass.supporter,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.startAccuracyCircle, 11)],
    ),
    BattleEquipment(
      type: EquipType.arm,
      equipClass: NikkeClass.supporter,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statDef, 11), EquipLine(EquipLineType.statAmmo, 11)],
    ),
    BattleEquipment(
      type: EquipType.leg,
      equipClass: NikkeClass.supporter,
      rarity: EquipRarity.t10,
      level: 3,
      equipLines: [EquipLine(EquipLineType.increaseElementalDamage, 11), EquipLine(EquipLineType.statChargeTime, 11)],
    ),
  ],
  cube: null,
);

final crownOption = BattleNikkeOptions(
  nikkeResourceId: 330,
  coreLevel: 11,
  syncLevel: 884,
  attractLevel: 40,
  skillLevels: [10, 10, 10],
  equips: [
    BattleEquipment(
      type: EquipType.head,
      equipClass: NikkeClass.defender,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [],
    ),
    BattleEquipment(
      type: EquipType.body,
      equipClass: NikkeClass.defender,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAmmo, 11)],
    ),
    BattleEquipment(
      type: EquipType.arm,
      equipClass: NikkeClass.defender,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAmmo, 11)],
    ),
    BattleEquipment(
      type: EquipType.leg,
      equipClass: NikkeClass.defender,
      rarity: EquipRarity.t10,
      level: 3,
      equipLines: [],
    ),
  ],
  cube: null,
);

final scarletBlackShadow = BattleNikkeOptions(
  nikkeResourceId: 225,
  coreLevel: 11,
  syncLevel: 884,
  attractLevel: 40,
  skillLevels: [10, 10, 10],
  equips: [
    BattleEquipment(
      type: EquipType.head,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [
        EquipLine(EquipLineType.statChargeTime, 11),
        EquipLine(EquipLineType.statAtk, 11),
        EquipLine(EquipLineType.increaseElementalDamage, 11),
      ],
    ),
    BattleEquipment(
      type: EquipType.body,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 10), EquipLine(EquipLineType.statAmmo, 9)],
    ),
    BattleEquipment(
      type: EquipType.arm,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 9), EquipLine(EquipLineType.increaseElementalDamage, 1)],
    ),
    BattleEquipment(
      type: EquipType.leg,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [
        EquipLine(EquipLineType.statCriticalDamage, 4),
        EquipLine(EquipLineType.statAtk, 7),
        EquipLine(EquipLineType.increaseElementalDamage, 11),
      ],
    ),
  ],
  cube: null,
);

final helm = BattleNikkeOptions(
  nikkeResourceId: 352,
  coreLevel: 11,
  syncLevel: 884,
  attractLevel: 30,
  skillLevels: [10, 10, 10],
  equips: [
    BattleEquipment(
      type: EquipType.head,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [
        EquipLine.onValue(EquipLineType.statCritical, 366),
        EquipLine(EquipLineType.statAtk, 13),
        EquipLine(EquipLineType.increaseElementalDamage, 10),
      ],
    ),
    BattleEquipment(
      type: EquipType.body,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 15), EquipLine(EquipLineType.increaseElementalDamage, 8)],
    ),
    BattleEquipment(
      type: EquipType.arm,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 5,
      equipLines: [EquipLine(EquipLineType.statAtk, 12), EquipLine(EquipLineType.increaseElementalDamage, 11)],
    ),
    BattleEquipment(
      type: EquipType.leg,
      equipClass: NikkeClass.attacker,
      rarity: EquipRarity.t10,
      level: 0,
      equipLines: [
        EquipLine.onValue(EquipLineType.statAmmo, 4428),
        EquipLine(EquipLineType.statAtk, 11),
        EquipLine(EquipLineType.increaseElementalDamage, 8),
      ],
    ),
  ],
  cube: null,
);
