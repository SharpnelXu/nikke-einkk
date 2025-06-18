import 'package:json_annotation/json_annotation.dart';

part '../generated/model/monster.g.dart';

@JsonSerializable(createToJson: false)
class MonsterSkillData {
  @JsonKey(name: 'skill_id')
  final int skillId;
  @JsonKey(name: 'use_function_id_skill')
  final List<int> useFunctionIds;
  @JsonKey(name: 'hurt_function_id_skill')
  final List<int> hurtFunctionIds;

  MonsterSkillData({this.skillId = 0, this.useFunctionIds = const [], this.hurtFunctionIds = const []});

  factory MonsterSkillData.fromJson(Map<String, dynamic> json) => _$MonsterSkillDataFromJson(json);
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
  final List<MonsterSkillData> skillData;
  @JsonKey(name: 'statenhance_id')
  final int statEnhanceId;

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
