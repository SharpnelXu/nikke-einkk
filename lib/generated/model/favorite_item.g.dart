// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/favorite_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteItemOption _$FavoriteItemOptionFromJson(Map<String, dynamic> json) => FavoriteItemOption(
  weaponType: $enumDecode(_$WeaponTypeEnumMap, json['weaponType']),
  rarity: $enumDecode(_$RarityEnumMap, json['rarity']),
  level: (json['level'] as num?)?.toInt() ?? 0,
  nameCode: (json['nameCode'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FavoriteItemOptionToJson(FavoriteItemOption instance) => <String, dynamic>{
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
