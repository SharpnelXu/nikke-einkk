import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/battle/rapture.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/model/equipment.dart';
import 'package:nikke_einkk/model/favorite_item.dart';
import 'package:nikke_einkk/model/harmony_cube.dart';
import 'package:nikke_einkk/model/items.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

part '../generated/model/user_data.g.dart';

@JsonSerializable()
class PlayerOptions {
  int globalSync;
  int personalRecycleLevel;
  Map<Corporation, int> corpRecycleLevels = {};
  Map<NikkeClass, int> classRecycleLevels = {};
  bool forceFillBurst = false;

  PlayerOptions({
    this.globalSync = 1,
    this.personalRecycleLevel = 0,
    Map<Corporation, int> corpRecycleLevels = const {},
    Map<NikkeClass, int> classRecycleLevels = const {},
    this.forceFillBurst = false,
  }) {
    this.corpRecycleLevels.addAll(corpRecycleLevels);
    this.classRecycleLevels.addAll(classRecycleLevels);
  }

  PlayerOptions copy() {
    return PlayerOptions(
      globalSync: globalSync,
      personalRecycleLevel: personalRecycleLevel,
      corpRecycleLevels: corpRecycleLevels,
      classRecycleLevels: classRecycleLevels,
      forceFillBurst: forceFillBurst,
    );
  }

  factory PlayerOptions.fromJson(Map<String, dynamic> json) => _$PlayerOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerOptionsToJson(this);

  int getRecycleHp(NikkeClass nikkeClass) {
    return personalRecycleLevel * RecycleStat.personal.hp +
        RecycleStat.nikkeClass.hp * (classRecycleLevels[nikkeClass] ?? 0);
  }

  int getRecycleAttack(Corporation corporation) {
    return RecycleStat.corporation.atk * (corpRecycleLevels[corporation] ?? 0);
  }

  int getRecycleDefence(NikkeClass nikkeClass, Corporation corporation) {
    return RecycleStat.nikkeClass.def * (classRecycleLevels[nikkeClass] ?? 0) +
        RecycleStat.corporation.def * (corpRecycleLevels[corporation] ?? 0);
  }
}

@JsonSerializable()
class NikkeOptions {
  int nikkeResourceId;
  int coreLevel;
  int syncLevel;
  int attractLevel;
  List<EquipmentOption?> equips;
  List<int> skillLevels;
  HarmonyCubeOption? cube;
  FavoriteItemOption? favoriteItem;

  bool alwaysFocus;
  bool forceCancelShootDelay;
  NikkeFullChargeMode chargeMode;

  static List<EquipType> equipTypes = [EquipType.head, EquipType.body, EquipType.arm, EquipType.leg];

  NikkeOptions({
    required this.nikkeResourceId,
    this.coreLevel = 1,
    this.syncLevel = 1,
    this.attractLevel = 1,
    List<EquipmentOption?> equips = const [null, null, null, null],
    List<int> skillLevels = const [10, 10, 10],
    this.cube,
    this.favoriteItem,
    this.alwaysFocus = false,
    this.forceCancelShootDelay = false,
    this.chargeMode = NikkeFullChargeMode.always,
  }) : equips = equips.map((equip) => equip?.copy()).toList(),
       skillLevels = skillLevels.toList();

  factory NikkeOptions.fromJson(Map<String, dynamic> json) => _$NikkeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$NikkeOptionsToJson(this);

  NikkeOptions copy() {
    return NikkeOptions(
      nikkeResourceId: nikkeResourceId,
      coreLevel: coreLevel,
      syncLevel: syncLevel,
      attractLevel: attractLevel,
      equips: equips,
      skillLevels: skillLevels.toList(),
      cube: cube?.copy(),
      favoriteItem: favoriteItem?.copy(),
      alwaysFocus: alwaysFocus,
      forceCancelShootDelay: forceCancelShootDelay,
      chargeMode: chargeMode,
    );
  }

  void copyFrom(NikkeOptions other) {
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

  void errorCorrection(NikkeDatabaseV2 db) {
    if (!db.characterResourceGardeTable.containsKey(nikkeResourceId)) {
      return;
    }

    syncLevel = syncLevel.clamp(1, db.maxSyncLevel);

    final groupedData = db.characterResourceGardeTable[nikkeResourceId]!;
    final coreLevels = groupedData.keys.toList();
    coreLevels.sort();
    coreLevel = coreLevel.clamp(coreLevels.first, coreLevels.last);

    final characterData = groupedData[coreLevel]!;
    attractLevel = attractLevel.clamp(1, characterData.maxAttractLv);

    for (int index = 0; index < NikkeOptions.equipTypes.length; index += 1) {
      if (equips.length <= index) {
        equips.add(null);
      } else if (equips[index] != null) {
        final equipment = equips[index]!;
        final type = NikkeOptions.equipTypes[index];
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
    equips = equips.sublist(0, 4);

    for (int index = 0; index < 3; index += 1) {
      if (skillLevels.length <= index) {
        skillLevels.add(1);
      } else {
        skillLevels[index] = skillLevels[index].clamp(1, 10);
      }
    }
    skillLevels = skillLevels.sublist(0, 3);

    final doll = favoriteItem;
    final weapon = db.characterShotTable[characterData.shotId]!;
    if (doll != null) {
      doll.weaponType = weapon.weaponType;
      if (doll.rarity == Rarity.ssr && !db.nameCodeFavItemTable.containsKey(characterData.nameCode)) {
        doll.rarity = Rarity.sr;
        doll.nameCode = 0;
      }

      doll.level = doll.level.clamp(0, maxDollLv(doll.rarity));
    }

    final cube = this.cube;
    if (cube != null) {
      if (db.harmonyCubeTable[cube.cubeId] == null) {
        this.cube = null;
      }
    }
  }
}

enum NikkeFullChargeMode { always, never, whenExitingBurst }

@JsonSerializable()
class UserData {
  Language language;
  PlayerOptions globalPlayerOptions = PlayerOptions();
  Map<int, NikkeOptions> globalNikkeOptions = {};
  PlayerOptions cnPlayerOptions = PlayerOptions();
  Map<int, NikkeOptions> cnNikkeOptions = {};
  Map<int, int> globalCubeLvs = {};
  Map<int, int> cnCubeLvs = {};

  UserData({
    this.language = Language.en,
    PlayerOptions? globalPlayerOptions,
    Map<int, NikkeOptions> globalNikkeOptions = const {},
    PlayerOptions? cnPlayerOptions,
    Map<int, NikkeOptions> cnNikkeOptions = const {},
    List<HarmonyCubeOption> cubes = const [],
    Map<int, int> globalCubeLvs = const {},
    Map<int, int> cnCubeLvs = const {},
  }) {
    if (globalPlayerOptions != null) {
      this.globalPlayerOptions = globalPlayerOptions.copy();
    }
    for (final id in globalNikkeOptions.keys) {
      this.globalNikkeOptions[id] = globalNikkeOptions[id]!.copy();
    }
    if (cnPlayerOptions != null) {
      this.cnPlayerOptions = cnPlayerOptions.copy();
    }
    for (final id in cnNikkeOptions.keys) {
      this.cnNikkeOptions[id] = cnNikkeOptions[id]!.copy();
    }
    this.globalCubeLvs.addAll(globalCubeLvs);
    this.cnCubeLvs.addAll(cnCubeLvs);
  }

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class BattleSetup {
  late PlayerOptions playerOptions;
  List<NikkeOptions> nikkeOptions = [];
  late BattleRaptureOptions raptureOptions;

  BattleSetup({
    required PlayerOptions playerOptions,
    List<NikkeOptions> nikkeOptions = const [],
    required BattleRaptureOptions raptureOptions,
  }) {
    this.playerOptions = playerOptions.copy();
    this.nikkeOptions.addAll(nikkeOptions.map((option) => option.copy()));
    this.raptureOptions = raptureOptions.copy();
  }

  factory BattleSetup.fromJson(Map<String, dynamic> json) => _$BattleSetupFromJson(json);

  Map<String, dynamic> toJson() => _$BattleSetupToJson(this);
}
