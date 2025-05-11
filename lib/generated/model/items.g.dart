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
  itemType: $enumDecodeNullable(_$ItemTypeEnumMap, json['item_type']) ?? ItemType.equip,
  itemSubType: $enumDecodeNullable(_$EquipTypeEnumMap, json['item_sub_type']) ?? EquipType.unknown,
  characterClass:
      $enumDecodeNullable(_$NikkeClassEnumMap, json['class'], unknownValue: NikkeClass.unknown) ?? NikkeClass.unknown,
  itemRarity: $enumDecodeNullable(_$EquipRarityEnumMap, json['item_rare']) ?? EquipRarity.unknown,
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

Map<String, dynamic> _$EquipmentDataToJson(EquipmentData instance) => <String, dynamic>{
  'id': instance.id,
  'name_localkey': instance.nameLocalkey,
  'description_localkey': instance.descriptionLocalkey,
  'resource_id': instance.resourceId,
  'item_type': _$ItemTypeEnumMap[instance.itemType]!,
  'item_sub_type': _$EquipTypeEnumMap[instance.itemSubType]!,
  'class': _$NikkeClassEnumMap[instance.characterClass]!,
  'item_rare': _$EquipRarityEnumMap[instance.itemRarity]!,
  'grade_core_id': instance.gradeCoreId,
  'grow_grade': instance.growGrade,
  'stat': instance.stat.map((e) => e.toJson()).toList(),
  'option_slot': instance.optionSlots.map((e) => e.toJson()).toList(),
  'option_cost': instance.optionCost,
  'option_change_cost': instance.optionChangeCost,
  'option_lock_cost': instance.optionLockCost,
};

const _$ItemTypeEnumMap = {ItemType.unknown: 'Unknown', ItemType.equip: 'Equip', ItemType.harmonyCube: 'HarmonyCube'};

const _$EquipTypeEnumMap = {
  EquipType.unknown: 'unknown',
  EquipType.head: 'Module_A',
  EquipType.body: 'Module_B',
  EquipType.arm: 'Module_C',
  EquipType.leg: 'Module_D',
};

const _$NikkeClassEnumMap = {
  NikkeClass.unknown: 'Unknown',
  NikkeClass.attacker: 'Attacker',
  NikkeClass.defender: 'Defender',
  NikkeClass.supporter: 'Supporter',
  NikkeClass.all: 'All',
};

const _$EquipRarityEnumMap = {
  EquipRarity.unknown: 'UNKNOWN',
  EquipRarity.t1: 'T1',
  EquipRarity.t2: 'T2',
  EquipRarity.t3: 'T3',
  EquipRarity.t4: 'T4',
  EquipRarity.t5: 'T5',
  EquipRarity.t6: 'T6',
  EquipRarity.t7: 'T7',
  EquipRarity.t8: 'T8',
  EquipRarity.t9: 'T9',
  EquipRarity.t10: 'T10',
};

EquipmentStat _$EquipmentStatFromJson(Map<String, dynamic> json) => EquipmentStat(
  statType: $enumDecodeNullable(_$StatTypeEnumMap, json['stat_type']) ?? StatType.none,
  statValue: (json['stat_value'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EquipmentStatToJson(EquipmentStat instance) => <String, dynamic>{
  'stat_type': _$StatTypeEnumMap[instance.statType]!,
  'stat_value': instance.statValue,
};

const _$StatTypeEnumMap = {
  StatType.atk: 'Atk',
  StatType.defence: 'Defence',
  StatType.hp: 'Hp',
  StatType.none: 'None',
  StatType.unknown: 'Unknown',
};

OptionSlot _$OptionSlotFromJson(Map<String, dynamic> json) => OptionSlot(
  optionSlot: (json['option_slot'] as num?)?.toInt() ?? 0,
  optionSlotSuccessRatio: (json['option_slot_success_ratio'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OptionSlotToJson(OptionSlot instance) => <String, dynamic>{
  'option_slot': instance.optionSlot,
  'option_slot_success_ratio': instance.optionSlotSuccessRatio,
};

HarmonyCubeSkillGroup _$HarmonyCubeSkillGroupFromJson(Map<String, dynamic> json) =>
    HarmonyCubeSkillGroup(skillGroupId: (json['skill_group_id'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$HarmonyCubeSkillGroupToJson(HarmonyCubeSkillGroup instance) => <String, dynamic>{
  'skill_group_id': instance.skillGroupId,
};

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
  itemType: $enumDecodeNullable(_$ItemTypeEnumMap, json['item_type']) ?? ItemType.harmonyCube,
  itemSubType: json['item_sub_type'] as String? ?? '',
  itemRare: $enumDecodeNullable(_$RarityEnumMap, json['item_rare']) ?? Rarity.ssr,
  characterClass: $enumDecodeNullable(_$NikkeClassEnumMap, json['class']) ?? NikkeClass.all,
  levelEnhanceId: (json['level_enhance_id'] as num?)?.toInt() ?? 0,
  harmonyCubeSkillGroups:
      (json['harmonycube_skill_group'] as List<dynamic>?)
          ?.map((e) => HarmonyCubeSkillGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HarmonyCubeDataToJson(HarmonyCubeData instance) => <String, dynamic>{
  'id': instance.id,
  'name_localkey': instance.nameLocalkey,
  'description_localkey': instance.descriptionLocalkey,
  'location_id': instance.locationId,
  'location_localkey': instance.locationLocalkey,
  'order': instance.order,
  'resource_id': instance.resourceId,
  'bg': instance.bg,
  'bg_color': instance.bgColor,
  'item_type': _$ItemTypeEnumMap[instance.itemType]!,
  'item_sub_type': instance.itemSubType,
  'item_rare': _$RarityEnumMap[instance.itemRare]!,
  'class': _$NikkeClassEnumMap[instance.characterClass]!,
  'level_enhance_id': instance.levelEnhanceId,
  'harmonycube_skill_group': instance.harmonyCubeSkillGroups.map((e) => e.toJson()).toList(),
};

const _$RarityEnumMap = {Rarity.unknown: 'UNKNOWN', Rarity.ssr: 'SSR', Rarity.sr: 'SR', Rarity.r: 'R'};

HarmonyCubeSkillLevel _$HarmonyCubeSkillLevelFromJson(Map<String, dynamic> json) =>
    HarmonyCubeSkillLevel(level: (json['skill_level'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$HarmonyCubeSkillLevelToJson(HarmonyCubeSkillLevel instance) => <String, dynamic>{
  'skill_level': instance.level,
};

HarmonyCubeStat _$HarmonyCubeStatFromJson(Map<String, dynamic> json) => HarmonyCubeStat(
  type: $enumDecodeNullable(_$StatTypeEnumMap, json['stat_type']) ?? StatType.unknown,
  rate: (json['stat_rate'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HarmonyCubeStatToJson(HarmonyCubeStat instance) => <String, dynamic>{
  'stat_type': _$StatTypeEnumMap[instance.type]!,
  'stat_rate': instance.rate,
};

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

Map<String, dynamic> _$HarmonyCubeLevelDataToJson(HarmonyCubeLevelData instance) => <String, dynamic>{
  'id': instance.id,
  'level_enhance_id': instance.levelEnhanceId,
  'level': instance.level,
  'skill_levels': instance.skillLevels.map((e) => e.toJson()).toList(),
  'material_id': instance.materialId,
  'material_value': instance.materialValue,
  'gold_value': instance.goldValue,
  'slot': instance.slot,
  'harmonycube_stats': instance.stats.map((e) => e.toJson()).toList(),
};

CollectionItemSkillGroup _$CollectionItemSkillGroupFromJson(Map<String, dynamic> json) =>
    CollectionItemSkillGroup(skillId: (json['collection_skill_id'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$CollectionItemSkillGroupToJson(CollectionItemSkillGroup instance) => <String, dynamic>{
  'collection_skill_id': instance.skillId,
};

FavoriteItemSkillGroup _$FavoriteItemSkillGroupFromJson(Map<String, dynamic> json) => FavoriteItemSkillGroup(
  skillId: (json['favorite_skill_id'] as num?)?.toInt() ?? 0,
  skillTable: $enumDecodeNullable(_$SkillTypeEnumMap, json['skill_table']) ?? SkillType.none,
  skillChangeSlot: (json['skill_change_slot'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FavoriteItemSkillGroupToJson(FavoriteItemSkillGroup instance) => <String, dynamic>{
  'favorite_skill_id': instance.skillId,
  'skill_table': _$SkillTypeEnumMap[instance.skillTable]!,
  'skill_change_slot': instance.skillChangeSlot,
};

const _$SkillTypeEnumMap = {
  SkillType.none: 'None',
  SkillType.stateEffect: 'StateEffect',
  SkillType.characterSkill: 'CharacterSkill',
  SkillType.unknown: 'Unknown',
};

FavoriteItemData _$FavoriteItemDataFromJson(Map<String, dynamic> json) => FavoriteItemData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  iconResourceId: json['icon_resource_id'] as String? ?? '',
  imgResourceId: json['img_resource_id'] as String? ?? '',
  propResourceId: json['prop_resource_id'] as String? ?? '',
  order: (json['order'] as num?)?.toInt() ?? 0,
  favoriteRare: $enumDecodeNullable(_$RarityEnumMap, json['favorite_rare']) ?? Rarity.r,
  favoriteType: $enumDecodeNullable(_$FavoriteItemTypeEnumMap, json['favorite_type']) ?? FavoriteItemType.collection,
  weaponType: $enumDecodeNullable(_$WeaponTypeEnumMap, json['weapon_type']) ?? WeaponType.none,
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

Map<String, dynamic> _$FavoriteItemDataToJson(FavoriteItemData instance) => <String, dynamic>{
  'id': instance.id,
  'name_localkey': instance.nameLocalkey,
  'description_localkey': instance.descriptionLocalkey,
  'icon_resource_id': instance.iconResourceId,
  'img_resource_id': instance.imgResourceId,
  'prop_resource_id': instance.propResourceId,
  'order': instance.order,
  'favorite_rare': _$RarityEnumMap[instance.favoriteRare]!,
  'favorite_type': _$FavoriteItemTypeEnumMap[instance.favoriteType]!,
  'weapon_type': _$WeaponTypeEnumMap[instance.weaponType]!,
  'name_code': instance.nameCode,
  'max_level': instance.maxLevel,
  'level_enhance_id': instance.levelEnhanceId,
  'probability_group': instance.probabilityGroup,
  'collection_skill_group_data': instance.collectionSkills.map((e) => e.toJson()).toList(),
  'favoriteitem_skill_group_data': instance.favoriteItemSkills.map((e) => e.toJson()).toList(),
  'albumcategory_id': instance.albumCategoryId,
};

const _$FavoriteItemTypeEnumMap = {FavoriteItemType.collection: 'Collection', FavoriteItemType.favorite: 'Favorite'};

const _$WeaponTypeEnumMap = {
  WeaponType.unknown: 'unknown',
  WeaponType.none: 'None',
  WeaponType.ar: 'AR',
  WeaponType.mg: 'MG',
  WeaponType.rl: 'RL',
  WeaponType.sg: 'SG',
  WeaponType.smg: 'SMG',
  WeaponType.sr: 'SR',
};

FavoriteItemStat _$FavoriteItemStatFromJson(Map<String, dynamic> json) => FavoriteItemStat(
  type: $enumDecodeNullable(_$StatTypeEnumMap, json['stat_type']) ?? StatType.unknown,
  value: (json['stat_value'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FavoriteItemStatToJson(FavoriteItemStat instance) => <String, dynamic>{
  'stat_type': _$StatTypeEnumMap[instance.type]!,
  'stat_value': instance.value,
};

CollectionItemSkillLevel _$CollectionItemSkillLevelFromJson(Map<String, dynamic> json) =>
    CollectionItemSkillLevel(level: (json['collection_skill_level'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$CollectionItemSkillLevelToJson(CollectionItemSkillLevel instance) => <String, dynamic>{
  'collection_skill_level': instance.level,
};

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

Map<String, dynamic> _$FavoriteItemLevelDataToJson(FavoriteItemLevelData instance) => <String, dynamic>{
  'id': instance.id,
  'level_enhance_id': instance.levelEnhanceId,
  'grade': instance.grade,
  'level': instance.level,
  'favoriteitem_stat_data': instance.stats.map((e) => e.toJson()).toList(),
  'collection_skill_level_data': instance.skillLevels.map((e) => e.toJson()).toList(),
};
