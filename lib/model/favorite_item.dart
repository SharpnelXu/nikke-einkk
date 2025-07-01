import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

part '../generated/model/favorite_item.g.dart';

@JsonSerializable()
class FavoriteItemOption {
  WeaponType weaponType;
  Rarity rarity;
  int level;
  int nameCode;

  FavoriteItemOption({required this.weaponType, required this.rarity, this.level = 0, this.nameCode = 0});

  factory FavoriteItemOption.fromJson(Map<String, dynamic> json) => _$FavoriteItemOptionFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemOptionToJson(this);

  FavoriteItemData get data =>
      rarity == Rarity.ssr ? dbLegacy.nameCodeFavItemTable[nameCode]! : dbLegacy.dollTable[weaponType]![rarity]!;

  FavoriteItemLevelData get levelData => dbLegacy.favoriteItemLevelTable[data.levelEnhanceId]![level]!;

  @Deprecated('use getDollStat')
  int getStat(StatType statType) {
    return levelData.stats.firstWhereOrNull((stat) => stat.type == statType)?.value ?? 0;
  }

  int getDollStat(StatType statType, NikkeDatabaseV2 db) {
    final data = getData(db);
    final levelData = db.favoriteItemLevelTable[data?.levelEnhanceId]?[level];
    return levelData?.stats.firstWhereOrNull((stat) => stat.type == statType)?.value ?? 0;
  }

  FavoriteItemData? getData(NikkeDatabaseV2 db) {
    return rarity == Rarity.ssr ? db.nameCodeFavItemTable[nameCode] : db.dollTable[weaponType]?[rarity];
  }

  List<(int, int)> getValidDollSkills(NikkeDatabaseV2 db) {
    final data = getData(db);
    final levelData = db.favoriteItemLevelTable[data?.levelEnhanceId]?[level];
    if (data == null || levelData == null) {
      return [];
    }

    final List<(int, int)> result = [];
    for (int index = 0; index < data.collectionSkills.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = data.collectionSkills[index].skillGroupId;
      final skillLevel = levelData.skillLevels[index].level;
      if (skillGroupId == 0 || skillLevel == 0) continue;

      result.add((skillGroupId, skillLevel));
    }
    return result;
  }

  List<int> getCollectionItemStateEffectIds() {
    final List<int> result = [];
    for (int index = 0; index < data.collectionSkills.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = data.collectionSkills[index].skillGroupId;
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

  FavoriteItemOption copy() {
    return FavoriteItemOption(weaponType: weaponType, rarity: rarity, level: level, nameCode: nameCode);
  }
}
