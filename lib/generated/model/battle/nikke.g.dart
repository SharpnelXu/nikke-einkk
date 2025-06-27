// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/battle/nikke.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleNikkeOptions _$BattleNikkeOptionsFromJson(Map<String, dynamic> json) => BattleNikkeOptions(
  nikkeResourceId: (json['nikkeResourceId'] as num).toInt(),
  coreLevel: (json['coreLevel'] as num?)?.toInt() ?? 1,
  syncLevel: (json['syncLevel'] as num?)?.toInt() ?? 1,
  attractLevel: (json['attractLevel'] as num?)?.toInt() ?? 1,
  equips:
      (json['equips'] as List<dynamic>?)
          ?.map((e) => e == null ? null : BattleEquipmentOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [null, null, null, null],
  skillLevels: (json['skillLevels'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [10, 10, 10],
  cube: json['cube'] == null ? null : BattleHarmonyCube.fromJson(json['cube'] as Map<String, dynamic>),
  favoriteItem:
      json['favoriteItem'] == null ? null : BattleFavoriteItem.fromJson(json['favoriteItem'] as Map<String, dynamic>),
  alwaysFocus: json['alwaysFocus'] as bool? ?? false,
  forceCancelShootDelay: json['forceCancelShootDelay'] as bool? ?? false,
  chargeMode: $enumDecodeNullable(_$NikkeFullChargeModeEnumMap, json['chargeMode']) ?? NikkeFullChargeMode.always,
);

Map<String, dynamic> _$BattleNikkeOptionsToJson(BattleNikkeOptions instance) => <String, dynamic>{
  'nikkeResourceId': instance.nikkeResourceId,
  'coreLevel': instance.coreLevel,
  'syncLevel': instance.syncLevel,
  'attractLevel': instance.attractLevel,
  'equips': instance.equips.map((e) => e?.toJson()).toList(),
  'skillLevels': instance.skillLevels,
  'cube': instance.cube?.toJson(),
  'favoriteItem': instance.favoriteItem?.toJson(),
  'alwaysFocus': instance.alwaysFocus,
  'forceCancelShootDelay': instance.forceCancelShootDelay,
  'chargeMode': _$NikkeFullChargeModeEnumMap[instance.chargeMode]!,
};

const _$NikkeFullChargeModeEnumMap = {
  NikkeFullChargeMode.always: 'always',
  NikkeFullChargeMode.never: 'never',
  NikkeFullChargeMode.whenExitingBurst: 'whenExitingBurst',
};
