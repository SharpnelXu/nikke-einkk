import 'dart:math';

import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/battle_skill.dart';
import 'package:nikke_einkk/model/battle/buff.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/skills.dart';

class BattleNikkeOptions {
  int nikkeResourceId;
  int coreLevel;
  int syncLevel;
  int attractLevel;
  List<BattleEquipment> equips;
  List<int> skillLevels;
  // cube
  // doll

  BattleNikkeOptions({
    required this.nikkeResourceId,
    this.coreLevel = 1,
    this.syncLevel = 1,
    this.attractLevel = 1,
    this.equips = const [],
    this.skillLevels = const [10, 10, 10],
  });
}

enum BattleNikkeStatus { behindCover, reloading, forceReloading, shooting }

class BattleNikke {
  BattlePlayerOptions playerOptions;
  BattleNikkeOptions option;

  int fps = 60;

  NikkeCharacterData get characterData =>
      gameData.characterResourceGardeTable[option.nikkeResourceId]![option.coreLevel]!;
  String get name => gameData.getTranslation(characterData.nameLocalkey)?.zhCN ?? characterData.resourceId.toString();
  WeaponSkillData get baseWeaponData => gameData.characterShotTable[characterData.shotId]!;
  // skill data
  NikkeClass get nikkeClass => characterData.characterClass;
  Corporation get corporation => characterData.corporation;
  Element get element => Element.fromId(characterData.elementId.first);

  int get coreLevel => characterData.gradeCoreId;

  CharacterStatData get baseStat =>
      gameData.groupedCharacterStatTable[characterData.statEnhanceId]?[option.syncLevel] ?? CharacterStatData.emptyData;
  CharacterStatEnhanceData get statEnhanceData =>
      gameData.characterStatEnhanceTable[characterData.statEnhanceId] ?? CharacterStatEnhanceData.emptyData;
  ClassAttractiveStatData get attractiveStat =>
      gameData.attractiveStatTable[option.attractLevel]?.getStatData(nikkeClass) ?? ClassAttractiveStatData.emptyData;

  int get baseHp => getBaseStat(
    baseStat: baseStat.hp,
    gradeEnhanceBase: statEnhanceData.gradeHp,
    coreEnhanceBaseRatio: statEnhanceData.coreHp,
    consoleStat: playerOptions.getRecycleHp(nikkeClass),
    bondStat: attractiveStat.hpRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.hp, corporation)),
  );

  int get baseAttack => getBaseStat(
    baseStat: baseStat.attack,
    gradeEnhanceBase: statEnhanceData.gradeAttack,
    coreEnhanceBaseRatio: statEnhanceData.coreAttack,
    consoleStat: playerOptions.getRecycleAttack(corporation),
    bondStat: attractiveStat.attackRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.atk, corporation)),
  );

  int get baseDefence => getBaseStat(
    baseStat: baseStat.defence,
    gradeEnhanceBase: statEnhanceData.gradeDefence,
    coreEnhanceBaseRatio: statEnhanceData.coreDefence,
    consoleStat: playerOptions.getRecycleDefence(nikkeClass, corporation),
    bondStat: attractiveStat.defenceRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.defence, corporation)),
  );

  int position = 0;
  int currentHp = 0;
  // coverBaseHp
  // coverCurrentHp
  int currentAmmo = 0;

  WeaponType get currentWeaponType => currentWeaponData.weaponType;
  WeaponSkillData get currentWeaponData => baseWeaponData;

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
  int get framesToFullCharge => BattleUtils.timeDataToFrame(currentWeaponData.chargeTime, fps);

  // these start with 0 (+= 1 each frame)
  int reloadingFrameCount = 0; // reason for += 1: fullReloadFrameCount is calculated as max at first reload frame
  int chargeFrames = 0;

  // TODO: min value 0?
  // these starts with max (-= 1 each frame)
  int spotFirstDelayFrameCount = 0;
  int spotLastDelayFrameCount = 0; // after charge attack force back to cover
  int shootingFrameCount = 0;

  int totalBulletsFired = 0;
  int totalBulletsHit = 0;

  BattleNikkeStatus status = BattleNikkeStatus.behindCover;

  List<BattleSkill> skills = [];
  List<BattleFunction> functions = [];
  List<BattleBuff> buffs = [];

  BattleNikke({required this.playerOptions, required this.option});

  // CharacterStatTable[statEnhanceId = groupId][lv] to get baseStat
  // CharacterStateEnhanceTable[statEnhanceId = id] to get gradeEnhanceStat
  // grade is [1, 4]
  // gradeStat = baseStat * gradeRatio (usually 2%) * (grade - 1) + gradeStat * (grade - 1)
  // MLBStat = baseStat + gradeStat
  // core is [1, 7]
  // coreStat = (MLBStat (which is gradeStat + baseStat) + bond stat + console stat) * coreRatio (2%)
  // finalStat = baseStat + gradeStat + coreStat + bondStat + consoleStat + cubeStat + gearStat + dollStat
  // However, it is unclear if this value is stored as int or double
  int getBaseStat({
    required int baseStat,
    required int gradeEnhanceBase,
    required int coreEnhanceBaseRatio,
    required int consoleStat,
    required int bondStat,
    required num equipStat,
  }) {
    final gradeLevel = min(4, coreLevel) - 1;
    final gradeStat =
        baseStat * gradeLevel * BattleUtils.toModifier(statEnhanceData.gradeRatio) + gradeLevel * gradeEnhanceBase;

    final coreStat =
        coreLevel > 4
            ? (baseStat + gradeStat + consoleStat + bondStat) *
                (coreLevel - 4) *
                BattleUtils.toModifier(coreEnhanceBaseRatio)
            : 0;

    return (baseStat + gradeStat + coreStat + consoleStat + bondStat + equipStat).round();
  }

  void init(BattleSimulation simulation, int position) {
    this.position = position;
    fps = simulation.fps;
    _accuracyCircleScale = baseWeaponData.startAccuracyCircleScale;
    rateOfFire = baseWeaponData.rateOfFire;
    chargeFrames = 0;
    shootingFrameCount = 0;
    spotLastDelayFrameCount = 0;
    spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(baseWeaponData.spotFirstDelay, fps);
    reloadingFrameCount = 0;
    fullReloadFrameCount = 0;

    totalBulletsFired = 0;
    totalBulletsHit = 0;
    functions.clear();
    buffs.clear();
    skills.clear();

    skills.add(BattleSkill(characterData.skill1Id, characterData.skill1Table, option.skillLevels[0], false));
    skills.add(BattleSkill(characterData.skill2Id, characterData.skill2Table, option.skillLevels[1], false));
    skills.add(BattleSkill(characterData.ultiSkillId, SkillType.characterSkill, option.skillLevels[2], true));

    for (final skill in skills) {
      skill.init(simulation, this);
    }
  }

  void startBattle(BattleSimulation simulation) {
    currentHp = baseHp;
    currentAmmo = getMaxAmmo(simulation);
  }

  void normalAction(BattleSimulation simulation) {
    determineStatus(simulation);

    switch (status) {
      case BattleNikkeStatus.behindCover:
        processBehindCoverStatus(simulation);
        break;
      case BattleNikkeStatus.reloading:
      case BattleNikkeStatus.forceReloading:
        processReloadingStatus(simulation);
        break;
      case BattleNikkeStatus.shooting:
        processShootingStatus(simulation);
        break;
    }

    for (final buff in buffs) {
      if (buff.data.durationType == DurationType.timeSec && buff.isActive(simulation)) {
        buff.duration -= 1;
      }
    }
  }

  void processBehindCoverStatus(BattleSimulation simulation) {
    // reset this when entering a non-shooting status
    spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(currentWeaponData.spotFirstDelay, fps);
    chargeFrames = 0;

    spotLastDelayFrameCount -= 1;
    shootingFrameCount -= 1;
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
    // reset this when entering a non-shooting status
    spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(currentWeaponData.spotFirstDelay, fps);
    chargeFrames = 0;

    spotLastDelayFrameCount -= 1;

    if (reloadingFrameCount == 0) {
      // this means this is the first frame of reloading
      // need to calculate how many frames needed to do one reload
      num baseReloadTimeData = currentWeaponData.reloadTime + currentWeaponData.spotLastDelay;
      // if (position == 1) {
      //   final savedTimeData = currentWeaponData.reloadTime * BattleUtils.toModifier(2969);
      //   baseReloadTimeData -= savedTimeData;
      // }

      fullReloadFrameCount = BattleUtils.timeDataToFrame(baseReloadTimeData, fps);

      simulation.registerEvent(
        simulation.currentFrame,
        NikkeReloadStartEvent(
          name: name,
          reloadTimeData: baseReloadTimeData,
          reloadFrames: fullReloadFrameCount,
          ownerPosition: position,
        ),
      );
    }

    reloadingFrameCount += 1;
    if (reloadingFrameCount >= fullReloadFrameCount) {
      final reloadRatio = BattleUtils.toModifier(currentWeaponData.reloadBullet);
      currentAmmo += (reloadRatio * getMaxAmmo(simulation)).round();
      reloadingFrameCount = 0;
    }

    // these rests should probably happen in other status as well
    if (currentWeaponData.accuracyChangeSpeed != 0) {
      // reset accuracy
      _accuracyCircleScale += (currentWeaponData.accuracyChangeSpeed / fps).round();
    }
    if (currentWeaponData.rateOfFireResetTime != 0) {
      rateOfFire -=
          ((currentWeaponData.endRateOfFire - currentWeaponData.rateOfFire) / currentWeaponData.rateOfFireResetTime)
              .round();
    }
    // also reset shooting time well in reloading? or maybe for all possible status?
    shootingFrameCount -= 1;
  }

  void processShootingStatus(BattleSimulation simulation) {
    shootingFrameCount -= 1;
    // before shooting need to go outside cover first, not sure if this should be its own status tho
    if (spotFirstDelayFrameCount > 0) {
      spotFirstDelayFrameCount -= 1;
      return;
    }

    final target = simulation.raptures.where((rapture) => canTarget(rapture)).firstOrNull;
    if (target == null) return;

    switch (currentWeaponType) {
      case WeaponType.ar:
      case WeaponType.smg:
      case WeaponType.mg:
      case WeaponType.sg:
        if (shootingFrameCount > 0) {
          return;
        }

        // if (totalBulletsFired % 10 == 0 && position == 2) {
        //   currentAmmo += 3;
        //   currentAmmo = min(maxAmmo, currentAmmo);
        // }

        simulation.registerEvent(
          simulation.currentFrame,
          NikkeFireEvent(
            name: name,
            currentAmmo: currentAmmo,
            maxAmmo: getMaxAmmo(simulation),
            ownerPosition: position,
          ),
        );
        if (currentWeaponData.fireType == FireType.instant) {
          simulation.registerEvent(
            simulation.currentFrame,
            NikkeDamageEvent(simulation: simulation, nikke: this, rapture: target, type: NikkeDamageType.bullet),
          );
          simulation.registerEvent(
            simulation.currentFrame,
            BurstGenerationEvent(simulation: simulation, nikke: this, rapture: target),
          );
        }

        // rateOfFire 90 = shoot 90 bullets per minute, so time data per bullet is 6000 / 90 = 66.66 (0.6666 second)
        shootingFrameCount = BattleUtils.timeDataToFrame(60 * 100 / rateOfFire, fps);
        shootingFrameCount = max(shootingFrameCount, 1); // minimum 1 frame cooldown

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
        if (chargeFrames < framesToFullCharge) {
          chargeFrames += 1;
          return;
        }

        if (currentWeaponData.fireType == FireType.instant) {
          simulation.registerEvent(
            simulation.currentFrame,
            NikkeDamageEvent(simulation: simulation, nikke: this, rapture: target, type: NikkeDamageType.bullet),
          );
          simulation.registerEvent(
            simulation.currentFrame,
            BurstGenerationEvent(simulation: simulation, nikke: this, rapture: target),
          );

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
                ownerPosition: position,
              ),
            );
          }

          // wild guess here
          final projectileTravelFrame = target.distance * 100 / currentWeaponData.spotProjectileSpeed;
          // + 1 since this is the first frame and frame counts down
          final damageFrame = fireFrame - projectileTravelFrame.round();

          if (damageFrame > 0) {
            // TODO: fill in defender buffs on hit rather now
            simulation.registerEvent(
              damageFrame,
              NikkeDamageEvent(simulation: simulation, nikke: this, rapture: target, type: NikkeDamageType.bullet),
            );
            simulation.registerEvent(
              damageFrame,
              BurstGenerationEvent(simulation: simulation, nikke: this, rapture: target),
            );
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
          spotLastDelayFrameCount = BattleUtils.timeDataToFrame(currentWeaponData.spotLastDelay, fps);
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

  void determineStatus(BattleSimulation simulation) {
    if (status == BattleNikkeStatus.forceReloading && currentAmmo != getMaxAmmo(simulation)) return;

    final target = simulation.raptures.where((rapture) => canTarget(rapture)).firstOrNull;

    // forcing cover, or no autoAttack, or no target
    if (simulation.useCover || (position == simulation.currentNikke && !simulation.autoAttack) || target == null) {
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
    return rapture.canBeTargeted ||
        currentWeaponData.preferTargetCondition == PreferTargetCondition.includeNoneTargetNone;
  }

  void broadcast(BattleEvent event, BattleSimulation simulation) {
    if (event is NikkeFireEvent && event.ownerPosition == position) {
      currentAmmo -= 1;
      totalBulletsFired += 1;

      for (final buff in buffs) {
        if (buff.data.durationType == DurationType.shots && buff.isActive(simulation)) {
          buff.duration -= 1;
        }
      }
    }

    if (event is NikkeDamageEvent && event.attackerPosition == position) {
      processDamageEvent(event, simulation);
    }

    for (final function in functions) {
      function.broadcast(event, simulation);
    }
  }

  void processDamageEvent(NikkeDamageEvent event, BattleSimulation simulation) {
    if (event.type != NikkeDamageType.bullet) return;

    final rapture = simulation.getRaptureByUniqueId(event.targetUniqueId);
    if (rapture == null) return;

    totalBulletsHit += 1;
  }

  // maybe change to a dedicated return structure to show which nikke gives which buffs
  int getAttackBuffValues(BattleSimulation simulation) {
    return getBuffValue(simulation, FunctionType.statAtk, 0, (nikke) => nikke.baseAttack);
  }

  int getIncreaseElementDamageBuffValues(BattleSimulation simulation) {
    int result = 0;
    for (final buff in buffs) {
      if (buff.data.functionType != FunctionType.incElementDmg || !buff.isActive(simulation)) continue;
      // all valueType is percent
      // not sure if function standard does anything here, coule be the base ele rate is 10000 for all in data
      result += buff.data.functionValue * buff.count;
    }

    return result;
  }

  int getAccuracyCircleScale(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statAccuracyCircle,
      _accuracyCircleScale,
      (nikke) => nikke.currentWeaponData.startAccuracyCircleScale,
    );
  }

  int getMaxAmmo(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statAmmoLoad,
      currentWeaponData.maxAmmo,
      (nikke) => nikke.currentWeaponData.maxAmmo,
    );
  }

  int getChargeDamageBuffs(BattleSimulation simulation) {
    return getBuffValue(
      simulation,
      FunctionType.statChargeDamage,
      0,
      (nikke) => nikke.currentWeaponData.fullChargeDamage,
    );
  }

  int getBuffValue(
    BattleSimulation simulation,
    FunctionType type,
    int baseValue,
    int Function(BattleNikke) getStandardBaseValue,
  ) {
    // position to percentValues
    final Map<int, int> percents = {};

    int flatValue = 0;
    for (final buff in buffs) {
      if (buff.data.functionType != type || !buff.isActive(simulation)) continue;

      if (buff.data.functionValueType == ValueType.percent) {
        final standardPosition = buff.getFunctionStandardTargetPosition(simulation);
        if (standardPosition != -1) {
          percents.putIfAbsent(standardPosition, () => 0);
          percents[standardPosition] = percents[standardPosition]! + buff.data.functionValue * buff.count;
        }
      } else if (buff.data.functionValueType == ValueType.integer) {
        flatValue += buff.data.functionValue;
      }
    }

    int result = baseValue + flatValue;
    for (final standardPosition in percents.keys) {
      final standard = simulation.getNikkeOnPosition(standardPosition)!;
      result += (getStandardBaseValue(standard) * BattleUtils.toModifier(percents[standardPosition]!)).round();
    }

    return result;
  }
}
