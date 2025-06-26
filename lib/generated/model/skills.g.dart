// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillValueData _$SkillValueDataFromJson(Map<String, dynamic> json) => SkillValueData(
  rawSkillValueType: json['skill_value_type'] as String? ?? '',
  skillValue: (json['skill_value'] as num?)?.toInt() ?? 0,
);

SkillData _$SkillDataFromJson(Map<String, dynamic> json) => SkillData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  skillCooltime: (json['skill_cooltime'] as num?)?.toInt() ?? 0,
  rawAttackType: json['attack_type'] as String? ?? '',
  counterType: json['counter_type'] as String? ?? '',
  rawPreferTarget: json['prefer_target'] as String? ?? '',
  rawPreferTargetCondition: json['prefer_target_condition'] as String? ?? '',
  rawSkillType: json['skill_type'] as String? ?? '',
  skillValueData:
      (json['skill_value_data'] as List<dynamic>?)
          ?.map((e) => SkillValueData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  rawDurationType: json['duration_type'] as String? ?? '',
  durationValue: (json['duration_value'] as num?)?.toInt() ?? 0,
  beforeUseFunctionIdList:
      (json['before_use_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  beforeHurtFunctionIdList:
      (json['before_hurt_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  afterUseFunctionIdList:
      (json['after_use_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  afterHurtFunctionIdList:
      (json['after_hurt_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  resourceName: json['resource_name'] as String? ?? '',
  icon: json['icon'] as String? ?? '',
  shakeId: (json['shake_id'] as num?)?.toInt() ?? 0,
);

SkillFunction _$SkillFunctionFromJson(Map<String, dynamic> json) =>
    SkillFunction(function: (json['function'] as num?)?.toInt() ?? 0);

StateEffectData _$StateEffectDataFromJson(Map<String, dynamic> json) => StateEffectData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  useFunctionIdList:
      (json['use_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  hurtFunctionIdList:
      (json['hurt_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  functions:
      (json['functions'] as List<dynamic>?)?.map((e) => SkillFunction.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  icon: json['icon'] as String? ?? '',
);

FunctionData _$FunctionDataFromJson(Map<String, dynamic> json) => FunctionData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  groupId: (json['group_id'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String?,
  rawBuffType: json['buff'] as String? ?? '',
  rawBuffRemove: json['buff_remove'] as String? ?? '',
  rawFunctionType: json['function_type'] as String? ?? '',
  rawFunctionValueType: json['function_value_type'] as String? ?? '',
  rawFunctionStandard: json['function_standard'] as String? ?? '',
  functionValue: (json['function_value'] as num?)?.toInt() ?? 0,
  fullCount: (json['full_count'] as num?)?.toInt() ?? 0,
  isCancel: json['is_cancel'] as bool? ?? false,
  rawDelayType: json['delay_type'] as String? ?? '',
  delayValue: (json['delay_value'] as num?)?.toInt() ?? 0,
  rawDurationType: json['duration_type'] as String? ?? '',
  durationValue: (json['duration_value'] as num?)?.toInt() ?? 0,
  limitValue: (json['limit_value'] as num?)?.toInt() ?? 0,
  rawFunctionTarget: json['function_target'] as String? ?? '',
  rawTimingTriggerType: json['timing_trigger_type'] as String? ?? '',
  rawTimingTriggerStandard: json['timing_trigger_standard'] as String? ?? '',
  timingTriggerValue: (json['timing_trigger_value'] as num?)?.toInt() ?? 0,
  rawStatusTriggerType: json['status_trigger_type'] as String? ?? '',
  rawStatusTriggerStandard: json['status_trigger_standard'] as String? ?? '',
  statusTriggerValue: (json['status_trigger_value'] as num?)?.toInt() ?? 0,
  rawStatusTrigger2Type: json['status_trigger2_type'] as String? ?? '',
  rawStatusTrigger2Standard: json['status_trigger2_standard'] as String? ?? '',
  statusTrigger2Value: (json['status_trigger2_value'] as num?)?.toInt() ?? 0,
  rawKeepingType: json['keeping_type'] as String? ?? '',
  buffIcon: json['buff_icon'] as String? ?? '',
  shotFxListType: json['shot_fx_list_type'] as String?,
  fxPrefab01: json['fx_prefab_01'] as String?,
  fxTarget01: json['fx_target_01'] as String?,
  fxSocketPoint01: json['fx_socket_point_01'] as String?,
  fxPrefab02: json['fx_prefab_02'] as String?,
  fxTarget02: json['fx_target_02'] as String?,
  fxSocketPoint02: json['fx_socket_point_02'] as String?,
  fxPrefab03: json['fx_prefab_03'] as String?,
  fxTarget03: json['fx_target_03'] as String?,
  fxSocketPoint03: json['fx_socket_point_03'] as String?,
  fxPrefabFull: json['fx_prefab_full'] as String?,
  fxTargetFull: json['fx_target_full'] as String?,
  fxSocketPointFull: json['fx_socket_point_full'] as String?,
  fxPrefab01Arena: json['fx_prefab_01_arena'] as String?,
  fxTarget01Arena: json['fx_target_01_arena'] as String?,
  fxSocketPoint01Arena: json['fx_socket_point_01_arena'] as String?,
  fxPrefab02Arena: json['fx_prefab_02_arena'] as String?,
  fxTarget02Arena: json['fx_target_02_arena'] as String?,
  fxSocketPoint02Arena: json['fx_socket_point_02_arena'] as String?,
  fxPrefab03Arena: json['fx_prefab_03_arena'] as String?,
  fxTarget03Arena: json['fx_target_03_arena'] as String?,
  fxSocketPoint03Arena: json['fx_socket_point_03_arena'] as String?,
  connectedFunction:
      (json['connected_function'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  descriptionLocalkey: json['description_localkey'] as String?,
  elementReactionIcon: json['element_reaction_icon'] as String?,
  functionBattlepower: (json['function_battlepower'] as num?)?.toInt(),
);

SkillDescriptionValue _$SkillDescriptionValueFromJson(Map<String, dynamic> json) =>
    SkillDescriptionValue(value: json['description_value'] as String?);

SkillInfoData _$SkillInfoDataFromJson(Map<String, dynamic> json) => SkillInfoData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  groupId: (json['group_id'] as num?)?.toInt() ?? 0,
  skillLevel: (json['skill_level'] as num?)?.toInt() ?? 0,
  nextLevelId: (json['next_level_id'] as num?)?.toInt() ?? 0,
  levelUpCostId: (json['level_up_cost_id'] as num?)?.toInt() ?? 0,
  icon: json['icon'] as String? ?? '',
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  infoDescriptionLocalkey: json['info_description_localkey'] as String? ?? '',
  descriptionValues:
      (json['description_value_list'] as List<dynamic>?)
          ?.map((e) => SkillDescriptionValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

WordGroupData _$WordGroupDataFromJson(Map<String, dynamic> json) => WordGroupData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  group: json['group'] as String? ?? '',
  pageNumber: (json['page_number'] as num?)?.toInt() ?? 0,
  order: (json['order'] as num?)?.toInt() ?? 0,
  resourceType: json['resource_type'] as String? ?? '',
  resourceValue: json['resource_value'] as String? ?? '',
);
