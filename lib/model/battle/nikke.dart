import 'dart:math';

import 'package:collection/collection.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/battle_skill.dart';
import 'package:nikke_einkk/model/battle/events/battle_event.dart';
import 'package:nikke_einkk/model/battle/events/burst_gen_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_damage_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_fire_event.dart';
import 'package:nikke_einkk/model/battle/events/nikke_reload_event.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';
import 'package:nikke_einkk/model/user_data.dart';

enum BattleNikkeStatus { behindCover, reloading, forceReloading, shooting, stunned }

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

class BattleDecoy extends BattleEntity {
  @override
  String get name => 'Decoy';

  @override
  int baseHp;

  @override
  int get baseAttack => 0;

  @override
  int baseDefence;

  BattleDecoy(this.baseHp, this.baseDefence) {
    init();
  }

  void init() {
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
  WeaponType get baseWeaponType => baseWeaponData.weaponType;
  // skill data
  NikkeClass get nikkeClass => characterData.characterClass;
  Corporation get corporation => characterData.corporation;
  @override
  Set<NikkeElement> get baseElements => characterData.elementId.map(NikkeElement.fromId).toSet();

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
  BattleDecoy? decoy;
  int _currentAmmo = 0;
  int? changeWeaponAmmo;
  set currentAmmo(int value) {
    if (changeWeaponAmmo == null) {
      _currentAmmo = value;
    } else {
      changeWeaponAmmo = value;
    }
  }

  int get currentAmmo => changeWeaponAmmo ?? _currentAmmo;

  WeaponType get currentWeaponType => currentWeaponData.weaponType;
  WeaponData get currentWeaponData => changeWeaponData ?? baseWeaponData;
  int changeWeaponDuration = 0;
  WeaponData? changeWeaponData;
  SkillData? changeWeaponSkill;

  // TODO: this encapsulates ranges so don't need to clamp on every change, but it's boiler plate ish
  // a lot of frame counters have min value 0,
  /// this is without buff, so internal tracking only
  int _baseAccCircleScale = 0;
  int get baseAccCircleScale => _baseAccCircleScale;
  set baseAccCircleScale(int newScale) =>
      _baseAccCircleScale = newScale.clamp(
        currentWeaponData.endAccuracyCircleScale,
        currentWeaponData.startAccuracyCircleScale,
      );

  int rateOfFire = 0;

  int fullReloadFrameCount = 0;

  // these start with 0 (+= 1 each frame)
  int reloadingFrameCount = 0; // reason for += 1: fullReloadFrameCount is calculated as max at first reload frame
  int chargeFrames = 0;
  int previousFullChargeFrameCount = 0;
  int maintainFireStanceFrameCount = 0;

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
  int totalBurstSkillUsed = 0;
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
    baseAccCircleScale = baseWeaponData.startAccuracyCircleScale;
    rateOfFire = baseWeaponData.rateOfFire;
    chargeFrames = 0;
    previousFullChargeFrameCount = 0;
    shootCountdown = 0;
    spotLastDelayFrameCount = 0;
    spotFirstDelayFrameCount = timeDataToFrame(baseWeaponData.spotFirstDelay, fps);
    maintainFireStanceFrameCount = 0;
    reloadingFrameCount = 0;
    fullReloadFrameCount = 0;
    currentHp = baseHp;
    currentAmmo = baseWeaponData.maxAmmo;
    cover.uniqueId = position + 5;
    cover.init(simulation);
    barriers.clear();
    decoy = null;

    totalBulletsFired = 0;
    totalFullChargeFired = 0;
    totalBulletsHit = 0;
    activatedBurstSkillThisCycle = false;
    totalBurstSkillUsed = 0;
    functions.clear();
    buffs.clear();
    funcRatioTracker.clear();
    skills.clear();

    changeWeaponDuration = 0;
    changeWeaponData = null;
    changeWeaponSkill = null;

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
      case BattleNikkeStatus.stunned:
        break;
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

    if (changeWeaponSkill != null && changeWeaponSkill!.durationType.isTimed) {
      changeWeaponDuration -= 1;
    }

    for (final barrier in barriers) {
      if (barrier.durationType.isTimed) {
        barrier.duration -= 1;
      }
    }

    //   for (final buff in buffs) {
    //     final data = buff.data;
    //     if (data.functionType == FunctionType.healBarrier && data.durationType.isDurationBuff) {
    //       final activeFrame = data.durationValue > 0 && (buff.fullDuration - buff.duration) % simulation.fps == 0;
    //       if (activeFrame && barriers.isNotEmpty) {
    //         int healValue = 0;
    //         if (data.functionValueType == ValueType.integer) {
    //           healValue = data.functionValue;
    //         } else if (data.functionValueType == ValueType.percent) {
    //           final functionStandard = simulation.getEntityById(buff.getFunctionStandardId());
    //           final changeValue = toModifier(data.functionValue) * (functionStandard?.getMaxHp(simulation) ?? 0);
    //           healValue = changeValue.round();
    //         }
    //         final finalHeal = healValue;
    //         for (final barrier in barriers) {
    //           if (barrier.hp > 0) {
    //             barrier.hp = (barrier.hp + finalHeal.round()).clamp(1, barrier.maxHp);
    //           }
    //         }
    //       }
    //     }
    //   }
  }

  void processBehindCoverStatus(BattleSimulation simulation) {
    // reset this when entering a non-shooting status
    spotFirstDelayFrameCount = timeDataToFrame(currentWeaponData.spotFirstDelay, fps);
    maintainFireStanceFrameCount = 0;
    chargeFrames = 0;
    spotLastDelayFrameCount -= 1;
    if (shootCountdown > 0) {
      shootCountdown -= getRateOfFire(simulation);
    }
    if (currentWeaponData.accuracyChangeSpeed != 0) {
      // reset accuracy
      baseAccCircleScale += (currentWeaponData.accuracyChangeSpeed / fps).round();
    }
    if (currentWeaponData.rateOfFireResetTime != 0) {
      final endRateOfFire = getEndRateOfFire(simulation);
      final startRateOfFire = getStartRateOfFire(simulation);
      final resetChangePerFrame = (endRateOfFire - startRateOfFire) / currentWeaponData.rateOfFireResetTime;
      rateOfFire -= resetChangePerFrame.round();
    }
  }

  void processReloadingStatus(BattleSimulation simulation) {
    if (reloadingFrameCount == 0) {
      // this means this is the first frame of reloading
      // need to calculate how many frames needed to do one reload
      int baseReloadTimeData = getTimeToReload(simulation);

      fullReloadFrameCount = max(timeDataToFrame(baseReloadTimeData, fps), 1);

      simulation.registerEvent(simulation.currentFrame, NikkeReloadStartEvent(uniqueId, fullReloadFrameCount));
    }

    reloadingFrameCount += 1;
    if (reloadingFrameCount >= fullReloadFrameCount) {
      final reloadRatio = toModifier(max(1, getReloadBulletRatio(simulation))); // ensure no empty reloads
      final maxAmmo = getMaxAmmo(simulation);
      currentAmmo = min(maxAmmo, currentAmmo + (reloadRatio * maxAmmo).round());
      reloadingFrameCount = 0;

      if (currentAmmo == maxAmmo) {
        fullReloadFrameCount = 0;
        simulation.registerEvent(simulation.currentFrame, NikkeReloadEndEvent(uniqueId));
      }
    }
  }

  void processShootingStatus(BattleSimulation simulation) {
    if (shootCountdown > 0) {
      shootCountdown -= getRateOfFire(simulation);
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

    if (maintainFireStanceFrameCount > 0) {
      maintainFireStanceFrameCount -= 1;
      if (maintainFireStanceFrameCount == 0 && WeaponType.chargeWeaponTypes.contains(currentWeaponType)) {
        previousFullChargeFrameCount = getFramesToFullCharge(simulation);
        chargeFrames = 1; // charge weapons seem to start with one frame of charge at the last frame of this animation
      }
      return;
    }

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
          NikkeFireEvent(uniqueId, currentAmmo: currentAmmo, maxAmmo: getMaxAmmo(simulation), isFullCharge: false),
        );
        if (currentWeaponData.fireType == FireType.instant) {
          generateDamageAndBurstEvents(simulation, simulation.currentFrame, target);
        }

      case WeaponType.rl:
      case WeaponType.sr:
        final framesToFullCharge = getFramesToFullCharge(simulation);
        if (previousFullChargeFrameCount <= 0) {
          previousFullChargeFrameCount = framesToFullCharge;
        }
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

        if (simulation.burstStage == 4 && simulation.burstStageFramesLeft < framesToFullCharge) {
          return;
        }

        if (currentWeaponData.inputType == InputType.downCharge && shootCountdown > 0) {
          return;
        }

        if (currentWeaponData.fireType == FireType.instant) {
          simulation.registerEvent(
            simulation.currentFrame,
            NikkeFireEvent(
              uniqueId,
              currentAmmo: currentAmmo,
              maxAmmo: getMaxAmmo(simulation),
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
          FireType.stickyProjectileDirect,
        ].contains(currentWeaponData.fireType)) {
          final projectileCreateFrame = timeDataToFrame(
            currentWeaponData.maintainFireStance * toModifier(currentWeaponData.upTypeFireTiming),
            fps,
          );

          final fireFrame = simulation.currentFrame - projectileCreateFrame.round();
          if (fireFrame > 0) {
            simulation.registerEvent(
              fireFrame,
              NikkeFireEvent(
                uniqueId,
                currentAmmo: currentAmmo,
                maxAmmo: getMaxAmmo(simulation),
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

          chargeFrames = 0;
        }

        // this is essentially shooting frame for SR & RL
        if (currentWeaponData.inputType == InputType.up) {
          if (currentWeaponData.maintainFireStance > 0) {
            // TODO: A2 has 9 extra frames, maybe due to animation but not sure
            maintainFireStanceFrameCount = timeDataToFrame(
              currentWeaponData.spotFirstDelay + currentWeaponData.maintainFireStance,
              fps,
            );
          } else {
            spotLastDelayFrameCount =
                option.forceCancelShootDelay ? 0 : timeDataToFrame(currentWeaponData.spotLastDelay, fps);
            // necessary for quick scope
            spotFirstDelayFrameCount = timeDataToFrame(currentWeaponData.spotFirstDelay, fps);
          }
        } else if (currentWeaponData.inputType == InputType.downCharge ||
            currentWeaponData.inputType == InputType.down) {
          while (shootCountdown <= 0) {
            shootCountdown += shootThreshold;
          }
        }

      case WeaponType.unknown:
      case WeaponType.none:
        // TODO: probably log?
        return;
    }

    if (currentWeaponData.accuracyChangePerShot > 0) {
      baseAccCircleScale -= currentWeaponData.accuracyChangePerShot;
    }

    final changePerShot = getRateOfFireChangePerShot(simulation);
    if (changePerShot > 0) {
      final endRateOfFire = getEndRateOfFire(simulation);
      final startRateOfFire = getStartRateOfFire(simulation);
      rateOfFire = (rateOfFire + changePerShot).clamp(startRateOfFire, endRateOfFire);
    }
  }

  void generateDamageAndBurstEvents(BattleSimulation simulation, int frame, BattleRapture target) {
    simulation.registerEvent(
      simulation.currentFrame,
      NikkeDamageEvent.bullet(simulation: simulation, nikke: this, rapture: target),
    );
    if (simulation.burstStage == 0) {
      simulation.registerEvent(simulation.currentFrame, BurstGenerationEvent.bullet(simulation, this, target));
    }
    if (getPierce(simulation) > 0) {
      for (final part in target.parts) {
        if (part.hp > 0) {
          simulation.registerEvent(
            simulation.currentFrame,
            NikkeDamageEvent.piercePart(simulation: simulation, nikke: this, rapture: target, part: part),
          );
          if (simulation.burstStage == 0) {
            simulation.registerEvent(simulation.currentFrame, BurstGenerationEvent.bullet(simulation, this, target));
          }
        }
      }
    }
  }

  void determineStatus(BattleSimulation simulation) {
    if (hasBuff(simulation, FunctionType.stun) && !hasBuff(simulation, FunctionType.immuneStun)) {
      status = BattleNikkeStatus.stunned;
      return;
    }
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
    event.processNikke(simulation, this);

    for (final function in functions) {
      function.broadcast(event, simulation);
    }
  }

  void resetWeaponParams(BattleSimulation simulation, bool equipNew) {
    final maxAmmo = getMaxAmmo(simulation);
    if (equipNew) {
      changeWeaponAmmo = maxAmmo;
    } else if (changeWeaponAmmo != null) {
      _currentAmmo = max(_currentAmmo, changeWeaponAmmo!);
      changeWeaponAmmo = null;
    }
    chargeFrames = 0;
    previousFullChargeFrameCount = 0;
    baseAccCircleScale = currentWeaponData.startAccuracyCircleScale;
    shootCountdown = 0;
    reloadingFrameCount = 0;
    fullReloadFrameCount = 0;
  }

  @override
  void endCurrentFrame(BattleSimulation simulation) {
    barriers.removeWhere((barrier) => barrier.hp <= 0 || barrier.duration == 0);

    if (changeWeaponDuration <= 0 && changeWeaponData != null) {
      changeWeaponSkill = null;
      changeWeaponData = null;

      resetWeaponParams(simulation, false);
    }
    if (hasBuff(simulation, FunctionType.allAmmo)) {
      currentAmmo = getMaxAmmo(simulation);
    }

    // gainAmmo is put here because max ammo can change in this frame
    final gainAmmo = getBuffValue(
      simulation,
      FunctionType.gainAmmo,
      0,
      (nikke) => nikke is BattleNikke ? nikke.getMaxAmmo(simulation) : 0,
    );
    currentAmmo = (currentAmmo + gainAmmo).clamp(0, getMaxAmmo(simulation));

    for (int skillIndex = 0; skillIndex < 3; skillIndex++) {
      final skill = skills[skillIndex];
      final changeCdType =
          [
            FunctionType.changeCoolTimeSkill1,
            FunctionType.changeCoolTimeSkill2,
            FunctionType.changeCoolTimeUlti,
          ][skillIndex];
      final immuneType = [null, null, FunctionType.immuneChangeCoolTimeUlti][skillIndex];
      if (immuneType != null && hasBuff(simulation, immuneType)) {
        continue;
      }
      final cdReduceTimeData = getBuffValue(
        simulation,
        changeCdType,
        0,
        (nikke) => nikke is BattleNikke ? nikke.getSkillCoolTime(simulation, skillIndex) : 0,
      );
      skill.changeCd(simulation, cdReduceTimeData);
    }

    super.endCurrentFrame(simulation);

    currentAmmo = currentAmmo.clamp(0, getMaxAmmo(simulation));
  }

  int getSkillCoolTime(BattleSimulation simulation, int skillIndex) {
    final maxCoolChangeFuncType =
        [
          FunctionType.changeMaxSkillCoolTime1,
          FunctionType.changeMaxSkillCoolTime2,
          FunctionType.changeMaxSkillCoolTimeUlti,
        ][skillIndex];

    final maxCoolChange = getBuffValue(
      simulation,
      maxCoolChangeFuncType,
      0,
      (nikke) => nikke is BattleNikke ? nikke.skills[skillIndex].skillData?.skillCooltime ?? 0 : 0,
    );

    return (skills[skillIndex].skillData?.skillCooltime ?? 0) - maxCoolChange;
  }

  int getFramesToFullCharge(BattleSimulation simulation) {
    final result = getBuffValue(
      simulation,
      FunctionType.statChargeTime,
      currentWeaponData.chargeTime,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.chargeTime : 0,
    );
    return max(1, timeDataToFrame(result, fps));
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
      baseAccCircleScale,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.startAccuracyCircleScale : 0,
    );
  }

  int getRateOfFire(BattleSimulation simulation) {
    final endRateOfFire = getEndRateOfFire(simulation);
    final startRateOfFire = getStartRateOfFire(simulation);
    rateOfFire = rateOfFire.clamp(startRateOfFire, endRateOfFire);
    return rateOfFire;
  }

  int getRateOfFireChangePerShot(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statRateOfFirePerShot,
      currentWeaponData.rateOfFireChangePerShot,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.rateOfFireChangePerShot : 0,
    );
  }

  int getStartRateOfFire(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statRateOfFire,
      currentWeaponData.rateOfFire,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.rateOfFire : 0,
    );
  }

  int getEndRateOfFire(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statEndRateOfFire,
      currentWeaponData.endRateOfFire,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.endRateOfFire : 0,
    );
  }

  int getReloadBulletRatio(BattleSimulation simulation) {
    final result = getBuffValue(
      simulation,
      FunctionType.statReloadBulletRatio,
      currentWeaponData.reloadBullet,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.reloadBullet : 0,
    );
    return result.clamp(0, 10000);
  }

  int getMaxAmmo(BattleSimulation simulation) {
    final result = getBuffValueOfTypes(
      simulation,
      [FunctionType.statAmmoLoad, FunctionType.statAmmo],
      currentWeaponData.maxAmmo,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.maxAmmo : 0,
    );

    return max(1, result);
  }

  int getChargeDamageBuffValues(BattleSimulation simulation) {
    int result = getBuffValue(
      simulation,
      FunctionType.statChargeDamage,
      0,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.fullChargeDamage : 0,
    );

    // plain buff since it's always integer
    final changePerAmmo = getPlainBuffValues(simulation, FunctionType.chargeDamageChangeMaxStatAmmo);
    if (changePerAmmo != 0) {
      result += changePerAmmo * getMaxAmmo(simulation);
    }

    final chargeTime = currentWeaponData.chargeTime;
    final changePerExceedChargeSpeed = getPlainBuffValues(simulation, FunctionType.chargeTimeChangetoDamage);
    if (chargeTime > 0 && changePerExceedChargeSpeed != 0) {
      final timeToFullCharge = getBuffValue(
        simulation,
        FunctionType.statChargeTime,
        chargeTime,
        (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.chargeTime : 0,
      );
      final exceedChargeSpeed = timeToFullCharge < 0 ? timeToFullCharge.abs() / chargeTime * 10000 : 0;
      result += (toModifier(changePerExceedChargeSpeed) * exceedChargeSpeed).round();
    }

    return result;
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

  int getTimeToReload(BattleSimulation simulation) {
    if (hasBuff(simulation, FunctionType.fixStatReloadTime)) {
      final result = getBuffValue(
        simulation,
        FunctionType.fixStatReloadTime,
        currentWeaponData.reloadTime,
        (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.reloadTime : 0,
      );
      return max(1, result + (fullReloadFrameCount == 0 ? currentWeaponData.spotLastDelay : 0));
    }

    final result = getBuffValue(
      simulation,
      FunctionType.statReloadTime,
      currentWeaponData.reloadTime,
      (nikke) => nikke is BattleNikke ? nikke.currentWeaponData.reloadTime : 0,
    );
    return max(1, result + (fullReloadFrameCount == 0 ? currentWeaponData.spotLastDelay : 0));
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

  void takeDamage(BattleSimulation simulation, int damage, bool hitCover) {
    final selfBarrier = barriers.firstWhereOrNull((barrier) => barrier.hp > 0);
    if (selfBarrier != null) {
      selfBarrier.hp -= damage;
    } else {
      final entity =
          (decoy?.currentHp ?? 0) > 0
              ? decoy!
              : hitCover && cover.currentHp > 0
              ? cover
              : this;
      entity.changeHp(simulation, -damage);
    }
  }

  BurstStep getUseBurstSkill(BattleSimulation simulation) {
    final changeBuffVal = getFirstPlainBuffValues(simulation, FunctionType.changeUseBurstSkill);
    return BurstStep.fromStep(changeBuffVal) ?? characterData.useBurstSkill;
  }

  BurstStep getChangeBurstStep(BattleSimulation simulation) {
    final changeBuffVal = getFirstPlainBuffValues(simulation, FunctionType.changeChangeBurstStep);
    return BurstStep.fromStep(changeBuffVal) ?? characterData.changeBurstStep;
  }

  int getExplosiveCircuitAccumulationRatio(BattleSimulation simulation) {
    return getPlainBuffValues(simulation, FunctionType.explosiveCircuitAccrueDamageRatio);
  }

  int getBurstDuration(BattleSimulation simulation) {
    return characterData.burstDuration + getPlainBuffValues(simulation, FunctionType.incBurstDuration);
  }
}
