import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/events/change_burst_step_event.dart';
import 'package:nikke_einkk/model/battle/events/launch_weapon_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/events/skill_attack_event.dart';
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
  final int ownerId;
  final int level;
  final int skillNum;
  final bool useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;
  Source get source => getSource(skillNum);

  BattleSkill(this.skillId, this.skillType, this.level, this.skillNum, this.ownerId, this.useGlobal);

  // todo: countDown on this
  int coolDown = 0;

  void init(BattleSimulation simulation, BattleNikke nikke) {
    coolDown = 0;

    if (skillType == SkillType.characterSkill && skillData != null) {
      if (skillNum != 3) {
        // normal skills start with coolDown
        coolDown = timeDataToFrame(getSkillCoolDown(simulation), simulation.fps);
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

    final requiredStep = simulation.getNikkeOnPosition(ownerId)?.getUseBurstSkill(simulation);
    final allStepCheck = requiredStep == BurstStep.allStep && [1, 2, 3].contains(simulation.burstStage);
    final stepCheck = allStepCheck || requiredStep?.step == simulation.burstStage;
    final basicBurstCheck = simulation.reEnterBurstCd == 0 && stepCheck;
    if (!basicBurstCheck) {
      return false;
    }

    final burstSpecification = simulation.advancedOption?.burstOrders[simulation.burstCycle];
    if (burstSpecification == null) {
      return true;
    } else {
      final positionCheck =
          burstSpecification.order.length > simulation.burstOrder
              ? burstSpecification.order[simulation.burstOrder] == ownerId
              : false;
      final timeCheck = burstSpecification.frame == null || burstSpecification.frame! >= simulation.currentFrame;
      return positionCheck && timeCheck;
    }
  }

  void changeCd(BattleSimulation simulation, int cdChangeTImdData) {
    if (cdChangeTImdData == 0) return;

    final maxCd = timeDataToFrame(getSkillCoolDown(simulation), simulation.fps);
    final changeFrames = timeDataToFrame(cdChangeTImdData, simulation.fps);
    coolDown = (coolDown + changeFrames).clamp(0, maxCd);
  }

  void processFrame(BattleSimulation simulation) {
    if (skillType == SkillType.stateEffect) return;
    final maxCd = timeDataToFrame(getSkillCoolDown(simulation), simulation.fps);
    coolDown = (coolDown - 1).clamp(0, maxCd);

    if (coolDown == 0 && canUseSkill(simulation)) {
      activateSkill(simulation, skillData!, ownerId, skillGroupId!, source);
      coolDown = timeDataToFrame(getSkillCoolDown(simulation), simulation.fps);
    }
  }

  int getSkillCoolDown(BattleSimulation simulation) {
    return simulation.getNikkeOnPosition(ownerId)?.getSkillCoolTime(simulation, skillNum - 1) ??
        skillData!.skillCooltime;
  }

  static void instantDamage({
    required BattleSimulation simulation,
    required SkillData skillData,
    required int damageRate,
    required int ownerId,
    required Source source,
    required BattleEntity target,
    required bool targetParts,
  }) {
    final owner = simulation.getNikkeOnPosition(ownerId);
    if (target is BattleRapture && owner != null) {
      // TODO: shareDamage is definitely incorrect (idea: in getSkillTarget, if target contains this buff, gets all
      //  raptures that contains this buff as target)

      bool shareDamage = false;
      final shareDamageBuff = target.buffs.firstWhereOrNull(
        (buff) => buff.data.functionType == FunctionType.damageShareInstant,
      );
      if (shareDamageBuff != null) {
        shareDamage = true;
        target.buffs.remove(shareDamageBuff);
      }
      final isDefIgnore = owner.hasBuff(simulation, FunctionType.defIgnoreSkillDamageInstant);
      final delayFrame = source == Source.burst ? timeDataToFrame(constData.damageBurstApplyDelay, simulation.fps) : 0;
      int damageFrame = simulation.currentFrame - delayFrame;
      if (damageFrame == simulation.maxFrames + 1) {
        damageFrame -= 1;
      }
      simulation.registerEvent(
        damageFrame,
        NikkeDamageEvent.skill(
          simulation: simulation,
          nikke: owner,
          rapture: target,
          source: source,
          damageRate: damageRate,
          skillType: skillData.skillType,
          isShareDamage: shareDamage,
          isIgnoreDefence: isDefIgnore,
        ),
      );

      if (targetParts) {
        for (final part in target.parts) {
          // TODO: check if part can be damaged
          simulation.registerEvent(
            damageFrame,
            NikkeDamageEvent.skill(
              simulation: simulation,
              nikke: simulation.getNikkeOnPosition(ownerId)!,
              rapture: target,
              source: source,
              damageRate: damageRate,
              skillType: skillData.skillType,
              partId: part.id,
            ),
          );
        }
      }

      simulation.registerEvent(damageFrame, SkillAttackEvent.create(ownerId, target.uniqueId, skillData, source));
    }
  }

  static void activateSkill(
    BattleSimulation simulation,
    SkillData skillData,
    int ownerId,
    int skillGroupId,
    Source source,
  ) {
    final owner = simulation.getNikkeOnPosition(ownerId)!;
    final skillTargets = getSkillTargets(simulation, skillData, ownerId);

    final event = UseSkillEvent(
      ownerId,
      skillTargets.map((entity) => entity.uniqueId).toList(),
      skillData.id,
      skillGroupId,
      source,
    );
    simulation.registerEvent(simulation.currentFrame, event);

    for (final beforeFuncId in [
      ...skillData.beforeUseFunctionIdList,
      if (!skillData.skillType.isDamage) ...skillData.beforeHurtFunctionIdList,
    ]) {
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
          instantDamage(
            simulation: simulation,
            skillData: skillData,
            damageRate: skillData.getSkillValue(0),
            ownerId: ownerId,
            source: source,
            target: target,
            targetParts: false,
          );
        }
        break;
      case CharacterSkillType.instantAllParts:
        for (final target in skillTargets) {
          instantDamage(
            simulation: simulation,
            skillData: skillData,
            damageRate: skillData.getSkillValue(0),
            ownerId: ownerId,
            source: source,
            target: target,
            targetParts: true,
          );
        }
        break;
      case CharacterSkillType.instantSequentialAttack:
        for (final target in skillTargets) {
          int additionalTimes = skillData.skillValueData[1].skillValue;
          if (skillData.skillValueData[4].skillValueType != ValueType.none) {
            final targetBuffGroup = skillData.getSkillValue(4);
            final buffStack = owner.buffs.where((buff) => buff.data.groupId == targetBuffGroup).firstOrNull;
            additionalTimes = buffStack?.count ?? additionalTimes;
          }
          final delayTime = skillData.getSkillValue(2);
          for (int count = 0; count < additionalTimes; count += 1) {
            final delayFrame =
                source == Source.burst ? timeDataToFrame(constData.damageBurstApplyDelay, simulation.fps) : 0;
            final damageFrame =
                simulation.currentFrame - delayFrame - timeDataToFrame(delayTime, simulation.fps) * count;
            if (target is BattleRapture) {
              simulation.registerEvent(
                damageFrame,
                NikkeDamageEvent.skill(
                  simulation: simulation,
                  nikke: owner,
                  rapture: target,
                  source: source,
                  damageRate: skillData.getSkillValue(0),
                  isShareDamage: false,
                ),
              );
              simulation.registerEvent(
                damageFrame,
                SkillAttackEvent.create(ownerId, target.uniqueId, skillData, source),
              );
            }
          }
        }
        break;
      case CharacterSkillType.installBarrier:
        for (final target in skillTargets) {
          if (target.hasBuff(simulation, FunctionType.immuneInstallBarrier)) {
            continue;
          }

          final barrierHpIncrease = target.getIncBarrierHp(simulation);
          final barrierHp =
              owner.getMaxHp(simulation) * toModifier(skillData.getSkillValue(1)) * (1 + toModifier(barrierHpIncrease));

          final barrier = Barrier(
            skillData.id,
            barrierHp.round(),
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
            final hpPercent = toModifier(skillData.getSkillValue(0));
            final defPercent = toModifier(skillData.getSkillValue(1)); // this is a guess

            final decoyHp = (target.getMaxHp(simulation) * hpPercent).round();
            final decoyDefence = (target.getFinalDefence(simulation) * defPercent).round();
            final decoy = BattleDecoy(decoyHp, decoyDefence);
            target.decoy = decoy;
          }
        }
        break;
      case CharacterSkillType.changeWeapon:
        for (final target in skillTargets) {
          final damageRate = skillData.getSkillValue(0);
          final fireRate = skillData.getSkillValue(1);
          final duration =
              skillData.durationType.isTimed
                  ? timeDataToFrame(skillData.durationValue, simulation.fps)
                  : skillData.durationValue;
          final weaponId = skillData.getSkillValue(2);
          final weaponData = simulation.db.characterShotTable[weaponId];
          if (target is BattleNikke && weaponData != null) {
            target.changeWeaponSkill = skillData;
            target.changeWeaponData = WeaponData.changeWeapon(damageRate, fireRate, weaponData);
            target.changeWeaponDuration = duration;
            target.resetWeaponParams(simulation, true);
          }
        }
        break;
      case CharacterSkillType.laserBeam:
        for (final target in skillTargets) {
          instantDamage(
            simulation: simulation,
            skillData: skillData,
            damageRate: skillData.getSkillValue(0),
            ownerId: ownerId,
            source: source,
            target: target,
            targetParts: false,
          );

          final damageRate = skillData.getSkillValue(1);
          final fireRate = skillData.getSkillValue(4);
          final duration =
              skillData.durationType.isTimed
                  ? timeDataToFrame(skillData.durationValue, simulation.fps)
                  : skillData.durationValue;
          final weaponId = skillData.getSkillValue(2);
          final weaponData = simulation.db.characterShotTable[weaponId];
          if (target is BattleNikke && weaponData != null) {
            target.changeWeaponSkill = skillData;
            target.changeWeaponData = WeaponData.changeWeapon(damageRate, fireRate, weaponData);
            target.changeWeaponDuration = duration;
            target.resetWeaponParams(simulation, true);
          }
        }
        break;
      case CharacterSkillType.hitMonsterGetBuff:
        for (final target in skillTargets) {
          if (target is BattleRapture) {
            final hitMonsterBuffId = skillData.getSkillValue(0);
            final hitPartsBuffId = skillData.getSkillValue(1);
            // skillValue[4] is limits per receiver? Only used by Killer Wife's Ult, so can't confirm
            target.hitMonsterGetBuffData = HitMonsterGetBuffData(
              hitMonsterFuncId: hitMonsterBuffId,
              hitPartsFuncId: hitPartsBuffId,
              limitPerReceiver: 1,
              ownerId: ownerId,
              source: source,
              duration: timeDataToFrame(skillData.durationValue, simulation.fps),
            );
          }
        }
        break;
      case CharacterSkillType.targetHitCountGetBuff:
        for (final target in skillTargets) {
          if (target is BattleRapture) {
            target.targetHitCountGetBuffData = TargetHitCountGetBuffData(
              funcId: skillData.getSkillValue(0),
              hitCountTarget: skillData.getSkillValue(1),
              limitPerReceiver: 1, // sklillValue 2?
              ownerId: ownerId,
              source: source,
              duration: timeDataToFrame(skillData.durationValue, simulation.fps),
            );
          }
        }
        break;
      case CharacterSkillType.stigma:
        for (final target in skillTargets) {
          if (target is BattleRapture) {
            target.stigmaData = StigmaData(
              skillData: skillData,
              ownerId: ownerId,
              source: source,
              duration: timeDataToFrame(skillData.durationValue, simulation.fps),
            );
          }
        }
        break;
      case CharacterSkillType.explosiveCircuit:
        for (final target in skillTargets) {
          if (target is BattleRapture) {
            target.explosiveCircuitData = ExplosiveCircuitData(
              skillData: skillData,
              ownerId: ownerId,
              source: source,
              duration: timeDataToFrame(skillData.durationValue, simulation.fps),
            );
          }
        }
        break;
      case CharacterSkillType.launchWeapon:
        // only Vesti uses this, so it's hard to determine what each parameter does
        // based on skill description, skillValue[0] is damage rate, skillValue[1] is fire rate
        // skillValue[2] is weaponId, skillValue[3] is weapon count, skillValue[4] is unknown, maybe travel speed?
        // if so, we can derive stage length via speed * time = 25 * 18 = 450 units?
        // deploy time is weapon's exit cover time but duration is unknown, only knows it's 18 seconds
        for (final target in skillTargets) {
          final damageRate = skillData.getSkillValue(0);
          final fireRate = skillData.getSkillValue(1);
          final weaponId = skillData.getSkillValue(2);
          final weaponCount = skillData.getSkillValue(3);
          final weaponData = simulation.db.characterShotTable[weaponId];
          final duration = timeDataToFrame(constData.vestiUltDuration, simulation.fps);
          if (target is BattleNikke && weaponData != null) {
            final launchWeaponData = WeaponData.changeWeapon(damageRate, fireRate, weaponData);
            final deployFrames = timeDataToFrame(launchWeaponData.spotFirstDelay, simulation.fps);
            final bulletInterval = (simulation.fps * 60 / fireRate).round();
            for (int count = 0; count < duration; count += bulletInterval) {
              final fireFrame = simulation.currentFrame - deployFrames - count;
              for (int i = 0; i < weaponCount; i += 1) {
                simulation.registerEvent(fireFrame, LaunchWeaponEvent.create(ownerId, launchWeaponData, source));
              }
            }
          }
        }
        break;
      case CharacterSkillType.healCharge: // TODO: implement
        for (final target in skillTargets) {
          if (target is BattleNikke) {
            target.healChargeData = HealChargeData(
              atkPercent: skillData.getSkillValue(0),
              ownerId: ownerId,
              source: source,
              duration: timeDataToFrame(skillData.durationValue, simulation.fps),
            );
          }
        }
        break;
      case CharacterSkillType.setBuff: // this likely does nothing, just used to get function targets
      case CharacterSkillType.aimingExplosion:
      case CharacterSkillType.aimingPenetration:
      case CharacterSkillType.installDrone:
      case CharacterSkillType.instantSkill:
      case CharacterSkillType.custom191Ulti:
      case CharacterSkillType.targetShot:
      case CharacterSkillType.instantLine:
      case CharacterSkillType.multiTarget:
      case CharacterSkillType.maxHPInstantNumber:
      case CharacterSkillType.reFullChargeHitDamage:
      case CharacterSkillType.none:
      case CharacterSkillType.unknown:
        break;
    }

    for (final afterFuncId in [
      ...skillData.afterUseFunctionIdList,
      if (!skillData.skillType.isDamage) ...skillData.afterHurtFunctionIdList,
    ]) {
      final functionData = simulation.db.functionTable[afterFuncId];
      if (functionData != null) {
        final function = BattleFunction(functionData, ownerId, source);
        // connected function likely doesn't check trigger target
        function.executeFunction(event, simulation);
      }
    }

    if (source == Source.burst) {
      final nextStep = owner.getChangeBurstStep(simulation);
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
            duration: owner.getBurstDuration(simulation),
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
    bool shouldUsePlusInstantTargetNum = false;
    switch (skillData.skillType) {
      case CharacterSkillType.installDecoy:
      case CharacterSkillType.changeWeapon:
      case CharacterSkillType.launchWeapon:
      case CharacterSkillType.laserBeam:
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
        shouldUsePlusInstantTargetNum = true;
        break;
      case CharacterSkillType.instantSequentialAttack:
      case CharacterSkillType.hitMonsterGetBuff:
      case CharacterSkillType.targetHitCountGetBuff:
      case CharacterSkillType.explosiveCircuit: // trony
      case CharacterSkillType.stigma: // dorothy
        return isThisNikke ? simulation.raptures.sublist(0, 1) : simulation.aliveNikkes.sublist(0, 1);
      case CharacterSkillType.instantAll:
      case CharacterSkillType.instantAllParts:
      case CharacterSkillType.instantArea:
      case CharacterSkillType.instantCircle:
      case CharacterSkillType.instantCircleSeparate:
        // just target all
        return isThisNikke ? simulation.raptures.toList() : simulation.aliveNikkes.toList();
      case CharacterSkillType.unknown:
      default:
        return [];
    }

    final extraTarget =
        shouldUsePlusInstantTargetNum && owner != null ? owner.getPlusInstantSkillTargetNum(simulation) : 0;
    final targetCount =
        (skillData.skillValueData[targetCountIndex].skillValueType == ValueType.integer
            ? skillData.skillValueData[targetCountIndex].skillValue
            : 0) +
        extraTarget;

    // isThisNikke  targetEnemy list
    // 1            1           raptures
    // 1            0           nikkes
    // 0            1           nikkes
    // 0            0           raptures
    final targetNikkes = isThisNikke ^ targetEnemy;
    final targetList = targetNikkes ? simulation.aliveNikkes.toList() : simulation.raptures.toList();

    switch (skillData.preferTargetCondition) {
      case PreferTargetCondition.unknown:
      case PreferTargetCondition.none:
        break;
      case PreferTargetCondition.includeNoneTargetLast:
        if (!targetNikkes) {
          targetList.sort((a, b) {
            final canTargetA = (a as BattleRapture).canBeTargeted ? -1 : 1;
            final canTargetB = (b as BattleRapture).canBeTargeted ? -1 : 1;
            return canTargetA - canTargetB;
          });
        }
        break;
      case PreferTargetCondition.includeNoneTargetNone:
        if (!targetNikkes) {
          targetList.retainWhere((rapture) => rapture is BattleRapture && rapture.canBeTargeted);
        }
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
      case PreferTargetCondition.onlySMG:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).baseWeaponData.weaponType == WeaponType.smg);
      case PreferTargetCondition.onlyMG:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).baseWeaponData.weaponType == WeaponType.mg);
      case PreferTargetCondition.onlySR:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).baseWeaponData.weaponType == WeaponType.sr);
      case PreferTargetCondition.burstStep1:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).characterData.useBurstSkill == BurstStep.step1);
      case PreferTargetCondition.burstStep2:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).characterData.useBurstSkill == BurstStep.step2);
      case PreferTargetCondition.burstStep3:
        targetList.retainWhere((nikke) => (nikke as BattleNikke).characterData.useBurstSkill == BurstStep.step3);
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
        return simulation.aliveNikkes.where((nikke) => [2, 4].contains(nikke.uniqueId)).toList();
      case PreferTarget.front:
        return simulation.aliveNikkes.where((nikke) => [1, 3, 5].contains(nikke.uniqueId)).toList();
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
      case PreferTarget.lowAttack:
        targetList.sort((a, b) {
          final totalAttackA = a.getFinalAttack(simulation);
          final totalAttackB = b.getFinalAttack(simulation);
          return totalAttackB != totalAttackA ? totalAttackA - totalAttackB : a.uniqueId - b.uniqueId;
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
        targetList.retainWhere((entity) => entity.baseElements.contains(NikkeElement.fire));
        break;
      case PreferTarget.water:
        targetList.retainWhere((entity) => entity.baseElements.contains(NikkeElement.water));
        break;
      case PreferTarget.electronic:
        targetList.retainWhere((entity) => entity.baseElements.contains(NikkeElement.electric));
        break;
      case PreferTarget.iron:
        targetList.retainWhere((entity) => entity.baseElements.contains(NikkeElement.iron));
        break;
      case PreferTarget.wind:
        targetList.retainWhere((entity) => entity.baseElements.contains(NikkeElement.wind));
        break;
      case PreferTarget.longInitChargeTime:
        targetList.sort((a, b) {
          if (a is BattleNikke && b is BattleNikke) {
            final chargeA = a.currentWeaponData.chargeTime;
            final chargeB = b.currentWeaponData.chargeTime;
            return chargeA != chargeB ? chargeB - chargeA : a.uniqueId - b.uniqueId;
          } else {
            return 0;
          }
        });
        break;
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

class HealChargeData {
  final int ownerId;
  final Source source;
  int atkPercent;
  int currentHeal = 0;
  int duration;

  HealChargeData({required this.atkPercent, required this.ownerId, required this.source, required this.duration});

  void storeHeal(BattleSimulation simulation, BattleNikke owner, int healAmount) {
    final maxHeal =
        (owner.getFinalAttack(simulation) *
                toModifier(atkPercent) *
                (1 + toModifier(owner.getPlainBuffValues(simulation, FunctionType.changeHealChargeValue))))
            .round();
    currentHeal += healAmount;
    if (currentHeal > maxHeal) {
      currentHeal = maxHeal;
    }
  }

  void processFrame(BattleSimulation simulation, BattleNikke owner) {
    duration -= 1;
    if (duration <= 0) {
      for (final nikke in simulation.aliveNikkes) {
        nikke.changeHp(simulation, currentHeal, true);
      }
      owner.healChargeData = null;
    }
  }
}

class HitMonsterGetBuffData {
  final int hitMonsterFuncId;
  final int hitPartsFuncId;
  final int ownerId;
  final int limitPerReceiver;
  final Source source;
  int duration;
  final Map<int, Map<int, int>> appliedTracker = {};

  HitMonsterGetBuffData({
    required this.hitMonsterFuncId,
    required this.hitPartsFuncId,
    required this.limitPerReceiver,
    required this.ownerId,
    required this.source,
    required this.duration,
  });

  void applyBuff(BattleSimulation simulation, NikkeDamageEvent event) {
    if (event.source != Source.bullet) {
      return;
    }

    final funcId = event.partId == null ? hitMonsterFuncId : hitPartsFuncId;
    final functionData = simulation.db.functionTable[funcId];
    if (functionData != null) {
      final receiverId = event.activatorId;
      final funcApplyTimes = appliedTracker[funcId]?[receiverId] ?? 0;
      if (funcApplyTimes >= limitPerReceiver) {
        return; // already applied enough times
      }

      // or directly add buff?
      final function = BattleFunction(functionData, ownerId, source);
      function.executeFunction(BattleEvent(ownerId, [receiverId]), simulation); // temp event to execute function
      appliedTracker.putIfAbsent(funcId, () => <int, int>{});
      appliedTracker[funcId]![receiverId] = funcApplyTimes + 1;
    }
  }
}

class TargetHitCountGetBuffData {
  final int funcId;
  final int hitCountTarget;
  final int ownerId;
  final int limitPerReceiver;
  final Source source;
  int duration;
  int hitCount = 0;
  final Map<int, int> appliedTracker = {};

  TargetHitCountGetBuffData({
    required this.funcId,
    required this.hitCountTarget,
    required this.limitPerReceiver,
    required this.ownerId,
    required this.source,
    required this.duration,
  });

  void applyBuff(BattleSimulation simulation, NikkeDamageEvent event) {
    if (event.source != Source.bullet) {
      return;
    }

    hitCount += 1;
    if (hitCount < hitCountTarget) {
      return; // not enough hits
    }

    final functionData = simulation.db.functionTable[funcId];
    if (functionData != null) {
      final receiverId = event.activatorId;
      final funcApplyTimes = appliedTracker[receiverId] ?? 0;
      if (funcApplyTimes >= limitPerReceiver) {
        return; // already applied enough times
      }

      // or directly add buff?
      final function = BattleFunction(functionData, ownerId, source);
      function.executeFunction(BattleEvent(ownerId, [receiverId]), simulation); // temp event to execute function
      appliedTracker[receiverId] = funcApplyTimes + 1;
    }
  }
}

class StigmaData {
  final SkillData skillData;
  final int ownerId;
  final Source source;
  int duration;
  int currentAccumulation = 0;
  int maxAccumulation = 0;

  StigmaData({required this.skillData, required this.ownerId, required this.source, required this.duration});

  void releaseAccumulationDamage(BattleSimulation simulation) {
    // should execute pre & post functions, but just hardcoding the share damage logic here
    final owner = simulation.getEntityById(ownerId);
    if (owner == null || owner is! BattleNikke) {
      return;
    }

    final targets = simulation.raptures;
    final damagePerTarget = (currentAccumulation / targets.length).round();
    for (final target in targets) {
      // hardcoding 3 seconds delay
      simulation.registerEvent(
        simulation.currentFrame - 3 * simulation.fps,
        NikkeFixDamageEvent.create(owner, target, source, damagePerTarget),
      );
    }
  }

  void accumulateDamage(BattleSimulation simulation, NikkeDamageEvent event) {
    final owner = simulation.getEntityById(ownerId);
    if (owner == null || owner is! BattleNikke) {
      return;
    }

    final attackAccumulationRatio = skillData.getSkillValue(0);
    maxAccumulation =
        (attackAccumulationRatio *
                owner.getFinalAttack(simulation) *
                toModifier(owner.getShareDamageIncrease(simulation)))
            .toInt();
    currentAccumulation += event.damageParameter.calculateExpectedDamage();
    currentAccumulation = min(currentAccumulation, maxAccumulation);
  }
}

class ExplosiveCircuitData {
  final SkillData skillData;
  final int ownerId;
  final Source source;
  int duration;
  int currentAccumulation = 0;
  int maxAccumulation = 0;

  ExplosiveCircuitData({required this.skillData, required this.ownerId, required this.source, required this.duration});

  void releaseAccumulationDamage(BattleSimulation simulation) {
    // should execute pre & post functions, but just hardcoding the share damage logic here
    final owner = simulation.getEntityById(ownerId);
    if (owner == null || owner is! BattleNikke) {
      return;
    }

    final targets = simulation.raptures;
    final damagePerTarget = (currentAccumulation / targets.length).round();
    for (final target in targets) {
      simulation.registerEvent(
        simulation.currentFrame,
        NikkeFixDamageEvent.create(owner, target, source, damagePerTarget),
      );
    }
  }

  void accumulateDamage(BattleSimulation simulation, NikkeDamageEvent event) {
    final owner = simulation.getEntityById(ownerId);
    if (owner == null || owner is! BattleNikke || owner.uniqueId != ownerId) {
      return;
    }

    final attackAccumulationRatio = skillData.getSkillValue(0);
    final accumulationRatio = toModifier(owner.getExplosiveCircuitAccumulationRatio(simulation));
    maxAccumulation =
        (attackAccumulationRatio *
                owner.getFinalAttack(simulation) *
                toModifier(owner.getShareDamageIncrease(simulation)))
            .toInt();
    currentAccumulation += (event.damageParameter.calculateExpectedDamage() * accumulationRatio).toInt();
    currentAccumulation = min(currentAccumulation, maxAccumulation);
  }
}

class StickyProjectileData {
  final int attackerId;
  final Source source;
  final int damageRate;

  StickyProjectileData({required this.attackerId, required this.source, required this.damageRate});

  void explode(BattleSimulation simulation, BattleRapture rapture) {
    final attacker = simulation.getNikkeOnPosition(attackerId);
    if (attacker != null && attacker.currentHp > 0) {
      simulation.registerEvent(
        simulation.currentFrame,
        NikkeDamageEvent.skill(
          simulation: simulation,
          nikke: attacker,
          rapture: rapture,
          damageRate: damageRate,
          source: source,
          isProjectileExplosion: true,
        ),
      );
    }
  }
}
