// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerOptions _$PlayerOptionsFromJson(Map<String, dynamic> json) => PlayerOptions(
  globalSync: (json['globalSync'] as num?)?.toInt() ?? 1,
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
);

Map<String, dynamic> _$PlayerOptionsToJson(PlayerOptions instance) => <String, dynamic>{
  'globalSync': instance.globalSync,
  'personalRecycleLevel': instance.personalRecycleLevel,
  'corpRecycleLevels': instance.corpRecycleLevels.map((k, e) => MapEntry(_$CorporationEnumMap[k]!, e)),
  'classRecycleLevels': instance.classRecycleLevels.map((k, e) => MapEntry(_$NikkeClassEnumMap[k]!, e)),
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

NikkeOptions _$NikkeOptionsFromJson(Map<String, dynamic> json) => NikkeOptions(
  nikkeResourceId: (json['nikkeResourceId'] as num).toInt(),
  coreLevel: (json['coreLevel'] as num?)?.toInt() ?? 1,
  syncLevel: (json['syncLevel'] as num?)?.toInt() ?? 1,
  attractLevel: (json['attractLevel'] as num?)?.toInt() ?? 1,
  equips:
      (json['equips'] as List<dynamic>?)
          ?.map((e) => e == null ? null : EquipmentOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [null, null, null, null],
  skillLevels: (json['skillLevels'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [10, 10, 10],
  cube: json['cube'] == null ? null : HarmonyCubeOption.fromJson(json['cube'] as Map<String, dynamic>),
  favoriteItem:
      json['favoriteItem'] == null ? null : FavoriteItemOption.fromJson(json['favoriteItem'] as Map<String, dynamic>),
  alwaysFocus: json['alwaysFocus'] as bool? ?? false,
  forceCancelShootDelay: json['forceCancelShootDelay'] as bool? ?? false,
  chargeMode: $enumDecodeNullable(_$NikkeFullChargeModeEnumMap, json['chargeMode']) ?? NikkeFullChargeMode.always,
);

Map<String, dynamic> _$NikkeOptionsToJson(NikkeOptions instance) => <String, dynamic>{
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

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  language: $enumDecodeNullable(_$LanguageEnumMap, json['language']) ?? Language.en,
  globalPlayerOptions:
      json['globalPlayerOptions'] == null
          ? null
          : PlayerOptions.fromJson(json['globalPlayerOptions'] as Map<String, dynamic>),
  globalNikkeOptions:
      (json['globalNikkeOptions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), NikkeOptions.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  cnPlayerOptions:
      json['cnPlayerOptions'] == null ? null : PlayerOptions.fromJson(json['cnPlayerOptions'] as Map<String, dynamic>),
  cnNikkeOptions:
      (json['cnNikkeOptions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), NikkeOptions.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  globalCubeLvs:
      (json['globalCubeLvs'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(int.parse(k), (e as num).toInt())) ??
      const {},
  cnCubeLvs:
      (json['cnCubeLvs'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(int.parse(k), (e as num).toInt())) ??
      const {},
  themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ?? ThemeMode.system,
  defaultWindowHeight: (json['defaultWindowHeight'] as num?)?.toDouble() ?? 1200,
  defaultWindowWidth: (json['defaultWindowWidth'] as num?)?.toDouble() ?? 1800,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'language': _$LanguageEnumMap[instance.language]!,
  'globalPlayerOptions': instance.globalPlayerOptions.toJson(),
  'globalNikkeOptions': instance.globalNikkeOptions.map((k, e) => MapEntry(k.toString(), e.toJson())),
  'cnPlayerOptions': instance.cnPlayerOptions.toJson(),
  'cnNikkeOptions': instance.cnNikkeOptions.map((k, e) => MapEntry(k.toString(), e.toJson())),
  'globalCubeLvs': instance.globalCubeLvs.map((k, e) => MapEntry(k.toString(), e)),
  'cnCubeLvs': instance.cnCubeLvs.map((k, e) => MapEntry(k.toString(), e)),
  'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
  'defaultWindowHeight': instance.defaultWindowHeight,
  'defaultWindowWidth': instance.defaultWindowWidth,
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

const _$ThemeModeEnumMap = {ThemeMode.system: 'system', ThemeMode.light: 'light', ThemeMode.dark: 'dark'};

BattleSetup _$BattleSetupFromJson(Map<String, dynamic> json) => BattleSetup(
  playerOptions: PlayerOptions.fromJson(json['playerOptions'] as Map<String, dynamic>),
  nikkeOptions:
      (json['nikkeOptions'] as List<dynamic>?)?.map((e) => NikkeOptions.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  raptureOptions: BattleRaptureOptions.fromJson(json['raptureOptions'] as Map<String, dynamic>),
  advancedOptions: BattleAdvancedOption.fromJson(json['advancedOptions'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BattleSetupToJson(BattleSetup instance) => <String, dynamic>{
  'playerOptions': instance.playerOptions.toJson(),
  'nikkeOptions': instance.nikkeOptions.map((e) => e.toJson()).toList(),
  'raptureOptions': instance.raptureOptions.toJson(),
  'advancedOptions': instance.advancedOptions.toJson(),
};

BattleAdvancedOption _$BattleAdvancedOptionFromJson(Map<String, dynamic> json) => BattleAdvancedOption(
    forceFillBurst: json['forceFillBurst'] as bool? ?? false,
    fps: (json['fps'] as num?)?.toInt() ?? 60,
    maxSeconds: (json['maxSeconds'] as num?)?.toInt() ?? 180,
  )
  ..burstOrders = (json['burstOrders'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(int.parse(k), BattleBurstSpecification.fromJson(e as Map<String, dynamic>)),
  );

Map<String, dynamic> _$BattleAdvancedOptionToJson(BattleAdvancedOption instance) => <String, dynamic>{
  'forceFillBurst': instance.forceFillBurst,
  'fps': instance.fps,
  'maxSeconds': instance.maxSeconds,
  'burstOrders': instance.burstOrders.map((k, e) => MapEntry(k.toString(), e.toJson())),
};

BattleBurstSpecification _$BattleBurstSpecificationFromJson(Map<String, dynamic> json) => BattleBurstSpecification(
  order: (json['order'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  frame: (json['frame'] as num?)?.toInt(),
);

Map<String, dynamic> _$BattleBurstSpecificationToJson(BattleBurstSpecification instance) => <String, dynamic>{
  'order': instance.order,
  'frame': instance.frame,
};
