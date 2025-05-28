// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/battle/harmony_cube.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattleHarmonyCube _$BattleHarmonyCubeFromJson(Map<String, dynamic> json) =>
    BattleHarmonyCube($enumDecode(_$HarmonyCubeTypeEnumMap, json['type']), (json['cubeLevel'] as num).toInt());

Map<String, dynamic> _$BattleHarmonyCubeToJson(BattleHarmonyCube instance) => <String, dynamic>{
  'type': _$HarmonyCubeTypeEnumMap[instance.type]!,
  'cubeLevel': instance.cubeLevel,
};

const _$HarmonyCubeTypeEnumMap = {
  HarmonyCubeType.accuracy: 'accuracy',
  HarmonyCubeType.chargeDamage: 'chargeDamage',
  HarmonyCubeType.reload: 'reload',
  HarmonyCubeType.gainAmmo: 'gainAmmo',
  HarmonyCubeType.chargeSpeed: 'chargeSpeed',
  HarmonyCubeType.ammoCapacity: 'ammoCapacity',
  HarmonyCubeType.burst: 'burst',
  HarmonyCubeType.maxHp: 'maxHp',
  HarmonyCubeType.defence: 'defence',
  HarmonyCubeType.healPotency: 'healPotency',
  HarmonyCubeType.damageTakenDown: 'damageTakenDown',
  HarmonyCubeType.emergencyMaxHp: 'emergencyMaxHp',
  HarmonyCubeType.parts: 'parts',
};
