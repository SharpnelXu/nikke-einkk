import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

class BattleFavoriteItem {
  final int favoriteItemId;
  final int level;

  BattleFavoriteItem(this.favoriteItemId, this.level);

  FavoriteItemData get data => gameData.favoriteItemTable[favoriteItemId]!;

  FavoriteItemLevelData get levelData => gameData.favoriteItemLevelTable[data.levelEnhanceId]![level]!;

  int getStat(StatType statType) {
    return levelData.stats.firstWhereOrNull((stat) => stat.type == statType)?.value ?? 0;
  }

  List<int> getCollectionItemStateEffectIds() {
    final List<int> result = [];
    for (int index = 0; index < data.collectionSkills.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = data.collectionSkills[index].skillId;
      final skillLevel = levelData.skillLevels[index].level;
      final skillLevelData = gameData.skillInfoTable[skillGroupId]?[skillLevel];

      if (skillLevelData != null) {
        result.add(skillLevelData.id);
      }
    }
    return result;
  }

  void applyCollectionItemEffect(BattleSimulation simulation, BattleNikke owner) {
    for (final stateEffectId in getCollectionItemStateEffectIds()) {
      final stateEffectData = gameData.stateEffectTable[stateEffectId]!;
      owner.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(gameData.functionTable[data.function]!)),
      );
    }
  }
}
