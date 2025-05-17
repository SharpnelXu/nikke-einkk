import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

class BattleHarmonyCube {
  final int cubeId;
  final int cubeLevel;

  BattleHarmonyCube(this.cubeId, this.cubeLevel);

  HarmonyCubeData get cubeData => gameData.harmonyCubeTable[cubeId]!;

  HarmonyCubeLevelData get levelData => gameData.harmonyCubeLevelTable[cubeData.levelEnhanceId]![cubeLevel]!;

  int getStat(StatType statType) {
    return levelData.stats.firstWhereOrNull((stat) => stat.type == statType)?.rate ?? 0;
  }

  List<int> getCubeStateEffectIds() {
    final List<int> result = [];
    for (int index = 0; index < cubeData.harmonyCubeSkillGroups.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = cubeData.harmonyCubeSkillGroups[index].skillGroupId;
      final skillLevel = levelData.skillLevels[index].level;
      final skillLevelData = gameData.groupedSkillInfoTable[skillGroupId]?[skillLevel];

      if (skillLevelData != null) {
        result.add(skillLevelData.id);
      }
    }
    return result;
  }

  void applyCubeEffect(BattleSimulation simulation, BattleNikke wearer) {
    for (final stateEffectId in getCubeStateEffectIds()) {
      final stateEffectData = gameData.stateEffectTable[stateEffectId]!;
      wearer.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(gameData.functionTable[data.function]!, wearer.uniqueId)),
      );
    }
  }

  BattleHarmonyCube copy() {
    return BattleHarmonyCube(cubeId, cubeLevel);
  }
}
