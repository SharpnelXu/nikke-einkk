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
class BattleFavoriteItem {
  WeaponType weaponType;
  Rarity rarity;
  int level;
  int nameCode;

  BattleFavoriteItem({required this.weaponType, required this.rarity, this.level = 0, this.nameCode = 0});

  factory BattleFavoriteItem.fromJson(Map<String, dynamic> json) => _$BattleFavoriteItemFromJson(json);

  Map<String, dynamic> toJson() => _$BattleFavoriteItemToJson(this);

  FavoriteItemData get data =>
      rarity == Rarity.ssr ? db.nameCodeFavItemTable[nameCode]! : db.dollTable[weaponType]![rarity]!;

  FavoriteItemLevelData get levelData => db.favoriteItemLevelTable[data.levelEnhanceId]![level]!;

  int getStat(StatType statType) {
    return levelData.stats.firstWhereOrNull((stat) => stat.type == statType)?.value ?? 0;
  }

  List<int> getCollectionItemStateEffectIds() {
    final List<int> result = [];
    for (int index = 0; index < data.collectionSkills.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = data.collectionSkills[index].skillId;
      final skillLevel = levelData.skillLevels[index].level;
      final skillLevelData = db.groupedSkillInfoTable[skillGroupId]?[skillLevel];

      if (skillLevelData != null) {
        result.add(skillLevelData.id);
      }
    }
    return result;
  }

  void applyCollectionItemEffect(BattleSimulation simulation, BattleNikke owner) {
    for (final stateEffectId in getCollectionItemStateEffectIds()) {
      final stateEffectData = db.stateEffectTable[stateEffectId]!;
      owner.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(db.functionTable[data.function]!, owner.uniqueId)),
      );
    }
  }

  BattleFavoriteItem copy() {
    return BattleFavoriteItem(weaponType: weaponType, rarity: rarity, level: level, nameCode: nameCode);
  }
}
