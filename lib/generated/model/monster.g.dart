// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/monster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonsterSkillData _$MonsterSkillDataFromJson(Map<String, dynamic> json) => MonsterSkillData(
  skillId: (json['skill_id'] as num?)?.toInt() ?? 0,
  useFunctionIds:
      (json['use_function_id_skill'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  hurtFunctionIds:
      (json['hurt_function_id_skill'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
);

MonsterData _$MonsterDataFromJson(Map<String, dynamic> json) => MonsterData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  elementIds: (json['element_id'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  monsterModelId: (json['monster_model_id'] as num?)?.toInt() ?? 0,
  nameKey: json['name_localkey'] as String? ?? '',
  appearanceKey: json['appearance_localkey'] as String? ?? '',
  descriptionKey: json['description_localkey'] as String? ?? '',
  isIrregular: json['is_irregular'] as bool? ?? false,
  hpRatio: (json['hp_ratio'] as num?)?.toInt() ?? 0,
  attackRatio: (json['attack_ratio'] as num?)?.toInt() ?? 0,
  defenceRatio: (json['defence_ratio'] as num?)?.toInt() ?? 0,
  energyResistRatio: (json['energy_resist_ratio'] as num?)?.toInt() ?? 0,
  metalResistRatio: (json['metal_resist_ratio'] as num?)?.toInt() ?? 0,
  bioResistRatio: (json['bio_resist_ratio'] as num?)?.toInt() ?? 0,
  detectorCenter: (json['detector_center'] as num?)?.toInt() ?? 0,
  detectorRadius: (json['detector_radius'] as num?)?.toInt() ?? 0,
  nonetarget: json['nonetarget'] as String? ?? 'Normal',
  functionnonetarget: json['functionnonetarget'] as String? ?? 'Normal',
  spotAi: json['spot_ai'] as String? ?? '',
  spotAiDefense: json['spot_ai_defense'] as String? ?? '',
  spotAiBaseDefense: json['spot_ai_basedefense'] as String? ?? '',
  spotMoveSpeed: (json['spot_move_speed'] as num?)?.toInt() ?? 0,
  spotAccelerationTime: (json['spot_acceleration_time'] as num?)?.toInt() ?? 0,
  fixedSpawnType: json['fixed_spawn_type'] as String? ?? 'None',
  spotRandRatioNormal: (json['spot_rand_ratio_normal'] as num?)?.toInt() ?? 0,
  spotRandRatioJump: (json['spot_rand_ratio_jump'] as num?)?.toInt() ?? 0,
  spotRandRatioDrop: (json['spot_rand_ratio_drop'] as num?)?.toInt() ?? 0,
  spotRandRatioDash: (json['spot_rand_ratio_dash'] as num?)?.toInt() ?? 0,
  spotRandRatioTeleport: (json['spot_rand_ratio_teleport'] as num?)?.toInt() ?? 0,
  skillData:
      (json['skill_data'] as List<dynamic>?)
          ?.map((e) => MonsterSkillData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  statEnhanceId: (json['statenhance_id'] as num?)?.toInt() ?? 0,
);

MonsterStatEnhanceData _$MonsterStatEnhanceDataFromJson(Map<String, dynamic> json) => MonsterStatEnhanceData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  groupId: (json['group_id'] as num?)?.toInt() ?? 0,
  lv: (json['lv'] as num?)?.toInt() ?? 0,
  levelHp: (json['level_hp'] as num?)?.toInt() ?? 0,
  levelAttack: (json['level_attack'] as num?)?.toInt() ?? 0,
  levelDefence: (json['level_defence'] as num?)?.toInt() ?? 0,
  levelStatDamageRatio: (json['level_statdamageratio'] as num?)?.toInt() ?? 0,
  levelEnergyResist: (json['level_energy_resist'] as num?)?.toInt() ?? 0,
  levelMetalResist: (json['level_metal_resist'] as num?)?.toInt() ?? 0,
  levelBioResist: (json['level_bio_resist'] as num?)?.toInt() ?? 0,
  levelProjectileHp: (json['level_projectile_hp'] as num?)?.toInt() ?? 0,
  levelBrokenHp: (json['level_broken_hp'] as num?)?.toInt() ?? 0,
);

MonsterPartData _$MonsterPartDataFromJson(Map<String, dynamic> json) => MonsterPartData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  monsterModelId: (json['monster_model_id'] as num?)?.toInt() ?? 0,
  partsNameKey: json['parts_name_localkey'] as String?,
  damageHpRatio: (json['damage_hp_ratio'] as num?)?.toInt() ?? 0,
  hpRatio: (json['hp_ratio'] as num?)?.toInt() ?? 0,
  attackRatio: (json['attack_ratio'] as num?)?.toInt() ?? 0,
  defenceRatio: (json['defence_ratio'] as num?)?.toInt() ?? 0,
  energyResistRatio: (json['energy_resist_ratio'] as num?)?.toInt() ?? 0,
  metalResistRatio: (json['metal_resist_ratio'] as num?)?.toInt() ?? 0,
  bioResistRatio: (json['bio_resist_ratio'] as num?)?.toInt() ?? 0,
  destroyAfterAnim: json['destroy_after_anim'] as bool? ?? false,
  destroyAfterMovable: json['destroy_after_movable'] as bool? ?? false,
  passiveSkillId: (json['passive_skill_id'] as num?)?.toInt() ?? 0,
  visibleHp: json['visible_hp'] as bool? ?? false,
  linkedPartsId: (json['linked_parts_id'] as num?)?.toInt() ?? 0,
  weaponObjects: (json['weapon_object'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  weaponObjectEnums: (json['weapon_object_enum'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  partsType: json['parts_type'] as String? ?? '',
  partsObjects: (json['parts_object'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  partsSkin: json['parts_skin'] as String? ?? '',
  destroyAnimTrigger: json['monster_destroy_anim_trigger'] as String? ?? 'None',
  isMainPart: json['is_main_part'] as bool? ?? false,
  isPartsDamageable: json['is_parts_damage_able'] as bool? ?? false,
);

MonsterStageLevelChangeData _$MonsterStageLevelChangeDataFromJson(Map<String, dynamic> json) =>
    MonsterStageLevelChangeData(
      id: (json['id'] as num?)?.toInt() ?? 0,
      group: (json['group'] as num?)?.toInt() ?? 0,
      step: (json['step'] as num?)?.toInt() ?? 0,
      conditionType: json['condition_type'] as String? ?? '',
      conditionValueMin: (json['condition_value_min'] as num?)?.toInt() ?? 0,
      conditionValueMax: (json['condition_value_max'] as num?)?.toInt() ?? 0,
      monsterStageLv: (json['monster_stage_lv'] as num?)?.toInt() ?? 0,
      passiveSkillId: (json['passive_skill_id'] as num?)?.toInt() ?? 0,
      targetPassiveSkillId: (json['target_passive_skill_id'] as num?)?.toInt() ?? 0,
      gimmickObjectLvControl: (json['gimmickobject_lv_control'] as num?)?.toInt() ?? 0,
    );
