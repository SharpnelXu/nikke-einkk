import 'package:json_annotation/json_annotation.dart';

part 'nikke.g.dart';

// sample data
// {
// "id": 352004,
// "name_localkey": "Locale_Character:520_name",
// "description_localkey": "Locale_Character:c520_description",
// "resource_id": 520,
// "additional_skins": [],
// "name_code": 5135,
// "order": 10111,
// "original_rare": "SSR",
// "grade_core_id": 4,
// "grow_grade": 352005,
// "stat_enhance_id": 5102,
// "class": "Attacker",
// "element_id": [
// 200001
// ],
// "critical_ratio": 1500,
// "critical_damage": 15000,
// "shot_id": 1052001,
// "bonusrange_min": 45,
// "bonusrange_max": 100,
// "use_burst_skill": "Step3",
// "change_burst_step": "StepFull",
// "burst_apply_delay": 1,
// "burst_duration": 1000,
// "ulti_skill_id": 1520301,
// "skill1_id": 2520101,
// "skill1_table": "StateEffect",
// "skill2_id": 2520201,
// "skill2_table": "StateEffect",
// "eff_category_type": "Walk",
// "eff_category_value": 0,
// "category_type_1": "None",
// "category_type_2": "None",
// "category_type_3": "None",
// "corporation": "TETRA",
// "cv_localkey": "Locale_Character:520_cv",
// "squad": "CookingOil",
// "piece_id": 5100520,
// "is_visible": true,
// "prism_is_active": false,
// "is_detail_close": false
// }

@JsonSerializable()
class NikkeCharacterData {
  // format "corporation + resourceId + gradeCoreId", e.g. 235004, series = 2, resourceId = 350, gradeCoreId = 04
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'resource_id')
  final int resourceId;
  // values observed in list are "acc", "bg". Yet to know what this refers to, but probably doesn't matter
  @JsonKey(name: 'additional_skins')
  final List<String> additionalSkins;
  // doesn't know what this means
  @JsonKey(name: 'name_code')
  final int nameCode;
  // doesn't know what this means
  final int order;
  // valid values are "SSR", "SR", "R"
  @JsonKey(name: 'original_rare', unknownEnumValue: Rarity.unknown)
  final Rarity originalRare;
  // valid values are [1, 11], use `limitBreak` for more readable format
  @JsonKey(name: 'grade_core_id')
  final int gradeCoreId;
  // denote if there's next grade, 0 means no next grade
  @JsonKey(name: 'grow_grade')
  final int growGrade;
  // CharacterStatEnhanceTable
  @JsonKey(name: 'stat_enhance_id')
  final int statEnhanceId;
  // "Attacker", "Defender", "Supporter"
  @JsonKey(name: 'class', unknownEnumValue: NikkeClass.unknown)
  final NikkeClass characterClass;
  @JsonKey(name: 'element_id')
  final List<int> elementId;
  @JsonKey(name: 'critical_ratio')
  final int criticalRatio;
  @JsonKey(name: 'critical_damage')
  final int criticalDamage;
  // CharacterShotTable
  @JsonKey(name: 'shot_id')
  final int shotId;
  // doesn't know what this means
  @JsonKey(name: 'bonusrange_min')
  final int bonusRangeMin;
  // doesn't know what this means
  @JsonKey(name: 'bonusrange_max')
  final int bonusRangeMax;
  // "AllStep", "Step1", "Step2", "Step3"
  @JsonKey(name: 'use_burst_skill', unknownEnumValue: BurstStep.unknown)
  final BurstStep useBurstSkill;
  // "NextStep", "Step1", "Step2", "Step3", "StepFull"
  @JsonKey(name: 'change_burst_step', unknownEnumValue: BurstStep.unknown)
  final BurstStep changeBurstStep;
  @JsonKey(name: 'burst_apply_delay')
  final int burstApplyDelay;
  // 500, 1000, 1500
  @JsonKey(name: 'burst_duration')
  final int burstDuration;
  // probably default to CharacterSkillTable
  @JsonKey(name: 'ulti_skill_id')
  final int ultiSkillId;
  // CharacterSkillTable
  @JsonKey(name: 'skill1_id')
  final int skill1Id;
  // value is "StateEffect", so use `skill1Id` and search in StateEffectTable
  // also has value "CharacterSkill", so search in CharacterSkillTable
  @JsonKey(name: 'skill1_table')
  final String skill1Table;
  // CharacterSkillTable
  @JsonKey(name: 'skill2_id')
  final int skill2Id;
  // value is "StateEffect", so use `skill2Id` and search in StateEffectTable
  // also has value "CharacterSkill", so search in CharacterSkillTable
  @JsonKey(name: 'skill2_table')
  final String skill2Table;
  // doesn't know what this means
  @JsonKey(name: 'eff_category_type')
  final String effCategoryType;
  // doesn't know what this means
  @JsonKey(name: 'eff_category_value')
  final int effCategoryValue;
  // doesn't know what this means
  @JsonKey(name: 'category_type_1')
  final String categoryType1;
  // doesn't know what this means
  @JsonKey(name: 'category_type_2')
  final String categoryType2;
  // doesn't know what this means
  @JsonKey(name: 'category_type_3')
  final String categoryType3;
  @JsonKey(unknownEnumValue: Corporation.unknown)
  final Corporation corporation;
  @JsonKey(name: 'cv_localkey')
  final String cvLocalkey;
  final String squad;
  // item id for upgrade to next gradeCore, table is ItemPieceTable
  @JsonKey(name: 'piece_id')
  final int pieceId;
  @JsonKey(name: 'is_visible')
  final bool isVisible;
  @JsonKey(name: 'prism_is_active')
  final bool prismIsActive;
  @JsonKey(name: 'is_detail_close')
  final bool isDetailClose;

  String get limitBreak => gradeCoreId <= 4 ? 'LimitBreak$gradeCoreId' : 'Core+${gradeCoreId - 4}';

  NikkeCharacterData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.resourceId = 0,
    this.additionalSkins = const [],
    this.nameCode = 0,
    this.order = 0,
    this.originalRare = Rarity.unknown,
    this.gradeCoreId = 0,
    this.growGrade = 0,
    this.statEnhanceId = 0,
    this.characterClass = NikkeClass.unknown,
    this.elementId = const [],
    this.criticalRatio = 0,
    this.criticalDamage = 0,
    this.shotId = 0,
    this.bonusRangeMin = 0,
    this.bonusRangeMax = 0,
    this.useBurstSkill = BurstStep.unknown,
    this.changeBurstStep = BurstStep.unknown,
    this.burstApplyDelay = 0,
    this.burstDuration = 0,
    this.ultiSkillId = 0,
    this.skill1Id = 0,
    this.skill1Table = '',
    this.skill2Id = 0,
    this.skill2Table = '',
    this.effCategoryType = '',
    this.effCategoryValue = 0,
    this.categoryType1 = '',
    this.categoryType2 = '',
    this.categoryType3 = '',
    this.corporation = Corporation.unknown,
    this.cvLocalkey = '',
    this.squad = '',
    this.pieceId = 0,
    this.isVisible = false,
    this.prismIsActive = false,
    this.isDetailClose = false,
  });

  factory NikkeCharacterData.fromJson(Map<String, dynamic> json) => _$NikkeCharacterDataFromJson(json);

  Map<String, dynamic> toJson() => _$NikkeCharacterDataToJson(this);

  bool get hasUnknownEnum {
    return originalRare == Rarity.unknown ||
        corporation == Corporation.unknown ||
        useBurstSkill == BurstStep.unknown ||
        changeBurstStep == BurstStep.unknown ||
        characterClass == NikkeClass.unknown;
  }
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Rarity { unknown, ssr, sr, r }

@JsonEnum(fieldRename: FieldRename.pascal)
enum NikkeClass { unknown, attacker, defender, supporter }

enum Element {
  unknown(-1),
  fire(100001),
  water(200001),
  wind(300001),
  electric(400001),
  iron(500001);

  final int id;

  const Element(this.id);

  static Element fromId(final int id) {
    return values.firstWhere(
      (e) => e.id == id,
      orElse: () => Element.unknown, // default value if not found
    );
  }
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum BurstStep {
  unknown,
  step1,
  step2,
  step3,
  stepFull,

  // red hood
  allStep,
  nextStep,

  // marian
  none,
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Corporation {
  unknown(-1),
  missilis(1),
  elysion(2),
  tetra(3),
  pilgrim(4),
  abnormal(5);

  final int id;

  const Corporation(this.id);
}
