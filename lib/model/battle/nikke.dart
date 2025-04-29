import 'dart:math';

import 'package:nikke_einkk/model/battle/battle_event.dart';
import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/translation.dart';

class BattleNikkeOptions {
  int nikkeResourceId;
  int coreLevel;
  int syncLevel;
  int attractLevel;
  List<BattleEquipmentData> equips;
  List<int> skillLevels;
  // cube
  // doll

  BattleNikkeOptions({
    required this.nikkeResourceId,
    this.coreLevel = 1,
    this.syncLevel = 1,
    this.attractLevel = 1,
    this.equips = const [],
    this.skillLevels = const [],
  });
}

enum BattleNikkeStatus { behindCover, reloading, forceReloading, shooting }

class BattleNikkeData {
  BattleSimulationData simulation;
  BattleNikkeOptions options;

  int position = 0;
  int currentHp = 0;
  int currentAmmo = 0;

  int reloadingFrameCount = 0;
  int fullReloadFrameCount = 0;

  int spotFirstDelayFrameCount = 0;
  int shootingFrameCount = 0;

  BattleNikkeStatus status = BattleNikkeStatus.behindCover;

  // unclear if this can be a simple get or has to be a proper method call that requires battleSimulationData
  int get maxAmmo => max(1, baseWeaponData.maxAmmo);
  WeaponType get currentWeaponType => baseWeaponData.weaponType;
  WeaponSkillData get currentWeaponData => baseWeaponData;

  // coverBaseHp
  // coverCurrentHp

  BattleNikkeData({required this.simulation, required this.options});

  int get fps => simulation.fps;

  NikkeCharacterData get characterData =>
      gameData.characterResourceGardeTable[options.nikkeResourceId]![options.coreLevel]!;
  WeaponSkillData get baseWeaponData => gameData.characterShotTable[characterData.shotId]!;
  // skill data
  Translation? get name => gameData.getTranslation(characterData.nameLocalkey);
  NikkeClass get nikkeClass => characterData.characterClass;
  Corporation get corporation => characterData.corporation;

  int get coreLevel => characterData.gradeCoreId;

  CharacterStatData get baseStat =>
      gameData.groupedCharacterStatTable[characterData.statEnhanceId]?[options.syncLevel] ??
      CharacterStatData.emptyData;
  CharacterStatEnhanceData get statEnhanceData =>
      gameData.characterStatEnhanceTable[characterData.statEnhanceId] ?? CharacterStatEnhanceData.emptyData;
  ClassAttractiveStatData get attractiveStat =>
      gameData.attractiveStatTable[options.attractLevel]?.getStatData(nikkeClass) ?? ClassAttractiveStatData.emptyData;

  int get baseHp => getBaseStat(
    baseStat: baseStat.hp,
    gradeEnhanceBase: statEnhanceData.gradeHp,
    coreEnhanceBaseRatio: statEnhanceData.coreHp,
    consoleStat: simulation.playerOptions.getRecycleHp(nikkeClass),
    bondStat: attractiveStat.hpRate,
    equipStat: options.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.hp, corporation)),
  );

  int get baseAttack => getBaseStat(
    baseStat: baseStat.attack,
    gradeEnhanceBase: statEnhanceData.gradeAttack,
    coreEnhanceBaseRatio: statEnhanceData.coreAttack,
    consoleStat: simulation.playerOptions.getRecycleAttack(corporation),
    bondStat: attractiveStat.attackRate,
    equipStat: options.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.atk, corporation)),
  );

  int get baseDefence => getBaseStat(
    baseStat: baseStat.defence,
    gradeEnhanceBase: statEnhanceData.gradeDefence,
    coreEnhanceBaseRatio: statEnhanceData.coreDefence,
    consoleStat: simulation.playerOptions.getRecycleDefence(nikkeClass, corporation),
    bondStat: attractiveStat.defenceRate,
    equipStat: options.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.defence, corporation)),
  );

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

  void init(int position) {
    this.position = position;
    currentHp = baseHp;
    currentAmmo = baseWeaponData.maxAmmo;
  }

  void normalAction() {
    determineStatus();

    switch (status) {
      case BattleNikkeStatus.behindCover:
        return;
      case BattleNikkeStatus.reloading:
      case BattleNikkeStatus.forceReloading:
        processReloadingStatus();
        break;
      case BattleNikkeStatus.shooting:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void processReloadingStatus() {
    // reset this when entering a non-shooting status
    spotFirstDelayFrameCount = 0;

    if (reloadingFrameCount == 0) {
      // this means this is the first frame of reloading
      // need to calculate how many frames needed to do one reload
      // TODO: reloading buffs is % of currentWeaponData.reloadTime
      fullReloadFrameCount = BattleUtils.timeDataToFrame(
        currentWeaponData.reloadTime + currentWeaponData.spotLastDelay,
        fps,
      );
    }

    reloadingFrameCount += 1;
    if (reloadingFrameCount >= fullReloadFrameCount) {
      final reloadRatio = BattleUtils.toModifier(currentWeaponData.reloadBullet);
      currentAmmo += (reloadRatio * maxAmmo).round();
      reloadingFrameCount = 0;
    }
  }

  bool canTarget(BattleRaptureData rapture) {
    return rapture.canBeTargeted ||
        currentWeaponData.preferTargetCondition == PreferTargetCondition.includeNoneTargetNone;
  }

  void processShootingStatus() {
    // before shooting need to go outside cover first, not sure if this should be its own status tho
    if (spotFirstDelayFrameCount < BattleUtils.timeDataToFrame(currentWeaponData.spotFirstDelay, fps)) {
      spotFirstDelayFrameCount += 1;
      return;
    }

    final target = simulation.raptures.where((rapture) => canTarget(rapture)).firstOrNull;

    switch (currentWeaponType) {
      case WeaponType.ar:
      case WeaponType.smg:
        if (shootingFrameCount == 0 && target != null) {
          // ready to fire a bullet, register fire
          simulation.registerEvent(simulation.currentFrame, NikkeFireEvent(ownerPosition: position));
          if (currentWeaponData.fireType == FireType.instant) {
            simulation.registerEvent(simulation.currentFrame, NikkeDamageEvent(nikke: this, rapture: target));
          }
        }
        break;
      case WeaponType.mg:
        // TODO: Handle this case.
        throw UnimplementedError();
      case WeaponType.sg:
        // TODO: Handle this case.
        throw UnimplementedError();
      case WeaponType.rl:
      case WeaponType.sr:
        // charging
        throw UnimplementedError();
      case WeaponType.unknown:
      case WeaponType.none:
        // TODO: probably log?
        return;
    }
  }

  void determineStatus() {
    if (status == BattleNikkeStatus.forceReloading && currentAmmo != maxAmmo) return;

    final target = simulation.raptures.where((rapture) => canTarget(rapture)).firstOrNull;

    // forcing cover, or no autoAttack, or no target
    if (simulation.useCover || (position == simulation.currentNikke && !simulation.autoAttack) || target == null) {
      status = BattleNikkeStatus.behindCover;

      if (currentAmmo < maxAmmo) {
        // attempt to reload
        status == BattleNikkeStatus.reloading;
      }
    } else {
      status = BattleNikkeStatus.shooting;

      if (currentAmmo == 0) {
        status = BattleNikkeStatus.forceReloading;
      }
    }
  }
}
