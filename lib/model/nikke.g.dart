// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nikke.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NikkeCharacterData _$NikkeCharacterDataFromJson(Map<String, dynamic> json) => NikkeCharacterData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  resourceId: (json['resource_id'] as num?)?.toInt() ?? 0,
  additionalSkins: (json['additional_skins'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  nameCode: (json['name_code'] as num?)?.toInt() ?? 0,
  order: (json['order'] as num?)?.toInt() ?? 0,
  originalRare:
      $enumDecodeNullable(_$RarityEnumMap, json['original_rare'], unknownValue: Rarity.unknown) ?? Rarity.unknown,
  gradeCoreId: (json['grade_core_id'] as num?)?.toInt() ?? 0,
  growGrade: (json['grow_grade'] as num?)?.toInt() ?? 0,
  statEnhanceId: (json['stat_enhance_id'] as num?)?.toInt() ?? 0,
  characterClass:
      $enumDecodeNullable(_$NikkeClassEnumMap, json['class'], unknownValue: NikkeClass.unknown) ?? NikkeClass.unknown,
  elementId: (json['element_id'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  criticalRatio: (json['critical_ratio'] as num?)?.toInt() ?? 0,
  criticalDamage: (json['critical_damage'] as num?)?.toInt() ?? 0,
  shotId: (json['shot_id'] as num?)?.toInt() ?? 0,
  bonusRangeMin: (json['bonusrange_min'] as num?)?.toInt() ?? 0,
  bonusRangeMax: (json['bonusrange_max'] as num?)?.toInt() ?? 0,
  useBurstSkill:
      $enumDecodeNullable(_$BurstStepEnumMap, json['use_burst_skill'], unknownValue: BurstStep.unknown) ??
      BurstStep.unknown,
  changeBurstStep:
      $enumDecodeNullable(_$BurstStepEnumMap, json['change_burst_step'], unknownValue: BurstStep.unknown) ??
      BurstStep.unknown,
  burstApplyDelay: (json['burst_apply_delay'] as num?)?.toInt() ?? 0,
  burstDuration: (json['burst_duration'] as num?)?.toInt() ?? 0,
  ultiSkillId: (json['ulti_skill_id'] as num?)?.toInt() ?? 0,
  skill1Id: (json['skill1_id'] as num?)?.toInt() ?? 0,
  skill1Table: json['skill1_table'] as String? ?? '',
  skill2Id: (json['skill2_id'] as num?)?.toInt() ?? 0,
  skill2Table: json['skill2_table'] as String? ?? '',
  effCategoryType: json['eff_category_type'] as String? ?? '',
  effCategoryValue: (json['eff_category_value'] as num?)?.toInt() ?? 0,
  categoryType1: json['category_type_1'] as String? ?? '',
  categoryType2: json['category_type_2'] as String? ?? '',
  categoryType3: json['category_type_3'] as String? ?? '',
  corporation:
      $enumDecodeNullable(_$CorporationEnumMap, json['corporation'], unknownValue: Corporation.unknown) ??
      Corporation.unknown,
  cvLocalkey: json['cv_localkey'] as String? ?? '',
  squad: json['squad'] as String? ?? '',
  pieceId: (json['piece_id'] as num?)?.toInt() ?? 0,
  isVisible: json['is_visible'] as bool? ?? false,
  prismIsActive: json['prism_is_active'] as bool? ?? false,
  isDetailClose: json['is_detail_close'] as bool? ?? false,
);

Map<String, dynamic> _$NikkeCharacterDataToJson(NikkeCharacterData instance) => <String, dynamic>{
  'id': instance.id,
  'name_localkey': instance.nameLocalkey,
  'description_localkey': instance.descriptionLocalkey,
  'resource_id': instance.resourceId,
  'additional_skins': instance.additionalSkins,
  'name_code': instance.nameCode,
  'order': instance.order,
  'original_rare': _$RarityEnumMap[instance.originalRare]!,
  'grade_core_id': instance.gradeCoreId,
  'grow_grade': instance.growGrade,
  'stat_enhance_id': instance.statEnhanceId,
  'class': _$NikkeClassEnumMap[instance.characterClass]!,
  'element_id': instance.elementId,
  'critical_ratio': instance.criticalRatio,
  'critical_damage': instance.criticalDamage,
  'shot_id': instance.shotId,
  'bonusrange_min': instance.bonusRangeMin,
  'bonusrange_max': instance.bonusRangeMax,
  'use_burst_skill': _$BurstStepEnumMap[instance.useBurstSkill]!,
  'change_burst_step': _$BurstStepEnumMap[instance.changeBurstStep]!,
  'burst_apply_delay': instance.burstApplyDelay,
  'burst_duration': instance.burstDuration,
  'ulti_skill_id': instance.ultiSkillId,
  'skill1_id': instance.skill1Id,
  'skill1_table': instance.skill1Table,
  'skill2_id': instance.skill2Id,
  'skill2_table': instance.skill2Table,
  'eff_category_type': instance.effCategoryType,
  'eff_category_value': instance.effCategoryValue,
  'category_type_1': instance.categoryType1,
  'category_type_2': instance.categoryType2,
  'category_type_3': instance.categoryType3,
  'corporation': _$CorporationEnumMap[instance.corporation]!,
  'cv_localkey': instance.cvLocalkey,
  'squad': instance.squad,
  'piece_id': instance.pieceId,
  'is_visible': instance.isVisible,
  'prism_is_active': instance.prismIsActive,
  'is_detail_close': instance.isDetailClose,
};

const _$RarityEnumMap = {Rarity.unknown: 'UNKNOWN', Rarity.ssr: 'SSR', Rarity.sr: 'SR', Rarity.r: 'R'};

const _$NikkeClassEnumMap = {
  NikkeClass.unknown: 'Unknown',
  NikkeClass.attacker: 'Attacker',
  NikkeClass.defender: 'Defender',
  NikkeClass.supporter: 'Supporter',
};

const _$BurstStepEnumMap = {
  BurstStep.unknown: 'Unknown',
  BurstStep.step1: 'Step1',
  BurstStep.step2: 'Step2',
  BurstStep.step3: 'Step3',
  BurstStep.stepFull: 'StepFull',
  BurstStep.allStep: 'AllStep',
  BurstStep.nextStep: 'NextStep',
  BurstStep.none: 'None',
};

const _$CorporationEnumMap = {
  Corporation.unknown: 'UNKNOWN',
  Corporation.missilis: 'MISSILIS',
  Corporation.elysion: 'ELYSION',
  Corporation.tetra: 'TETRA',
  Corporation.pilgrim: 'PILGRIM',
  Corporation.abnormal: 'ABNORMAL',
};
