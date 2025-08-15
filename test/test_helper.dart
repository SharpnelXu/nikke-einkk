import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/favorite_item.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/user_data.dart';

class TestHelper {
  TestHelper._();

  static void loadData() {
    if (!global.initialized) {
      global.init();
    }
    if (!cn.initialized) {
      cn.init();
    }
  }

  static void loadUserDb() {
    if (!userDb.initialized) {
      userDb.init();
    }
  }
}

class Pair<A, B> {
  A value1;
  B value2;

  Pair(this.value1, this.value2);
}

class Const {
  static final _trainingWaterTarget = BattleRaptureOptions(
    startDistance: 30,
    element: NikkeElement.water,
    startDefence: 140,
  );
  static BattleRaptureOptions get trainingWaterTarget => _trainingWaterTarget.copy();

  static final _shootingRangeWaterBoss = BattleRaptureOptions(
    name: 'Locale_Monster:2420040422_name',
    monsterId: 2420040422,
    level: 300,
    startDistance: 30, // tbd
    coreSize: 10,
    isStageTarget: true,
    canBeTargeted: true,
    element: NikkeElement.water,
    startHp: (48575982 * 9999.9999).round(),
    startAttack: (71350 * 0.0001).round(),
    startDefence: (14272 * 0.0070).round(),
    damageRatio: 238571,
    projectileHp: 140600,
    brokenHp: 48575982,
  );
  static BattleRaptureOptions get shootingRangeWaterBoss => _shootingRangeWaterBoss.copy();

  static final _liter = NikkeOptions(
    nikkeResourceId: 82,
    coreLevel: 11,
    syncLevel: 884,
    attractLevel: 30,
    skillLevels: [10, 6, 10],
    equips: [
      EquipmentOption(
        type: EquipType.head,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine(EquipLineType.increaseElementalDamage, 11)],
      ),
      EquipmentOption(
        type: EquipType.body,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine(EquipLineType.statAmmo, 11), EquipLine(EquipLineType.startAccuracyCircle, 11)],
      ),
      EquipmentOption(
        type: EquipType.arm,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine(EquipLineType.statDef, 11), EquipLine(EquipLineType.statAmmo, 11)],
      ),
      EquipmentOption(
        type: EquipType.leg,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 3,
        equipLines: [EquipLine(EquipLineType.increaseElementalDamage, 11), EquipLine(EquipLineType.statChargeTime, 11)],
      ),
    ],
    favoriteItem: FavoriteItemOption(weaponType: WeaponType.smg, rarity: Rarity.r, level: 0),
    cube: null,
  );
  static NikkeOptions get liter => _liter.copy();

  static final _helm = NikkeOptions(
    nikkeResourceId: 352,
    coreLevel: 11,
    syncLevel: 884,
    attractLevel: 30,
    skillLevels: [10, 10, 10],
    equips: [
      EquipmentOption(
        type: EquipType.head,
        equipClass: NikkeClass.attacker,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine(EquipLineType.increaseElementalDamage, 9),
          EquipLine(EquipLineType.statAtk, 13),
          EquipLine(EquipLineType.statCritical, 5),
        ],
      ),
      EquipmentOption(
        type: EquipType.body,
        equipClass: NikkeClass.attacker,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine(EquipLineType.statAtk, 15), EquipLine(EquipLineType.increaseElementalDamage, 7)],
      ),
      EquipmentOption(
        type: EquipType.arm,
        equipClass: NikkeClass.attacker,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine(EquipLineType.statAtk, 12), EquipLine(EquipLineType.increaseElementalDamage, 11)],
      ),
      EquipmentOption(
        type: EquipType.leg,
        equipClass: NikkeClass.attacker,
        rarity: EquipRarity.t10,
        level: 0,
        equipLines: [
          EquipLine(EquipLineType.increaseElementalDamage, 7),
          EquipLine(EquipLineType.statAtk, 11),
          EquipLine(EquipLineType.statAmmo, 5),
        ],
      ),
    ],
    favoriteItem: FavoriteItemOption(weaponType: WeaponType.sr, rarity: Rarity.ssr, level: 2, nameCode: 5066),
    cube: null,
  );
  static NikkeOptions get helm => _helm.copy();

  static final _cindy = NikkeOptions(
    nikkeResourceId: 511,
    coreLevel: 11,
    syncLevel: 884,
    attractLevel: 40,
    skillLevels: [10, 10, 10],
    equips: [
      EquipmentOption(
        type: EquipType.head,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine(EquipLineType.statAmmo, 11),
          EquipLine.onValue(EquipLineType.statAtk, 829, global),
          EquipLine.onValue(EquipLineType.startAccuracyCircle, 1040, global),
        ],
      ),
      EquipmentOption(
        type: EquipType.body,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine.onValue(EquipLineType.statAtk, 900, global), EquipLine(EquipLineType.statAmmo, 11)],
      ),
      EquipmentOption(
        type: EquipType.arm,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine(EquipLineType.statAtk, 11)],
      ),
      EquipmentOption(
        type: EquipType.leg,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine.onValue(EquipLineType.statCritical, 469, global),
          EquipLine.onValue(EquipLineType.statAtk, 1111, global),
          EquipLine.onValue(EquipLineType.statChargeTime, 257, global),
        ],
      ),
    ],
    favoriteItem: FavoriteItemOption(weaponType: WeaponType.rl, rarity: Rarity.sr, level: 15),
    cube: null,
  );
  static NikkeOptions get cindy => _cindy.copy();

  static final _crown = NikkeOptions(
    nikkeResourceId: 330,
    coreLevel: 11,
    syncLevel: 884,
    attractLevel: 40,
    skillLevels: [10, 10, 10],
    equips: [
      EquipmentOption(
        type: EquipType.head,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine.onValue(EquipLineType.statAtk, 1040, global),
          EquipLine.onValue(EquipLineType.statChargeDamage, 477, global),
        ],
      ),
      EquipmentOption(
        type: EquipType.body,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [EquipLine.onValue(EquipLineType.statAtk, 1181, global), EquipLine(EquipLineType.statAmmo, 11)],
      ),
      EquipmentOption(
        type: EquipType.arm,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine.onValue(EquipLineType.statChargeDamage, 492, global),
          EquipLine(EquipLineType.statAtk, 11),
        ],
      ),
      EquipmentOption(
        type: EquipType.leg,
        equipClass: NikkeClass.defender,
        rarity: EquipRarity.t10,
        level: 3,
        equipLines: [
          EquipLine.onValue(EquipLineType.statCritical, 366, global),
          EquipLine.onValue(EquipLineType.statAmmo, 4017, global),
        ],
      ),
    ],
    favoriteItem: FavoriteItemOption(weaponType: WeaponType.mg, rarity: Rarity.sr, level: 15),
    cube: null,
  );
  static NikkeOptions get crown => _crown.copy();

  static final _grave = NikkeOptions(
    nikkeResourceId: 514,
    coreLevel: 11,
    syncLevel: 884,
    attractLevel: 40,
    skillLevels: [10, 10, 10],
    equips: [
      EquipmentOption(
        type: EquipType.head,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine.onValue(EquipLineType.statCriticalDamage, 1448, global),
          EquipLine.onValue(EquipLineType.statChargeDamage, 1111, global),
          EquipLine.onValue(EquipLineType.statCritical, 264, global),
        ],
      ),
      EquipmentOption(
        type: EquipType.body,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine.onValue(EquipLineType.statAtk, 1181, global),
          EquipLine.onValue(EquipLineType.statCritical, 571, global),
          EquipLine.onValue(EquipLineType.statAmmo, 6893, global),
        ],
      ),
      EquipmentOption(
        type: EquipType.arm,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine.onValue(EquipLineType.statChargeDamage, 1111, global),
          EquipLine.onValue(EquipLineType.statAtk, 1040, global),
        ],
      ),
      EquipmentOption(
        type: EquipType.leg,
        equipClass: NikkeClass.supporter,
        rarity: EquipRarity.t10,
        level: 5,
        equipLines: [
          EquipLine.onValue(EquipLineType.statAmmo, 2784, global),
          EquipLine.onValue(EquipLineType.statAtk, 829, global),
        ],
      ),
    ],
    favoriteItem: FavoriteItemOption(weaponType: WeaponType.ar, rarity: Rarity.sr, level: 15),
    cube: null,
  );
  static NikkeOptions get grave => _grave.copy();

  Const._();
}
