import 'package:json_annotation/json_annotation.dart';

part '../generated/model/common.g.dart';

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
  // might be problematic to treat resourceId as characterId in the future
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
  @JsonKey(name: 'original_rare')
  final Rarity originalRare;
  // valid values are [1, 11], use `limitBreak` for more readable format
  @JsonKey(name: 'grade_core_id')
  final int gradeCoreId;
  // denote if there's next grade, 0 means no next grade
  @JsonKey(name: 'grow_grade')
  final int growGrade;
  // CharacterStatEnhanceTable & CharacterStatTable
  // CharacterStatTable[statEnhanceId = groupId][lv] to get baseStat
  // CharacterStateEnhanceTable[statEnhanceId = id] to get gradeEnhanceStat
  // grade is [1, 4]
  // gradeStat = baseStat * gradeRatio (usually 2%) * (grade - 1) + gradeStat * (grade - 1)
  // MLBStat = baseStat + gradeStat
  // core is [1, 7]
  // coreStat = (MLBStat (which is gradeStat + baseStat) + bond stat + console stat) * coreRatio (2%)
  // finalStat = baseStat + gradeStat + coreStat + bondStat + consoleStat + cubeStat + gearStat + dollStat
  @JsonKey(name: 'stat_enhance_id')
  final int statEnhanceId;
  // "Attacker", "Defender", "Supporter"
  @JsonKey(name: 'class')
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
  @JsonKey(name: 'use_burst_skill')
  final BurstStep useBurstSkill;
  // "NextStep", "Step1", "Step2", "Step3", "StepFull"
  @JsonKey(name: 'change_burst_step')
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

@JsonSerializable()
class WeaponSkillData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  final String cameraWork;
  @JsonKey(name: 'weapon_type')
  final WeaponType weaponType;
  @JsonKey(name: 'attack_type')
  final String attackType;
  @JsonKey(name: 'counter_enermy')
  final String counterEnemy;
  @JsonKey(name: 'prefer_target')
  final String preferTarget;
  @JsonKey(name: 'prefer_target_condition')
  final String preferTargetCondition;
  @JsonKey(name: 'shot_timing')
  final String shotTiming;
  @JsonKey(name: 'fire_type')
  final String fireType;
  @JsonKey(name: 'input_type')
  final String inputType;
  @JsonKey(name: 'is_targeting')
  final bool isTargeting;
  final int damage;
  @JsonKey(name: 'shot_count')
  final int shotCount;
  @JsonKey(name: 'muzzle_count')
  final int muzzleCount;
  @JsonKey(name: 'multi_target_count')
  final int multiTargetCount;
  @JsonKey(name: 'center_shot_count')
  final int centerShotCount;
  @JsonKey(name: 'max_ammo')
  final int maxAmmo;
  @JsonKey(name: 'maintain_fire_stance')
  final int maintainFireStance;
  @JsonKey(name: 'uptype_fire_timing')
  final int upTypeFireTiming;
  @JsonKey(name: 'reload_time')
  final int reloadTime;
  @JsonKey(name: 'reload_bullet')
  final int reloadBullet;
  @JsonKey(name: 'reload_start_ammo')
  final int reloadStartAmmo;
  @JsonKey(name: 'rate_of_fire_reset_time')
  final int rateOfFireResetTime;
  @JsonKey(name: 'rate_of_fire')
  final int rateOfFire;
  @JsonKey(name: 'end_rate_of_fire')
  final int endRateOfFire;
  @JsonKey(name: 'rate_of_fire_change_pershot')
  final int rateOfFireChangePerShot;
  @JsonKey(name: 'burst_energy_pershot')
  final int burstEnergyPerShot;
  @JsonKey(name: 'target_burst_energy_pershot')
  final int targetBurstEnergyPerShot;
  @JsonKey(name: 'spot_first_delay')
  final int spotFirstDelay;
  @JsonKey(name: 'spot_last_delay')
  final int spotLastDelay;
  @JsonKey(name: 'start_accuracy_circle_scale')
  final int startAccuracyCircleScale;
  @JsonKey(name: 'end_accuracy_circle_scale')
  final int endAccuracyCircleScale;
  @JsonKey(name: 'accuracy_change_pershot')
  final int accuracyChangePerShot;
  @JsonKey(name: 'accuracy_change_speed')
  final int accuracyChangeSpeed;
  @JsonKey(name: 'auto_start_accuracy_circle_scale')
  final int autoStartAccuracyCircleScale;
  @JsonKey(name: 'auto_end_accuracy_circle_scale')
  final int autoEndAccuracyCircleScale;
  @JsonKey(name: 'auto_accuracy_change_pershot')
  final int autoAccuracyChangePerShot;
  @JsonKey(name: 'auto_accuracy_change_speed')
  final int autoAccuracyChangeSpeed;
  @JsonKey(name: 'zoom_rate')
  final int zoomRate;
  @JsonKey(name: 'multi_aim_range')
  final int multiAimRange;
  @JsonKey(name: 'spot_projectile_speed')
  final int spotProjectileSpeed;
  @JsonKey(name: 'charge_time')
  final int chargeTime;
  @JsonKey(name: 'full_charge_damage')
  final int fullChargeDamage;
  @JsonKey(name: 'full_charge_burst_energy')
  final int fullChargeBurstEnergy;
  @JsonKey(name: 'spot_radius_object')
  final int spotRadiusObject;
  @JsonKey(name: 'spot_radius')
  final int spotRadius;
  @JsonKey(name: 'spot_explosion_range')
  final int spotExplosionRange;
  @JsonKey(name: 'core_damage_rate')
  final int coreDamageRate;
  final int penetration;
  @JsonKey(name: 'use_function_id_list')
  final List<int> useFunctionIdList;
  @JsonKey(name: 'hurt_function_id_list')
  final List<int> hurtFunctionIdList;
  @JsonKey(name: 'shake_id')
  final int shakeId;
  @JsonKey(name: 'ShakeType')
  final String shakeType;
  @JsonKey(name: 'ShakeWeight')
  final int shakeWeight;

  WeaponSkillData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.cameraWork = '',
    this.weaponType = WeaponType.unknown,
    this.attackType = '',
    this.counterEnemy = '',
    this.preferTarget = '',
    this.preferTargetCondition = '',
    this.shotTiming = '',
    this.fireType = '',
    this.inputType = '',
    this.isTargeting = false,
    this.damage = 0,
    this.shotCount = 0,
    this.muzzleCount = 0,
    this.multiTargetCount = 0,
    this.centerShotCount = 0,
    this.maxAmmo = 0,
    this.maintainFireStance = 0,
    this.upTypeFireTiming = 0,
    this.reloadTime = 0,
    this.reloadBullet = 0,
    this.reloadStartAmmo = 0,
    this.rateOfFireResetTime = 0,
    this.rateOfFire = 0,
    this.endRateOfFire = 0,
    this.rateOfFireChangePerShot = 0,
    this.burstEnergyPerShot = 0,
    this.targetBurstEnergyPerShot = 0,
    this.spotFirstDelay = 0,
    this.spotLastDelay = 0,
    this.startAccuracyCircleScale = 0,
    this.endAccuracyCircleScale = 0,
    this.accuracyChangePerShot = 0,
    this.accuracyChangeSpeed = 0,
    this.autoStartAccuracyCircleScale = 0,
    this.autoEndAccuracyCircleScale = 0,
    this.autoAccuracyChangePerShot = 0,
    this.autoAccuracyChangeSpeed = 0,
    this.zoomRate = 0,
    this.multiAimRange = 0,
    this.spotProjectileSpeed = 0,
    this.chargeTime = 0,
    this.fullChargeDamage = 0,
    this.fullChargeBurstEnergy = 0,
    this.spotRadiusObject = 0,
    this.spotRadius = 0,
    this.spotExplosionRange = 0,
    this.coreDamageRate = 0,
    this.penetration = 0,
    this.useFunctionIdList = const [],
    this.hurtFunctionIdList = const [],
    this.shakeId = 0,
    this.shakeType = '',
    this.shakeWeight = 0,
  });

  factory WeaponSkillData.fromJson(Map<String, dynamic> json) => _$WeaponSkillDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeaponSkillDataToJson(this);
}

@JsonSerializable()
class EquipmentItemData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'resource_id')
  final String resourceId;
  @JsonKey(name: 'item_type')
  final ItemType itemType;
  @JsonKey(name: 'item_sub_type')
  final EquipType itemSubType;
  @JsonKey(name: 'class')
  final NikkeClass characterClass;
  @JsonKey(name: 'item_rare')
  final EquipRarity itemRarity;
  @JsonKey(name: 'grade_core_id')
  final int gradeCoreId;
  @JsonKey(name: 'grow_grade')
  final int growGrade;
  final List<EquipmentStat> stat;
  @JsonKey(name: 'option_slot')
  final List<OptionSlot> optionSlots;
  @JsonKey(name: 'option_cost')
  final int optionCost;
  @JsonKey(name: 'option_change_cost')
  final int optionChangeCost;
  @JsonKey(name: 'option_lock_cost')
  final int optionLockCost;

  EquipmentItemData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.resourceId = '',
    this.itemType = ItemType.equip,
    this.itemSubType = EquipType.unknown,
    this.characterClass = NikkeClass.unknown,
    this.itemRarity = EquipRarity.unknown,
    this.gradeCoreId = 0,
    this.growGrade = 0,
    this.stat = const [],
    this.optionSlots = const [],
    this.optionCost = 0,
    this.optionChangeCost = 0,
    this.optionLockCost = 0,
  });

  factory EquipmentItemData.fromJson(Map<String, dynamic> json) => _$EquipmentItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentItemDataToJson(this);
}

@JsonSerializable()
class EquipmentStat {
  final StatType statType;
  final int statValue;

  EquipmentStat({this.statType = StatType.none, this.statValue = 0});

  factory EquipmentStat.fromJson(Map<String, dynamic> json) => _$EquipmentStatFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentStatToJson(this);
}

@JsonSerializable()
class OptionSlot {
  final int optionSlot;
  final int optionSlotSuccessRatio;

  OptionSlot({this.optionSlot = 0, this.optionSlotSuccessRatio = 0});

  factory OptionSlot.fromJson(Map<String, dynamic> json) => _$OptionSlotFromJson(json);
  Map<String, dynamic> toJson() => _$OptionSlotToJson(this);
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Rarity { unknown, ssr, sr, r }

@JsonEnum(fieldRename: FieldRename.pascal)
enum StatType { atk, defence, hp, none, unknown }

enum WeaponType {
  unknown,
  @JsonValue('None')
  none,
  @JsonValue('AR')
  ar,
  @JsonValue('MG')
  mg,
  @JsonValue('RL')
  rl,
  @JsonValue('SG')
  sg,
  @JsonValue('SMG')
  smg,
  @JsonValue('SR')
  sr;

  @override
  String toString() {
    return name.toUpperCase();
  }
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum ItemType { unknown, equip }

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum EquipRarity { unknown, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10 }

enum EquipType {
  unknown,
  @JsonValue('Module_A')
  head,
  @JsonValue('Module_B')
  body,
  @JsonValue('Module_C')
  arm,
  @JsonValue('Module_D')
  leg,
}

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
  none(0),
  missilis(1),
  elysion(2),
  tetra(3),
  pilgrim(4),
  abnormal(5);

  final int id;

  const Corporation(this.id);
}

enum RecycleStat {
  /// hardcoding values here since they won't change anytime soon.
  /// if needed to read data, table is RecycleResearchStatTable
  personal(hp: 450, atk: 0, def: 0),
  nikkeClass(hp: 750, atk: 0, def: 5),
  corporation(hp: 0, atk: 25, def: 5);

  final int hp;
  final int atk;
  final int def;

  const RecycleStat({required this.hp, required this.atk, required this.def});
}
