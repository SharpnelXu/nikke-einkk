import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/nikke.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleFunction {
  final FunctionData data;

  FunctionStatus status = FunctionStatus.off;
  int timesActivated = 0;

  BattleFunction(this.data);

  void broadcast(BattleEvent event, BattleSimulation simulation) {
    // the idea is that all data necessary for processing this broadcast should be available in the event
    final standard = getTriggerStandardTarget(event, simulation)!;
    switch (data.timingTriggerType) {
      case TimingTriggerType.onHitNum:
        if (event is! NikkeDamageEvent) return;

        if (standard.totalBulletsHit > 0 && standard.totalBulletsHit % data.timingTriggerValue == 0) {
          executeFunction(event, simulation, standard);
        }
        break;
      case TimingTriggerType.onStart:
        if (event is! BattleStartEvent) return;
        executeFunction(event, simulation, standard);
        break;
      case TimingTriggerType.onUseAmmo:
        if (event is! NikkeFireEvent) return;

        if (standard.totalBulletsFired > 0 && standard.totalBulletsFired % data.timingTriggerValue == 0) {
          executeFunction(event, simulation, standard);
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
      case TimingTriggerType.onEnterBurstStep:
      case TimingTriggerType.onFullCharge:
      case TimingTriggerType.onFullChargeHit:
      case TimingTriggerType.onFullChargeHitNum:
      case TimingTriggerType.onFullChargeNum:
      case TimingTriggerType.onFullChargeShot:
      case TimingTriggerType.onFullChargeShotNum:
      case TimingTriggerType.onFullCount:
      case TimingTriggerType.onFunctionBuffCheck:
      case TimingTriggerType.onFunctionOff:
      case TimingTriggerType.onFunctionOn:
      case TimingTriggerType.onHealCover:
      case TimingTriggerType.onHealedBy:
      case TimingTriggerType.onHitNumExceptCore:
      case TimingTriggerType.onHitNumberOver:
      case TimingTriggerType.onHitRatio:
      case TimingTriggerType.onHpRatioUnder:
      case TimingTriggerType.onHpRatioUp:
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
      case TimingTriggerType.onSkillUse:
      case TimingTriggerType.onSpawnMonster:
      case TimingTriggerType.onSpawnTarget:
      case TimingTriggerType.onSquadHurtRatio:
      case TimingTriggerType.onSummonMonster:
      case TimingTriggerType.onTeamHpRatioUnder:
      case TimingTriggerType.onTeamHpRatioUp:
      case TimingTriggerType.onUseBurstSkill:
      case TimingTriggerType.onUserPartsDestroy:
      case TimingTriggerType.unknown:
        break;
    }
  }

  void executeFunction(BattleEvent event, BattleSimulation simulation, BattleNikke triggerTarget) {
    if (data.limitValue > 0 && timesActivated >= data.limitValue) return;

    timesActivated += 1;
    final activator = simulation.getNikkeOnPosition(event.getUserPosition())!;
    final functionTargets = getFunctionTargets(event, simulation);
    switch (data.functionType) {
      case FunctionType.damageReduction:
      case FunctionType.firstBurstGaugeSpeedUp:
      case FunctionType.gainAmmo: // is actually a buff of 0 duration
      case FunctionType.givingHealVariation:
      case FunctionType.incElementDmg:
      case FunctionType.partsDamage:
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
      case FunctionType.statReloadTime:
        for (final nikke in functionTargets) {
          final previousMaxAmmo = nikke.getMaxAmmo(simulation);
          final previousMaxHp = nikke.getMaxHp(simulation);

          final existingBuff = nikke.buffs.firstWhereOrNull((buff) => buff.data.id == data.id);
          if (existingBuff != null) {
            existingBuff.duration =
                data.durationType == DurationType.timeSec
                    ? BattleUtils.timeDataToFrame(data.durationValue, simulation.fps)
                    : data.durationValue;
            existingBuff.count = min(existingBuff.count + 1, data.fullCount);
          } else {
            nikke.buffs.add(BattleBuff(data, activator.position, triggerTarget.position, nikke.position));
          }

          if (data.functionType == FunctionType.statHpHeal) {
            final afterMaxHp = nikke.getMaxHp(simulation);
            nikke.currentHp = (nikke.currentHp + afterMaxHp - previousMaxHp).clamp(1, afterMaxHp);
          } else if (data.functionType == FunctionType.statAmmoLoad) {
            final afterMaxAmmo = nikke.getMaxAmmo(simulation);
            nikke.currentAmmo = (nikke.currentAmmo + afterMaxAmmo - previousMaxAmmo).clamp(1, afterMaxAmmo);
          }
        }
        status = data.keepingType;
        break;
      case FunctionType.unknown:
      case FunctionType.addDamage:
      case FunctionType.addIncElementDmgType:
      case FunctionType.allAmmo:
      case FunctionType.allStepBurstNextStep:
      case FunctionType.atkBuffChange:
      case FunctionType.atkChangHpRate:
      case FunctionType.atkChangeMaxHpRate:
      case FunctionType.atkReplaceMaxHpRate:
      case FunctionType.attention:
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
      case FunctionType.changeCoolTimeUlti:
      case FunctionType.changeCurrentHpValue:
      case FunctionType.changeMaxSkillCoolTime2:
      case FunctionType.changeMaxSkillCoolTimeUlti:
      case FunctionType.changeNormalDefIgnoreDamage:
      case FunctionType.chargeDamageChangeMaxStatAmmo:
      case FunctionType.chargeTimeChangetoDamage:
      case FunctionType.changeUseBurstSkill:
      case FunctionType.copyAtk:
      case FunctionType.copyHp:
      case FunctionType.coreShotDamageChange:
      case FunctionType.coverResurrection:
      case FunctionType.currentHpRatioDamage:
      case FunctionType.cycleUse:
      case FunctionType.damage:
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
      case FunctionType.drainHpBuff:
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
      case FunctionType.healCharacter:
      case FunctionType.healCover:
      case FunctionType.healDecoy:
      case FunctionType.healShare:
      case FunctionType.healVariation:
      case FunctionType.hide:
      case FunctionType.hpProportionDamage:
      case FunctionType.immuneAttention:
      case FunctionType.immuneBio:
      case FunctionType.immuneChangeCoolTimeUlti:
      case FunctionType.immuneDamage:
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
      case FunctionType.none:
      case FunctionType.normalDamageRatioChange:
      case FunctionType.normalStatCritical:
      case FunctionType.outBonusRangeDamageChange:
      case FunctionType.overHealSave:
      case FunctionType.partsHpChangeUIOff:
      case FunctionType.partsHpChangeUIOn:
      case FunctionType.partsImmuneDamage:
      case FunctionType.penetrationDamage:
      case FunctionType.plusDebuffCount:
      case FunctionType.plusInstantSkillTargetNum:
      case FunctionType.projectileDamage:
      case FunctionType.projectileExplosionDamage:
      case FunctionType.removeFunctionGroup:
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
      case FunctionType.statPenetration:
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
      case FunctionType.useCharacterSkillId:
      case FunctionType.useSkill2:
      case FunctionType.windReduction:
        break;
    }
  }

  BattleNikke? getTriggerStandardTarget(BattleEvent event, BattleSimulation simulation) {
    switch (data.timingTriggerStandard) {
      case StandardType.user:
        return simulation.getNikkeOnPosition(event.getUserPosition());
      case StandardType.unknown:
      case StandardType.none:
      case StandardType.functionTarget:
      case StandardType.triggerTarget:
        return null;
    }
  }

  List<BattleNikke> getFunctionTargets(BattleEvent event, BattleSimulation simulation) {
    switch (data.functionTarget) {
      case FunctionTargetType.allCharacter:
        return simulation.nikkes;
      case FunctionTargetType.self:
        return [simulation.getNikkeOnPosition(event.getUserPosition())!];
      case FunctionTargetType.unknown:
      case FunctionTargetType.none:
      case FunctionTargetType.target:
      case FunctionTargetType.targetCover:
      case FunctionTargetType.allMonster:
      case FunctionTargetType.userCover:
        return [];
    }
  }
}
