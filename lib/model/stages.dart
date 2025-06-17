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
    this.difficultyType = 'Normal',
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
