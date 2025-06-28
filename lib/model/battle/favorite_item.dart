import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

part '../../generated/model/battle/favorite_item.g.dart';

@JsonSerializable()
class BattleFavoriteItemOption {
  WeaponType weaponType;
  Rarity rarity;
  int level;
  int nameCode;

  BattleFavoriteItemOption({required this.weaponType, required this.rarity, this.level = 0, this.nameCode = 0});

  factory BattleFavoriteItemOption.fromJson(Map<String, dynamic> json) => _$BattleFavoriteItemOptionFromJson(json);

  Map<String, dynamic> toJson() => _$BattleFavoriteItemOptionToJson(this);

  FavoriteItemData get data =>
      rarity == Rarity.ssr ? dbLegacy.nameCodeFavItemTable[nameCode]! : dbLegacy.dollTable[weaponType]![rarity]!;

  FavoriteItemLevelData get levelData => dbLegacy.favoriteItemLevelTable[data.levelEnhanceId]![level]!;

  @Deprecated('use getDollStat')
  int getStat(StatType statType) {
    return levelData.stats.firstWhereOrNull((stat) => stat.type == statType)?.value ?? 0;
  }

  int getDollStat(StatType statType, NikkeDatabaseV2 db) {
    final data = rarity == Rarity.ssr ? db.nameCodeFavItemTable[nameCode] : db.dollTable[weaponType]?[rarity];
    final levelData = db.favoriteItemLevelTable[data?.levelEnhanceId]?[level];
    return levelData?.stats.firstWhereOrNull((stat) => stat.type == statType)?.value ?? 0;
  }

  List<int> getCollectionItemStateEffectIds() {
    final List<int> result = [];
    for (int index = 0; index < data.collectionSkills.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = data.collectionSkills[index].skillId;
      final skillLevel = levelData.skillLevels[index].level;
      final skillLevelData = dbLegacy.groupedSkillInfoTable[skillGroupId]?[skillLevel];

      if (skillLevelData != null) {
        result.add(skillLevelData.id);
      }
    }
    return result;
  }

  void applyCollectionItemEffect(BattleSimulation simulation, BattleNikke owner) {
    for (final stateEffectId in getCollectionItemStateEffectIds()) {
      final stateEffectData = dbLegacy.stateEffectTable[stateEffectId]!;
      owner.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(dbLegacy.functionTable[data.function]!, owner.uniqueId)),
      );
    }
  }

  BattleFavoriteItemOption copy() {
    return BattleFavoriteItemOption(weaponType: weaponType, rarity: rarity, level: level, nameCode: nameCode);
  }
}
