import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';

class BattleSkill {
  int skillId;
  SkillType skillType;
  final bool isBurst;
  final int level;

  BattleSkill(this.skillId, this.skillType, this.level, this.isBurst);

  // todo: countDown on this
  int coolDown = 0;

  void init(BattleSimulation simulation, BattleNikke nikke) {
    coolDown = 0;

    if (skillType == SkillType.characterSkill && isBurst) {
      final skillData = gameData.characterSkillTable[skillId + level - 1]!;
      coolDown = BattleUtils.timeDataToFrame(skillData.skillCooltime, simulation.fps);
    }

    if (skillType == SkillType.stateEffect) {
      final stateEffectData = gameData.stateEffectTable[skillId + level - 1]!;
      nikke.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(gameData.functionTable[data.function]!)),
      );
    }
  }

  bool canUseSkill() {
    return skillType == SkillType.characterSkill && coolDown == 0;
  }

  void activateSkill(BattleSimulation simulation) {}
}
