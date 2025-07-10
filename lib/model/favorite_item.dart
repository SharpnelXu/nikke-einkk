import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';

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

  int getDollStat(StatType statType, NikkeDatabase db) {
    final data = getData(db);
    final levelData = db.favoriteItemLevelTable[data?.levelEnhanceId]?[level];
    return levelData?.stats.firstWhereOrNull((stat) => stat.type == statType)?.value ?? 0;
  }

  FavoriteItemData? getData(NikkeDatabase db) {
    return rarity == Rarity.ssr ? db.nameCodeFavItemTable[nameCode] : db.dollTable[weaponType]?[rarity];
  }

  List<(int, int)> getValidDollSkills(NikkeDatabase db) {
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

  void applyCollectionItemEffect(BattleSimulation simulation, BattleNikke owner) {
    final db = simulation.db;
    for (final (skillGroup, skillLv) in getValidDollSkills(db)) {
      final skillInfo = db.groupedSkillInfoTable[skillGroup]?[skillLv];
      final stateEffect = db.stateEffectTable[skillInfo?.id];
      if (stateEffect == null) {
        logger.w('Invalid Doll Skill: $skillGroup Lv$skillLv');
      } else {
        for (final funcId in stateEffect.allValidFuncIds) {
          final func = simulation.db.functionTable[funcId];
          if (func == null) {
            logger.w('Invalid Doll Func: $funcId');
          } else {
            owner.functions.add(BattleFunction(func, owner.uniqueId, Source.doll));
          }
        }
      }
    }
  }

  FavoriteItemOption copy() {
    return FavoriteItemOption(weaponType: weaponType, rarity: rarity, level: level, nameCode: nameCode);
  }
}
