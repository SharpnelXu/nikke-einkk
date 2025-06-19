import 'package:json_annotation/json_annotation.dart';

part '../generated/model/stages.g.dart';

// Probably not needed at all
@JsonSerializable(createToJson: false)
class UnionRaidManagerRecord {
  final int id;
  @JsonKey(name: 'monster_preset')
  final int monsterPreset;

  UnionRaidManagerRecord({required this.id, required this.monsterPreset});

  factory UnionRaidManagerRecord.fromJson(Map<String, dynamic> json) => _$UnionRaidManagerRecordFromJson(json);
}

@JsonSerializable(createToJson: false)
class UnionRaidWaveData {
  final int id;
  @JsonKey(name: 'preset_group_id')
  final int presetGroupId;
  @JsonKey(name: 'difficulty_type')
  final String difficultyType;
  @JsonKey(name: 'wave_order')
  final int waveOrder;
  final int wave;
  @JsonKey(name: 'wave_change_step')
  final int waveChangeStep;
  @JsonKey(name: 'monster_stage_lv')
  final int monsterStageLevel;
  @JsonKey(name: 'monster_stage_lv_change_group')
  final int monsterStageLevelChangeGroup;
  @JsonKey(name: 'dynamic_object_stage_lv')
  final int dynamicObjectStageLevel;
  @JsonKey(name: 'cover_stage_lv')
  final int coverStageLevel;
  @JsonKey(name: 'spot_autocontrol')
  final bool spotAutocontrol;
  @JsonKey(name: 'wave_name')
  final String waveName;
  @JsonKey(name: 'wave_description')
  final String waveDescription;
  @JsonKey(name: 'monster_image_si')
  final String monsterImageSi;
  @JsonKey(name: 'monster_image')
  final String monsterImage;
  @JsonKey(name: 'monster_spine_scale')
  final double monsterSpineScale;
  @JsonKey(name: 'reward_id')
  final int rewardId;

  UnionRaidWaveData({
    this.id = 0,
    this.presetGroupId = 0,
    this.difficultyType = '',
    this.waveOrder = 0,
    this.wave = 0,
    this.waveChangeStep = 0,
    this.monsterStageLevel = 0,
    this.monsterStageLevelChangeGroup = 0,
    this.dynamicObjectStageLevel = 0,
    this.coverStageLevel = 0,
    this.spotAutocontrol = false,
    this.waveName = '',
    this.waveDescription = '',
    this.monsterImageSi = '',
    this.monsterImage = '',
    this.monsterSpineScale = 1.0,
    this.rewardId = 0,
  });

  factory UnionRaidWaveData.fromJson(Map<String, dynamic> json) => _$UnionRaidWaveDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class WaveMonster {
  @JsonKey(name: 'wave_monster_id')
  final int? monsterId;
  @JsonKey(name: 'spawn_type')
  final String? spawnType;

  WaveMonster({this.monsterId, this.spawnType});

  factory WaveMonster.fromJson(Map<String, dynamic> json) => _$WaveMonsterFromJson(json);
}

@JsonSerializable(createToJson: false)
class WavePathData {
  @JsonKey(name: 'wave_path')
  final String? path;
  @JsonKey(name: 'wave_monster_list')
  final List<WaveMonster> monsterList;
  @JsonKey(name: 'private_monster_count')
  final int? privateMonsterCount;

  WavePathData({this.path, this.monsterList = const [], this.privateMonsterCount});

  factory WavePathData.fromJson(Map<String, dynamic> json) => _$WavePathDataFromJson(json);
}

@JsonSerializable(explicitToJson: true, createToJson: false)
class WaveData {
  @JsonKey(name: 'stage_id')
  final int stageId;
  @JsonKey(name: 'group_id')
  final String groupId;
  @JsonKey(name: 'spot_mod')
  final String spotMod;
  @JsonKey(name: 'battle_time')
  final int battleTime;
  @JsonKey(name: 'monster_count')
  final int monsterCount;
  @JsonKey(name: 'use_intro_scene')
  final bool useIntroScene;
  @JsonKey(name: 'wave_repeat')
  final bool waveRepeat;
  @JsonKey(name: 'point_data')
  final String pointData;
  @JsonKey(name: 'point_data_fly')
  final String pointDataFly;
  @JsonKey(name: 'background_name')
  final String backgroundName;
  final String theme;
  @JsonKey(name: 'theme_time')
  final String themeTime;
  @JsonKey(name: 'stage_info_bg')
  final String stageInfoBg;
  @JsonKey(name: 'target_list')
  final List<int> targetList;
  @JsonKey(name: 'wave_data')
  final List<WavePathData> waveData;
  @JsonKey(name: 'close_monster_count')
  final int closeMonsterCount;
  @JsonKey(name: 'mid_monster_count')
  final int midMonsterCount;
  @JsonKey(name: 'far_monster_count')
  final int farMonsterCount;
  @JsonKey(name: 'mod_value')
  final int? modValue;
  @JsonKey(name: 'ui_theme')
  final String? uiTheme;

  WaveData({
    this.stageId = 0,
    this.groupId = '',
    this.spotMod = '',
    this.battleTime = 0,
    this.monsterCount = 0,
    this.useIntroScene = false,
    this.waveRepeat = false,
    this.pointData = '',
    this.pointDataFly = '',
    this.backgroundName = '',
    this.theme = '',
    this.themeTime = '',
    this.stageInfoBg = '',
    this.targetList = const [],
    this.waveData = const [],
    this.closeMonsterCount = 0,
    this.midMonsterCount = 0,
    this.farMonsterCount = 0,
    this.modValue,
    this.uiTheme,
  });

  factory WaveData.fromJson(Map<String, dynamic> json) => _$WaveDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class SoloRaidWaveData {
  final int id;
  @JsonKey(name: 'preset_group_id')
  final int presetGroupId;
  @JsonKey(name: 'difficulty_type')
  final String difficultyType;
  @JsonKey(name: 'quick_battle_type')
  final String quickBattleType;
  @JsonKey(name: 'character_lv')
  final int characterLevel;
  @JsonKey(name: 'wave_open_condition')
  final int waveOpenCondition;
  @JsonKey(name: 'wave_order')
  final int waveOrder;
  @JsonKey(name: 'wave')
  final int wave;
  @JsonKey(name: 'monster_stage_lv')
  final int monsterStageLevel;
  @JsonKey(name: 'monster_stage_lv_change_group')
  final int monsterStageLevelChangeGroup;
  @JsonKey(name: 'dynamic_object_stage_lv')
  final int dynamicObjectStageLevel;
  @JsonKey(name: 'cover_stage_lv')
  final int coverStageLevel;
  @JsonKey(name: 'spot_autocontrol')
  final bool spotAutocontrol;
  @JsonKey(name: 'wave_name')
  final String waveName;
  @JsonKey(name: 'wave_description')
  final String waveDescription;
  @JsonKey(name: 'monster_image_si')
  final String monsterImageSi;
  @JsonKey(name: 'monster_image')
  final String monsterImage;
  @JsonKey(name: 'first_clear_reward_id')
  final int firstClearRewardId;
  @JsonKey(name: 'reward_id')
  final int rewardId;

  SoloRaidWaveData({
    this.id = 0,
    this.presetGroupId = 0,
    this.difficultyType = '',
    this.quickBattleType = '',
    this.characterLevel = 0,
    this.waveOpenCondition = 0,
    this.waveOrder = 0,
    this.wave = 0,
    this.monsterStageLevel = 0,
    this.monsterStageLevelChangeGroup = 0,
    this.dynamicObjectStageLevel = 0,
    this.coverStageLevel = 0,
    this.spotAutocontrol = false,
    this.waveName = '',
    this.waveDescription = '',
    this.monsterImageSi = '',
    this.monsterImage = '',
    this.firstClearRewardId = 0,
    this.rewardId = 0,
  });

  factory SoloRaidWaveData.fromJson(Map<String, dynamic> json) => _$SoloRaidWaveDataFromJson(json);
}
