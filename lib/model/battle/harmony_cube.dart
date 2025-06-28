import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

part '../../generated/model/battle/harmony_cube.g.dart';

@JsonSerializable()
class BattleHarmonyCubeOption {
  int cubeId;
  int cubeLevel;

  BattleHarmonyCubeOption(this.cubeId, this.cubeLevel);
  BattleHarmonyCubeOption.fromType(HarmonyCubeType type, this.cubeLevel) : cubeId = type.cubeId;

  factory BattleHarmonyCubeOption.fromJson(Map<String, dynamic> json) => _$BattleHarmonyCubeOptionFromJson(json);

  Map<String, dynamic> toJson() => _$BattleHarmonyCubeOptionToJson(this);

  HarmonyCubeData get cubeData => dbLegacy.harmonyCubeTable[cubeId]!;

  HarmonyCubeLevelData get levelData => dbLegacy.harmonyCubeLevelTable[cubeData.levelEnhanceId]![cubeLevel]!;

  @Deprecated('use getCubeStat')
  int getStat(StatType statType) {
    return levelData.stats.firstWhereOrNull((stat) => stat.type == statType)?.rate ?? 0;
  }

  int getCubeStat(StatType statType, NikkeDatabaseV2 db) {
    final cubeData = db.harmonyCubeTable[cubeId];
    final levelData = db.harmonyCubeEnhanceLvTable[cubeData?.levelEnhanceId]?[cubeLevel];
    return levelData?.stats.firstWhereOrNull((stat) => stat.type == statType)?.rate ?? 0;
  }

  List<int> getCubeStateEffectIds() {
    final List<int> result = [];
    for (int index = 0; index < cubeData.harmonyCubeSkillGroups.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = cubeData.harmonyCubeSkillGroups[index].skillGroupId;
      final skillLevel = levelData.skillLevels[index].level;
      final skillLevelData = dbLegacy.groupedSkillInfoTable[skillGroupId]?[skillLevel];

      if (skillLevelData != null) {
        result.add(skillLevelData.id);
      }
    }
    return result;
  }

  List<(int, int)> getValidCubeSkills(NikkeDatabaseV2 db) {
    final cubeData = db.harmonyCubeTable[cubeId];
    final levelData = db.harmonyCubeEnhanceLvTable[cubeData?.levelEnhanceId]?[cubeLevel];
    if (cubeData == null || levelData == null) {
      return [];
    }

    final List<(int, int)> result = [];
    for (int index = 0; index < cubeData.harmonyCubeSkillGroups.length; index += 1) {
      if (levelData.skillLevels.length <= index) continue;

      final skillGroupId = cubeData.harmonyCubeSkillGroups[index].skillGroupId;
      final skillLevel = levelData.skillLevels[index].level;
      if (skillGroupId == 0 || skillLevel == 0) continue;

      result.add((skillGroupId, skillLevel));
    }
    return result;
  }

  void applyCubeEffect(BattleSimulation simulation, BattleNikke wearer) {
    for (final stateEffectId in getCubeStateEffectIds()) {
      final stateEffectData = dbLegacy.stateEffectTable[stateEffectId]!;
      wearer.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(dbLegacy.functionTable[data.function]!, wearer.uniqueId)),
      );
    }
  }

  BattleHarmonyCubeOption copy() {
    return BattleHarmonyCubeOption(cubeId, cubeLevel);
  }
}
