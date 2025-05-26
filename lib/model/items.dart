import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/db.dart';

import 'common.dart';

part '../generated/model/items.g.dart';

// ItemEquipTable
@JsonSerializable()
class EquipmentData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'resource_id')
  final String resourceId;
  @JsonKey(name: 'item_type')
  final ItemType itemType;
  @JsonKey(name: 'item_sub_type')
  final EquipType itemSubType;
  @JsonKey(name: 'class', unknownEnumValue: NikkeClass.unknown)
  final NikkeClass characterClass;
  @JsonKey(name: 'item_rare')
  final EquipRarity itemRarity;
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
    this.itemType = ItemType.equip,
    this.itemSubType = EquipType.unknown,
    this.characterClass = NikkeClass.unknown,
    this.itemRarity = EquipRarity.unknown,
    this.gradeCoreId = 0,
    this.growGrade = 0,
    this.stat = const [],
    this.optionSlots = const [],
    this.optionCost = 0,
    this.optionChangeCost = 0,
    this.optionLockCost = 0,
  });

  factory EquipmentData.fromJson(Map<String, dynamic> json) => _$EquipmentDataFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentDataToJson(this);
}

@JsonSerializable()
class EquipmentStat {
  @JsonKey(name: 'stat_type')
  final StatType statType;
  @JsonKey(name: 'stat_value')
  final int statValue;

  EquipmentStat({this.statType = StatType.none, this.statValue = 0});

  factory EquipmentStat.fromJson(Map<String, dynamic> json) => _$EquipmentStatFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentStatToJson(this);
}

@JsonSerializable()
class OptionSlot {
  @JsonKey(name: 'option_slot')
  final int optionSlot;
  @JsonKey(name: 'option_slot_success_ratio')
  final int optionSlotSuccessRatio;

  OptionSlot({this.optionSlot = 0, this.optionSlotSuccessRatio = 0});

  factory OptionSlot.fromJson(Map<String, dynamic> json) => _$OptionSlotFromJson(json);
  Map<String, dynamic> toJson() => _$OptionSlotToJson(this);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum ItemType { unknown, equip, harmonyCube }

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
    EquipRarity.unknown => -1,
    EquipRarity.t1 || EquipRarity.t2 => 0,
    EquipRarity.t3 || EquipRarity.t4 => 3,
    EquipRarity.t5 || EquipRarity.t6 => 4,
    EquipRarity.t7 || EquipRarity.t8 || EquipRarity.t9 || EquipRarity.t10 => 5,
  };

  bool get canHaveCorp => switch (this) {
    EquipRarity.unknown || EquipRarity.t1 || EquipRarity.t2 || EquipRarity.t3 || EquipRarity.t10 => false,
    EquipRarity.t4 || EquipRarity.t5 || EquipRarity.t6 || EquipRarity.t7 || EquipRarity.t8 || EquipRarity.t9 => true,
  };
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
  leg,
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
  statCriticalDamage(7001100),
  statCritical(7001200),
  statDef(7001300);

  final int stateEffectIdBase;

  const EquipLineType(this.stateEffectIdBase);
}

class EquipLine {
  EquipLineType type;
  int _level;
  int get level => _level;
  set level(int newLevel) => _level = newLevel.clamp(1, 15);

  EquipLine(this.type, this._level);

  EquipLine.onValue(this.type, int stat) : _level = 1 {
    for (int level = 1; level <= 15; level += 1) {
      _level = level;
      final stateEffectData = gameData.stateEffectTable[getStateEffectId()]!;
      for (final functionId in stateEffectData.functions) {
        if (functionId.function != 0) {
          final function = gameData.functionTable[functionId.function]!;
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
}

@JsonSerializable()
class HarmonyCubeSkillGroup {
  @JsonKey(name: 'skill_group_id')
  final int skillGroupId;

  HarmonyCubeSkillGroup({this.skillGroupId = 0});

  factory HarmonyCubeSkillGroup.fromJson(Map<String, dynamic> json) => _$HarmonyCubeSkillGroupFromJson(json);

  Map<String, dynamic> toJson() => _$HarmonyCubeSkillGroupToJson(this);
}

@JsonSerializable(explicitToJson: true)
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
  final ItemType itemType;
  @JsonKey(name: 'item_sub_type')
  final String itemSubType;
  @JsonKey(name: 'item_rare')
  final Rarity itemRare;
  @JsonKey(name: 'class')
  final NikkeClass characterClass;
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
    this.itemType = ItemType.harmonyCube,
    this.itemSubType = '',
    this.itemRare = Rarity.ssr,
    this.characterClass = NikkeClass.all,
    this.levelEnhanceId = 0,
    this.harmonyCubeSkillGroups = const [],
  });

  factory HarmonyCubeData.fromJson(Map<String, dynamic> json) => _$HarmonyCubeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HarmonyCubeDataToJson(this);
}

@JsonSerializable()
class HarmonyCubeSkillLevel {
  @JsonKey(name: 'skill_level')
  final int level;

  HarmonyCubeSkillLevel({this.level = 0});

  factory HarmonyCubeSkillLevel.fromJson(Map<String, dynamic> json) => _$HarmonyCubeSkillLevelFromJson(json);

  Map<String, dynamic> toJson() => _$HarmonyCubeSkillLevelToJson(this);
}

@JsonSerializable()
class HarmonyCubeStat {
  @JsonKey(name: 'stat_type')
  final StatType type;
  @JsonKey(name: 'stat_rate')
  final int rate;

  HarmonyCubeStat({this.type = StatType.unknown, this.rate = 0});

  factory HarmonyCubeStat.fromJson(Map<String, dynamic> json) => _$HarmonyCubeStatFromJson(json);

  Map<String, dynamic> toJson() => _$HarmonyCubeStatToJson(this);
}

@JsonSerializable(explicitToJson: true)
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

  Map<String, dynamic> toJson() => _$HarmonyCubeLevelDataToJson(this);
}

@JsonSerializable()
class CollectionItemSkillGroup {
  @JsonKey(name: 'collection_skill_id')
  final int skillId;

  CollectionItemSkillGroup({this.skillId = 0});

  factory CollectionItemSkillGroup.fromJson(Map<String, dynamic> json) => _$CollectionItemSkillGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionItemSkillGroupToJson(this);
}

@JsonSerializable()
class FavoriteItemSkillGroup {
  @JsonKey(name: 'favorite_skill_id')
  final int skillId;
  @JsonKey(name: 'skill_table')
  final SkillType skillTable;
  @JsonKey(name: 'skill_change_slot')
  final int skillChangeSlot;

  FavoriteItemSkillGroup({this.skillId = 0, this.skillTable = SkillType.none, this.skillChangeSlot = 0});

  factory FavoriteItemSkillGroup.fromJson(Map<String, dynamic> json) => _$FavoriteItemSkillGroupFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemSkillGroupToJson(this);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum FavoriteItemType { collection, favorite }

@JsonSerializable(explicitToJson: true)
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
  final Rarity favoriteRare;
  @JsonKey(name: 'favorite_type')
  final FavoriteItemType favoriteType;
  @JsonKey(name: 'weapon_type')
  final WeaponType weaponType;
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
    this.favoriteRare = Rarity.r,
    this.favoriteType = FavoriteItemType.collection,
    this.weaponType = WeaponType.none,
    this.nameCode = 0,
    this.maxLevel = 0,
    this.levelEnhanceId = 0,
    this.probabilityGroup = 0,
    this.collectionSkills = const [],
    this.favoriteItemSkills = const [],
    this.albumCategoryId = 0,
  });

  factory FavoriteItemData.fromJson(Map<String, dynamic> json) => _$FavoriteItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemDataToJson(this);
}

@JsonSerializable()
class FavoriteItemStat {
  @JsonKey(name: 'stat_type')
  final StatType type;
  @JsonKey(name: 'stat_value')
  final int value;

  FavoriteItemStat({this.type = StatType.unknown, this.value = 0});

  factory FavoriteItemStat.fromJson(Map<String, dynamic> json) => _$FavoriteItemStatFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemStatToJson(this);
}

@JsonSerializable()
class CollectionItemSkillLevel {
  @JsonKey(name: 'collection_skill_level')
  final int level;

  CollectionItemSkillLevel({this.level = 0});

  factory CollectionItemSkillLevel.fromJson(Map<String, dynamic> json) => _$CollectionItemSkillLevelFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionItemSkillLevelToJson(this);
}

@JsonSerializable(explicitToJson: true)
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

  Map<String, dynamic> toJson() => _$FavoriteItemLevelDataToJson(this);
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
}
