// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/battle/battle_simulator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattlePlayerOptions _$BattlePlayerOptionsFromJson(Map<String, dynamic> json) => BattlePlayerOptions(
  personalRecycleLevel: (json['personalRecycleLevel'] as num?)?.toInt() ?? 0,
  corpRecycleLevels:
      (json['corpRecycleLevels'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$CorporationEnumMap, k), (e as num).toInt()),
      ) ??
      const {},
  classRecycleLevels:
      (json['classRecycleLevels'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$NikkeClassEnumMap, k), (e as num).toInt()),
      ) ??
      const {},
  forceFillBurst: json['forceFillBurst'] as bool? ?? false,
);

Map<String, dynamic> _$BattlePlayerOptionsToJson(BattlePlayerOptions instance) => <String, dynamic>{
  'personalRecycleLevel': instance.personalRecycleLevel,
  'corpRecycleLevels': instance.corpRecycleLevels.map((k, e) => MapEntry(_$CorporationEnumMap[k]!, e)),
  'classRecycleLevels': instance.classRecycleLevels.map((k, e) => MapEntry(_$NikkeClassEnumMap[k]!, e)),
  'forceFillBurst': instance.forceFillBurst,
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

const _$NikkeClassEnumMap = {
  NikkeClass.unknown: 'Unknown',
  NikkeClass.attacker: 'Attacker',
  NikkeClass.defender: 'Defender',
  NikkeClass.supporter: 'Supporter',
  NikkeClass.all: 'All',
};
