// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentData _$EquipmentDataFromJson(Map<String, dynamic> json) => EquipmentData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  resourceId: json['resource_id'] as String? ?? '',
  rawItemType: json['item_type'] as String? ?? '',
  rawItemSubType: json['item_sub_type'] as String? ?? '',
  rawCharacterClass: json['class'] as String? ?? '',
  rawItemRarity: json['item_rare'] as String? ?? '',
  gradeCoreId: (json['grade_core_id'] as num?)?.toInt() ?? 0,
  growGrade: (json['grow_grade'] as num?)?.toInt() ?? 0,
  stat:
      (json['stat'] as List<dynamic>?)?.map((e) => EquipmentStat.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  optionSlots:
      (json['option_slot'] as List<dynamic>?)?.map((e) => OptionSlot.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  optionCost: (json['option_cost'] as num?)?.toInt() ?? 0,
  optionChangeCost: (json['option_change_cost'] as num?)?.toInt() ?? 0,
  optionLockCost: (json['option_lock_cost'] as num?)?.toInt() ?? 0,
);

EquipmentStat _$EquipmentStatFromJson(Map<String, dynamic> json) => EquipmentStat(
  rawStatType: json['stat_type'] as String? ?? '',
  statValue: (json['stat_value'] as num?)?.toInt() ?? 0,
);

OptionSlot _$OptionSlotFromJson(Map<String, dynamic> json) => OptionSlot(
  optionSlot: (json['option_slot'] as num?)?.toInt() ?? 0,
  optionSlotSuccessRatio: (json['option_slot_success_ratio'] as num?)?.toInt() ?? 0,
);

EquipLine _$EquipLineFromJson(Map<String, dynamic> json) =>
    EquipLine($enumDecode(_$EquipLineTypeEnumMap, json['type']), (json['level'] as num).toInt());

Map<String, dynamic> _$EquipLineToJson(EquipLine instance) => <String, dynamic>{
  'type': _$EquipLineTypeEnumMap[instance.type]!,
  'level': instance.level,
};

const _$EquipLineTypeEnumMap = {
  EquipLineType.none: 'none',
  EquipLineType.statAtk: 'statAtk',
  EquipLineType.statDef: 'statDef',
  EquipLineType.increaseElementalDamage: 'increaseElementalDamage',
  EquipLineType.statCriticalDamage: 'statCriticalDamage',
  EquipLineType.statCritical: 'statCritical',
  EquipLineType.statAmmo: 'statAmmo',
  EquipLineType.statChargeDamage: 'statChargeDamage',
  EquipLineType.statChargeTime: 'statChargeTime',
  EquipLineType.startAccuracyCircle: 'startAccuracyCircle',
};

HarmonyCubeSkillGroup _$HarmonyCubeSkillGroupFromJson(Map<String, dynamic> json) =>
    HarmonyCubeSkillGroup(skillGroupId: (json['skill_group_id'] as num?)?.toInt() ?? 0);

HarmonyCubeData _$HarmonyCubeDataFromJson(Map<String, dynamic> json) => HarmonyCubeData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  locationId: (json['location_id'] as num?)?.toInt() ?? 0,
  locationLocalkey: json['location_localkey'] as String? ?? '',
  order: (json['order'] as num?)?.toInt() ?? 0,
  resourceId: (json['resource_id'] as num?)?.toInt() ?? 0,
  bg: json['bg'] as String? ?? '',
  bgColor: json['bg_color'] as String? ?? '',
  rawItemType: json['item_type'] as String? ?? '',
  itemSubType: json['item_sub_type'] as String? ?? '',
  rawItemRare: json['item_rare'] as String? ?? '',
  rawCharacterClass: json['class'] as String? ?? '',
  levelEnhanceId: (json['level_enhance_id'] as num?)?.toInt() ?? 0,
  harmonyCubeSkillGroups:
      (json['harmonycube_skill_group'] as List<dynamic>?)
          ?.map((e) => HarmonyCubeSkillGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

HarmonyCubeSkillLevel _$HarmonyCubeSkillLevelFromJson(Map<String, dynamic> json) =>
    HarmonyCubeSkillLevel(level: (json['skill_level'] as num?)?.toInt() ?? 0);

HarmonyCubeStat _$HarmonyCubeStatFromJson(Map<String, dynamic> json) =>
    HarmonyCubeStat(rawType: json['stat_type'] as String? ?? '', rate: (json['stat_rate'] as num?)?.toInt() ?? 0);

HarmonyCubeLevelData _$HarmonyCubeLevelDataFromJson(Map<String, dynamic> json) => HarmonyCubeLevelData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  levelEnhanceId: (json['level_enhance_id'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 0,
  skillLevels:
      (json['skill_levels'] as List<dynamic>?)
          ?.map((e) => HarmonyCubeSkillLevel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  materialId: (json['material_id'] as num?)?.toInt() ?? 0,
  materialValue: (json['material_value'] as num?)?.toInt() ?? 0,
  goldValue: (json['gold_value'] as num?)?.toInt() ?? 0,
  slot: (json['slot'] as num?)?.toInt() ?? 0,
  stats:
      (json['harmonycube_stats'] as List<dynamic>?)
          ?.map((e) => HarmonyCubeStat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

CollectionItemSkillGroup _$CollectionItemSkillGroupFromJson(Map<String, dynamic> json) =>
    CollectionItemSkillGroup(skillId: (json['collection_skill_id'] as num?)?.toInt() ?? 0);

FavoriteItemSkillGroup _$FavoriteItemSkillGroupFromJson(Map<String, dynamic> json) => FavoriteItemSkillGroup(
  skillId: (json['favorite_skill_id'] as num?)?.toInt() ?? 0,
  rawSkillTable: json['skill_table'] as String? ?? '',
  skillChangeSlot: (json['skill_change_slot'] as num?)?.toInt() ?? 0,
);

FavoriteItemData _$FavoriteItemDataFromJson(Map<String, dynamic> json) => FavoriteItemData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  iconResourceId: json['icon_resource_id'] as String? ?? '',
  imgResourceId: json['img_resource_id'] as String? ?? '',
  propResourceId: json['prop_resource_id'] as String? ?? '',
  order: (json['order'] as num?)?.toInt() ?? 0,
  rawFavoriteRare: json['favorite_rare'] as String? ?? '',
  rawFavoriteType: json['favorite_type'] as String? ?? '',
  rawWeaponType: json['weapon_type'] as String? ?? '',
  nameCode: (json['name_code'] as num?)?.toInt() ?? 0,
  maxLevel: (json['max_level'] as num?)?.toInt() ?? 0,
  levelEnhanceId: (json['level_enhance_id'] as num?)?.toInt() ?? 0,
  probabilityGroup: (json['probability_group'] as num?)?.toInt() ?? 0,
  collectionSkills:
      (json['collection_skill_group_data'] as List<dynamic>?)
          ?.map((e) => CollectionItemSkillGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  favoriteItemSkills:
      (json['favoriteitem_skill_group_data'] as List<dynamic>?)
          ?.map((e) => FavoriteItemSkillGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  albumCategoryId: (json['albumcategory_id'] as num?)?.toInt() ?? 0,
);

FavoriteItemStat _$FavoriteItemStatFromJson(Map<String, dynamic> json) =>
    FavoriteItemStat(rawType: json['stat_type'] as String? ?? '', value: (json['stat_value'] as num?)?.toInt() ?? 0);

CollectionItemSkillLevel _$CollectionItemSkillLevelFromJson(Map<String, dynamic> json) =>
    CollectionItemSkillLevel(level: (json['collection_skill_level'] as num?)?.toInt() ?? 0);

FavoriteItemLevelData _$FavoriteItemLevelDataFromJson(Map<String, dynamic> json) => FavoriteItemLevelData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  levelEnhanceId: (json['level_enhance_id'] as num?)?.toInt() ?? 0,
  grade: (json['grade'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 0,
  stats:
      (json['favoriteitem_stat_data'] as List<dynamic>?)
          ?.map((e) => FavoriteItemStat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  skillLevels:
      (json['collection_skill_level_data'] as List<dynamic>?)
          ?.map((e) => CollectionItemSkillLevel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);
