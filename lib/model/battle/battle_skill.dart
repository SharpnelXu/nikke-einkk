import 'dart:math';

import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleSkill {
  int skillId;
  SkillType skillType;
  final int ownerUniqueId;
  final int level;
  final int skillNum;

  BattleSkill(this.skillId, this.skillType, this.level, this.skillNum, this.ownerUniqueId);

  // todo: countDown on this
  int coolDown = 0;

  void init(BattleSimulation simulation, BattleNikke nikke) {
    coolDown = 0;

    if (skillType == SkillType.characterSkill) {
      final skillData = gameData.characterSkillTable[skillId + level - 1]!;

      if (skillNum != 3) {
        // normal skills start with coolDown
        coolDown = BattleUtils.timeDataToFrame(skillData.skillCooltime, simulation.fps);
      }
    }

    if (skillType == SkillType.stateEffect) {
      final stateEffectData = gameData.stateEffectTable[skillId + level - 1]!;
      nikke.functions.addAll(
        stateEffectData.functions
            .where((data) => data.function != 0)
            .map((data) => BattleFunction(gameData.functionTable[data.function]!, nikke.uniqueId)),
      );
    }
  }

  bool canUseSkill() {
    return skillType == SkillType.characterSkill && coolDown == 0;
  }

  void processFrame(BattleSimulation simulation) {
    if (skillType == SkillType.stateEffect) return;

    if (coolDown > 0) {
      coolDown -= 1;
    }

    if (coolDown == 0 && skillNum != 3) {
      activateSkill(simulation);
    }
  }

  void activateSkill(BattleSimulation simulation) {
    final skillData = gameData.characterSkillTable[skillId + level - 1];
    if (skillData == null) return;

    final skillTargets = getSkillTargets(simulation, skillData);

    final event = UseSkillEvent(
      simulation,
      ownerUniqueId,
      skillNum,
      skillTargets.map((entity) => entity.uniqueId).toList(),
    );

    for (final beforeUseFunctionId in [...skillData.beforeUseFunctionIdList, skillData.beforeHurtFunctionIdList]) {
      final functionData = gameData.functionTable[beforeUseFunctionId];
      if (functionData != null) {
        final function = BattleFunction(functionData, ownerUniqueId);
        // connected function likely doesn't check trigger target
        function.executeFunction(event, simulation);
      }
    }
    
    switch (skillData.skillType) {
      case CharacterSkillType.setBuff:
      case CharacterSkillType.instantAll:
      case CharacterSkillType.instantArea:
      case CharacterSkillType.instantCircle:
      case CharacterSkillType.instantCircleSeparate:
      case CharacterSkillType.instantNumber:
      case CharacterSkillType.instantSequentialAttack:
      case CharacterSkillType.installBarrier:
      case CharacterSkillType.installDecoy:
      case CharacterSkillType.changeWeapon:
      case CharacterSkillType.launchWeapon:
      case CharacterSkillType.laserBeam:
      case CharacterSkillType.explosiveCircuit:
      case CharacterSkillType.stigma:
      case CharacterSkillType.hitMonsterGetBuff:
      case CharacterSkillType.unknown:
        break;
    }

    for (final beforeUseFunctionId in [...skillData.afterUseFunctionIdList, skillData.afterHurtFunctionIdList]) {
      final functionData = gameData.functionTable[beforeUseFunctionId];
      if (functionData != null) {
        final function = BattleFunction(functionData, ownerUniqueId);
        // connected function likely doesn't check trigger target
        function.executeFunction(event, simulation);
      }
    }

    coolDown = BattleUtils.timeDataToFrame(skillData.skillCooltime, simulation.fps);
  }

  List<BattleEntity> getSkillTargets(BattleSimulation simulation, SkillData skillData) {
    final owner = simulation.getEntityByUniqueId(ownerUniqueId);
    final isThisNikke = owner is BattleNikke;
    bool targetEnemy;
    int targetCountIndex;
    switch (skillData.skillType) {
      case CharacterSkillType.installDecoy:
      case CharacterSkillType.changeWeapon:
        return [if (owner != null) owner];
      case CharacterSkillType.installBarrier:
        targetCountIndex = 2;
        targetEnemy = false;
        break;
      case CharacterSkillType.setBuff:
        targetCountIndex = 1;
        targetEnemy = false;
        break;
      case CharacterSkillType.instantNumber:
        targetCountIndex = 1;
        targetEnemy = true;
        break;
      case CharacterSkillType.instantSequentialAttack:
        return isThisNikke ? simulation.raptures.sublist(0, 1) : simulation.nikkes.sublist(0, 1);
      case CharacterSkillType.instantAll:
      case CharacterSkillType.instantArea:
      case CharacterSkillType.instantCircle:
      case CharacterSkillType.instantCircleSeparate:
        return isThisNikke ? simulation.raptures.toList() : simulation.nikkes.toList();
      case CharacterSkillType.launchWeapon:
      case CharacterSkillType.laserBeam:
      case CharacterSkillType.explosiveCircuit:
      case CharacterSkillType.stigma:
      // ^ not sure what these are
      case CharacterSkillType.hitMonsterGetBuff:
      // ^ D: Killer Wife's Ult
      case CharacterSkillType.unknown:
        return [];
    }

    final targetCount =
        skillData.skillValueData[targetCountIndex].skillValueType == ValueType.integer
            ? skillData.skillValueData[targetCountIndex].skillValue
            : 0;
    if (targetCount == 0) {
      return [];
    }

    // isThisNikke  targetEnemy list
    // 1            1           raptures
    // 1            0           nikkes
    // 0            1           nikkes
    // 0            0           raptures
    final targetNikkes = isThisNikke ^ targetEnemy;
    final targetList = targetNikkes ? simulation.nikkes.toList() : simulation.raptures.toList();

    switch (skillData.preferTarget) {
      case PreferTarget.random:
      case PreferTarget.nearAim:
        break;
      case PreferTarget.attacker:
        targetList.retainWhere(
          (nikke) => nikke is BattleNikke && nikke.characterData.characterClass == NikkeClass.attacker,
        );
        break;
      case PreferTarget.defender:
        targetList.retainWhere(
          (nikke) => nikke is BattleNikke && nikke.characterData.characterClass == NikkeClass.defender,
        );
        break;
      case PreferTarget.supporter:
        targetList.retainWhere(
          (nikke) => nikke is BattleNikke && nikke.characterData.characterClass == NikkeClass.supporter,
        );
        break;
      case PreferTarget.back:
        // some conditions like this don't need target list
        return simulation.nikkes.where((nikke) => [2, 4].contains(nikke.uniqueId)).toList();
      case PreferTarget.front:
        return simulation.nikkes.where((nikke) => [1, 3, 5].contains(nikke.uniqueId)).toList();
      case PreferTarget.haveDebuff:
        targetList.retainWhere(
          (entity) => entity.buffs.any((buff) => [BuffType.deBuff, BuffType.deBuffEtc].contains(buff.data.buff)),
        );
        break;
      case PreferTarget.highAttack:
        targetList.sort((a, b) {
          final totalAttackA = a.baseAttack + a.getAttackBuffValues(simulation);
          final totalAttackB = b.baseAttack + b.getAttackBuffValues(simulation);
          return totalAttackB - totalAttackA;
        });
        break;
      case PreferTarget.highAttackFirstSelf:
        targetList.sort((a, b) {
          final totalAttackA = a.baseAttack + a.getAttackBuffValues(simulation);
          final totalAttackB = b.baseAttack + b.getAttackBuffValues(simulation);
          return totalAttackB - totalAttackA;
        });
        break;
      case PreferTarget.highAttackLastSelf:
        targetList.sort((a, b) {
          final totalAttackA = a.baseAttack + a.getAttackBuffValues(simulation);
          final totalAttackB = b.baseAttack + b.getAttackBuffValues(simulation);
          return totalAttackB - totalAttackA;
        });
        if (owner != null && targetList.contains(owner)) {
          targetList.remove(owner);
          targetList.add(owner);
        }
        break;
      case PreferTarget.highDefence:
        targetList.sort((a, b) {
          final totalDefenceA = a.baseDefence + a.getDefenceBuffValues(simulation);
          final totalDefenceB = b.baseDefence + b.getDefenceBuffValues(simulation);
          return totalDefenceB - totalDefenceA;
        });
        if (owner != null && targetList.contains(owner)) {
          targetList.remove(owner);
          targetList.insert(0, owner);
        }
        break;
      case PreferTarget.highHP:
        targetList.sort((a, b) => b.currentHp - a.currentHp);
        break;
      case PreferTarget.highMaxHP:
        targetList.sort((a, b) => b.getMaxHp(simulation) - a.getMaxHp(simulation));
        break;
      case PreferTarget.lowDefence:
        targetList.sort((a, b) {
          final totalDefenceA = a.baseDefence + a.getDefenceBuffValues(simulation);
          final totalDefenceB = b.baseDefence + b.getDefenceBuffValues(simulation);
          return totalDefenceA - totalDefenceB;
        });
        break;
      case PreferTarget.lowHP:
        targetList.sort((a, b) => a.currentHp - b.currentHp);
        break;
      case PreferTarget.lowHPCover:
        if (!targetNikkes) return [];

        targetList.sort((a, b) => (a as BattleNikke).cover.currentHp - (b as BattleNikke).cover.currentHp);
        break;
      case PreferTarget.lowHPLastSelf:
        targetList.sort((a, b) => a.currentHp - b.currentHp);
        if (owner != null && targetList.contains(owner)) {
          targetList.remove(owner);
          targetList.add(owner);
        }
        break;
      case PreferTarget.lowHPRatio:
        targetList.sort((a, b) {
          final ratioA = (a.currentHp / a.getMaxHp(simulation) * 10000).round();
          final ratioB = (b.currentHp / b.getMaxHp(simulation) * 10000).round();
          return ratioA - ratioB;
        });
        break;
      case PreferTarget.fire:
        targetList.retainWhere((entity) => entity.element == NikkeElement.fire);
        break;
      case PreferTarget.water:
        targetList.retainWhere((entity) => entity.element == NikkeElement.water);
        break;
      case PreferTarget.electronic:
        targetList.retainWhere((entity) => entity.element == NikkeElement.electric);
        break;
      case PreferTarget.iron:
        targetList.retainWhere((entity) => entity.element == NikkeElement.iron);
        break;
      case PreferTarget.wind:
        targetList.retainWhere((entity) => entity.element == NikkeElement.wind);
        break;
      case PreferTarget.longInitChargeTime:
      case PreferTarget.targetAR:
      case PreferTarget.targetGL:
      case PreferTarget.targetPS:
      case PreferTarget.unknown:
        return [];
    }

    return targetList.sublist(0, min(targetList.length, targetCount));
  }
}
