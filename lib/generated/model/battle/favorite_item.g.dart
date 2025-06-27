// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/battle/favorite_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleFavoriteItemOption _$BattleFavoriteItemOptionFromJson(Map<String, dynamic> json) => BattleFavoriteItemOption(
  weaponType: $enumDecode(_$WeaponTypeEnumMap, json['weaponType']),
  rarity: $enumDecode(_$RarityEnumMap, json['rarity']),
  level: (json['level'] as num?)?.toInt() ?? 0,
  nameCode: (json['nameCode'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BattleFavoriteItemOptionToJson(BattleFavoriteItemOption instance) => <String, dynamic>{
  'weaponType': _$WeaponTypeEnumMap[instance.weaponType]!,
  'rarity': _$RarityEnumMap[instance.rarity]!,
  'level': instance.level,
  'nameCode': instance.nameCode,
};

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

const _$RarityEnumMap = {Rarity.unknown: 'UNKNOWN', Rarity.ssr: 'SSR', Rarity.sr: 'SR', Rarity.r: 'R'};
