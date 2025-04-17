// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Translation _$TranslationFromJson(Map<String, dynamic> json) => Translation(
  key: json['Key'] as String? ?? "",
  ko: json['ko'] as String? ?? "",
  en: json['en'] as String? ?? "",
  ja: json['ja'] as String? ?? "",
  zhTW: json['zh-TW'] as String? ?? "",
  zhCN: json['zh-CN'] as String? ?? "",
  th: json['th'] as String? ?? "",
  fr: json['fr'] as String? ?? "",
  isSmart: (json['IsSmart'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TranslationToJson(Translation instance) => <String, dynamic>{
  'Key': instance.key,
  'ko': instance.ko,
  'en': instance.en,
  'ja': instance.ja,
  'zh-TW': instance.zhTW,
  'zh-CN': instance.zhCN,
  'th': instance.th,
  'fr': instance.fr,
  'IsSmart': instance.isSmart,
};
