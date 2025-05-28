// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  playerOptions:
      json['playerOptions'] == null
          ? null
          : BattlePlayerOptions.fromJson(json['playerOptions'] as Map<String, dynamic>),
  nikkeOptions:
      (json['nikkeOptions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), BattleNikkeOptions.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  cubes:
      (json['cubes'] as List<dynamic>?)?.map((e) => BattleHarmonyCube.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'playerOptions': instance.playerOptions.toJson(),
  'nikkeOptions': instance.nikkeOptions.map((k, e) => MapEntry(k.toString(), e.toJson())),
  'cubes': instance.cubes.map((e) => e.toJson()).toList(),
};
