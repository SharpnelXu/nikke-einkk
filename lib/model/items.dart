import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/db.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';
part '../generated/model/items.g.dart';

// ItemEquipTable
@JsonSerializable(createToJson: false)
class EquipmentData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'resource_id')
  final String resourceId;
  @JsonKey(name: 'item_type')
  final String rawItemType;
  ItemType get itemType => ItemType.fromName(rawItemType);
  @JsonKey(name: 'item_sub_type')
  final String rawItemSubType;
  EquipType get itemSubType => EquipType.fromName(rawItemSubType);
  @JsonKey(name: 'class')
  final String rawCharacterClass;
  NikkeClass get characterClass => NikkeClass.fromName(rawCharacterClass);
  @JsonKey(name: 'item_rare')
  final String rawItemRarity;
  EquipRarity get itemRarity => EquipRarity.fromName(rawItemRarity);
  @JsonKey(name: 'grade_core_id')
  final int gradeCoreId;
  @JsonKey(name: 'grow_grade')
  final int growGrade;
  final List<EquipmentStat> stat;
  @JsonKey(name: 'option_slot')
  final List<OptionSlot> optionSlots;
  @JsonKey(name: 'option_cost')
  final int optionCost;
  @JsonKey(name: 'option_change_cost')
  final int optionChangeCost;
  @JsonKey(name: 'option_lock_cost')
  final int optionLockCost;

  EquipmentData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.resourceId = '',
    this.rawItemType = '',
    this.rawItemSubType = '',
    this.rawCharacterClass = '',
    this.rawItemRarity = '',
    this.gradeCoreId = 0,
    this.growGrade = 0,
    this.stat = const [],
    this.optionSlots = const [],
    this.optionCost = 0,
    this.optionChangeCost = 0,
    this.optionLockCost = 0,
  });

  factory EquipmentData.fromJson(Map<String, dynamic> json) => _$EquipmentDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class EquipmentStat {
  @JsonKey(name: 'stat_type')
  final String rawStatType;
  StatType get statType => StatType.fromName(rawStatType);

  @JsonKey(name: 'stat_value')
  final int statValue;

  EquipmentStat({this.rawStatType = '', this.statValue = 0});

  factory EquipmentStat.fromJson(Map<String, dynamic> json) => _$EquipmentStatFromJson(json);
}

@JsonSerializable(createToJson: false)
class OptionSlot {
  @JsonKey(name: 'option_slot')
  final int optionSlot;
  @JsonKey(name: 'option_slot_success_ratio')
  final int optionSlotSuccessRatio;

  OptionSlot({this.optionSlot = 0, this.optionSlotSuccessRatio = 0});

  factory OptionSlot.fromJson(Map<String, dynamic> json) => _$OptionSlotFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum ItemType {
  unknown,
  equip,
  harmonyCube;

  static final Map<String, ItemType> _reverseMap = Map.fromIterable(
    ItemType.values,
    key: (v) => (v as ItemType).name.pascal,
  );

  static ItemType fromName(String? name) {
    return _reverseMap[name] ?? ItemType.unknown;
  }
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum EquipRarity {
  unknown,
  t1,
  t2,
  t3,
  t4,
  t5,
  t6,
  t7,
  t8,
  t9,
  t10;

  Color get color {
    switch (this) {
      case EquipRarity.unknown:
      case EquipRarity.t1:
      case EquipRarity.t2:
        return Colors.grey;
      case EquipRarity.t3:
        return Colors.lightGreen;
      case EquipRarity.t4:
        return Colors.green;
      case EquipRarity.t5:
        return Colors.indigo;
      case EquipRarity.t6:
        return Colors.blue;
      case EquipRarity.t7:
        return Colors.deepPurple;
      case EquipRarity.t8:
        return Colors.purple;
      case EquipRarity.t9:
        return Colors.orange;
      case EquipRarity.t10:
        return Colors.purpleAccent;
    }
  }

  int get maxLevel => switch (this) {
    EquipRarity.unknown => 0,
    EquipRarity.t1 || EquipRarity.t2 => 0,
    EquipRarity.t3 || EquipRarity.t4 => 3,
    EquipRarity.t5 || EquipRarity.t6 => 4,
    EquipRarity.t7 || EquipRarity.t8 || EquipRarity.t9 || EquipRarity.t10 => 5,
  };

  bool get canHaveCorp => switch (this) {
    EquipRarity.unknown || EquipRarity.t1 || EquipRarity.t2 || EquipRarity.t3 || EquipRarity.t10 => false,
    EquipRarity.t4 || EquipRarity.t5 || EquipRarity.t6 || EquipRarity.t7 || EquipRarity.t8 || EquipRarity.t9 => true,
  };

  static final Map<String, EquipRarity> _reverseMap = Map.fromIterable(
    EquipRarity.values,
    key: (v) => (v as EquipRarity).name.pascal,
  );

  static EquipRarity fromName(String? name) {
    return _reverseMap[name] ?? EquipRarity.unknown;
  }
}

enum EquipType {
  unknown,
  @JsonValue('Module_A')
  head,
  @JsonValue('Module_B')
  body,
  @JsonValue('Module_C')
  arm,
  @JsonValue('Module_D')
  leg;

  static final Map<String, EquipType> _reverseMap = {
    'Module_A': EquipType.head,
    'Module_B': EquipType.body,
    'Module_C': EquipType.arm,
    'Module_D': EquipType.leg,
  };

  static EquipType fromName(String? name) {
    return _reverseMap[name] ?? EquipType.unknown;
  }
}

/// from EquipmentOptionTable.json
enum EquipLineType {
  none(0),
  increaseElementalDamage(7000500),
  startAccuracyCircle(7000600),
  statAmmo(7000700),
  statAtk(7000800),
  statChargeDamage(7000900),
  statChargeTime(7001000),
  statCriticalDamage(7001200),
  statCritical(7001100),
  statDef(7001300);

  final int stateEffectIdBase;

  const EquipLineType(this.stateEffectIdBase);

  @override
  String toString() {
    switch (this) {
      case EquipLineType.none:
        return 'None';
      case EquipLineType.increaseElementalDamage:
        return 'ElementDamage';
      case EquipLineType.startAccuracyCircle:
        return 'Accuracy';
      case EquipLineType.statAmmo:
        return 'Ammo';
      case EquipLineType.statAtk:
        return 'Attack';
      case EquipLineType.statChargeDamage:
        return 'ChargeDamage';
      case EquipLineType.statChargeTime:
        return 'ChargeSpeed';
      case EquipLineType.statCriticalDamage:
        return 'CriticalDamage';
      case EquipLineType.statCritical:
        return 'CriticalRate';
      case EquipLineType.statDef:
        return 'Defence';
    }
  }
}

@JsonSerializable()
class EquipLine {
  EquipLineType type;
  int _level;
  int get level => _level;
  set level(int newLevel) => _level = newLevel.clamp(1, 15);

  EquipLine(this.type, int level) : _level = level;

  EquipLine.onValue(this.type, int stat) : _level = 1 {
    for (int level = 1; level <= 15; level += 1) {
      _level = level;
      final stateEffectData = dbLegacy.stateEffectTable[getStateEffectId()]!;
      for (final functionId in stateEffectData.functions) {
        if (functionId.function != 0) {
          final function = dbLegacy.functionTable[functionId.function]!;
          if (stat == function.functionValue) {
            return;
          }
        }
      }
    }
  }

  EquipLine.none() : type = EquipLineType.none, _level = 1;

  int getStateEffectId() {
    return type == EquipLineType.none ? 0 : type.stateEffectIdBase + level;
  }

  EquipLine copy() {
    return EquipLine(type, level);
  }

  factory EquipLine.fromJson(Map<String, dynamic> json) => _$EquipLineFromJson(json);

  Map<String, dynamic> toJson() => _$EquipLineToJson(this);
}

@JsonSerializable(createToJson: false)
class HarmonyCubeSkillGroup {
  @JsonKey(name: 'skill_group_id')
  final int skillGroupId;

  HarmonyCubeSkillGroup({this.skillGroupId = 0});

  factory HarmonyCubeSkillGroup.fromJson(Map<String, dynamic> json) => _$HarmonyCubeSkillGroupFromJson(json);
}

@JsonSerializable(createToJson: false)
class HarmonyCubeData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'location_id')
  final int locationId;
  @JsonKey(name: 'location_localkey')
  final String locationLocalkey;
  final int order;
  @JsonKey(name: 'resource_id')
  final int resourceId;
  final String bg;
  @JsonKey(name: 'bg_color')
  final String bgColor;
  @JsonKey(name: 'item_type')
  final String rawItemType;
  ItemType get itemType => ItemType.fromName(rawItemType);
  @JsonKey(name: 'item_sub_type')
  final String itemSubType;
  @JsonKey(name: 'item_rare')
  final String rawItemRare;
  Rarity get itemRare => Rarity.fromName(rawItemRare);
  @JsonKey(name: 'class')
  final String rawCharacterClass;
  NikkeClass get characterClass => NikkeClass.fromName(rawCharacterClass);
  @JsonKey(name: 'level_enhance_id')
  final int levelEnhanceId;
  @JsonKey(name: 'harmonycube_skill_group')
  final List<HarmonyCubeSkillGroup> harmonyCubeSkillGroups;

  HarmonyCubeData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.locationId = 0,
    this.locationLocalkey = '',
    this.order = 0,
    this.resourceId = 0,
    this.bg = '',
    this.bgColor = '',
    this.rawItemType = '',
    this.itemSubType = '',
    this.rawItemRare = '',
    this.rawCharacterClass = '',
    this.levelEnhanceId = 0,
    this.harmonyCubeSkillGroups = const [],
  });

  factory HarmonyCubeData.fromJson(Map<String, dynamic> json) => _$HarmonyCubeDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class HarmonyCubeSkillLevel {
  @JsonKey(name: 'skill_level')
  final int level;

  HarmonyCubeSkillLevel({this.level = 0});

  factory HarmonyCubeSkillLevel.fromJson(Map<String, dynamic> json) => _$HarmonyCubeSkillLevelFromJson(json);
}

@JsonSerializable(createToJson: false)
class HarmonyCubeStat {
  @JsonKey(name: 'stat_type')
  final String rawType;
  StatType get type => StatType.fromName(rawType);
  @JsonKey(name: 'stat_rate')
  final int rate;

  HarmonyCubeStat({this.rawType = '', this.rate = 0});

  factory HarmonyCubeStat.fromJson(Map<String, dynamic> json) => _$HarmonyCubeStatFromJson(json);
}

@JsonSerializable(createToJson: false)
class HarmonyCubeLevelData {
  final int id;
  @JsonKey(name: 'level_enhance_id')
  final int levelEnhanceId;
  final int level;
  @JsonKey(name: 'skill_levels')
  final List<HarmonyCubeSkillLevel> skillLevels;
  @JsonKey(name: 'material_id')
  final int materialId;
  @JsonKey(name: 'material_value')
  final int materialValue;
  @JsonKey(name: 'gold_value')
  final int goldValue;
  final int slot;
  @JsonKey(name: 'harmonycube_stats')
  final List<HarmonyCubeStat> stats;

  HarmonyCubeLevelData({
    this.id = 0,
    this.levelEnhanceId = 0,
    this.level = 0,
    this.skillLevels = const [],
    this.materialId = 0,
    this.materialValue = 0,
    this.goldValue = 0,
    this.slot = 0,
    this.stats = const [],
  });

  factory HarmonyCubeLevelData.fromJson(Map<String, dynamic> json) => _$HarmonyCubeLevelDataFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum FavoriteItemType {
  unknown,
  collection,
  favorite;

  static final Map<String, FavoriteItemType> _reverseMap = Map.fromIterable(
    FavoriteItemType.values,
    key: (v) => (v as FavoriteItemType).name.pascal,
  );

  static FavoriteItemType fromName(String? name) {
    return _reverseMap[name] ?? FavoriteItemType.unknown;
  }
}

@JsonSerializable(createToJson: false)
class CollectionItemSkillGroup {
  @JsonKey(name: 'collection_skill_id')
  final int skillId;

  CollectionItemSkillGroup({this.skillId = 0});

  factory CollectionItemSkillGroup.fromJson(Map<String, dynamic> json) => _$CollectionItemSkillGroupFromJson(json);
}

@JsonSerializable(createToJson: false)
class FavoriteItemSkillGroup {
  @JsonKey(name: 'favorite_skill_id')
  final int skillId;
  @JsonKey(name: 'skill_table')
  final String rawSkillTable;
  SkillType get skillTable => SkillType.fromName(rawSkillTable);
  @JsonKey(name: 'skill_change_slot')
  final int skillChangeSlot;

  FavoriteItemSkillGroup({this.skillId = 0, this.rawSkillTable = '', this.skillChangeSlot = 0});

  factory FavoriteItemSkillGroup.fromJson(Map<String, dynamic> json) => _$FavoriteItemSkillGroupFromJson(json);
}

@JsonSerializable(createToJson: false)
class FavoriteItemData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'icon_resource_id')
  final String iconResourceId;
  @JsonKey(name: 'img_resource_id')
  final String imgResourceId;
  @JsonKey(name: 'prop_resource_id')
  final String propResourceId;
  final int order;
  @JsonKey(name: 'favorite_rare')
  final String rawFavoriteRare;
  Rarity get favoriteRare => Rarity.fromName(rawFavoriteRare);
  @JsonKey(name: 'favorite_type')
  final String rawFavoriteType;
  FavoriteItemType get favoriteType => FavoriteItemType.fromName(rawFavoriteType);
  @JsonKey(name: 'weapon_type')
  final String rawWeaponType;
  WeaponType get weaponType => WeaponType.fromName(rawWeaponType);
  @JsonKey(name: 'name_code')
  final int nameCode;
  @JsonKey(name: 'max_level')
  final int maxLevel;
  @JsonKey(name: 'level_enhance_id')
  final int levelEnhanceId;
  @JsonKey(name: 'probability_group')
  final int probabilityGroup;
  @JsonKey(name: 'collection_skill_group_data')
  final List<CollectionItemSkillGroup> collectionSkills;
  @JsonKey(name: 'favoriteitem_skill_group_data')
  final List<FavoriteItemSkillGroup> favoriteItemSkills;
  @JsonKey(name: 'albumcategory_id')
  final int albumCategoryId;

  FavoriteItemData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.iconResourceId = '',
    this.imgResourceId = '',
    this.propResourceId = '',
    this.order = 0,
    this.rawFavoriteRare = '',
    this.rawFavoriteType = '',
    this.rawWeaponType = '',
    this.nameCode = 0,
    this.maxLevel = 0,
    this.levelEnhanceId = 0,
    this.probabilityGroup = 0,
    this.collectionSkills = const [],
    this.favoriteItemSkills = const [],
    this.albumCategoryId = 0,
  });

  factory FavoriteItemData.fromJson(Map<String, dynamic> json) => _$FavoriteItemDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class FavoriteItemStat {
  @JsonKey(name: 'stat_type')
  final String rawType;
  StatType get type => StatType.fromName(rawType);
  @JsonKey(name: 'stat_value')
  final int value;

  FavoriteItemStat({this.rawType = '', this.value = 0});

  factory FavoriteItemStat.fromJson(Map<String, dynamic> json) => _$FavoriteItemStatFromJson(json);
}

@JsonSerializable(createToJson: false)
class CollectionItemSkillLevel {
  @JsonKey(name: 'collection_skill_level')
  final int level;

  CollectionItemSkillLevel({this.level = 0});

  factory CollectionItemSkillLevel.fromJson(Map<String, dynamic> json) => _$CollectionItemSkillLevelFromJson(json);
}

@JsonSerializable(createToJson: false)
class FavoriteItemLevelData {
  final int id;
  @JsonKey(name: 'level_enhance_id')
  final int levelEnhanceId;
  final int grade;
  final int level;
  @JsonKey(name: 'favoriteitem_stat_data')
  final List<FavoriteItemStat> stats;
  @JsonKey(name: 'collection_skill_level_data')
  final List<CollectionItemSkillLevel> skillLevels;

  FavoriteItemLevelData({
    this.id = 0,
    this.levelEnhanceId = 0,
    this.grade = 0,
    this.level = 0,
    this.stats = const [],
    this.skillLevels = const [],
  });

  factory FavoriteItemLevelData.fromJson(Map<String, dynamic> json) => _$FavoriteItemLevelDataFromJson(json);
}

/// cube table
enum HarmonyCubeType {
  accuracy(1000301),
  chargeDamage(1000302),
  reload(1000303),
  gainAmmo(1000304),
  chargeSpeed(1000305),
  ammoCapacity(1000306),
  burst(1000307),
  maxHp(1000308),
  defence(1000309),
  healPotency(1000310),
  damageTakenDown(1000311),
  emergencyMaxHp(1000312), // 400180101
  parts(1000313)
  // pierce(100314)
  ;

  final int cubeId;

  const HarmonyCubeType(this.cubeId);

  @override
  String toString() {
    switch (this) {
      case HarmonyCubeType.accuracy:
        return 'Accuracy';
      case HarmonyCubeType.chargeDamage:
        return 'Charge Damage';
      case HarmonyCubeType.reload:
        return 'Reload Speed';
      case HarmonyCubeType.gainAmmo:
        return 'Ammo Regen';
      case HarmonyCubeType.chargeSpeed:
        return 'Charge Speed';
      case HarmonyCubeType.ammoCapacity:
        return 'Ammo Capacity';
      case HarmonyCubeType.burst:
        return 'Burst Gen';
      case HarmonyCubeType.maxHp:
        return 'Max Hp';
      case HarmonyCubeType.defence:
        return 'Defence';
      case HarmonyCubeType.healPotency:
        return 'Heal Potency';
      case HarmonyCubeType.damageTakenDown:
        return 'Damage Resist';
      case HarmonyCubeType.emergencyMaxHp:
        return 'Emergency Max Hp';
      case HarmonyCubeType.parts:
        return 'Parts Damage';
    }
  }

  String shortString() {
    switch (this) {
      case HarmonyCubeType.accuracy:
        return 'ACC';
      case HarmonyCubeType.chargeDamage:
        return 'CHD';
      case HarmonyCubeType.reload:
        return 'RLS';
      case HarmonyCubeType.gainAmmo:
        return 'AMR';
      case HarmonyCubeType.chargeSpeed:
        return 'CHS';
      case HarmonyCubeType.ammoCapacity:
        return 'AMC';
      case HarmonyCubeType.burst:
        return 'BRG';
      case HarmonyCubeType.maxHp:
        return 'MHP';
      case HarmonyCubeType.defence:
        return 'DEF';
      case HarmonyCubeType.healPotency:
        return 'HEL';
      case HarmonyCubeType.damageTakenDown:
        return 'DAR';
      case HarmonyCubeType.emergencyMaxHp:
        return 'EMH';
      case HarmonyCubeType.parts:
        return 'PTD';
    }
  }
}
