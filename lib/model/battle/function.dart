import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/battle_skill.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleFunction {
  final FunctionData data;
  final int ownerUniqueId;

  FunctionStatus status = FunctionStatus.off;
  int timesActivated = 0;

  BattleFunction(this.data, this.ownerUniqueId);

  void broadcast(BattleEvent event, BattleSimulation simulation) {
    if (data.limitValue > 0 && timesActivated >= data.limitValue) return;

    // the idea is that all data necessary for processing this broadcast should be available in the event
    final standard = getTimingTriggerStandardTarget(event, simulation);

    switch (data.timingTriggerType) {
      case TimingTriggerType.onHitNum:
        // triggerStandard: {user, none}, majority is user
        if (event is! NikkeDamageEvent || standard?.uniqueId != ownerUniqueId || event.type != NikkeDamageType.bullet) {
          return;
        }

        if (standard is BattleNikke &&
            standard.totalBulletsHit > 0 &&
            standard.totalBulletsHit % data.timingTriggerValue == 0) {
          executeFunction(event, simulation);
        }
        break;
      case TimingTriggerType.onStart:
        // triggerStandard: {user, none}
        if (event is! BattleStartEvent) return;
        executeFunction(event, simulation);
        break;
      case TimingTriggerType.onUseAmmo:
        // triggerStandard: {user, none}, majority is user
        if (event is! NikkeFireEvent || standard?.uniqueId != ownerUniqueId) return;

        if (standard is BattleNikke &&
            standard.totalBulletsFired > 0 &&
            standard.totalBulletsFired % data.timingTriggerValue == 0) {
          executeFunction(event, simulation);
        }
        break;
      case TimingTriggerType.onHpRatioUnder:
        // all standard is User
        if (event is! HpChangeEvent || standard == null || standard.uniqueId != ownerUniqueId) return;

        final hpPercent = standard.currentHp / standard.getMaxHp(simulation);
        if ((hpPercent * 10000).round() <= data.timingTriggerValue) {
          if (status == FunctionStatus.off) {
            executeFunction(event, simulation);
            status = FunctionStatus.on;
          }
        } else {
          // until the true meaning of keepStatus is figured out this is used as a simple boolean for certain
          // functions only
          status = FunctionStatus.off;
        }
        break;
      case TimingTriggerType.onHpRatioUp:
        // all standard is User
        if (event is! HpChangeEvent || standard == null || standard.uniqueId != ownerUniqueId) return;

        final hpPercent = standard.currentHp / standard.getMaxHp(simulation);
        if ((hpPercent * 10000).round() >= data.timingTriggerValue) {
          if (status == FunctionStatus.off) {
            executeFunction(event, simulation);
            status = FunctionStatus.on;
          }
        } else {
          // until the true meaning of keepStatus is figured out this is used as a simple boolean for certain
          // functions only
          status = FunctionStatus.off;
        }
        break;
      case TimingTriggerType.onSkillUse:
        if (event is UseSkillEvent &&
            event.skillGroup == data.timingTriggerValue &&
            standard?.uniqueId == ownerUniqueId) {
          executeFunction(event, simulation);
        }
        break;
      case TimingTriggerType.onEnterBurstStep:
        if (event is ChangeBurstStepEvent && event.nextStage == data.timingTriggerValue) {
          executeFunction(event, simulation);
        }
        break;
      case TimingTriggerType.onFullCount:
        if (event is BuffEvent &&
            standard?.uniqueId == ownerUniqueId &&
            event.buffCount == event.fullCount &&
            event.buffGroupId == data.timingTriggerValue) {
          executeFunction(event, simulation);
        }
        break;
      case TimingTriggerType.onHealedBy:
        if (event is HpChangeEvent && event.getActivatorUniqueId() == ownerUniqueId && event.isHeal) {
          executeFunction(event, simulation);
        }
        break;
      case TimingTriggerType.none:
      case TimingTriggerType.onAmmoRatioUnder:
      case TimingTriggerType.onBurstSkillStep:
      case TimingTriggerType.onBurstSkillUseNum:
      case TimingTriggerType.onCheckTime:
      case TimingTriggerType.onCoreHitNum:
      case TimingTriggerType.onCoreHitNumOnce:
      case TimingTriggerType.onCoreHitRatio:
      case TimingTriggerType.onCoverHurtRatio:
      case TimingTriggerType.onCriticalHitNum:
      case TimingTriggerType.onDead:
      case TimingTriggerType.onEndFullBurst:
      case TimingTriggerType.onEndReload:
      case TimingTriggerType.onFullCharge:
      case TimingTriggerType.onFullChargeHit:
      case TimingTriggerType.onFullChargeHitNum:
      case TimingTriggerType.onFullChargeNum:
      case TimingTriggerType.onFullChargeShot:
      case TimingTriggerType.onFullChargeShotNum:
      case TimingTriggerType.onFunctionBuffCheck:
      case TimingTriggerType.onFunctionOff:
      case TimingTriggerType.onFunctionOn:
      case TimingTriggerType.onHealCover:
      case TimingTriggerType.onHitNumExceptCore:
      case TimingTriggerType.onHitNumberOver:
      case TimingTriggerType.onHitRatio:
      case TimingTriggerType.onHurtCount:
      case TimingTriggerType.onHurtRatio:
      case TimingTriggerType.onInstallBarrier:
      case TimingTriggerType.onInstantDeath:
      case TimingTriggerType.onKeepFullcharge:
      case TimingTriggerType.onKillRatio:
      case TimingTriggerType.onLastAmmoUse:
      case TimingTriggerType.onLastShotHit:
      case TimingTriggerType.onNikkeDead:
      case TimingTriggerType.onPartsBrokenNum:
      case TimingTriggerType.onPartsHitNum:
      case TimingTriggerType.onPartsHitRatio:
      case TimingTriggerType.onPartsHurtCount:
      case TimingTriggerType.onPelletHitNum:
      case TimingTriggerType.onPelletHitPerShot:
      case TimingTriggerType.onResurrection:
      case TimingTriggerType.onShotNotFullCharge:
      case TimingTriggerType.onShotRatio:
      case TimingTriggerType.onSpawnMonster:
      case TimingTriggerType.onSpawnTarget:
      case TimingTriggerType.onSquadHurtRatio:
      case TimingTriggerType.onSummonMonster:
      case TimingTriggerType.onTeamHpRatioUnder:
      case TimingTriggerType.onTeamHpRatioUp:
      case TimingTriggerType.onUseBurstSkill:
      case TimingTriggerType.onUserPartsDestroy:
      case TimingTriggerType.unknown:
        // logger.i('Unimplemented TimingTriggerType: ${data.timingTriggerType}');
        break;
    }
  }

  BattleEntity? getTimingTriggerStandardTarget(BattleEvent event, BattleSimulation simulation) {
    switch (data.timingTriggerStandard) {
      case StandardType.user:
      case StandardType.none:
        // a lot of timingTriggerTypes have standards set to none which clearly need an countTarget, so default to
        // activator. examples include Elegg S2
        return simulation.getEntityByUniqueId(event.getActivatorUniqueId());
      case StandardType.functionTarget:
        // functionTarget: {onTeamHpRatioUnder, onPartsBrokenNum, onTeamHpRatioUp, onFullCount (not actually used)}
        // so essentially this means all nikkes? only that would makes sense for Flora S2
        // TODO: leaving that out until it's time to write that, so weird
        return null;
      case StandardType.unknown:
      case StandardType.triggerTarget: // no trigger target for timing trigger standard
        return null;
    }
  }

  bool checkTargetStatus(BattleEvent event, BattleSimulation simulation, BattleEntity target) {
    return checkStatusTrigger(
          simulation,
          getStatusTriggerStandardTarget(event, simulation, data.statusTriggerStandard, target),
          data.statusTriggerType,
          data.statusTriggerValue,
        ) &&
        checkStatusTrigger(
          simulation,
          getStatusTriggerStandardTarget(event, simulation, data.statusTrigger2Standard, target),
          data.statusTrigger2Type,
          data.statusTrigger2Value,
        );
  }

  bool addBuff(BattleEvent event, BattleSimulation simulation) {
    bool result = false;
    final functionTargets = getFunctionTargets(event, simulation);
    for (final target in functionTargets) {
      final statusCheck = checkTargetStatus(event, simulation, target);
      if (!statusCheck) continue;

      result = true;
      final previousMaxAmmo = target is BattleNikke ? target.getMaxAmmo(simulation) : 0;
      final previousMaxHp = target.getMaxHp(simulation);

      final existingBuff = target.buffs.firstWhereOrNull((buff) => buff.data.groupId == data.groupId);
      if (existingBuff != null) {
        existingBuff.duration =
            data.durationType == DurationType.timeSec
                ? BattleUtils.timeDataToFrame(data.durationValue, simulation.fps)
                : data.durationValue;
        existingBuff.count = min(existingBuff.count + 1, data.fullCount);

        // overwrite is probably done this way
        if (existingBuff.data.level < data.level) {
          existingBuff.data = data;
          existingBuff.buffGiverUniqueId = event.getActivatorUniqueId();
          existingBuff.buffReceiverUniqueId = target.uniqueId;
        }
        simulation.registerEvent(simulation.currentFrame, BuffEvent(simulation, existingBuff));
      } else {
        final buff = BattleBuff(data, ownerUniqueId, target.uniqueId, simulation);
        target.buffs.add(buff);
        simulation.registerEvent(simulation.currentFrame, BuffEvent(simulation, buff));
      }

      if (data.functionType == FunctionType.statHpHeal) {
        final afterMaxHp = target.getMaxHp(simulation);
        target.changeHp(simulation, afterMaxHp - previousMaxHp);
      } else if (target is BattleNikke && data.functionType == FunctionType.statAmmoLoad) {
        final afterMaxAmmo = target.getMaxAmmo(simulation);
        target.currentAmmo = (target.currentAmmo + afterMaxAmmo - previousMaxAmmo).clamp(1, afterMaxAmmo);
      } else if (data.functionType == FunctionType.statHp) {
        final afterMaxHp = target.getMaxHp(simulation);
        simulation.registerEvent(
          simulation.currentFrame,
          HpChangeEvent(simulation, target, afterMaxHp - previousMaxHp, isMaxHpOnly: true),
        );
      }
    }
    status = data.keepingType;
    return result;
  }

  void executeFunction(BattleEvent event, BattleSimulation simulation) {
    bool activated = false;
    switch (data.functionType) {
      case FunctionType.addDamage:
      case FunctionType.attention:
      case FunctionType.changeCoolTimeUlti: // act as a buff for rounding
      case FunctionType.coreShotDamageChange:
      case FunctionType.damageReduction:
      case FunctionType.drainHpBuff:
      case FunctionType.firstBurstGaugeSpeedUp:
      case FunctionType.gainAmmo: // is actually a buff of 0 duration
      case FunctionType.givingHealVariation:
      case FunctionType.healVariation:
      case FunctionType.incElementDmg:
      case FunctionType.immuneDamage: // TODO: actually implement after hp deduction is real for boss
      case FunctionType.normalDamageRatioChange: // user & functionTarget (Rumani Burst)
      case FunctionType.partsDamage:
      case FunctionType.penetrationDamage:
      case FunctionType.removeFunctionGroup: // probably better to remove at end of frame
      case FunctionType.statAccuracyCircle:
      case FunctionType.statAmmo:
      case FunctionType.statAmmoLoad:
      case FunctionType.statAtk:
      case FunctionType.statChargeDamage:
      case FunctionType.statChargeTime:
      case FunctionType.statCritical:
      case FunctionType.statCriticalDamage:
      case FunctionType.statDef:
      case FunctionType.statHp:
      case FunctionType.statHpHeal:
      case FunctionType.statPenetration:
      case FunctionType.statReloadTime:
      case FunctionType.none: // misc counters etc.
        // add buff
        activated = addBuff(event, simulation);
        break;
      case FunctionType.changeCurrentHpValue:
        // all function standard is user
        final functionTargets = getFunctionTargets(event, simulation);
        for (final target in functionTargets) {
          activated |= checkTargetStatus(event, simulation, target);
          if (data.functionValueType == ValueType.integer) {
            target.changeHp(simulation, data.functionValue);
          } else if (data.functionValueType == ValueType.percent) {
            final functionStandard = simulation.getEntityByUniqueId(getFunctionStandardUniqueId(target.uniqueId));
            if (functionStandard != null) {
              final changeValue = BattleUtils.toModifier(data.functionValue) * functionStandard.currentHp;
              target.changeHp(simulation, changeValue.round());
            }
          }
        }
        break;
      case FunctionType.damage:
        final functionTargets = getFunctionTargets(event, simulation);
        for (final target in functionTargets) {
          if (target is BattleRapture) {
            activated |= checkTargetStatus(event, simulation, target);
            simulation.registerEvent(
              simulation.currentFrame,
              NikkeDamageEvent.skill(
                simulation: simulation,
                nikke: simulation.getNikkeOnPosition(ownerUniqueId)!,
                rapture: target,
                damageRate: data.functionValue,
              ),
            );
          }
        }
        break;
      case FunctionType.healCover:
        final functionTargets = getFunctionTargets(event, simulation);
        for (final target in functionTargets) {
          if (target is! BattleNikke) continue;

          activated |= checkTargetStatus(event, simulation, target);
          if (data.functionValueType == ValueType.integer) {
            target.cover.changeHp(simulation, data.functionValue, true);
          } else if (data.functionValueType == ValueType.percent) {
            final functionStandard = simulation.getNikkeOnPosition(getFunctionStandardUniqueId(target.uniqueId))!.cover;
            final changeValue = BattleUtils.toModifier(data.functionValue) * functionStandard.getMaxHp(simulation);
            target.cover.changeHp(simulation, changeValue.round(), true);
          }
        }
        break;
      case FunctionType.healCharacter:
        final functionTargets = getFunctionTargets(event, simulation);
        for (final target in functionTargets) {
          activated |= checkTargetStatus(event, simulation, target);

          final activator = simulation.getEntityByUniqueId(event.getActivatorUniqueId());
          final healVariation = activator?.getHealVariation(simulation) ?? 0;

          int healValue = 0;
          if (data.functionValueType == ValueType.integer) {
            healValue = data.functionValue;
          } else if (data.functionValueType == ValueType.percent) {
            final functionStandard = simulation.getNikkeOnPosition(getFunctionStandardUniqueId(target.uniqueId))!;
            final changeValue = BattleUtils.toModifier(data.functionValue) * functionStandard.getMaxHp(simulation);
            healValue = changeValue.round();
          }
          final finalHeal = healValue + healValue * BattleUtils.toModifier(healVariation);
          target.changeHp(simulation, finalHeal.round(), true);
        }
        break;
      case FunctionType.useCharacterSkillId:
        final skill = gameData.characterSkillTable[data.functionValue];
        if (skill != null) {
          activated = true;
          BattleSkill.activateSkill(simulation, skill, ownerUniqueId, gameData.skillInfoTable[skill.id]!.groupId, -1);
        }
        break;
      case FunctionType.unknown:
      case FunctionType.addIncElementDmgType:
      case FunctionType.allAmmo:
      case FunctionType.allStepBurstNextStep:
      case FunctionType.atkBuffChange:
      case FunctionType.atkChangHpRate:
      case FunctionType.atkChangeMaxHpRate:
      case FunctionType.atkReplaceMaxHpRate:
      case FunctionType.barrierDamage:
      case FunctionType.bonusRangeDamageChange:
      case FunctionType.breakDamage:
      case FunctionType.buffRemove:
      case FunctionType.burstGaugeCharge:
      case FunctionType.callingMonster:
      case FunctionType.changeChangeBurstStep:
      case FunctionType.changeCoolTimeAll:
      case FunctionType.changeCoolTimeSkill1:
      case FunctionType.changeCoolTimeSkill2:
      case FunctionType.changeMaxSkillCoolTime2:
      case FunctionType.changeMaxSkillCoolTimeUlti:
      case FunctionType.changeNormalDefIgnoreDamage:
      case FunctionType.chargeDamageChangeMaxStatAmmo:
      case FunctionType.chargeTimeChangetoDamage:
      case FunctionType.changeUseBurstSkill:
      case FunctionType.copyAtk:
      case FunctionType.copyHp:
      case FunctionType.coverResurrection:
      case FunctionType.currentHpRatioDamage:
      case FunctionType.cycleUse:
      case FunctionType.damageBio:
      case FunctionType.damageEnergy:
      case FunctionType.damageFunctionTargetGroupId:
      case FunctionType.damageFunctionUnable:
      case FunctionType.damageFunctionValueChange:
      case FunctionType.damageMetal:
      case FunctionType.damageRatioEnergy:
      case FunctionType.damageRatioMetal:
      case FunctionType.damageShare:
      case FunctionType.damageShareInstant:
      case FunctionType.damageShareInstantUnable:
      case FunctionType.debuffImmune:
      case FunctionType.debuffRemove:
      case FunctionType.defChangHpRate:
      case FunctionType.defIgnoreDamage:
      case FunctionType.defIgnoreDamageRatio:
      case FunctionType.durationDamageRatio:
      case FunctionType.durationValueChange:
      case FunctionType.explosiveCircuitAccrueDamageRatio:
      case FunctionType.finalStatHpHeal:
      case FunctionType.fixStatReloadTime:
      case FunctionType.forcedStop:
      case FunctionType.fullChargeHitDamageRepeat:
      case FunctionType.fullCountDamageRatio:
      case FunctionType.functionOverlapChange:
      case FunctionType.gainUltiGauge:
      case FunctionType.gravityBomb:
      case FunctionType.healBarrier:
      case FunctionType.healDecoy:
      case FunctionType.healShare:
      case FunctionType.hide:
      case FunctionType.hpProportionDamage:
      case FunctionType.immuneAttention:
      case FunctionType.immuneBio:
      case FunctionType.immuneChangeCoolTimeUlti:
      case FunctionType.immuneDamageMainHp:
      case FunctionType.immuneEnergy:
      case FunctionType.immuneForcedStop:
      case FunctionType.immuneGravityBomb:
      case FunctionType.immuneInstantDeath:
      case FunctionType.immuneInstallBarrier:
      case FunctionType.immuneMetal:
      case FunctionType.immuneOtherElement:
      case FunctionType.immuneStun:
      case FunctionType.immuneTaunt:
      case FunctionType.immortal:
      case FunctionType.incBarrierHp:
      case FunctionType.incBurstDuration:
      case FunctionType.infection:
      case FunctionType.instantAllBurstDamage:
      case FunctionType.instantDeath:
      case FunctionType.linkAtk:
      case FunctionType.linkDef:
      case FunctionType.normalStatCritical:
      case FunctionType.outBonusRangeDamageChange:
      case FunctionType.overHealSave:
      case FunctionType.partsHpChangeUIOff:
      case FunctionType.partsHpChangeUIOn:
      case FunctionType.partsImmuneDamage:
      case FunctionType.plusDebuffCount:
      case FunctionType.plusInstantSkillTargetNum:
      case FunctionType.projectileDamage:
      case FunctionType.projectileExplosionDamage:
      case FunctionType.repeatUseBurstStep:
      case FunctionType.resurrection:
      case FunctionType.shareDamageIncrease:
      case FunctionType.silence:
      case FunctionType.singleBurstDamage:
      case FunctionType.statBioResist:
      case FunctionType.statBonusRangeMax:
      case FunctionType.statBurstSkillCoolTime:
      case FunctionType.statChargeTimeImmune:
      case FunctionType.statEndRateOfFire:
      case FunctionType.statEnergyResist:
      case FunctionType.statExplosion:
      case FunctionType.statInstantSkillRange:
      case FunctionType.statMaintainFireStance:
      case FunctionType.statRateOfFire:
      case FunctionType.statRateOfFirePerShot:
      case FunctionType.statReloadBulletRatio:
      case FunctionType.statShotCount:
      case FunctionType.statSpotRadius:
      case FunctionType.stickyProjectileCollisionDamage:
      case FunctionType.stickyProjectileExplosion:
      case FunctionType.stickyProjectileInstantExplosion:
      case FunctionType.stun:
      case FunctionType.taunt:
      case FunctionType.targetGroupid:
      case FunctionType.targetPartsId:
      case FunctionType.timingTriggerValueChange:
      case FunctionType.transformation:
      case FunctionType.uncoverable:
      case FunctionType.useSkill2:
      case FunctionType.windReduction:
        logger.i('Unimplemented FunctionType: ${data.functionType}');
        break;
    }

    timesActivated += 1; // probably still count as activated?
    if (activated) {
      // TODO: confirm if connected functions have proper status check or only apply to succeeded targets
      if (data.connectedFunction.isNotEmpty) {
        for (final functionId in data.connectedFunction) {
          final functionData = gameData.functionTable[functionId];
          if (functionData != null) {
            final connectedFunction = BattleFunction(functionData, ownerUniqueId);
            // connected function likely doesn't check trigger target
            connectedFunction.executeFunction(event, simulation);
          }
        }
      }
    }
  }

  List<BattleEntity> getFunctionTargets(BattleEvent event, BattleSimulation simulation) {
    final List<BattleEntity> result = [];
    switch (data.functionTarget) {
      case FunctionTargetType.allCharacter:
        result.addAll(simulation.nikkes);
        break;
      case FunctionTargetType.self:
        final self = simulation.getNikkeOnPosition(ownerUniqueId);
        if (self != null) {
          result.add(self);
        }
        break;
      case FunctionTargetType.allMonster:
        result.addAll(simulation.raptures);
        break;
      case FunctionTargetType.target:
        // if used with skills, it's skill's target
        for (final targetUniqueId in event.getTargetUniqueIds()) {
          final target = simulation.getEntityByUniqueId(targetUniqueId);
          if (target != null) {
            result.add(target);
          }
        }
        break;
      case FunctionTargetType.targetCover:
        for (final targetUniqueId in event.getTargetUniqueIds()) {
          final target = simulation.getEntityByUniqueId(targetUniqueId);
          if (target != null && target is BattleNikke) {
            result.add(target.cover);
          }
        }
      case FunctionTargetType.userCover:
        final self = simulation.getNikkeOnPosition(ownerUniqueId);
        if (self != null) {
          result.add(self.cover);
        }
        break;
      case FunctionTargetType.unknown:
      case FunctionTargetType.none:
        break;
    }
    return result;
  }

  BattleEntity? getStatusTriggerStandardTarget(
    BattleEvent event,
    BattleSimulation simulation,
    StandardType standardType,
    BattleEntity currentFunctionTarget,
  ) {
    switch (standardType) {
      case StandardType.user:
        return simulation.getEntityByUniqueId(ownerUniqueId);
      case StandardType.functionTarget:
        return currentFunctionTarget;
      case StandardType.triggerTarget:
        // only used by Phantom S1 (addDamage, onShotRatio, isFunctionOn) & Flora S2 (activate barrier, onTeamHpUnder,
        // checkPosition), current interpretation is whoever triggered the event
        return simulation.getEntityByUniqueId(event.getActivatorUniqueId());
      case StandardType.none: // when statusTriggerType is not none, standardType is only none for isCheckMonster
      case StandardType.unknown:
        return null;
    }
  }

  static bool checkStatusTrigger(BattleSimulation simulation, BattleEntity? target, StatusTriggerType type, int value) {
    switch (type) {
      case StatusTriggerType.none:
        return true;
      case StatusTriggerType.isBurstStepState:
        return simulation.burstStage == value;
      case StatusTriggerType.isCheckMonster:
        return simulation.raptures.length >= value;
      case StatusTriggerType.isHpRatioUnder:
        // functionTarget (only Trina S1, which is triggered by skill) & user
        return target != null && (target.currentHp / target.getMaxHp(simulation) * 10000).round() <= value;
      case StatusTriggerType.isHpRatioUp:
        // all user
        return target != null && (target.currentHp / target.getMaxHp(simulation) * 10000).round() >= value;
      case StatusTriggerType.isWeaponType:
        return target is BattleNikke && target.baseWeaponData.id == value;
      case StatusTriggerType.isFunctionOff:
        return target != null && target.buffs.every((buff) => buff.data.groupId != value);
      case StatusTriggerType.isFunctionOn:
        final result = target != null && target.buffs.any((buff) => buff.data.groupId == value);
        return result;
      case StatusTriggerType.isBurstMember:
        return target is BattleNikke && target.activatedBurstSkillThisCycle == true;
      case StatusTriggerType.isNotBurstMember:
        return target is BattleNikke && target.activatedBurstSkillThisCycle == false;
      case StatusTriggerType.unknown:
      case StatusTriggerType.isAlive:
      case StatusTriggerType.isAmmoCount:
      case StatusTriggerType.isCharacter:
      case StatusTriggerType.isCheckFunctionOverlapUp:
      case StatusTriggerType.isCheckMonsterType:
      case StatusTriggerType.isCheckPartsId:
      case StatusTriggerType.isCheckPosition:
      case StatusTriggerType.isCheckTarget:
      case StatusTriggerType.isCheckTeamBurstNextStep:
      case StatusTriggerType.isClassType:
      case StatusTriggerType.isCover:
      case StatusTriggerType.isExplosiveCircuitOff:
      case StatusTriggerType.isFullCharge:
      case StatusTriggerType.isFullCount:
      case StatusTriggerType.isFunctionBuffCheck:
      case StatusTriggerType.isFunctionTypeOffCheck:
      case StatusTriggerType.isHaveBarrier:
      case StatusTriggerType.isHaveDecoy:
      case StatusTriggerType.isNotCheckTeamBurstNextStep:
      case StatusTriggerType.isNotHaveBarrier:
      case StatusTriggerType.isPhase:
      case StatusTriggerType.isSameSquadCount:
      case StatusTriggerType.isSameSquadUp:
      case StatusTriggerType.isSearchElementId:
      case StatusTriggerType.isStun:
        logger.i('Unimplemented StatusTriggerType: $type');
        return false;
    }
  }

  int getFunctionStandardUniqueId(int targetUniqueId) {
    switch (data.functionStandard) {
      case StandardType.user:
        return ownerUniqueId;
      case StandardType.functionTarget:
        return targetUniqueId;
      case StandardType.triggerTarget: // there is no triggerTarget in functionStandardType
      case StandardType.unknown:
      case StandardType.none:
        return -1;
    }
  }
}
