import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/change_burst_step_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/events/sequential_attack_event.dart';
import 'package:nikke_einkk/model/battle/events/use_skill_event.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleSkill {
  int skillId;
  int? get skillGroupId => db.skillInfoTable[skillId]?.groupId;
  int? get levelSkillId => db.groupedSkillInfoTable[skillGroupId]?[level]?.id;
  SkillData? get skillData => db.characterSkillTable[levelSkillId];
  SkillType skillType;
  final int ownerUniqueId;
  final int level;
  final int skillNum;
  final bool useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;
  Source get source => getSource(skillNum);

  BattleSkill(this.skillId, this.skillType, this.level, this.skillNum, this.ownerUniqueId, this.useGlobal);

  // todo: countDown on this
  int coolDown = 0;

  void init(BattleSimulation simulation, BattleNikke nikke) {
    coolDown = 0;

    if (skillType == SkillType.characterSkill && skillData != null) {
      if (skillNum != 3) {
        // normal skills start with coolDown
        coolDown = timeDataToFrame(skillData!.skillCooltime, simulation.fps);
      }
    }

    if (skillType == SkillType.stateEffect) {
      final stateEffectData = db.stateEffectTable[skillId + level - 1];
      if (stateEffectData != null) {
        nikke.functions.addAll(
          stateEffectData.allValidFuncIds
              .where((funcId) => db.functionTable.containsKey(funcId))
              .map((funcId) => BattleFunction(db.functionTable[funcId]!, nikke.uniqueId, source)),
        );
      }
    }
  }

  bool canUseSkill(BattleSimulation simulation) {
    if (skillData == null || skillType != SkillType.characterSkill || coolDown > 0) return false;
    if (skillNum != 3) return true;

    final requiredStep = simulation.getNikkeOnPosition(ownerUniqueId)?.characterData.useBurstSkill;
    final allStepCheck = requiredStep == BurstStep.allStep && [1, 2, 3].contains(simulation.burstStage);
    final stepCheck = allStepCheck || requiredStep?.step == simulation.burstStage;
    return simulation.reEnterBurstCd == 0 && stepCheck;
  }

  void changeCd(BattleSimulation simulation, int ultCdChangeTimeData) {
    if (ultCdChangeTimeData == 0) return;

    coolDown = max(coolDown + timeDataToFrame(ultCdChangeTimeData, simulation.fps).round(), 0);
  }

  void processFrame(BattleSimulation simulation) {
    if (skillType == SkillType.stateEffect) return;
    if (coolDown > 0) {
      coolDown -= 1;
    }

    if (coolDown == 0 && canUseSkill(simulation)) {
      activateSkill(simulation, skillData!, ownerUniqueId, skillGroupId!, source);
      coolDown = timeDataToFrame(skillData!.skillCooltime, simulation.fps);
    }
  }

  static void instantDamage(
    BattleSimulation simulation,
    SkillData skillData,
    int ownerId,
    Source source,
    BattleEntity target,
  ) {
    if (target is BattleRapture) {
      bool shareDamage = false;
      final shareDamageBuff = target.buffs.firstWhereOrNull(
        (buff) => buff.data.functionType == FunctionType.damageShareInstant,
      );
      if (shareDamageBuff != null) {
        shareDamage = true;
        target.buffs.remove(shareDamageBuff);
      }
      simulation.registerEvent(
        simulation.currentFrame,
        NikkeDamageEvent.skill(
          simulation: simulation,
          nikke: simulation.getNikkeOnPosition(ownerId)!,
          rapture: target,
          source: source,
          damageRate: skillData.skillValueData[0].skillValue,
          isShareDamage: shareDamage,
        ),
      );
    }
  }

  static void activateSkill(
    BattleSimulation simulation,
    SkillData skillData,
    int ownerId,
    int skillGroupId,
    Source source,
  ) {
    final skillTargets = getSkillTargets(simulation, skillData, ownerId);
    final owner = simulation.getNikkeOnPosition(ownerId)!;

    final event = UseSkillEvent(
      ownerId,
      skillTargets.map((entity) => entity.uniqueId).toList(),
      skillData.id,
      skillGroupId,
      source,
    );
    simulation.registerEvent(simulation.currentFrame, event);

    for (final beforeFuncId in [...skillData.beforeUseFunctionIdList, ...skillData.beforeHurtFunctionIdList]) {
      final functionData = simulation.db.functionTable[beforeFuncId];
      if (functionData != null) {
        final function = BattleFunction(functionData, ownerId, source);
        // connected function likely doesn't check trigger target
        function.executeFunction(event, simulation);
      }
    }

    switch (skillData.skillType) {
      case CharacterSkillType.instantAll:
      case CharacterSkillType.instantArea:
      case CharacterSkillType.instantCircle:
      case CharacterSkillType.instantCircleSeparate:
      case CharacterSkillType.instantNumber:
        for (final target in skillTargets) {
          instantDamage(simulation, skillData, ownerId, source, target);
        }
        break;
      case CharacterSkillType.instantSequentialAttack:
        for (final target in skillTargets) {
          instantDamage(simulation, skillData, ownerId, source, target);

          final additionalTimes = skillData.skillValueData[1].skillValue - 1;
          final delayTime = skillData.skillValueData[2].skillValue;
          for (int count = 1; count <= additionalTimes; count += 1) {
            final damageFrame = simulation.currentFrame - timeDataToFrame(delayTime, simulation.fps) * count;
            if (target is BattleRapture) {
              simulation.registerEvent(
                damageFrame,
                NikkeDamageEvent.skill(
                  simulation: simulation,
                  nikke: simulation.getNikkeOnPosition(ownerId)!,
                  rapture: target,
                  source: source,
                  damageRate: skillData.skillValueData[0].skillValue,
                  isShareDamage: false,
                ),
              );
              simulation.registerEvent(
                damageFrame,
                SequentialAttackEvent.create(ownerId, target.uniqueId, skillData, source),
              );
            }
          }
        }
        break;
      case CharacterSkillType.installBarrier:
        for (final target in skillTargets) {
          final barrierHp = owner.getMaxHp(simulation) * toModifier(skillData.skillValueData[1].skillValue);
          final barrier = Barrier(
            skillData.id,
            barrierHp.round(),
            skillData.durationType,
            timeDataToFrame(skillData.durationValue, simulation.fps),
          );
          if (target is BattleRapture) {
            target.barrier = barrier;
          } else if (target is BattleNikke) {
            target.barriers.removeWhere((oldBarrier) => oldBarrier.id == skillData.id);
            target.barriers.add(barrier);
          }
        }
        break;
      case CharacterSkillType.installDecoy:
        for (final target in skillTargets) {
          if (target is BattleNikke) {
            final hpPercent = toModifier(skillData.skillValueData[0].skillValue);
            final defPercent = toModifier(skillData.skillValueData[1].skillValue); // this is a guess

            final decoyHp = (target.getMaxHp(simulation) * hpPercent).round();
            final decoyDefence = (target.getFinalDefence(simulation) * defPercent).round();
            final decoy = BattleDecoy(decoyHp, decoyDefence);
            target.decoy = decoy;
          }
        }
        break;
      case CharacterSkillType.changeWeapon:
      case CharacterSkillType.launchWeapon:
      case CharacterSkillType.laserBeam:
      case CharacterSkillType.explosiveCircuit:
      case CharacterSkillType.stigma:
      case CharacterSkillType.hitMonsterGetBuff:
      case CharacterSkillType.setBuff: // this likely does nothing, just used to get function targets
      case CharacterSkillType.unknown:
      case CharacterSkillType.instantAllParts:
      case CharacterSkillType.targetHitCountGetBuff:
        break;
    }

    for (final afterFuncId in [...skillData.afterUseFunctionIdList, ...skillData.afterHurtFunctionIdList]) {
      final functionData = simulation.db.functionTable[afterFuncId];
      if (functionData != null) {
        final function = BattleFunction(functionData, ownerId, source);
        // connected function likely doesn't check trigger target
        function.executeFunction(event, simulation);
      }
    }

    final nextStep = owner.characterData.changeBurstStep;
    if (source == Source.burst) {
      owner.activatedBurstSkillThisCycle = true;

      if (validNextStep.contains(nextStep) && simulation.reEnterBurstCd == 0) {
        final nextStageNum = nextStep == BurstStep.nextStep ? simulation.burstStage + 1 : nextStep.step;
        simulation.reEnterBurstCd = timeDataToFrame(constData.sameBurstStageCd, simulation.fps);
        simulation.registerEvent(
          simulation.currentFrame,
          ChangeBurstStepEvent(
            ownerId,
            currentStage: simulation.burstStage,
            nextStage: nextStageNum,
            duration: owner.characterData.burstDuration,
          ),
        );
      }
    }
  }

  static List<BurstStep> validNextStep = [
    BurstStep.nextStep,
    BurstStep.step1,
    BurstStep.step2,
    BurstStep.step3,
    BurstStep.stepFull,
  ];

  static List<BattleEntity> getSkillTargets(BattleSimulation simulation, SkillData skillData, int ownerUniqueId) {
    final owner = simulation.getEntityById(ownerUniqueId);
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
        return isThisNikke ? simulation.raptures.sublist(0, 1) : simulation.nonnullNikkes.sublist(0, 1);
      case CharacterSkillType.instantAll:
      case CharacterSkillType.instantAllParts:
      case CharacterSkillType.instantArea:
      case CharacterSkillType.instantCircle:
      case CharacterSkillType.instantCircleSeparate:
        return isThisNikke ? simulation.raptures.toList() : simulation.nonnullNikkes.toList();
      case CharacterSkillType.launchWeapon:
      case CharacterSkillType.laserBeam:
      case CharacterSkillType.explosiveCircuit:
      case CharacterSkillType.stigma:
      // ^ not sure what these are
      case CharacterSkillType.hitMonsterGetBuff:
      // ^ D: Killer Wife's Ult
      case CharacterSkillType.targetHitCountGetBuff:
      case CharacterSkillType.unknown:
        return [];
    }

    final targetCount =
        skillData.skillValueData[targetCountIndex].skillValueType == ValueType.integer
            ? skillData.skillValueData[targetCountIndex].skillValue
            : 0;

    // isThisNikke  targetEnemy list
    // 1            1           raptures
    // 1            0           nikkes
    // 0            1           nikkes
    // 0            0           raptures
    final targetNikkes = isThisNikke ^ targetEnemy;
    final targetList = targetNikkes ? simulation.nonnullNikkes.toList() : simulation.raptures.toList();

    switch (skillData.preferTargetCondition) {
      case PreferTargetCondition.unknown:
      case PreferTargetCondition.none:
        break;
      case PreferTargetCondition.includeNoneTargetLast:
        targetList.sort((a, b) {
          final canTargetA = (a as BattleRapture).canBeTargeted ? -1 : 1;
          final canTargetB = (b as BattleRapture).canBeTargeted ? -1 : 1;
          return canTargetA - canTargetB;
        });
        break;
      case PreferTargetCondition.includeNoneTargetNone:
        targetList.retainWhere((rapture) => rapture is BattleRapture && rapture.canBeTargeted);
        break;
      case PreferTargetCondition.excludeSelf:
        targetList.remove(owner);
        break;
      case PreferTargetCondition.destroyCover:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).cover.currentHp == 0);
        break;
      case PreferTargetCondition.onlySG:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).baseWeaponData.weaponType == WeaponType.sg);
        break;
      case PreferTargetCondition.onlyRL:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).baseWeaponData.weaponType == WeaponType.rl);
        break;
      case PreferTargetCondition.onlyAR:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).baseWeaponData.weaponType == WeaponType.ar);
        break;
    }

    if (targetCount == 0) {
      return targetList;
    }

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
        return simulation.nonnullNikkes.where((nikke) => [2, 4].contains(nikke.uniqueId)).toList();
      case PreferTarget.front:
        return simulation.nonnullNikkes.where((nikke) => [1, 3, 5].contains(nikke.uniqueId)).toList();
      case PreferTarget.haveDebuff:
        targetList.retainWhere(
          (entity) => entity.buffs.any((buff) => [BuffType.deBuff, BuffType.deBuffEtc].contains(buff.data.buff)),
        );
        break;
      case PreferTarget.highAttack:
        targetList.sort((a, b) {
          final totalAttackA = a.getFinalAttack(simulation);
          final totalAttackB = b.getFinalAttack(simulation);
          return totalAttackB != totalAttackA ? totalAttackB - totalAttackA : a.uniqueId - b.uniqueId;
        });
        break;
      case PreferTarget.highAttackFirstSelf:
        targetList.sort((a, b) {
          final totalAttackA = a.getFinalAttack(simulation);
          final totalAttackB = b.getFinalAttack(simulation);
          return totalAttackB != totalAttackA ? totalAttackB - totalAttackA : a.uniqueId - b.uniqueId;
        });
        if (owner != null && targetList.contains(owner)) {
          targetList.remove(owner);
          targetList.insert(0, owner);
        }
        break;
      case PreferTarget.highAttackLastSelf:
        targetList.sort((a, b) {
          final totalAttackA = a.getFinalAttack(simulation);
          final totalAttackB = b.getFinalAttack(simulation);
          return totalAttackB != totalAttackA ? totalAttackB - totalAttackA : a.uniqueId - b.uniqueId;
        });
        if (owner != null && targetList.contains(owner)) {
          targetList.remove(owner);
          targetList.add(owner);
        }
        break;
      case PreferTarget.highDefence:
        targetList.sort((a, b) {
          final totalDefenceA = a.getFinalDefence(simulation);
          final totalDefenceB = b.getFinalDefence(simulation);
          return totalDefenceB != totalDefenceA ? totalDefenceB - totalDefenceA : a.uniqueId - b.uniqueId;
        });
        break;
      case PreferTarget.highHP:
        targetList.sort((a, b) => b.currentHp != a.currentHp ? b.currentHp - a.currentHp : a.uniqueId - b.uniqueId);
        break;
      case PreferTarget.highMaxHP:
        targetList.sort((a, b) {
          final maxHpA = a.getMaxHp(simulation);
          final maxHpB = b.getMaxHp(simulation);

          return maxHpB != maxHpA ? maxHpB - maxHpA : a.uniqueId - b.uniqueId;
        });
        break;
      case PreferTarget.lowDefence:
        targetList.sort((a, b) {
          final totalDefenceA = a.getFinalDefence(simulation);
          final totalDefenceB = b.getFinalDefence(simulation);
          return totalDefenceB != totalDefenceA ? totalDefenceA - totalDefenceB : a.uniqueId - b.uniqueId;
        });
        break;
      case PreferTarget.lowHP:
        targetList.sort((a, b) => a.currentHp != b.currentHp ? a.currentHp - b.currentHp : a.uniqueId - b.uniqueId);
        break;
      case PreferTarget.lowHPCover:
        if (!targetNikkes) return [];

        targetList.sort(
          (a, b) =>
              (a as BattleNikke).cover.currentHp != (b as BattleNikke).cover.currentHp
                  ? a.cover.currentHp - b.cover.currentHp
                  : a.uniqueId - b.uniqueId,
        );
        break;
      case PreferTarget.lowHPLastSelf:
        targetList.sort((a, b) => a.currentHp != b.currentHp ? a.currentHp - b.currentHp : a.uniqueId - b.uniqueId);
        if (owner != null && targetList.contains(owner)) {
          targetList.remove(owner);
          targetList.add(owner);
        }
        break;
      case PreferTarget.lowHPRatio:
        targetList.sort((a, b) {
          final ratioA = (a.currentHp / a.getMaxHp(simulation) * 10000).round();
          final ratioB = (b.currentHp / b.getMaxHp(simulation) * 10000).round();
          return ratioA != ratioB ? ratioA - ratioB : a.uniqueId - b.uniqueId;
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
      case PreferTarget.none:
      case PreferTarget.notStun:
        return [];
    }

    return targetList.sublist(0, min(targetList.length, targetCount));
  }
}
