// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/battle/equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleEquipmentOption _$BattleEquipmentOptionFromJson(Map<String, dynamic> json) => BattleEquipmentOption(
  type: $enumDecode(_$EquipTypeEnumMap, json['type']),
  equipClass: $enumDecode(_$NikkeClassEnumMap, json['equipClass']),
  rarity: $enumDecode(_$EquipRarityEnumMap, json['rarity']),
  corporation: $enumDecodeNullable(_$CorporationEnumMap, json['corporation']) ?? Corporation.none,
  level: (json['level'] as num?)?.toInt() ?? 0,
  equipLines:
      (json['equipLines'] as List<dynamic>?)?.map((e) => EquipLine.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
);

Map<String, dynamic> _$BattleEquipmentOptionToJson(BattleEquipmentOption instance) => <String, dynamic>{
  'type': _$EquipTypeEnumMap[instance.type]!,
  'equipClass': _$NikkeClassEnumMap[instance.equipClass]!,
  'rarity': _$EquipRarityEnumMap[instance.rarity]!,
  'corporation': _$CorporationEnumMap[instance.corporation]!,
  'level': instance.level,
  'equipLines': instance.equipLines.map((e) => e.toJson()).toList(),
};

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

const _$CorporationEnumMap = {
  Corporation.unknown: 'UNKNOWN',
  Corporation.none: 'NONE',
  Corporation.missilis: 'MISSILIS',
  Corporation.elysion: 'ELYSION',
  Corporation.tetra: 'TETRA',
  Corporation.pilgrim: 'PILGRIM',
  Corporation.abnormal: 'ABNORMAL',
};
