import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/battle_skill.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/user_data.dart';

enum BattleNikkeStatus { behindCover, reloading, forceReloading, shooting }

class BattleCover extends BattleEntity {
  int level;

  @override
  String get name => 'Cover';

  @override
  int get baseHp => db.coverStatTable[level]?.levelHp ?? 0;

  @override
  int get baseAttack => 0;

  @override
  int get baseDefence => db.coverStatTable[level]?.levelDefence ?? 0;

  bool useGlobal = true;
  NikkeDatabase get db => useGlobal ? global : cn;

  BattleCover(this.level, this.useGlobal);

  void init(BattleSimulation simulation) {
    if (!db.coverStatTable.containsKey(level)) {
      logger.w('Invalid Cover level: $level');
    }
    currentHp = baseHp;
    buffs.clear();
  }
}

class BattleNikke extends BattleEntity {
  PlayerOptions playerOptions;
  NikkeOptions option;

  int fps = 60;

  NikkeCharacterData get characterData => db.characterResourceGardeTable[option.nikkeResourceId]![option.coreLevel]!;
  @override
  String get name => locale.getTranslation(characterData.nameLocalkey) ?? characterData.resourceId.toString();
  WeaponData get baseWeaponData => db.characterShotTable[characterData.shotId]!;
  // skill data
  NikkeClass get nikkeClass => characterData.characterClass;
  Corporation get corporation => characterData.corporation;
  @override
  NikkeElement get element => NikkeElement.fromId(characterData.elementId.first);

  List<NikkeElement> get effectiveElements =>
      characterData.elementId.map((eleId) => NikkeElement.fromId(eleId)).toList();

  int get coreLevel => characterData.gradeCoreId;

  CharacterStatData get baseStat =>
      db.groupedCharacterStatTable[characterData.statEnhanceId]?[option.syncLevel] ?? CharacterStatData.emptyData;
  CharacterStatEnhanceData get statEnhanceData =>
      db.characterStatEnhanceTable[characterData.statEnhanceId] ?? CharacterStatEnhanceData.emptyData;
  ClassAttractiveStatData get attractiveStat =>
      db.attractiveStatTable[option.attractLevel]?.getStatData(nikkeClass) ?? ClassAttractiveStatData.emptyData;

  @override
  int get baseHp => getBaseStat(
    coreLevel: coreLevel,
    baseStat: baseStat.hp,
    gradeRatio: statEnhanceData.gradeRatio,
    gradeEnhanceBase: statEnhanceData.gradeHp,
    coreEnhanceBaseRatio: statEnhanceData.coreHp,
    consoleStat: playerOptions.getRecycleHp(nikkeClass),
    bondStat: attractiveStat.hpRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + (equip?.getEquipStat(StatType.hp, db, corporation) ?? 0)),
    cubeStat: option.cube?.getCubeStat(StatType.hp, db) ?? 0,
    dollStat: option.favoriteItem?.getDollStat(StatType.hp, db) ?? 0,
  );

  @override
  int get baseAttack => getBaseStat(
    coreLevel: coreLevel,
    baseStat: baseStat.attack,
    gradeRatio: statEnhanceData.gradeRatio,
    gradeEnhanceBase: statEnhanceData.gradeAttack,
    coreEnhanceBaseRatio: statEnhanceData.coreAttack,
    consoleStat: playerOptions.getRecycleAttack(corporation),
    bondStat: attractiveStat.attackRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + (equip?.getEquipStat(StatType.atk, db, corporation) ?? 0)),
    cubeStat: option.cube?.getCubeStat(StatType.atk, db) ?? 0,
    dollStat: option.favoriteItem?.getDollStat(StatType.atk, db) ?? 0,
  );

  @override
  int get baseDefence => getBaseStat(
    coreLevel: coreLevel,
    baseStat: baseStat.defence,
    gradeRatio: statEnhanceData.gradeRatio,
    gradeEnhanceBase: statEnhanceData.gradeDefence,
    coreEnhanceBaseRatio: statEnhanceData.coreDefence,
    consoleStat: playerOptions.getRecycleDefence(nikkeClass, corporation),
    bondStat: attractiveStat.defenceRate,
    equipStat: option.equips.fold(
      0,
      (sum, equip) => sum + (equip?.getEquipStat(StatType.defence, db, corporation) ?? 0),
    ),
    cubeStat: option.cube?.getCubeStat(StatType.defence, db) ?? 0,
    dollStat: option.favoriteItem?.getDollStat(StatType.defence, db) ?? 0,
  );

  late BattleCover cover;
  List<Barrier> barriers = [];
  int currentAmmo = 0;

  WeaponType get currentWeaponType => currentWeaponData.weaponType;
  WeaponData get currentWeaponData => baseWeaponData;

  // TODO: this encapsulates ranges so don't need to clamp on every change, but it's boiler plate ish
  // a lot of frame counters have min value 0,
  /// this is without buff, so internal tracking only
  int __accuracyCircleScale = 0;
  int get _accuracyCircleScale => __accuracyCircleScale;
  set _accuracyCircleScale(int newScale) =>
      __accuracyCircleScale = newScale.clamp(
        currentWeaponData.endAccuracyCircleScale,
        currentWeaponData.startAccuracyCircleScale,
      );

  int _rateOfFire = 0;
  int get rateOfFire => _rateOfFire;
  set rateOfFire(int value) => _rateOfFire = value.clamp(currentWeaponData.rateOfFire, currentWeaponData.endRateOfFire);

  int fullReloadFrameCount = 0;

  // these start with 0 (+= 1 each frame)
  int reloadingFrameCount = 0; // reason for += 1: fullReloadFrameCount is calculated as max at first reload frame
  int chargeFrames = 0;
  int previousFullChargeFrameCount = 0;

  // TODO: min value 0?
  // these starts with max (-= 1 each frame)
  int spotFirstDelayFrameCount = 0;
  int spotLastDelayFrameCount = 0; // after charge attack force back to cover

  // ready to fire if equals or below 0.
  // after each bullet, add 60 * fps to this value, which then gets subtracted with rateOfFire in each frame.
  // this makes the counter immune to rounding errors due to frame rate & fixes SMG fire rate.
  int shootCountdown = 0;
  int get shootThreshold => 60 * fps;

  int totalBulletsFired = 0;
  int totalFullChargeFired = 0;
  int totalBulletsHit = 0;
  bool activatedBurstSkillThisCycle = false;

  BattleNikkeStatus status = BattleNikkeStatus.behindCover;

  List<BattleSkill> skills = [];
  List<BattleFunction> functions = [];

  final bool useGlobal;
  NikkeDatabase get db => useGlobal ? global : cn;

  BattleNikke({required this.playerOptions, required this.option, this.useGlobal = true}) {
    cover = BattleCover(option.syncLevel, true);
  }

  void init(BattleSimulation simulation, int position) {
    uniqueId = position;
    fps = simulation.fps;
    status = BattleNikkeStatus.behindCover;
    _accuracyCircleScale = baseWeaponData.startAccuracyCircleScale;
    rateOfFire = baseWeaponData.rateOfFire;
    chargeFrames = 0;
    previousFullChargeFrameCount = 0;
    shootCountdown = 0;
    spotLastDelayFrameCount = 0;
    spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(baseWeaponData.spotFirstDelay, fps);
    reloadingFrameCount = 0;
    fullReloadFrameCount = 0;
    currentHp = baseHp;
    currentAmmo = baseWeaponData.maxAmmo;
    cover.uniqueId = position + 5;
    cover.init(simulation);
    barriers.clear();

    totalBulletsFired = 0;
    totalFullChargeFired = 0;
    totalBulletsHit = 0;
    activatedBurstSkillThisCycle = false;
    functions.clear();
    buffs.clear();
    skills.clear();

    for (final equip in option.equips) {
      equip?.applyEquipLines(simulation, this);
    }
    option.cube?.applyCubeEffect(simulation, this);
    option.favoriteItem?.applyCollectionItemEffect(simulation, this);

    skills.add(
      BattleSkill(characterData.skill1Id, characterData.skill1Table, option.skillLevels[0], 1, uniqueId, useGlobal),
    );
    skills.add(
      BattleSkill(characterData.skill2Id, characterData.skill2Table, option.skillLevels[1], 2, uniqueId, useGlobal),
    );
    skills.add(
      BattleSkill(characterData.ultiSkillId, SkillType.characterSkill, option.skillLevels[2], 3, uniqueId, useGlobal),
    );

    // substitute favorite item skill
    final favoriteItem = option.favoriteItem;
    final favItemData = option.favoriteItem?.getData(db);
    final dollLvData = db.favoriteItemLevelTable[favItemData?.levelEnhanceId]?[favoriteItem?.level];
    if (favItemData != null &&
        favItemData.nameCode > 0 &&
        favItemData.nameCode == characterData.nameCode &&
        dollLvData != null) {
      // grade is the number of stars, so either 1, 2, 3 in this case
      final substituteCount = min(favItemData.favoriteItemSkills.length, dollLvData.grade);
      final favoriteItemSkills = favItemData.favoriteItemSkills.sublist(0, substituteCount);
      for (final substituteSkillData in favoriteItemSkills) {
        if (substituteSkillData.skillId == 0) continue;

        final skillToChange = skills[substituteSkillData.skillChangeSlot - 1];
        skillToChange.skillId = substituteSkillData.skillId;
        skillToChange.skillType = substituteSkillData.skillTable;
      }
    }

    for (final skill in skills) {
      skill.init(simulation, this);
    }
  }

  @override
  void normalAction(BattleSimulation simulation) {
    determineStatus(simulation);

    switch (status) {
      case BattleNikkeStatus.behindCover:
        processBehindCoverStatus(simulation);
        break;
      case BattleNikkeStatus.reloading:
      case BattleNikkeStatus.forceReloading:
        processBehindCoverStatus(simulation);
        processReloadingStatus(simulation);
        break;
      case BattleNikkeStatus.shooting:
        processShootingStatus(simulation);
        break;
    }

    super.normalAction(simulation);

    for (final skill in skills) {
      skill.processFrame(simulation);
    }

    for (final barrier in barriers) {
      if (barrier.durationType == DurationType.timeSec) {
        barrier.duration -= 1;
      }
    }
    barriers.removeWhere(
      (barrier) => barrier.hp <= 0 || (barrier.duration == 0 && barrier.durationType == DurationType.timeSec),
    );
  }

  void processBehindCoverStatus(BattleSimulation simulation) {
    // reset this when entering a non-shooting status
    spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(currentWeaponData.spotFirstDelay, fps);
    chargeFrames = 0;
    spotLastDelayFrameCount -= 1;
    if (shootCountdown > 0) {
      shootCountdown -= rateOfFire;
    }
    if (currentWeaponData.accuracyChangeSpeed != 0) {
      // reset accuracy
      _accuracyCircleScale += (currentWeaponData.accuracyChangeSpeed / fps).round();
    }
    if (currentWeaponData.rateOfFireResetTime != 0) {
      rateOfFire -=
          ((currentWeaponData.endRateOfFire - currentWeaponData.rateOfFire) / currentWeaponData.rateOfFireResetTime)
              .round();
    }
  }

  void processReloadingStatus(BattleSimulation simulation) {
    if (reloadingFrameCount == 0) {
      // this means this is the first frame of reloading
      // need to calculate how many frames needed to do one reload
      int baseReloadTimeData = getTimeToReload(simulation);

      fullReloadFrameCount = max(BattleUtils.timeDataToFrame(baseReloadTimeData, fps), 1);

      simulation.registerEvent(
        simulation.currentFrame,
        NikkeReloadStartEvent(
          name: name,
          reloadTimeData: baseReloadTimeData,
          reloadFrames: fullReloadFrameCount,
          ownerUniqueId: uniqueId,
        ),
      );
    }

    reloadingFrameCount += 1;
    if (reloadingFrameCount >= fullReloadFrameCount) {
      final reloadRatio = BattleUtils.toModifier(max(1, currentWeaponData.reloadBullet)); // ensure no empty reloads
      final maxAmmo = getMaxAmmo(simulation);
      currentAmmo = min(maxAmmo, currentAmmo + (reloadRatio * maxAmmo).round());
      reloadingFrameCount = 0;
    }
  }

  void processShootingStatus(BattleSimulation simulation) {
    if (shootCountdown > 0) {
      shootCountdown -= rateOfFire;
    }
    // before shooting need to go outside cover first, not sure if this should be its own status tho
    if (spotFirstDelayFrameCount > 0) {
      spotFirstDelayFrameCount -= 1;
      if (spotFirstDelayFrameCount == 0 && WeaponType.chargeWeaponTypes.contains(currentWeaponType)) {
        previousFullChargeFrameCount = getFramesToFullCharge(simulation);
        chargeFrames = 1; // charge weapons seem to start with one frame of charge at the last frame of this animation
      }
      return;
    }
    // could use abs to track how long nikke stayed outside
    spotFirstDelayFrameCount -= 1;

    final target = simulation.raptures.where((rapture) => canTarget(rapture)).firstOrNull;
    if (target == null) return;

    switch (currentWeaponType) {
      case WeaponType.ar:
      case WeaponType.smg:
      case WeaponType.mg:
      case WeaponType.sg:
        if (shootCountdown > 0) {
          return;
        }

        while (shootCountdown <= 0) {
          shootCountdown += shootThreshold;
        }

        simulation.registerEvent(
          simulation.currentFrame,
          NikkeFireEvent(
            name: name,
            currentAmmo: currentAmmo,
            maxAmmo: getMaxAmmo(simulation),
            ownerUniqueId: uniqueId,
            isFullCharge: false,
          ),
        );
        if (currentWeaponData.fireType == FireType.instant) {
          generateDamageAndBurstEvents(simulation, simulation.currentFrame, target);
        }

        // these two should probably be available for all weapon types
        if (currentWeaponData.accuracyChangePerShot > 0) {
          _accuracyCircleScale -= currentWeaponData.accuracyChangePerShot;
        }
        if (currentWeaponData.rateOfFireChangePerShot > 0) {
          rateOfFire += currentWeaponData.rateOfFireChangePerShot;
        }

        return;
      case WeaponType.rl:
      case WeaponType.sr:
        final framesToFullCharge = getFramesToFullCharge(simulation);
        if (framesToFullCharge != previousFullChargeFrameCount) {
          // update chargeFrames to based on percentage, this is for change in charge speed
          final chargePercent = chargeFrames / previousFullChargeFrameCount;
          chargeFrames = (framesToFullCharge * chargePercent).round();
          previousFullChargeFrameCount = framesToFullCharge;
        }

        chargeFrames += 1;
        if (chargeFrames < framesToFullCharge && option.chargeMode == NikkeFullChargeMode.always) {
          return;
        }

        if (simulation.burstStage == 4 && simulation.burstStageDuration < framesToFullCharge) {
          return;
        }

        if (currentWeaponData.fireType == FireType.instant) {
          simulation.registerEvent(
            simulation.currentFrame,
            NikkeFireEvent(
              name: name,
              currentAmmo: currentAmmo,
              maxAmmo: getMaxAmmo(simulation),
              ownerUniqueId: uniqueId,
              isFullCharge: chargeFrames >= framesToFullCharge,
            ),
          );
          generateDamageAndBurstEvents(simulation, simulation.currentFrame, target);

          // TODO: move to attackDoneEvent (end of fire animation) for A2 & SBS (end of uptype_fire_timing)
          chargeFrames = 0;
        } else if ([
          FireType.homingProjectile,
          FireType.projectileCurve,
          FireType.projectileDirect,
        ].contains(currentWeaponData.fireType)) {
          final projectileCreateFrame = BattleUtils.timeDataToFrame(
            currentWeaponData.maintainFireStance * BattleUtils.toModifier(currentWeaponData.upTypeFireTiming),
            fps,
          );

          final fireFrame = simulation.currentFrame - projectileCreateFrame.round();
          if (fireFrame > 0) {
            simulation.registerEvent(
              fireFrame,
              NikkeFireEvent(
                name: name,
                currentAmmo: currentAmmo,
                maxAmmo: getMaxAmmo(simulation),
                ownerUniqueId: uniqueId,
                isFullCharge: chargeFrames >= framesToFullCharge,
              ),
            );
          }

          // wild guess here
          final projectileTravelFrame = target.distance * 100 / currentWeaponData.spotProjectileSpeed;
          // + 1 since this is the first frame and frame counts down
          final damageFrame = fireFrame - projectileTravelFrame.round();

          if (damageFrame > 0) {
            generateDamageAndBurstEvents(simulation, damageFrame, target);
          }
        }

        // this is essentially shooting frame for SR & RL
        if (currentWeaponData.maintainFireStance > 0) {
          // TODO: A2 has 9 extra frames, maybe due to animation but not sure
          spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(
            currentWeaponData.spotFirstDelay + currentWeaponData.maintainFireStance,
            fps,
          );
        } else {
          spotLastDelayFrameCount =
              option.forceCancelShootDelay ? 0 : BattleUtils.timeDataToFrame(currentWeaponData.spotLastDelay, fps);
          spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(currentWeaponData.spotFirstDelay, fps);
          chargeFrames = 0;
        }

        // these two should probably be available for all weapon types
        if (currentWeaponData.accuracyChangePerShot > 0) {
          _accuracyCircleScale -= currentWeaponData.accuracyChangePerShot;
        }
        if (currentWeaponData.rateOfFireChangePerShot > 0) {
          rateOfFire += currentWeaponData.rateOfFireChangePerShot;
        }

        return;
      case WeaponType.unknown:
      case WeaponType.none:
        // TODO: probably log?
        return;
    }
  }

  void generateDamageAndBurstEvents(BattleSimulation simulation, int frame, BattleRapture target) {
    simulation.registerEvent(
      simulation.currentFrame,
      NikkeDamageEvent.bullet(simulation: simulation, nikke: this, rapture: target),
    );
    if (simulation.burstStage == 0) {
      simulation.registerEvent(
        simulation.currentFrame,
        BurstGenerationEvent(simulation: simulation, nikke: this, rapture: target),
      );
    }
    if (getPierce(simulation) > 0) {
      for (final part in target.parts) {
        if (part.hp > 0) {
          simulation.registerEvent(
            simulation.currentFrame,
            NikkeDamageEvent.piercePart(simulation: simulation, nikke: this, rapture: target, part: part),
          );
          if (simulation.burstStage == 0) {
            simulation.registerEvent(
              simulation.currentFrame,
              BurstGenerationEvent(simulation: simulation, nikke: this, rapture: target),
            );
          }
        }
      }
    }
  }

  void determineStatus(BattleSimulation simulation) {
    if (status == BattleNikkeStatus.forceReloading && currentAmmo != getMaxAmmo(simulation)) return;

    final target = simulation.raptures.where((rapture) => canTarget(rapture)).firstOrNull;

    // forcing cover, or no autoAttack, or no target
    if (simulation.useCover || (uniqueId == simulation.currentNikke && !simulation.autoAttack) || target == null) {
      status = BattleNikkeStatus.behindCover;

      if (currentAmmo < getMaxAmmo(simulation)) {
        // attempt to reload
        status == BattleNikkeStatus.reloading;
      }
    } else {
      status = BattleNikkeStatus.shooting;

      if (currentAmmo == 0) {
        status = BattleNikkeStatus.forceReloading;
      } else if (spotLastDelayFrameCount > 0) {
        status = BattleNikkeStatus.behindCover;
      }
    }
  }

  bool isBonusRange(int distance) {
    return distance >= characterData.bonusRangeMin && distance <= characterData.bonusRangeMax;
  }

  bool canTarget(BattleRapture rapture) {
    return (rapture.canBeTargeted ||
            currentWeaponData.preferTargetCondition == PreferTargetCondition.includeNoneTargetNone) &&
        !rapture.outsideScreen;
  }

  void broadcast(BattleEvent event, BattleSimulation simulation) {
    if (event is NikkeFireEvent && event.ownerUniqueId == uniqueId) {
      currentAmmo = max(0, currentAmmo - 1);
      totalBulletsFired += 1;

      if (event.isFullCharge) {
        totalFullChargeFired += 1;
      }

      for (final buff in buffs) {
        if (buff.data.durationType == DurationType.shots && db.onShotFunctionTypes.contains(buff.data.functionType)) {
          buff.duration -= 1;
        }
      }

      // auto would still perform retreat behind cover animation
      if (currentAmmo == 0) {
        spotLastDelayFrameCount = BattleUtils.timeDataToFrame(currentWeaponData.spotLastDelay, fps);
      }
    }

    if (event is NikkeDamageEvent && event.attackerUniqueId == uniqueId) {
      processDamageEvent(event, simulation);
    }

    if (event is ExitFullBurstEvent) {
      activatedBurstSkillThisCycle = false;
    }

    if (event is RaptureDamageEvent && event.targetUniqueId == uniqueId) {
      for (final buff in buffs) {
        if (buff.data.durationType == DurationType.shots && db.onHitFunctionTypes.contains(buff.data.functionType)) {
          buff.duration -= 1;
        }
      }
    }

    for (final function in functions) {
      function.broadcast(event, simulation);
    }
  }

  void processDamageEvent(NikkeDamageEvent event, BattleSimulation simulation) {
    final rapture = simulation.getRaptureByUniqueId(event.targetUniqueId);
    if (rapture == null) return;

    if (event.type == NikkeDamageType.bullet) {
      totalBulletsHit += 1;
    }

    final drainHp = getDrainHpBuff(simulation);
    if (drainHp > 0) {
      final expectedDamage = event.damageParameter.calculateExpectedDamage();
      changeHp(simulation, (BattleUtils.toModifier(drainHp) * expectedDamage).round(), true);
    }
  }

  @override
  void endCurrentFrame(BattleSimulation simulation) {
    final gainAmmo = getBuffValue(
      simulation,
      FunctionType.gainAmmo,
      0,
      (nikke) => nikke is BattleNikke ? nikke.getMaxAmmo(simulation) : 0,
    );
    currentAmmo = (currentAmmo + gainAmmo).clamp(0, getMaxAmmo(simulation));

    final ultCdReduceTimeData = getBuffValue(
      simulation,
      FunctionType.changeCoolTimeUlti,
      0,
      (nikke) => nikke is BattleNikke ? nikke.skills[2].skillData?.skillCooltime ?? 0 : 0,
    );
    skills[2].changeCd(simulation, ultCdReduceTimeData);

    super.endCurrentFrame(simulation);
  }

  int getFramesCharged(BattleSimulation simulation) {
    final chargeSpeedSubtractedFrame = getBuffValue(
      simulation,
      FunctionType.statChargeTime,
      currentWeaponData.chargeTime,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.chargeTime : 0,
    );
    final framesToFullCharge = getFramesToFullCharge(simulation);
    final framesCharged = framesToFullCharge / max(1, framesToFullCharge - chargeSpeedSubtractedFrame);
    return framesCharged.round();
  }

  int getCriticalRate(BattleSimulation simulation) {
    return characterData.criticalRatio + getPlainBuffValues(simulation, FunctionType.statCritical);
  }

  int getNormalCriticalBuff(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.normalStatCritical);
  }

  /// nikke specific buffs
  int getAccuracyCircleScale(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statAccuracyCircle,
      _accuracyCircleScale,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.startAccuracyCircleScale : 0,
    );
  }

  int getMaxAmmo(BattleSimulation simulation) {
    return getBuffValueOfTypes(
      simulation,
      [FunctionType.statAmmoLoad, FunctionType.statAmmo],
      currentWeaponData.maxAmmo,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.maxAmmo : 0,
    );
  }

  int getChargeDamageBuffValues(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statChargeDamage,
      0,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.fullChargeDamage : 0,
    );
  }

  int getCoreDamageBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.coreShotDamageChange);
  }

  int getNormalDamageRatioChangeBuffValues(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.normalDamageRatioChange,
      0,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.damage : 0,
    );
  }

  int getFramesToFullCharge(BattleSimulation simulation) {
    final result = getBuffValue(
      simulation,
      FunctionType.statChargeTime,
      currentWeaponData.chargeTime,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.chargeTime : 0,
    );
    return max(1, BattleUtils.timeDataToFrame(result, fps) - 1);
  }

  int getTimeToReload(BattleSimulation simulation) {
    final result = getBuffValue(
      simulation,
      FunctionType.statReloadTime,
      currentWeaponData.reloadTime,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.reloadTime : 0,
    );
    return max(1, result + currentWeaponData.spotLastDelay);
  }

  int getBurstGen(BattleSimulation simulation, bool isTarget) {
    return getBuffValue(
      simulation,
      FunctionType.firstBurstGaugeSpeedUp,
      isTarget ? currentWeaponData.targetBurstEnergyPerShot : currentWeaponData.burstEnergyPerShot,
      (entity) =>
          entity is BattleNikke
              ? isTarget
                  ? entity.currentWeaponData.targetBurstEnergyPerShot
                  : entity.currentWeaponData.burstEnergyPerShot
              : 0,
    );
  }

  int getPartsDamageBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.partsDamage);
  }

  int getPierceDamageBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.penetrationDamage);
  }

  int getShareDamageBuffValues(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.shareDamageIncrease);
  }

  int getPierce(BattleSimulation simulation) {
    return currentWeaponData.penetration + getPlainBuffValues(simulation, FunctionType.statPenetration);
  }

  int getBreakDamageBuff(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.breakDamage);
  }
}
