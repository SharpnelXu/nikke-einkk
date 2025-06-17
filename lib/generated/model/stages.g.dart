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
  difficultyType: json['difficulty_type'] as String? ?? 'Normal',
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
