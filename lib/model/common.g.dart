// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

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
  Corporation.none: 'NONE',
  Corporation.missilis: 'MISSILIS',
  Corporation.elysion: 'ELYSION',
  Corporation.tetra: 'TETRA',
  Corporation.pilgrim: 'PILGRIM',
  Corporation.abnormal: 'ABNORMAL',
};

WeaponSkillData _$WeaponSkillDataFromJson(Map<String, dynamic> json) => WeaponSkillData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  cameraWork: json['cameraWork'] as String? ?? '',
  weaponType: $enumDecodeNullable(_$WeaponTypeEnumMap, json['weapon_type']) ?? WeaponType.unknown,
  attackType: json['attack_type'] as String? ?? '',
  counterEnemy: json['counter_enermy'] as String? ?? '',
  preferTarget: json['prefer_target'] as String? ?? '',
  preferTargetCondition: json['prefer_target_condition'] as String? ?? '',
  shotTiming: json['shot_timing'] as String? ?? '',
  fireType: json['fire_type'] as String? ?? '',
  inputType: json['input_type'] as String? ?? '',
  isTargeting: json['is_targeting'] as bool? ?? false,
  damage: (json['damage'] as num?)?.toInt() ?? 0,
  shotCount: (json['shot_count'] as num?)?.toInt() ?? 0,
  muzzleCount: (json['muzzle_count'] as num?)?.toInt() ?? 0,
  multiTargetCount: (json['multi_target_count'] as num?)?.toInt() ?? 0,
  centerShotCount: (json['center_shot_count'] as num?)?.toInt() ?? 0,
  maxAmmo: (json['max_ammo'] as num?)?.toInt() ?? 0,
  maintainFireStance: (json['maintain_fire_stance'] as num?)?.toInt() ?? 0,
  upTypeFireTiming: (json['uptype_fire_timing'] as num?)?.toInt() ?? 0,
  reloadTime: (json['reload_time'] as num?)?.toInt() ?? 0,
  reloadBullet: (json['reload_bullet'] as num?)?.toInt() ?? 0,
  reloadStartAmmo: (json['reload_start_ammo'] as num?)?.toInt() ?? 0,
  rateOfFireResetTime: (json['rate_of_fire_reset_time'] as num?)?.toInt() ?? 0,
  rateOfFire: (json['rate_of_fire'] as num?)?.toInt() ?? 0,
  endRateOfFire: (json['end_rate_of_fire'] as num?)?.toInt() ?? 0,
  rateOfFireChangePerShot: (json['rate_of_fire_change_pershot'] as num?)?.toInt() ?? 0,
  burstEnergyPerShot: (json['burst_energy_pershot'] as num?)?.toInt() ?? 0,
  targetBurstEnergyPerShot: (json['target_burst_energy_pershot'] as num?)?.toInt() ?? 0,
  spotFirstDelay: (json['spot_first_delay'] as num?)?.toInt() ?? 0,
  spotLastDelay: (json['spot_last_delay'] as num?)?.toInt() ?? 0,
  startAccuracyCircleScale: (json['start_accuracy_circle_scale'] as num?)?.toInt() ?? 0,
  endAccuracyCircleScale: (json['end_accuracy_circle_scale'] as num?)?.toInt() ?? 0,
  accuracyChangePerShot: (json['accuracy_change_pershot'] as num?)?.toInt() ?? 0,
  accuracyChangeSpeed: (json['accuracy_change_speed'] as num?)?.toInt() ?? 0,
  autoStartAccuracyCircleScale: (json['auto_start_accuracy_circle_scale'] as num?)?.toInt() ?? 0,
  autoEndAccuracyCircleScale: (json['auto_end_accuracy_circle_scale'] as num?)?.toInt() ?? 0,
  autoAccuracyChangePerShot: (json['auto_accuracy_change_pershot'] as num?)?.toInt() ?? 0,
  autoAccuracyChangeSpeed: (json['auto_accuracy_change_speed'] as num?)?.toInt() ?? 0,
  zoomRate: (json['zoom_rate'] as num?)?.toInt() ?? 0,
  multiAimRange: (json['multi_aim_range'] as num?)?.toInt() ?? 0,
  spotProjectileSpeed: (json['spot_projectile_speed'] as num?)?.toInt() ?? 0,
  chargeTime: (json['charge_time'] as num?)?.toInt() ?? 0,
  fullChargeDamage: (json['full_charge_damage'] as num?)?.toInt() ?? 0,
  fullChargeBurstEnergy: (json['full_charge_burst_energy'] as num?)?.toInt() ?? 0,
  spotRadiusObject: (json['spot_radius_object'] as num?)?.toInt() ?? 0,
  spotRadius: (json['spot_radius'] as num?)?.toInt() ?? 0,
  spotExplosionRange: (json['spot_explosion_range'] as num?)?.toInt() ?? 0,
  coreDamageRate: (json['core_damage_rate'] as num?)?.toInt() ?? 0,
  penetration: (json['penetration'] as num?)?.toInt() ?? 0,
  useFunctionIdList:
      (json['use_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  hurtFunctionIdList:
      (json['hurt_function_id_list'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? const [],
  shakeId: (json['shake_id'] as num?)?.toInt() ?? 0,
  shakeType: json['ShakeType'] as String? ?? '',
  shakeWeight: (json['ShakeWeight'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$WeaponSkillDataToJson(WeaponSkillData instance) => <String, dynamic>{
  'id': instance.id,
  'name_localkey': instance.nameLocalkey,
  'description_localkey': instance.descriptionLocalkey,
  'cameraWork': instance.cameraWork,
  'weapon_type': _$WeaponTypeEnumMap[instance.weaponType]!,
  'attack_type': instance.attackType,
  'counter_enermy': instance.counterEnemy,
  'prefer_target': instance.preferTarget,
  'prefer_target_condition': instance.preferTargetCondition,
  'shot_timing': instance.shotTiming,
  'fire_type': instance.fireType,
  'input_type': instance.inputType,
  'is_targeting': instance.isTargeting,
  'damage': instance.damage,
  'shot_count': instance.shotCount,
  'muzzle_count': instance.muzzleCount,
  'multi_target_count': instance.multiTargetCount,
  'center_shot_count': instance.centerShotCount,
  'max_ammo': instance.maxAmmo,
  'maintain_fire_stance': instance.maintainFireStance,
  'uptype_fire_timing': instance.upTypeFireTiming,
  'reload_time': instance.reloadTime,
  'reload_bullet': instance.reloadBullet,
  'reload_start_ammo': instance.reloadStartAmmo,
  'rate_of_fire_reset_time': instance.rateOfFireResetTime,
  'rate_of_fire': instance.rateOfFire,
  'end_rate_of_fire': instance.endRateOfFire,
  'rate_of_fire_change_pershot': instance.rateOfFireChangePerShot,
  'burst_energy_pershot': instance.burstEnergyPerShot,
  'target_burst_energy_pershot': instance.targetBurstEnergyPerShot,
  'spot_first_delay': instance.spotFirstDelay,
  'spot_last_delay': instance.spotLastDelay,
  'start_accuracy_circle_scale': instance.startAccuracyCircleScale,
  'end_accuracy_circle_scale': instance.endAccuracyCircleScale,
  'accuracy_change_pershot': instance.accuracyChangePerShot,
  'accuracy_change_speed': instance.accuracyChangeSpeed,
  'auto_start_accuracy_circle_scale': instance.autoStartAccuracyCircleScale,
  'auto_end_accuracy_circle_scale': instance.autoEndAccuracyCircleScale,
  'auto_accuracy_change_pershot': instance.autoAccuracyChangePerShot,
  'auto_accuracy_change_speed': instance.autoAccuracyChangeSpeed,
  'zoom_rate': instance.zoomRate,
  'multi_aim_range': instance.multiAimRange,
  'spot_projectile_speed': instance.spotProjectileSpeed,
  'charge_time': instance.chargeTime,
  'full_charge_damage': instance.fullChargeDamage,
  'full_charge_burst_energy': instance.fullChargeBurstEnergy,
  'spot_radius_object': instance.spotRadiusObject,
  'spot_radius': instance.spotRadius,
  'spot_explosion_range': instance.spotExplosionRange,
  'core_damage_rate': instance.coreDamageRate,
  'penetration': instance.penetration,
  'use_function_id_list': instance.useFunctionIdList,
  'hurt_function_id_list': instance.hurtFunctionIdList,
  'shake_id': instance.shakeId,
  'ShakeType': instance.shakeType,
  'ShakeWeight': instance.shakeWeight,
};

const _$WeaponTypeEnumMap = {
  WeaponType.unknown: 'unknown',
  WeaponType.none: 'None',
  WeaponType.ar: 'AR',
  WeaponType.mg: 'MG',
  WeaponType.rl: 'RL',
  WeaponType.sg: 'SG',
  WeaponType.smg: 'SMG',
  WeaponType.sr: 'SR',
};

EquipmentItemData _$EquipmentItemDataFromJson(Map<String, dynamic> json) => EquipmentItemData(
  id: (json['id'] as num?)?.toInt() ?? 0,
  nameLocalkey: json['name_localkey'] as String? ?? '',
  descriptionLocalkey: json['description_localkey'] as String? ?? '',
  resourceId: json['resource_id'] as String? ?? '',
  itemType: $enumDecodeNullable(_$ItemTypeEnumMap, json['item_type']) ?? ItemType.equip,
  itemSubType: $enumDecodeNullable(_$EquipTypeEnumMap, json['item_sub_type']) ?? EquipType.unknown,
  characterClass: $enumDecodeNullable(_$NikkeClassEnumMap, json['class']) ?? NikkeClass.unknown,
  itemRarity: $enumDecodeNullable(_$EquipRarityEnumMap, json['item_rare']) ?? EquipRarity.unknown,
  gradeCoreId: (json['grade_core_id'] as num?)?.toInt() ?? 0,
  growGrade: (json['grow_grade'] as num?)?.toInt() ?? 0,
  stat:
      (json['stat'] as List<dynamic>?)?.map((e) => EquipmentStat.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  optionSlots:
      (json['option_slot'] as List<dynamic>?)?.map((e) => OptionSlot.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  optionCost: (json['option_cost'] as num?)?.toInt() ?? 0,
  optionChangeCost: (json['option_change_cost'] as num?)?.toInt() ?? 0,
  optionLockCost: (json['option_lock_cost'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EquipmentItemDataToJson(EquipmentItemData instance) => <String, dynamic>{
  'id': instance.id,
  'name_localkey': instance.nameLocalkey,
  'description_localkey': instance.descriptionLocalkey,
  'resource_id': instance.resourceId,
  'item_type': _$ItemTypeEnumMap[instance.itemType]!,
  'item_sub_type': _$EquipTypeEnumMap[instance.itemSubType]!,
  'class': _$NikkeClassEnumMap[instance.characterClass]!,
  'item_rare': _$EquipRarityEnumMap[instance.itemRarity]!,
  'grade_core_id': instance.gradeCoreId,
  'grow_grade': instance.growGrade,
  'stat': instance.stat,
  'option_slot': instance.optionSlots,
  'option_cost': instance.optionCost,
  'option_change_cost': instance.optionChangeCost,
  'option_lock_cost': instance.optionLockCost,
};

const _$ItemTypeEnumMap = {ItemType.unknown: 'Unknown', ItemType.equip: 'Equip'};

const _$EquipTypeEnumMap = {
  EquipType.unknown: 'unknown',
  EquipType.head: 'Module_A',
  EquipType.body: 'Module_B',
  EquipType.arm: 'Module_C',
  EquipType.leg: 'Module_D',
};

const _$EquipRarityEnumMap = {
  EquipRarity.unknown: 'UNKNOWN',
  EquipRarity.t1: 'T1',
  EquipRarity.t2: 'T2',
  EquipRarity.t3: 'T3',
  EquipRarity.t4: 'T4',
  EquipRarity.t5: 'T5',
  EquipRarity.t6: 'T6',
  EquipRarity.t7: 'T7',
  EquipRarity.t8: 'T8',
  EquipRarity.t9: 'T9',
  EquipRarity.t10: 'T10',
};

EquipmentStat _$EquipmentStatFromJson(Map<String, dynamic> json) => EquipmentStat(
  statType: $enumDecodeNullable(_$StatTypeEnumMap, json['statType']) ?? StatType.none,
  statValue: (json['statValue'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EquipmentStatToJson(EquipmentStat instance) => <String, dynamic>{
  'statType': _$StatTypeEnumMap[instance.statType]!,
  'statValue': instance.statValue,
};

const _$StatTypeEnumMap = {
  StatType.atk: 'Atk',
  StatType.defence: 'Defence',
  StatType.hp: 'Hp',
  StatType.none: 'None',
  StatType.unknown: 'Unknown',
};

OptionSlot _$OptionSlotFromJson(Map<String, dynamic> json) => OptionSlot(
  optionSlot: (json['optionSlot'] as num?)?.toInt() ?? 0,
  optionSlotSuccessRatio: (json['optionSlotSuccessRatio'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OptionSlotToJson(OptionSlot instance) => <String, dynamic>{
  'optionSlot': instance.optionSlot,
  'optionSlotSuccessRatio': instance.optionSlotSuccessRatio,
};
