import 'dart:math';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/barrier.dart';
import 'package:nikke_einkk/model/battle/battle_entity.dart';
import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/battle_skill.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/favorite_item.dart';
import 'package:nikke_einkk/model/battle/function.dart';
import 'package:nikke_einkk/model/battle/harmony_cube.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/model/skills.dart';

part '../../generated/model/battle/nikke.g.dart';

@JsonSerializable()
class BattleNikkeOptions {
  int nikkeResourceId;
  int coreLevel;
  int syncLevel;
  int attractLevel;
  List<BattleEquipment?> equips;
  List<int> skillLevels;
  BattleHarmonyCube? cube;
  BattleFavoriteItem? favoriteItem;

  bool alwaysFocus;
  bool forceCancelShootDelay;
  NikkeFullChargeMode chargeMode;

  BattleNikkeOptions({
    required this.nikkeResourceId,
    this.coreLevel = 1,
    this.syncLevel = 1,
    this.attractLevel = 1,
    List<BattleEquipment?> equips = const [null, null, null, null],
    List<int> skillLevels = const [10, 10, 10],
    this.cube,
    this.favoriteItem,
    this.alwaysFocus = false,
    this.forceCancelShootDelay = false,
    this.chargeMode = NikkeFullChargeMode.always,
  }) : equips = equips.toList(),
       skillLevels = skillLevels.toList() {
    final favoriteItemNameCode = favoriteItem?.data.nameCode ?? -1;
    if (favoriteItemNameCode > 0 &&
        favoriteItemNameCode != db.characterResourceGardeTable[nikkeResourceId]?[coreLevel]?.nameCode) {
      favoriteItem = null;
    }
  }

  factory BattleNikkeOptions.fromJson(Map<String, dynamic> json) => _$BattleNikkeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$BattleNikkeOptionsToJson(this);

  void errorCorrection() {
    if (!db.characterResourceGardeTable.containsKey(nikkeResourceId)) {
      return;
    }

    syncLevel = syncLevel.clamp(1, db.maxSyncLevel);

    final groupedData = db.characterResourceGardeTable[nikkeResourceId]!;
    final coreLevels = groupedData.keys.toList();
    coreLevels.sort();
    coreLevel.clamp(coreLevels.first, coreLevels.last);

    final characterData = groupedData[coreLevel]!;
    final maxAttract = characterData.corporationSubType == CorporationSubType.overspec ? 40 : 30;
    attractLevel = attractLevel.clamp(1, maxAttract);

    for (int index = 0; index < 4; index += 1) {
      if (equips.length <= index) {
        equips.add(null);
      } else if (equips[index] != null) {
        final equipment = equips[index]!;
        final type = EquipType.values[index + 1];
        equipment.type = type;
        equipment.equipClass = characterData.characterClass;
        if (equipment.rarity.canHaveCorp && equipment.corporation != Corporation.none) {
          equipment.corporation = characterData.corporation;
        } else {
          equipment.corporation = Corporation.none;
        }
        if (equipment.level > equipment.rarity.maxLevel) {
          equipment.level = equipment.rarity.maxLevel;
        }

        if (equipment.rarity == EquipRarity.t10) {
          for (int index = 0; index < 3; index += 1) {
            if (equipment.equipLines.length <= index) {
              equipment.equipLines.add(EquipLine.none());
            } else {
              equipment.equipLines[index].level = equipment.equipLines[index].level.clamp(1, 15);
            }
          }
          if (equipment.equipLines.length > 3) {
            equipment.equipLines = equipment.equipLines.sublist(0, 3);
          }
        } else {
          equipment.equipLines.clear();
        }
      }
    }
    if (equips.length > 4) {
      equips = equips.sublist(0, 4);
    }

    for (int index = 0; index < 3; index += 1) {
      if (skillLevels.length <= index) {
        skillLevels.add(1);
      } else {
        skillLevels[index] = skillLevels[index].clamp(1, 10);
      }
    }
    if (skillLevels.length > 3) {
      skillLevels = skillLevels.sublist(0, 3);
    }

    final doll = favoriteItem;
    final weapon = db.characterShotTable[characterData.shotId]!;
    if (doll != null) {
      doll.weaponType = weapon.weaponType;
      if (doll.rarity == Rarity.ssr && !db.nameCodeFavItemTable.containsKey(characterData.nameCode)) {
        doll.rarity = Rarity.sr;
        doll.nameCode = 0;
      }

      final maxLevel = doll.rarity == Rarity.ssr ? 2 : 15;
      doll.level = doll.level.clamp(0, maxLevel);
    }
  }

  BattleNikkeOptions copy() {
    return BattleNikkeOptions(
      nikkeResourceId: nikkeResourceId,
      coreLevel: coreLevel,
      syncLevel: syncLevel,
      attractLevel: attractLevel,
      equips: equips.map((equip) => equip?.copy()).toList(),
      skillLevels: skillLevels.toList(),
      cube: cube?.copy(),
      favoriteItem: favoriteItem?.copy(),
      alwaysFocus: alwaysFocus,
      forceCancelShootDelay: forceCancelShootDelay,
      chargeMode: chargeMode,
    );
  }

  void copyFrom(BattleNikkeOptions other) {
    nikkeResourceId = other.nikkeResourceId;
    coreLevel = other.coreLevel;
    syncLevel = other.syncLevel;
    attractLevel = other.attractLevel;
    equips.clear();
    equips.addAll(other.equips.map((equip) => equip?.copy()).toList());
    skillLevels.clear();
    skillLevels.addAll(other.skillLevels);
    cube = other.cube?.copy();
    favoriteItem = other.favoriteItem?.copy();
    alwaysFocus = other.alwaysFocus;
    forceCancelShootDelay = other.forceCancelShootDelay;
    chargeMode = other.chargeMode;
  }
}

enum NikkeFullChargeMode { always, never, whenExitingBurst }

enum BattleNikkeStatus { behindCover, reloading, forceReloading, shooting }

class BattleCover extends BattleEntity {
  int level;

  @override
  String get name => 'Cover';

  @override
  int get baseHp => db.coverStatTable[level]!.levelHp;

  @override
  int get baseAttack => 0;

  @override
  int get baseDefence => db.coverStatTable[level]!.levelDefence;

  BattleCover(this.level);

  void init(BattleSimulation simulation) {
    currentHp = baseHp;
    buffs.clear();
  }
}

class BattleNikke extends BattleEntity {
  BattlePlayerOptions playerOptions;
  BattleNikkeOptions option;

  int fps = 60;

  NikkeCharacterData get characterData => db.characterResourceGardeTable[option.nikkeResourceId]![option.coreLevel]!;
  @override
  String get name => db.getTranslation(characterData.nameLocalkey)?.zhCN ?? characterData.resourceId.toString();
  WeaponData get baseWeaponData => db.characterShotTable[characterData.shotId]!;
  // skill data
  NikkeClass get nikkeClass => characterData.characterClass;
  Corporation get corporation => characterData.corporation;
  NikkeElement get element => NikkeElement.fromId(characterData.elementId.first);

  int get coreLevel => characterData.gradeCoreId;

  CharacterStatData get baseStat =>
      db.groupedCharacterStatTable[characterData.statEnhanceId]?[option.syncLevel] ?? CharacterStatData.emptyData;
  CharacterStatEnhanceData get statEnhanceData =>
      db.characterStatEnhanceTable[characterData.statEnhanceId] ?? CharacterStatEnhanceData.emptyData;
  ClassAttractiveStatData get attractiveStat =>
      db.attractiveStatTable[option.attractLevel]?.getStatData(nikkeClass) ?? ClassAttractiveStatData.emptyData;

  @override
  int get baseHp => BattleUtils.getBaseStat(
    coreLevel: coreLevel,
    baseStat: baseStat.hp,
    gradeRatio: statEnhanceData.gradeRatio,
    gradeEnhanceBase: statEnhanceData.gradeHp,
    coreEnhanceBaseRatio: statEnhanceData.coreHp,
    consoleStat: playerOptions.getRecycleHp(nikkeClass),
    bondStat: attractiveStat.hpRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + (equip?.getStat(StatType.hp, corporation) ?? 0)),
    cubeStat: option.cube?.getStat(StatType.hp) ?? 0,
    dollStat: option.favoriteItem?.getStat(StatType.hp) ?? 0,
  );

  @override
  int get baseAttack => BattleUtils.getBaseStat(
    coreLevel: coreLevel,
    baseStat: baseStat.attack,
    gradeRatio: statEnhanceData.gradeRatio,
    gradeEnhanceBase: statEnhanceData.gradeAttack,
    coreEnhanceBaseRatio: statEnhanceData.coreAttack,
    consoleStat: playerOptions.getRecycleAttack(corporation),
    bondStat: attractiveStat.attackRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + (equip?.getStat(StatType.atk, corporation) ?? 0)),
    cubeStat: option.cube?.getStat(StatType.atk) ?? 0,
    dollStat: option.favoriteItem?.getStat(StatType.atk) ?? 0,
  );

  @override
  int get baseDefence => BattleUtils.getBaseStat(
    coreLevel: coreLevel,
    baseStat: baseStat.defence,
    gradeRatio: statEnhanceData.gradeRatio,
    gradeEnhanceBase: statEnhanceData.gradeDefence,
    coreEnhanceBaseRatio: statEnhanceData.coreDefence,
    consoleStat: playerOptions.getRecycleDefence(nikkeClass, corporation),
    bondStat: attractiveStat.defenceRate,
    equipStat: option.equips.fold(0, (sum, equip) => sum + (equip?.getStat(StatType.defence, corporation) ?? 0)),
    cubeStat: option.cube?.getStat(StatType.defence) ?? 0,
    dollStat: option.favoriteItem?.getStat(StatType.defence) ?? 0,
  );

  late BattleCover cover;
  Barrier? barrier;
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
  int shootingFrameCount = 0;

  int totalBulletsFired = 0;
  int totalFullChargeFired = 0;
  int totalBulletsHit = 0;
  bool activatedBurstSkillThisCycle = false;

  BattleNikkeStatus status = BattleNikkeStatus.behindCover;

  List<BattleSkill> skills = [];
  List<BattleFunction> functions = [];

  BattleNikke({required this.playerOptions, required this.option}) {
    cover = BattleCover(option.syncLevel);
    element = NikkeElement.fromId(characterData.elementId.first);
  }

  void init(BattleSimulation simulation, int position) {
    uniqueId = position;
    fps = simulation.fps;
    _accuracyCircleScale = baseWeaponData.startAccuracyCircleScale;
    rateOfFire = baseWeaponData.rateOfFire;
    chargeFrames = 0;
    previousFullChargeFrameCount = 0;
    shootingFrameCount = 0;
    spotLastDelayFrameCount = 0;
    spotFirstDelayFrameCount = BattleUtils.timeDataToFrame(baseWeaponData.spotFirstDelay, fps);
    reloadingFrameCount = 0;
    fullReloadFrameCount = 0;
    currentHp = baseHp;
    currentAmmo = baseWeaponData.maxAmmo;
    cover.uniqueId = position + 5;
    cover.init(simulation);
    barrier = null;

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

    skills.add(BattleSkill(characterData.skill1Id, characterData.skill1Table, option.skillLevels[0], 1, uniqueId));
    skills.add(BattleSkill(characterData.skill2Id, characterData.skill2Table, option.skillLevels[1], 2, uniqueId));
    skills.add(BattleSkill(characterData.ultiSkillId, SkillType.characterSkill, option.skillLevels[2], 3, uniqueId));

    // substitute favorite item skill
    final favoriteItem = option.favoriteItem;
    if (favoriteItem != null &&
        favoriteItem.data.nameCode > 0 &&
        favoriteItem.data.nameCode == characterData.nameCode) {
      // grade is the number of stars, so either 1, 2, 3 in this case
      final substituteCount = min(favoriteItem.data.favoriteItemSkills.length, favoriteItem.levelData.grade);
      final favoriteItemSkills = favoriteItem.data.favoriteItemSkills.sublist(0, substituteCount);
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

  // seems not needed since statAmmoLoad & statHpHeal buffs apply instantly in addBuffs
  void startBattle(BattleSimulation simulation) {
    currentHp = baseHp;
    currentAmmo = getMaxAmmo(simulation);
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

    final barrier = this.barrier;
    if (barrier != null) {
      if (barrier.durationType == DurationType.timeSec) {
        barrier.duration -= 1;
        if (barrier.duration == 0) {
          this.barrier = null;
        }
      }

      if (barrier.hp <= 0) {
        this.barrier = null;
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
      if (spotFirstDelayFrameCount == 0 && WeaponType.chargeWeaponTypes.contains(currentWeaponType)) {
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
            ownerUniqueId: uniqueId,
            isFullCharge: false,
          ),
        );
        if (currentWeaponData.fireType == FireType.instant) {
          generateDamageAndBurstEvents(simulation, simulation.currentFrame, target);
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
        if (buff.data.durationType == DurationType.shots) {
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
