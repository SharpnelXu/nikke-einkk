// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EquipmentItemData _$EquipmentItemDataFromJson(Map<String, dynamic> json) => EquipmentItemData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  resourceId: json['resource_id'] as String? ?? '',
  itemType: $enumDecodeNullable(_$ItemTypeEnumMap, json['item_type']) ?? ItemType.equip,
  itemSubType: $enumDecodeNullable(_$EquipTypeEnumMap, json['item_sub_type']) ?? EquipType.unknown,
  characterClass: $enumDecodeNullable(_$NikkeClassEnumMap, json['class']) ?? NikkeClass.unknown,
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

Map<String, dynamic> _$EquipmentItemDataToJson(EquipmentItemData instance) => <String, dynamic>{
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
  'stat': instance.stat,
  'option_slot': instance.optionSlots,
  'option_cost': instance.optionCost,
  'option_change_cost': instance.optionChangeCost,
  'option_lock_cost': instance.optionLockCost,
};

const _$ItemTypeEnumMap = {ItemType.unknown: 'Unknown', ItemType.equip: 'Equip'};

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
  statType: $enumDecodeNullable(_$StatTypeEnumMap, json['statType']) ?? StatType.none,
  statValue: (json['statValue'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EquipmentStatToJson(EquipmentStat instance) => <String, dynamic>{
  'statType': _$StatTypeEnumMap[instance.statType]!,
  'statValue': instance.statValue,
};

const _$StatTypeEnumMap = {
  StatType.atk: 'Atk',
  StatType.defence: 'Defence',
  StatType.hp: 'Hp',
  StatType.none: 'None',
  StatType.unknown: 'Unknown',
};

OptionSlot _$OptionSlotFromJson(Map<String, dynamic> json) => OptionSlot(
  optionSlot: (json['optionSlot'] as num?)?.toInt() ?? 0,
  optionSlotSuccessRatio: (json['optionSlotSuccessRatio'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OptionSlotToJson(OptionSlot instance) => <String, dynamic>{
  'optionSlot': instance.optionSlot,
  'optionSlotSuccessRatio': instance.optionSlotSuccessRatio,
};
