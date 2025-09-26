// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/stages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnionRaidManagerRecord _$UnionRaidManagerRecordFromJson(Map<String, dynamic> json) =>
    UnionRaidManagerRecord(id: (json['id'] as num).toInt(), monsterPreset: (json['monster_preset'] as num).toInt());

UnionRaidWaveData _$UnionRaidWaveDataFromJson(Map<String, dynamic> json) => UnionRaidWaveData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  presetGroupId: (json['preset_group_id'] as num?)?.toInt() ?? 0,
  difficultyType: json['difficulty_type'] as String? ?? '',
  waveOrder: (json['wave_order'] as num?)?.toInt() ?? 0,
  wave: (json['wave'] as num?)?.toInt() ?? 0,
  waveChangeStep: (json['wave_change_step'] as num?)?.toInt() ?? 0,
  monsterStageLevel: (json['monster_stage_lv'] as num?)?.toInt() ?? 0,
  monsterStageLevelChangeGroup: (json['monster_stage_lv_change_group'] as num?)?.toInt() ?? 0,
  dynamicObjectStageLevel: (json['dynamic_object_stage_lv'] as num?)?.toInt() ?? 0,
  coverStageLevel: (json['cover_stage_lv'] as num?)?.toInt() ?? 0,
  spotAutocontrol: json['spot_autocontrol'] as bool? ?? false,
  waveName: json['wave_name'] as String? ?? '',
  waveDescription: json['wave_description'] as String? ?? '',
  monsterImageSi: json['monster_image_si'] as String? ?? '',
  monsterImage: json['monster_image'] as String? ?? '',
  monsterSpineScale: (json['monster_spine_scale'] as num?)?.toDouble() ?? 1.0,
  rewardId: (json['reward_id'] as num?)?.toInt() ?? 0,
);

WaveMonster _$WaveMonsterFromJson(Map<String, dynamic> json) =>
    WaveMonster(monsterId: (json['wave_monster_id'] as num?)?.toInt(), spawnType: json['spawn_type'] as String?);

WavePathData _$WavePathDataFromJson(Map<String, dynamic> json) => WavePathData(
  path: json['wave_path'] as String?,
  monsterList:
      (json['wave_monster_list'] as List<dynamic>?)
          ?.map((e) => WaveMonster.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  privateMonsterCount: (json['private_monster_count'] as num?)?.toInt(),
);

WaveData _$WaveDataFromJson(Map<String, dynamic> json) => WaveData(
  stageId: (json['stage_id'] as num?)?.toInt() ?? 0,
  groupId: json['group_id'] as String? ?? '',
  spotMod: json['spot_mod'] as String? ?? '',
  battleTime: (json['battle_time'] as num?)?.toInt() ?? 0,
  monsterCount: (json['monster_count'] as num?)?.toInt() ?? 0,
  useIntroScene: json['use_intro_scene'] as bool? ?? false,
  waveRepeat: json['wave_repeat'] as bool? ?? false,
  pointData: json['point_data'] as String? ?? '',
  pointDataFly: json['point_data_fly'] as String? ?? '',
  backgroundName: json['background_name'] as String? ?? '',
  theme: json['theme'] as String? ?? '',
  themeTime: json['theme_time'] as String? ?? '',
  stageInfoBg: json['stage_info_bg'] as String? ?? '',
  targetList: (json['target_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  waveData:
      (json['wave_data'] as List<dynamic>?)?.map((e) => WavePathData.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  closeMonsterCount: (json['close_monster_count'] as num?)?.toInt() ?? 0,
  midMonsterCount: (json['mid_monster_count'] as num?)?.toInt() ?? 0,
  farMonsterCount: (json['far_monster_count'] as num?)?.toInt() ?? 0,
  modValue: (json['mod_value'] as String?),
  uiTheme: json['ui_theme'] as String?,
);

SoloRaidWaveData _$SoloRaidWaveDataFromJson(Map<String, dynamic> json) => SoloRaidWaveData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  presetGroupId: (json['preset_group_id'] as num?)?.toInt() ?? 0,
  difficultyType: json['difficulty_type'] as String? ?? '',
  quickBattleType: json['quick_battle_type'] as String? ?? '',
  characterLevel: (json['character_lv'] as num?)?.toInt() ?? 0,
  waveOpenCondition: (json['wave_open_condition'] as num?)?.toInt() ?? 0,
  waveOrder: (json['wave_order'] as num?)?.toInt() ?? 0,
  wave: (json['wave'] as num?)?.toInt() ?? 0,
  monsterStageLevel: (json['monster_stage_lv'] as num?)?.toInt() ?? 0,
  monsterStageLevelChangeGroup: (json['monster_stage_lv_change_group'] as num?)?.toInt() ?? 0,
  dynamicObjectStageLevel: (json['dynamic_object_stage_lv'] as num?)?.toInt() ?? 0,
  coverStageLevel: (json['cover_stage_lv'] as num?)?.toInt() ?? 0,
  spotAutocontrol: json['spot_autocontrol'] as bool? ?? false,
  waveName: json['wave_name'] as String? ?? '',
  waveDescription: json['wave_description'] as String? ?? '',
  monsterImageSi: json['monster_image_si'] as String? ?? '',
  monsterImage: json['monster_image'] as String? ?? '',
  firstClearRewardId: (json['first_clear_reward_id'] as num?)?.toInt() ?? 0,
  rewardId: (json['reward_id'] as num?)?.toInt() ?? 0,
);

MultiplayerRaidData _$MultiplayerRaidDataFromJson(Map<String, dynamic> json) => MultiplayerRaidData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  playerCount: (json['player_count'] as num?)?.toInt() ?? 0,
  characterSelectTimeLimit: (json['character_select_time_limit'] as num?)?.toInt() ?? 0,
  characterLevel: (json['character_lv'] as num?)?.toInt() ?? 0,
  stageLevel: (json['stage_level'] as num?)?.toInt() ?? 0,
  monsterStageLevel: (json['monster_stage_lv'] as num?)?.toInt() ?? 0,
  dynamicObjectStageLevel: (json['dynamic_object_stage_lv'] as num?)?.toInt() ?? 0,
  coverStageLevel: (json['cover_stage_lv'] as num?)?.toInt() ?? 0,
  monsterStageLevelChangeGroup: (json['monster_stage_lv_change_group'] as num?)?.toInt() ?? 0,
  spotId: (json['spot_id'] as num?)?.toInt() ?? 0,
  conditionRewardGroup: (json['condition_reward_group'] as num?)?.toInt() ?? 0,
  rewardLimitCount: (json['reward_limit_count'] as num?)?.toInt() ?? 0,
  rankConditionRewardGroup: (json['rank_condition_reward_group'] as num?)?.toInt() ?? 0,
  monsterStageLvChangeGroupEasy: (json['monster_stage_lv_change_group_easy'] as num?)?.toInt(),
  spotIdEasy: (json['spot_id_easy'] as num?)?.toInt(),
);
