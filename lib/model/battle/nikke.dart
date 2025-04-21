import 'dart:math';

import 'package:nikke_einkk/model/battle/battle_simulator.dart';
import 'package:nikke_einkk/model/battle/equipment.dart';
import 'package:nikke_einkk/model/battle/utils.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/translation.dart';

class BattleNikkeOptions {
  int nikkeResourceId;
  int coreLevel;
  int syncLevel;
  int attractLevel;
  BattlePlayerOptions? battlePlayerOptions;
  List<BattleEquipmentData> equips;
  List<int> skillLevels;
  // cube
  // doll

  BattleNikkeOptions({
    required this.nikkeResourceId,
    this.coreLevel = 1,
    this.syncLevel = 1,
    this.attractLevel = 1,
    this.battlePlayerOptions,
    this.equips = const [],
    this.skillLevels = const [],
  });
}

class BattleNikkeData {
  BattleNikkeOptions options;

  int position = 0;

  // coverBaseHp
  // coverCurrentHp

  // hp
  // atk
  // def

  BattleNikkeData({required this.options});

  NikkeCharacterData get characterData =>
      gameData.characterResourceGardeTable[options.nikkeResourceId]![options.coreLevel]!;
  WeaponSkillData get weaponSkillData => gameData.characterShotTable[characterData.shotId]!;
  // skill data
  Translation? get name => gameData.getTranslation(characterData.nameLocalkey);
  NikkeClass get nikkeClass => characterData.characterClass;
  Corporation get corporation => characterData.corporation;
  WeaponType get weaponType => weaponSkillData.weaponType;

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
    consoleStat: options.battlePlayerOptions?.getRecycleHp(nikkeClass) ?? 0,
    bondStat: attractiveStat.hpRate,
    equipStat: options.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.hp, corporation)),
  );

  int get baseAttack => getBaseStat(
    baseStat: baseStat.attack,
    gradeEnhanceBase: statEnhanceData.gradeAttack,
    coreEnhanceBaseRatio: statEnhanceData.coreAttack,
    consoleStat: options.battlePlayerOptions?.getRecycleAttack(corporation) ?? 0,
    bondStat: attractiveStat.attackRate,
    equipStat: options.equips.fold(0, (sum, equip) => sum + equip.getStat(StatType.atk, corporation)),
  );

  int get baseDefence => getBaseStat(
    baseStat: baseStat.defence,
    gradeEnhanceBase: statEnhanceData.gradeDefence,
    coreEnhanceBaseRatio: statEnhanceData.coreDefence,
    consoleStat: options.battlePlayerOptions?.getRecycleDefence(nikkeClass, corporation) ?? 0,
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

  void attack(BattleSimulationData simulation) {
    
  }
}
