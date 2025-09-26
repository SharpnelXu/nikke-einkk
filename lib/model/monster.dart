import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/model/skills.dart';

part '../generated/model/monster.g.dart';

@JsonSerializable(createToJson: false)
class MonsterSkillInfoData {
  @JsonKey(name: 'skill_id')
  final int skillId;
  @JsonKey(name: 'use_function_id_skill')
  final List<int> useFunctionIds;
  @JsonKey(name: 'hurt_function_id_skill')
  final List<int> hurtFunctionIds;

  List<int> get validFunctionIds => [...useFunctionIds, ...hurtFunctionIds].where((id) => id != 0).toList();

  MonsterSkillInfoData({this.skillId = 0, this.useFunctionIds = const [], this.hurtFunctionIds = const []});

  factory MonsterSkillInfoData.fromJson(Map<String, dynamic> json) => _$MonsterSkillInfoDataFromJson(json);
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class MonsterData {
  final int id;
  @JsonKey(name: 'element_id')
  final List<int> elementIds;
  @JsonKey(name: 'monster_model_id')
  final int monsterModelId;
  @JsonKey(name: 'name_localkey')
  final String nameKey;
  @JsonKey(name: 'appearance_localkey')
  final String appearanceKey;
  @JsonKey(name: 'description_localkey')
  final String descriptionKey;
  @JsonKey(name: 'is_irregular')
  final bool isIrregular;
  @JsonKey(name: 'hp_ratio')
  final int hpRatio;
  @JsonKey(name: 'attack_ratio')
  final int attackRatio;
  @JsonKey(name: 'defence_ratio')
  final int defenceRatio;
  @JsonKey(name: 'energy_resist_ratio')
  final int energyResistRatio;
  @JsonKey(name: 'metal_resist_ratio')
  final int metalResistRatio;
  @JsonKey(name: 'bio_resist_ratio')
  final int bioResistRatio;
  @JsonKey(name: 'detector_center')
  final int detectorCenter;
  @JsonKey(name: 'detector_radius')
  final int detectorRadius;
  final String nonetarget;
  final String functionnonetarget;
  @JsonKey(name: 'spot_ai')
  final String spotAi;
  @JsonKey(name: 'spot_ai_defense')
  final String spotAiDefense;
  @JsonKey(name: 'spot_ai_basedefense')
  final String spotAiBaseDefense;
  @JsonKey(name: 'spot_move_speed')
  final int spotMoveSpeed;
  @JsonKey(name: 'spot_acceleration_time')
  final int spotAccelerationTime;
  @JsonKey(name: 'fixed_spawn_type')
  final String fixedSpawnType;
  @JsonKey(name: 'spot_rand_ratio_normal')
  final int spotRandRatioNormal;
  @JsonKey(name: 'spot_rand_ratio_jump')
  final int spotRandRatioJump;
  @JsonKey(name: 'spot_rand_ratio_drop')
  final int spotRandRatioDrop;
  @JsonKey(name: 'spot_rand_ratio_dash')
  final int spotRandRatioDash;
  @JsonKey(name: 'spot_rand_ratio_teleport')
  final int spotRandRatioTeleport;
  @JsonKey(name: 'skill_data')
  final List<MonsterSkillInfoData> skillData;
  @JsonKey(name: 'statenhance_id')
  final int statEnhanceId;
  @JsonKey(name: 'ui_grade')
  final String? uiGrade;
  @JsonKey(name: 'passive_skill_id')
  final int? passiveSkillId;
  List<MonsterSkillInfoData> get validSkillData => skillData.where((data) => data.skillId != 0).toList();

  MonsterData({
    this.id = 0,
    this.elementIds = const [],
    this.monsterModelId = 0,
    this.nameKey = '',
    this.appearanceKey = '',
    this.descriptionKey = '',
    this.isIrregular = false,
    this.hpRatio = 0,
    this.attackRatio = 0,
    this.defenceRatio = 0,
    this.energyResistRatio = 0,
    this.metalResistRatio = 0,
    this.bioResistRatio = 0,
    this.detectorCenter = 0,
    this.detectorRadius = 0,
    this.nonetarget = 'Normal',
    this.functionnonetarget = 'Normal',
    this.spotAi = '',
    this.spotAiDefense = '',
    this.spotAiBaseDefense = '',
    this.spotMoveSpeed = 0,
    this.spotAccelerationTime = 0,
    this.fixedSpawnType = 'None',
    this.spotRandRatioNormal = 0,
    this.spotRandRatioJump = 0,
    this.spotRandRatioDrop = 0,
    this.spotRandRatioDash = 0,
    this.spotRandRatioTeleport = 0,
    this.skillData = const [],
    this.statEnhanceId = 0,
    this.uiGrade,
    this.passiveSkillId,
  });

  factory MonsterData.fromJson(Map<String, dynamic> json) => _$MonsterDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class MonsterStatEnhanceData {
  final int id;
  @JsonKey(name: 'group_id')
  final int groupId;
  final int lv;
  @JsonKey(name: 'level_hp')
  final int levelHp;
  @JsonKey(name: 'level_attack')
  final int levelAttack;
  @JsonKey(name: 'level_defence')
  final int levelDefence;
  @JsonKey(name: 'level_statdamageratio')
  final int levelStatDamageRatio;
  @JsonKey(name: 'level_energy_resist')
  final int levelEnergyResist;
  @JsonKey(name: 'level_metal_resist')
  final int levelMetalResist;
  @JsonKey(name: 'level_bio_resist')
  final int levelBioResist;
  @JsonKey(name: 'level_projectile_hp')
  final int levelProjectileHp;
  @JsonKey(name: 'level_broken_hp')
  final int levelBrokenHp;

  MonsterStatEnhanceData({
    this.id = 0,
    this.groupId = 0,
    this.lv = 0,
    this.levelHp = 0,
    this.levelAttack = 0,
    this.levelDefence = 0,
    this.levelStatDamageRatio = 0,
    this.levelEnergyResist = 0,
    this.levelMetalResist = 0,
    this.levelBioResist = 0,
    this.levelProjectileHp = 0,
    this.levelBrokenHp = 0,
  });

  factory MonsterStatEnhanceData.fromJson(Map<String, dynamic> json) => _$MonsterStatEnhanceDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class MonsterPartData {
  final int id;
  @JsonKey(name: 'monster_model_id')
  final int monsterModelId;
  @JsonKey(name: 'parts_name_localkey')
  final String? partsNameKey;
  @JsonKey(name: 'damage_hp_ratio')
  final int damageHpRatio;
  @JsonKey(name: 'hp_ratio')
  final int hpRatio;
  @JsonKey(name: 'attack_ratio')
  final int attackRatio;
  @JsonKey(name: 'defence_ratio')
  final int defenceRatio;
  @JsonKey(name: 'energy_resist_ratio')
  final int energyResistRatio;
  @JsonKey(name: 'metal_resist_ratio')
  final int metalResistRatio;
  @JsonKey(name: 'bio_resist_ratio')
  final int bioResistRatio;
  @JsonKey(name: 'destroy_after_anim')
  final bool destroyAfterAnim;
  @JsonKey(name: 'destroy_after_movable')
  final bool destroyAfterMovable;
  @JsonKey(name: 'passive_skill_id')
  final int passiveSkillId;
  @JsonKey(name: 'visible_hp')
  final bool visibleHp;
  @JsonKey(name: 'linked_parts_id')
  final int linkedPartsId;
  @JsonKey(name: 'weapon_object')
  final List<String> weaponObjects;
  @JsonKey(name: 'weapon_object_enum')
  final List<String> weaponObjectEnums;
  @JsonKey(name: 'parts_type')
  final String partsType;
  @JsonKey(name: 'parts_object')
  final List<String> partsObjects;
  @JsonKey(name: 'parts_skin')
  final String partsSkin;
  @JsonKey(name: 'monster_destroy_anim_trigger')
  final String destroyAnimTrigger;
  @JsonKey(name: 'is_main_part')
  final bool isMainPart;
  @JsonKey(name: 'is_parts_damage_able')
  final bool isPartsDamageable;

  MonsterPartData({
    this.id = 0,
    this.monsterModelId = 0,
    this.partsNameKey,
    this.damageHpRatio = 0,
    this.hpRatio = 0,
    this.attackRatio = 0,
    this.defenceRatio = 0,
    this.energyResistRatio = 0,
    this.metalResistRatio = 0,
    this.bioResistRatio = 0,
    this.destroyAfterAnim = false,
    this.destroyAfterMovable = false,
    this.passiveSkillId = 0,
    this.visibleHp = false,
    this.linkedPartsId = 0,
    this.weaponObjects = const [],
    this.weaponObjectEnums = const [],
    this.partsType = '',
    this.partsObjects = const [],
    this.partsSkin = '',
    this.destroyAnimTrigger = 'None',
    this.isMainPart = false,
    this.isPartsDamageable = false,
  });

  factory MonsterPartData.fromJson(Map<String, dynamic> json) => _$MonsterPartDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class MonsterStageLevelChangeData {
  final int id;
  final int group;
  final int step;
  @JsonKey(name: 'condition_type')
  final String conditionType;
  @JsonKey(name: 'condition_value_min')
  final int conditionValueMin;
  @JsonKey(name: 'condition_value_max')
  final int conditionValueMax;
  @JsonKey(name: 'monster_stage_lv')
  final int monsterStageLv;
  @JsonKey(name: 'passive_skill_id')
  final int passiveSkillId;
  @JsonKey(name: 'target_passive_skill_id')
  final int targetPassiveSkillId;
  @JsonKey(name: 'gimmickobject_lv_control')
  final int gimmickObjectLvControl;

  MonsterStageLevelChangeData({
    this.id = 0,
    this.group = 0,
    this.step = 0,
    this.conditionType = '',
    this.conditionValueMin = 0,
    this.conditionValueMax = 0,
    this.monsterStageLv = 0,
    this.passiveSkillId = 0,
    this.targetPassiveSkillId = 0,
    this.gimmickObjectLvControl = 0,
  });

  factory MonsterStageLevelChangeData.fromJson(Map<String, dynamic> json) =>
      _$MonsterStageLevelChangeDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class MonsterSkillData {
  final int id;
  @JsonKey(name: 'name_localkey')
  final String? nameKey;
  @JsonKey(name: 'description_localkey')
  final String? descriptionKey;
  @JsonKey(name: 'skill_icon')
  final String skillIcon;
  @JsonKey(name: 'skill_ani_number')
  final String animationNumber;
  @JsonKey(name: 'weapon_type')
  final String weaponType;
  @JsonKey(name: 'prefer_target')
  final String rawPreferTarget;
  PreferTarget get preferTarget => PreferTarget.fromName(rawPreferTarget);
  @JsonKey(name: 'show_lock_on')
  final bool showLockOn;
  @JsonKey(name: 'attack_type')
  final String rawAttackType;
  AttackType get attackType => AttackType.fromName(rawAttackType);
  @JsonKey(name: 'fire_type')
  final String rawFireType;
  FireType get fireType => FireType.fromName(rawFireType);
  @JsonKey(name: 'casting_time')
  final int castingTime;
  @JsonKey(name: 'break_object')
  final List<String> breakObjects;
  @JsonKey(name: 'break_object_hp_raito')
  final int breakObjectHpRatio;
  @JsonKey(name: 'skill_value_type_01')
  final String rawSkillValueType1;
  ValueType get skillValueType1 => ValueType.fromName(rawSkillValueType1);
  @JsonKey(name: 'skill_value_01')
  final int skillValue1;
  @JsonKey(name: 'skill_value_type_02')
  final String rawSkillValueType2;
  ValueType get skillValueType2 => ValueType.fromName(rawSkillValueType2);
  @JsonKey(name: 'skill_value_02')
  final int skillValue2;
  @JsonKey(name: 'shot_count')
  final int shotCount;
  @JsonKey(name: 'delay_time')
  final int delayTime;
  @JsonKey(name: 'shot_timing')
  final String shotTiming;
  final int penetration;
  @JsonKey(name: 'projectile_speed')
  final int projectileSpeed;
  @JsonKey(name: 'projectile_hp_ratio')
  final int projectileHpRatio;
  @JsonKey(name: 'projectile_def_ratio')
  final int projectileDefRatio;
  @JsonKey(name: 'projectile_radius_object')
  final int projectileRadiusObject;
  @JsonKey(name: 'projectile_radius')
  final int projectileRadius;
  @JsonKey(name: 'spot_explosion_range')
  final int explosionRange;
  @JsonKey(name: 'is_destroyable_projectile')
  final bool isDestroyableProjectile;
  @JsonKey(name: 'relate_anim')
  final bool relateAnim;
  @JsonKey(name: 'deceleration_rate')
  final int decelerationRate;
  @JsonKey(name: 'target_character_ratio')
  final int targetCharacterRatio;
  @JsonKey(name: 'target_cover_ratio')
  final int targetCoverRatio;
  @JsonKey(name: 'target_nothing_ratio')
  final int targetNothingRatio;
  @JsonKey(name: 'calling_group_id')
  final int callingGroupId;
  @JsonKey(name: 'target_count')
  final int targetCount;
  @JsonKey(name: 'object_resource')
  final List<String> objectResources;
  @JsonKey(name: 'object_position_type')
  final String objectPositionType;
  @JsonKey(name: 'object_position')
  final List<double> objectPosition;
  @JsonKey(name: 'is_using_timeline')
  final bool isUsingTimeline;
  @JsonKey(name: 'control_gauge')
  final int controlGauge;
  @JsonKey(name: 'control_parts')
  final List<String> controlParts;

  @JsonKey(name: 'weapon_object_enum')
  final String? weaponObjectEnum;
  @JsonKey(name: 'linked_parts')
  final String? linkedParts;
  @JsonKey(name: 'cancel_type')
  final String? cancelType;
  @JsonKey(name: 'move_object')
  final List<String> moveObject;

  MonsterSkillData({
    this.id = 0,
    this.nameKey,
    this.descriptionKey,
    this.skillIcon = '',
    this.animationNumber = '',
    this.weaponType = '',
    this.rawPreferTarget = 'None',
    this.showLockOn = false,
    this.rawAttackType = '',
    this.rawFireType = '',
    this.castingTime = 0,
    this.breakObjects = const [],
    this.breakObjectHpRatio = 0,
    this.rawSkillValueType1 = '',
    this.skillValue1 = 0,
    this.rawSkillValueType2 = 'None',
    this.skillValue2 = 0,
    this.shotCount = 0,
    this.delayTime = 0,
    this.shotTiming = 'None',
    this.penetration = 0,
    this.projectileSpeed = 0,
    this.projectileHpRatio = 0,
    this.projectileDefRatio = 0,
    this.projectileRadiusObject = 0,
    this.projectileRadius = 0,
    this.explosionRange = 0,
    this.isDestroyableProjectile = false,
    this.relateAnim = false,
    this.decelerationRate = 0,
    this.targetCharacterRatio = 0,
    this.targetCoverRatio = 0,
    this.targetNothingRatio = 0,
    this.callingGroupId = 0,
    this.targetCount = 0,
    this.objectResources = const [],
    this.objectPositionType = 'None',
    this.objectPosition = const [0.0, 0.0, 0.0],
    this.isUsingTimeline = false,
    this.controlGauge = 0,
    this.controlParts = const [],
    this.weaponObjectEnum,
    this.linkedParts,
    this.cancelType,
    this.moveObject = const [],
  });

  factory MonsterSkillData.fromJson(Map<String, dynamic> json) => _$MonsterSkillDataFromJson(json);
}
