// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  language: $enumDecodeNullable(_$LanguageEnumMap, json['language']) ?? Language.en,
  globalPlayerOptions:
      json['globalPlayerOptions'] == null
          ? null
          : BattlePlayerOptions.fromJson(json['globalPlayerOptions'] as Map<String, dynamic>),
  globalNikkeOptions:
      (json['globalNikkeOptions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), BattleNikkeOptions.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  cnPlayerOptions:
      json['cnPlayerOptions'] == null
          ? null
          : BattlePlayerOptions.fromJson(json['cnPlayerOptions'] as Map<String, dynamic>),
  cnNikkeOptions:
      (json['cnNikkeOptions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), BattleNikkeOptions.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'language': _$LanguageEnumMap[instance.language]!,
  'globalPlayerOptions': instance.globalPlayerOptions.toJson(),
  'globalNikkeOptions': instance.globalNikkeOptions.map((k, e) => MapEntry(k.toString(), e.toJson())),
  'cnPlayerOptions': instance.cnPlayerOptions.toJson(),
  'cnNikkeOptions': instance.cnNikkeOptions.map((k, e) => MapEntry(k.toString(), e.toJson())),
};

const _$LanguageEnumMap = {
  Language.unknown: 'unknown',
  Language.ko: 'ko',
  Language.en: 'en',
  Language.ja: 'ja',
  Language.zhTW: 'zhTW',
  Language.zhCN: 'zhCN',
  Language.th: 'th',
  Language.de: 'de',
  Language.fr: 'fr',
  Language.debug: 'debug',
};

BattleSetup _$BattleSetupFromJson(Map<String, dynamic> json) => BattleSetup(
  playerOptions: BattlePlayerOptions.fromJson(json['playerOptions'] as Map<String, dynamic>),
  nikkeOptions:
      (json['nikkeOptions'] as List<dynamic>?)
          ?.map((e) => BattleNikkeOptions.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  raptureOptions: BattleRaptureOptions.fromJson(json['raptureOptions'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BattleSetupToJson(BattleSetup instance) => <String, dynamic>{
  'playerOptions': instance.playerOptions.toJson(),
  'nikkeOptions': instance.nikkeOptions.map((e) => e.toJson()).toList(),
  'raptureOptions': instance.raptureOptions.toJson(),
};
