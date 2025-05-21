import 'package:json_annotation/json_annotation.dart';

part '../generated/model/translation.g.dart';

@JsonSerializable()
class Translation {
  @JsonKey(name: 'Key')
  String key;
  String ko;
  String en;
  String ja;
  @JsonKey(name: 'zh-TW')
  String zhTW;
  @JsonKey(name: 'zh-CN')
  String zhCN;
  String th;
  String de;
  String fr;
  @JsonKey(name: 'IsSmart')
  int isSmart;

  Translation({
    this.key = "",
    this.ko = "",
    this.en = "",
    this.ja = "",
    this.zhTW = "",
    this.zhCN = "",
    this.th = "",
    this.de = "",
    this.fr = "",
    this.isSmart = 0,
  });

  factory Translation.fromJson(Map<String, dynamic> json) => _$TranslationFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
