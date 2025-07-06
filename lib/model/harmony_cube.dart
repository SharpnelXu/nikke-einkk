import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';

part '../generated/model/harmony_cube.g.dart';

@JsonSerializable()
class HarmonyCubeOption {
  int cubeId;
  int cubeLevel;

  HarmonyCubeOption(this.cubeId, this.cubeLevel);
  HarmonyCubeOption.fromType(HarmonyCubeType type, this.cubeLevel) : cubeId = type.cubeId;

  factory HarmonyCubeOption.fromJson(Map<String, dynamic> json) => _$HarmonyCubeOptionFromJson(json);

  Map<String, dynamic> toJson() => _$HarmonyCubeOptionToJson(this);

  int getCubeStat(StatType statType, NikkeDatabase db) {
    final cubeData = db.harmonyCubeTable[cubeId];
    final levelData = db.harmonyCubeEnhanceLvTable[cubeData?.levelEnhanceId]?[cubeLevel];
    return levelData?.stats.firstWhereOrNull((stat) => stat.type == statType)?.rate ?? 0;
  }

  List<(int, int)> getValidCubeSkills(NikkeDatabase db) {
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
    final db = simulation.db;
    for (final (skillGroup, skillLv) in getValidCubeSkills(db)) {
      final skillInfo = db.groupedSkillInfoTable[skillGroup]?[skillLv];
      final stateEffect = db.stateEffectTable[skillInfo?.id];
      if (stateEffect == null) {
        logger.w('Invalid Cube Skill: $skillGroup Lv$skillLv');
      } else {
        for (final funcId in stateEffect.allValidFuncIds) {
          final func = simulation.db.functionTable[funcId];
          if (func == null) {
            logger.w('Invalid Cube Func: $funcId');
          } else {
            wearer.functions.add(BattleFunction(func, wearer.uniqueId));
          }
        }
      }
    }
  }

  HarmonyCubeOption copy() {
    return HarmonyCubeOption(cubeId, cubeLevel);
  }
}
