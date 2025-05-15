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
  final SkillType skill1Table;
  // CharacterSkillTable
  @JsonKey(name: 'skill2_id')
  final int skill2Id;
  // value is "StateEffect", so use `skill2Id` and search in StateEffectTable
  // also has value "CharacterSkill", so search in CharacterSkillTable
  @JsonKey(name: 'skill2_table')
  final SkillType skill2Table;
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
    this.skill1Table = SkillType.unknown,
    this.skill2Id = 0,
    this.skill2Table = SkillType.unknown,
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
class WeaponData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'camera_work')
  final String cameraWork;
  @JsonKey(name: 'weapon_type')
  final WeaponType weaponType;
  // Metal/Energy/Bio, probably not used
  @JsonKey(name: 'attack_type')
  final AttackType attackType;
  // Metal_Type/Energy_Type, probably not used
  @JsonKey(name: 'counter_enermy')
  final String counterEnemy;
  @JsonKey(name: 'prefer_target')
  final PreferTarget preferTarget;
  @JsonKey(name: 'prefer_target_condition')
  final PreferTargetCondition preferTargetCondition;
  @JsonKey(name: 'shot_timing')
  final ShotTiming shotTiming;
  @JsonKey(name: 'fire_type')
  final FireType fireType;
  @JsonKey(name: 'input_type')
  final InputType inputType;
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
  // screen shake?
  @JsonKey(name: 'shake_id')
  final int shakeId;
  @JsonKey(name: 'ShakeType')
  final String shakeType;
  @JsonKey(name: 'ShakeWeight')
  final int shakeWeight;

  WeaponData({
    this.id = 0,
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.cameraWork = '',
    this.weaponType = WeaponType.unknown,
    this.attackType = AttackType.unknown,
    this.counterEnemy = '',
    this.preferTarget = PreferTarget.front,
    this.preferTargetCondition = PreferTargetCondition.none,
    this.shotTiming = ShotTiming.concurrence,
    this.fireType = FireType.instant,
    this.inputType = InputType.down,
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

  factory WeaponData.fromJson(Map<String, dynamic> json) => _$WeaponDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeaponDataToJson(this);
}

@JsonSerializable()
class CharacterStatData {
  final int id;
  final int group;
  final int level;
  @JsonKey(name: 'level_hp')
  final int hp;
  @JsonKey(name: 'level_attack')
  final int attack;
  @JsonKey(name: 'level_defence')
  final int defence;
  @JsonKey(name: 'level_energy_resist')
  final int energyResist;
  @JsonKey(name: 'level_metal_resist')
  final int metalResist;
  @JsonKey(name: 'level_bio_resist')
  final int bioResist;

  CharacterStatData({
    this.id = 0,
    this.group = 0,
    this.level = 0,
    this.hp = 0,
    this.attack = 0,
    this.defence = 0,
    this.energyResist = 0,
    this.metalResist = 0,
    this.bioResist = 0,
  });

  factory CharacterStatData.fromJson(Map<String, dynamic> json) => _$CharacterStatDataFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterStatDataToJson(this);

  static final emptyData = CharacterStatData();
}

@JsonSerializable()
class CharacterStatEnhanceData {
  final int id;
  @JsonKey(name: 'grade_ratio')
  final int gradeRatio;
  @JsonKey(name: 'grade_hp')
  final int gradeHp;
  @JsonKey(name: 'grade_attack')
  final int gradeAttack;
  @JsonKey(name: 'grade_defence')
  final int gradeDefence;
  @JsonKey(name: 'grade_energy_resist')
  final int gradeEnergyResist;
  @JsonKey(name: 'grade_metal_resist')
  final int gradeMetalResist;
  @JsonKey(name: 'grade_bio_resist')
  final int gradeBioResist;
  @JsonKey(name: 'core_hp')
  final int coreHp;
  @JsonKey(name: 'core_attack')
  final int coreAttack;
  @JsonKey(name: 'core_defence')
  final int coreDefence;
  @JsonKey(name: 'core_energy_resist')
  final int coreEnergyResist;
  @JsonKey(name: 'core_metal_resist')
  final int coreMetalResist;
  @JsonKey(name: 'core_bio_resist')
  final int coreBioResist;

  CharacterStatEnhanceData({
    this.id = 0,
    this.gradeRatio = 0,
    this.gradeHp = 0,
    this.gradeAttack = 0,
    this.gradeDefence = 0,
    this.gradeEnergyResist = 0,
    this.gradeMetalResist = 0,
    this.gradeBioResist = 0,
    this.coreHp = 0,
    this.coreAttack = 0,
    this.coreDefence = 0,
    this.coreEnergyResist = 0,
    this.coreMetalResist = 0,
    this.coreBioResist = 0,
  });

  factory CharacterStatEnhanceData.fromJson(Map<String, dynamic> json) => _$CharacterStatEnhanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterStatEnhanceDataToJson(this);

  static final emptyData = CharacterStatEnhanceData();
}

class ClassAttractiveStatData {
  final int hpRate;
  final int attackRate;
  final int defenceRate;
  final int energyResistRate;
  final int metalResistRate;
  final int bioResistRate;

  ClassAttractiveStatData({
    this.hpRate = 0,
    this.attackRate = 0,
    this.defenceRate = 0,
    this.energyResistRate = 0,
    this.metalResistRate = 0,
    this.bioResistRate = 0,
  });

  static final emptyData = ClassAttractiveStatData();
}

@JsonSerializable()
class AttractiveStatData {
  final int id;
  @JsonKey(name: 'attractive_level')
  final int attractiveLevel;
  @JsonKey(name: 'attractive_point')
  final int attractivePoint;

  // Attacker rates
  @JsonKey(name: 'attacker_hp_rate')
  final int attackerHpRate;
  @JsonKey(name: 'attacker_attack_rate')
  final int attackerAttackRate;
  @JsonKey(name: 'attacker_defence_rate')
  final int attackerDefenceRate;
  @JsonKey(name: 'attacker_energy_resist_rate')
  final int attackerEnergyResistRate;
  @JsonKey(name: 'attacker_metal_resist_rate')
  final int attackerMetalResistRate;
  @JsonKey(name: 'attacker_bio_resist_rate')
  final int attackerBioResistRate;

  // Defender rates
  @JsonKey(name: 'defender_hp_rate')
  final int defenderHpRate;
  @JsonKey(name: 'defender_attack_rate')
  final int defenderAttackRate;
  @JsonKey(name: 'defender_defence_rate')
  final int defenderDefenceRate;
  @JsonKey(name: 'defender_energy_resist_rate')
  final int defenderEnergyResistRate;
  @JsonKey(name: 'defender_metal_resist_rate')
  final int defenderMetalResistRate;
  @JsonKey(name: 'defender_bio_resist_rate')
  final int defenderBioResistRate;

  // Supporter rates
  @JsonKey(name: 'supporter_hp_rate')
  final int supporterHpRate;
  @JsonKey(name: 'supporter_attack_rate')
  final int supporterAttackRate;
  @JsonKey(name: 'supporter_defence_rate')
  final int supporterDefenceRate;
  @JsonKey(name: 'supporter_energy_resist_rate')
  final int supporterEnergyResistRate;
  @JsonKey(name: 'supporter_metal_resist_rate')
  final int supporterMetalResistRate;
  @JsonKey(name: 'supporter_bio_resist_rate')
  final int supporterBioResistRate;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final ClassAttractiveStatData attackerStatData;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ClassAttractiveStatData defenderStatData;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ClassAttractiveStatData supporterStatData;

  AttractiveStatData({
    this.id = 0,
    this.attractiveLevel = 0,
    this.attractivePoint = 0,
    this.attackerHpRate = 0,
    this.attackerAttackRate = 0,
    this.attackerDefenceRate = 0,
    this.attackerEnergyResistRate = 0,
    this.attackerMetalResistRate = 0,
    this.attackerBioResistRate = 0,
    this.defenderHpRate = 0,
    this.defenderAttackRate = 0,
    this.defenderDefenceRate = 0,
    this.defenderEnergyResistRate = 0,
    this.defenderMetalResistRate = 0,
    this.defenderBioResistRate = 0,
    this.supporterHpRate = 0,
    this.supporterAttackRate = 0,
    this.supporterDefenceRate = 0,
    this.supporterEnergyResistRate = 0,
    this.supporterMetalResistRate = 0,
    this.supporterBioResistRate = 0,
  }) : attackerStatData = ClassAttractiveStatData(
         hpRate: attackerHpRate,
         attackRate: attackerAttackRate,
         defenceRate: attackerDefenceRate,
         energyResistRate: attackerEnergyResistRate,
         metalResistRate: attackerMetalResistRate,
         bioResistRate: attackerBioResistRate,
       ),
       defenderStatData = ClassAttractiveStatData(
         hpRate: defenderHpRate,
         attackRate: defenderAttackRate,
         defenceRate: defenderDefenceRate,
         energyResistRate: defenderEnergyResistRate,
         metalResistRate: defenderMetalResistRate,
         bioResistRate: defenderBioResistRate,
       ),
       supporterStatData = ClassAttractiveStatData(
         hpRate: supporterHpRate,
         attackRate: supporterAttackRate,
         defenceRate: supporterDefenceRate,
         energyResistRate: supporterEnergyResistRate,
         metalResistRate: supporterMetalResistRate,
         bioResistRate: supporterBioResistRate,
       );

  factory AttractiveStatData.fromJson(Map<String, dynamic> json) => _$AttractiveStatDataFromJson(json);

  Map<String, dynamic> toJson() => _$AttractiveStatDataToJson(this);

  ClassAttractiveStatData getStatData(NikkeClass nikkeClass) {
    return switch (nikkeClass) {
      NikkeClass.unknown => ClassAttractiveStatData.emptyData,
      NikkeClass.all => ClassAttractiveStatData.emptyData,
      NikkeClass.attacker => attackerStatData,
      NikkeClass.defender => defenderStatData,
      NikkeClass.supporter => supporterStatData,
    };
  }
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Rarity { unknown, ssr, sr, r }

@JsonEnum(fieldRename: FieldRename.pascal)
enum StatType { atk, defence, hp, none, unknown }

enum WeaponType {
  unknown(-1),
  @JsonValue('None')
  none(0),
  @JsonValue('AR')
  ar(1),
  @JsonValue('MG')
  mg(4),
  @JsonValue('RL')
  rl(2),
  @JsonValue('SG')
  sg(5),
  @JsonValue('SMG')
  smg(9),
  @JsonValue('SR')
  sr(3);

  final int id;

  const WeaponType(this.id);

  static const List<WeaponType> chargeWeaponTypes = [WeaponType.rl, WeaponType.sr];

  @override
  String toString() {
    return name.toUpperCase();
  }
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum NikkeClass { unknown, attacker, defender, supporter, all }

enum NikkeElement {
  unknown(-1),
  fire(100001),
  water(200001),
  wind(300001),
  electric(400001),
  iron(500001);

  final int id;

  const NikkeElement(this.id);

  static NikkeElement fromId(final int id) {
    return values.firstWhere(
      (e) => e.id == id,
      orElse: () => NikkeElement.unknown, // default value if not found
    );
  }

  bool strongAgainst(NikkeElement other) {
    switch (this) {
      case NikkeElement.unknown:
        return false;
      case NikkeElement.fire:
        return other == NikkeElement.wind;
      case NikkeElement.water:
        return other == NikkeElement.fire;
      case NikkeElement.wind:
        return other == NikkeElement.iron;
      case NikkeElement.electric:
        return other == NikkeElement.water;
      case NikkeElement.iron:
        return other == NikkeElement.electric;
    }
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

// from characterShotTable:
// enum PreferTarget { unknown, targetAR, targetGL, targetPS, front, back, highHP }
// from characterSkillTable
// "preferTarget": "{HighAttack, HighDefence, HighAttackLastSelf, LowHP, Attacker, Random, LowHPLastSelf, LowHPRatio,
// HighAttackFirstSelf, LowHPCover, NearAim, HighMaxHP, HaveDebuff, HighHP, Defender, LowDefence, Fire,
// LongInitChargeTime, Electronic}"
@JsonEnum(fieldRename: FieldRename.pascal)
enum PreferTarget {
  unknown,

  targetAR,
  targetGL,
  targetPS,

  random,
  back,
  front,
  haveDebuff,
  longInitChargeTime,

  highAttack,
  highAttackFirstSelf,
  highAttackLastSelf,
  highDefence,
  highHP,
  highMaxHP,
  lowDefence,
  lowHP,
  lowHPCover,
  lowHPLastSelf,
  lowHPRatio,
  nearAim,

  attacker,
  defender,
  supporter,

  fire,
  water,
  electronic,
  iron,
  wind,
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum PreferTargetCondition {
  unknown,
  none,
  includeNoneTargetLast,
  includeNoneTargetNone,
  excludeSelf,
  destroyCover,
  onlySG,
  onlyRL,
  onlyAR,
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum ShotTiming { sequence, concurrence } // sequence only used for Vesti's Burst Skill

@JsonEnum(fieldRename: FieldRename.pascal)
enum FireType {
  instant, // All AR, SG, SR, MG (except Modernia burst)
  homingProjectile, // should be all other RLs
  mechaShiftyShot,
  multiTarget, // Modernia burst
  projectileCurve, // Cindy
  projectileDirect, // 5 RL occurrences (Laplace, Ynui Alt, Summer Neon burst, A2, SBS)
  stickyProjectileDirect, // Rapi: Red Hood alt attack
}

enum InputType {
  @JsonValue('DOWN')
  down,
  @JsonValue('DOWN_Charge')
  downCharge,
  @JsonValue('UP')
  up,
}

// "attackType": "{Fire, Energy, Water, Bio, Electronic, Wind, Iron}"
@JsonEnum(fieldRename: FieldRename.pascal)
enum AttackType { fire, water, electronic, iron, wind, energy, bio, metal, unknown }

@JsonEnum(fieldRename: FieldRename.pascal)
enum SkillType { none, stateEffect, characterSkill, unknown }

@JsonSerializable()
class CoverStatData {
  final int id;
  final int lv;
  @JsonKey(name: 'level_hp')
  final int levelHp;
  @JsonKey(name: 'level_defence')
  final int levelDefence;

  CoverStatData({this.id = 0, this.lv = 0, this.levelHp = 0, this.levelDefence = 0});

  factory CoverStatData.fromJson(Map<String, dynamic> json) => _$CoverStatDataFromJson(json);

  Map<String, dynamic> toJson() => _$CoverStatDataToJson(this);
}
