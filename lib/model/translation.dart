import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/db.dart';

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

  String forLanguage(Language language) {
    switch (language) {
      case Language.ko:
        return ko;
      case Language.en:
        return en;
      case Language.ja:
        return ja;
      case Language.zhTW:
        return zhTW;
      case Language.zhCN:
        return zhCN;
      case Language.th:
        return th;
      case Language.de:
        return de;
      case Language.fr:
        return fr;
      default:
        return en;
    }
  }
}
