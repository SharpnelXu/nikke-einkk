import 'package:json_annotation/json_annotation.dart';

import 'common.dart';

part '../generated/model/skills.g.dart';

// "skillType": "{SetBuff, InstantNumber, InstantArea, InstallBarrier, InstantAll, InstantCircle, InstallDecoy,
// ChangeWeapon, LaunchWeapon, LaserBeam, Stigma, InstantCircleSeparate, HitMonsterGetBuff, ExplosiveCircuit, InstantSequentialAttack}"
@JsonEnum(fieldRename: FieldRename.pascal)
enum CharacterSkillType {
  setBuff,
  instantAll,
  instantArea,
  instantCircle,
  instantCircleSeparate,
  instantNumber,
  instantSequentialAttack,
  installBarrier,
  installDecoy,
  changeWeapon,
  launchWeapon,
  laserBeam,
  explosiveCircuit,
  stigma,
  hitMonsterGetBuff,
  unknown,
}

// "durationType": "{TimeSec, None, Shots, Battles}"
// from functionTable: hits, timeSecBattles
@JsonEnum(fieldRename: FieldRename.pascal)
enum DurationType { none, timeSec, shots, battles, hits, timeSecBattles, unknown }

// "skillValueType": "{None, Integer, Percent}"
@JsonEnum(fieldRename: FieldRename.pascal)
enum ValueType { none, integer, percent, unknown }

@JsonSerializable()
class SkillValueData {
  @JsonKey(name: 'skill_value_type')
  final ValueType skillValueType;

  @JsonKey(name: 'skill_value')
  final int skillValue;

  SkillValueData({this.skillValueType = ValueType.unknown, this.skillValue = 0});

  factory SkillValueData.fromJson(Map<String, dynamic> json) => _$SkillValueDataFromJson(json);

  Map<String, dynamic> toJson() => _$SkillValueDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SkillData {
  final int id;
  @JsonKey(name: 'skill_cooltime')
  final int skillCooltime;
  @JsonKey(name: 'attack_type')
  final AttackType attackType;
  // "counterType": "{Metal_Type, Energy_Type, Bio_Type}", this is probably not used
  @JsonKey(name: 'counter_type')
  final String counterType;
  @JsonKey(name: 'prefer_target')
  final PreferTarget preferTarget;
  @JsonKey(name: 'prefer_target_condition')
  final PreferTargetCondition preferTargetCondition;
  @JsonKey(name: 'skill_type')
  final CharacterSkillType skillType;
  @JsonKey(name: 'skill_value_data')
  final List<SkillValueData> skillValueData;
  @JsonKey(name: 'duration_type')
  final DurationType durationType;
  @JsonKey(name: 'duration_value')
  final int durationValue;
  @JsonKey(name: 'before_use_function_id_list')
  final List<int> beforeUseFunctionIdList;
  @JsonKey(name: 'before_hurt_function_id_list')
  final List<int> beforeHurtFunctionIdList;
  @JsonKey(name: 'after_use_function_id_list')
  final List<int> afterUseFunctionIdList;
  @JsonKey(name: 'after_hurt_function_id_list')
  final List<int> afterHurtFunctionIdList;
  @JsonKey(name: 'resource_name')
  final String resourceName;
  final String icon;
  @JsonKey(name: 'shake_id')
  final int shakeId;

  SkillData({
    this.id = 0,
    this.skillCooltime = 0,
    this.attackType = AttackType.unknown,
    this.counterType = '',
    this.preferTarget = PreferTarget.unknown,
    this.preferTargetCondition = PreferTargetCondition.unknown,
    this.skillType = CharacterSkillType.unknown,
    this.skillValueData = const [],
    this.durationType = DurationType.unknown,
    this.durationValue = 0,
    this.beforeUseFunctionIdList = const [],
    this.beforeHurtFunctionIdList = const [],
    this.afterUseFunctionIdList = const [],
    this.afterHurtFunctionIdList = const [],
    this.resourceName = '',
    this.icon = '',
    this.shakeId = 0,
  });

  factory SkillData.fromJson(Map<String, dynamic> json) => _$SkillDataFromJson(json);

  Map<String, dynamic> toJson() => _$SkillDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SkillFunction {
  final int function;

  SkillFunction({this.function = 0});

  factory SkillFunction.fromJson(Map<String, dynamic> json) => _$SkillFunctionFromJson(json);

  Map<String, dynamic> toJson() => _$SkillFunctionToJson(this);
}

// State Effects directly call functions, probably add buffs?
@JsonSerializable(explicitToJson: true)
class StateEffectData {
  final int id;
  // no state effects use this
  @JsonKey(name: 'use_function_id_list')
  final List<int> useFunctionIdList;
  // no nikke state effects use this
  @JsonKey(name: 'hurt_function_id_list')
  final List<int> hurtFunctionIdList;
  final List<SkillFunction> functions;
  final String icon;

  StateEffectData({
    this.id = 0,
    this.useFunctionIdList = const [],
    this.hurtFunctionIdList = const [],
    this.functions = const [],
    this.icon = '',
  });

  factory StateEffectData.fromJson(Map<String, dynamic> json) => _$StateEffectDataFromJson(json);

  Map<String, dynamic> toJson() => _$StateEffectDataToJson(this);
}

// "buff": "{Etc, Buff, DeBuff, BuffEtc, DebuffEtc}"
@JsonEnum(fieldRename: FieldRename.pascal)
enum BuffType {
  etc,
  buff,
  buffEtc,
  deBuff,
  @JsonValue('DebuffEtc')
  deBuffEtc,
  unknown,
}

// "buffRemove": "{Etc, Clear, Resist}"
// not sure if this is the same as buffType, probably not the same
@JsonEnum(fieldRename: FieldRename.pascal)
enum BuffRemoveType { etc, clear, resist, unknown }

@JsonEnum(fieldRename: FieldRename.pascal)
enum FunctionType {
  unknown,
  addDamage,
  addIncElementDmgType,
  allAmmo,
  allStepBurstNextStep,
  atkBuffChange,
  atkChangHpRate,
  atkChangeMaxHpRate,
  atkReplaceMaxHpRate,
  attention,
  barrierDamage,
  bonusRangeDamageChange,
  breakDamage,
  buffRemove,
  burstGaugeCharge,
  callingMonster,
  changeChangeBurstStep,
  changeCoolTimeAll,
  changeCoolTimeSkill1,
  changeCoolTimeSkill2,
  changeCoolTimeUlti,
  changeCurrentHpValue,
  changeMaxSkillCoolTime2,
  changeMaxSkillCoolTimeUlti,
  changeNormalDefIgnoreDamage,
  chargeDamageChangeMaxStatAmmo,
  chargeTimeChangetoDamage,
  changeUseBurstSkill,
  copyAtk,
  copyHp,
  coreShotDamageChange,
  coverResurrection,
  currentHpRatioDamage,
  cycleUse,
  damage,
  damageBio,
  damageEnergy,
  damageFunctionTargetGroupId,
  damageFunctionUnable,
  damageFunctionValueChange,
  damageMetal,
  damageRatioEnergy,
  damageRatioMetal,
  damageReduction,
  damageShare,
  damageShareInstant,
  damageShareInstantUnable,
  debuffImmune,
  debuffRemove,
  defChangHpRate,
  defIgnoreDamage,
  defIgnoreDamageRatio,
  drainHpBuff,
  durationDamageRatio,
  durationValueChange,
  explosiveCircuitAccrueDamageRatio,
  finalStatHpHeal,
  firstBurstGaugeSpeedUp,
  fixStatReloadTime,
  forcedStop,
  fullChargeHitDamageRepeat,
  fullCountDamageRatio,
  functionOverlapChange,
  gainAmmo,
  gainUltiGauge,
  givingHealVariation,
  gravityBomb,
  healBarrier,
  healCharacter,
  healCover,
  healDecoy,
  healShare,
  healVariation,
  hide,
  hpProportionDamage,
  immuneAttention,
  immuneBio,
  immuneChangeCoolTimeUlti,
  immuneDamage,
  @JsonValue('ImmuneDamage_MainHP')
  immuneDamageMainHp,
  immuneEnergy,
  immuneForcedStop,
  immuneGravityBomb,
  immuneInstantDeath,
  immuneInstallBarrier,
  immuneMetal,
  immuneOtherElement,
  immuneStun,
  immuneTaunt,
  immortal,
  incBarrierHp,
  incBurstDuration,
  incElementDmg,
  infection,
  instantAllBurstDamage,
  instantDeath,
  linkAtk,
  linkDef,
  none,
  normalDamageRatioChange,
  normalStatCritical,
  outBonusRangeDamageChange,
  overHealSave,
  partsDamage,
  partsHpChangeUIOff,
  partsHpChangeUIOn,
  partsImmuneDamage,
  penetrationDamage,
  plusDebuffCount,
  plusInstantSkillTargetNum,
  projectileDamage,
  projectileExplosionDamage,
  removeFunctionGroup,
  repeatUseBurstStep,
  resurrection,
  shareDamageIncrease,
  silence,
  singleBurstDamage,
  statAccuracyCircle,
  statAmmo,
  statAmmoLoad,
  statAtk,
  statBioResist,
  statBonusRangeMax,
  statBurstSkillCoolTime,
  statChargeDamage,
  statChargeTime,
  statChargeTimeImmune,
  statCritical,
  statCriticalDamage,
  statDef,
  statEndRateOfFire,
  statEnergyResist,
  statExplosion,
  statHp,
  statHpHeal,
  statInstantSkillRange,
  statMaintainFireStance,
  statPenetration,
  statRateOfFire,
  statRateOfFirePerShot,
  statReloadBulletRatio,
  statReloadTime,
  statShotCount,
  statSpotRadius,
  stickyProjectileCollisionDamage,
  stickyProjectileExplosion,
  stickyProjectileInstantExplosion,
  stun,
  taunt,
  targetGroupid,
  targetPartsId,
  timingTriggerValueChange,
  transformation,
  uncoverable,
  useCharacterSkillId,
  useSkill2,
  windReduction,
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum StandardType { unknown, none, user, functionTarget, triggerTarget }

@JsonEnum(fieldRename: FieldRename.pascal)
enum FunctionTargetType { unknown, none, self, target, targetCover, allCharacter, allMonster, userCover }

@JsonEnum(fieldRename: FieldRename.pascal)
enum TimingTriggerType {
  unknown,
  none,
  onAmmoRatioUnder,
  onBurstSkillStep,
  onBurstSkillUseNum,
  onCheckTime,
  onCoreHitNum,
  onCoreHitNumOnce,
  onCoreHitRatio,
  onCoverHurtRatio,
  onCriticalHitNum,
  onDead,
  onEndFullBurst,
  onEndReload,
  onEnterBurstStep,
  onFullCharge,
  onFullChargeHit,
  onFullChargeHitNum,
  onFullChargeNum,
  onFullChargeShot,
  onFullChargeShotNum,
  onFullCount,
  onFunctionBuffCheck,
  onFunctionOff,
  onFunctionOn,
  onHealCover,
  onHealedBy,
  onHitNum,
  onHitNumExceptCore,
  onHitNumberOver,
  onHitRatio,
  onHpRatioUnder,
  onHpRatioUp,
  onHurtCount,
  onHurtRatio,
  onInstallBarrier,
  onInstantDeath,
  onKeepFullcharge,
  onKillRatio,
  onLastAmmoUse,
  onLastShotHit,
  onNikkeDead,
  onPartsBrokenNum,
  onPartsHitNum,
  onPartsHitRatio,
  onPartsHurtCount,
  onPelletHitNum,
  onPelletHitPerShot,
  onResurrection,
  onShotNotFullCharge,
  onShotRatio,
  onSkillUse,
  onSpawnMonster,
  onSpawnTarget,
  onSquadHurtRatio,
  onStart,
  onSummonMonster,
  onTeamHpRatioUnder,
  onTeamHpRatioUp,
  onUseAmmo,
  onUseBurstSkill,
  onUserPartsDestroy,
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum StatusTriggerType {
  unknown,
  none,
  isAlive,
  isAmmoCount,
  isBurstMember,
  isBurstStepState,
  isCharacter,
  isCheckFunctionOverlapUp,
  isCheckMonster,
  isCheckMonsterType,
  isCheckPartsId,
  isCheckPosition,
  isCheckTarget,
  isCheckTeamBurstNextStep,
  isClassType,
  isCover,
  isExplosiveCircuitOff,
  isFullCharge,
  isFullCount,
  isFunctionBuffCheck,
  isFunctionOff,
  isFunctionOn,
  isFunctionTypeOffCheck,
  isHaveBarrier,
  isHaveDecoy,
  isHpRatioUnder,
  isHpRatioUp,
  isNotBurstMember,
  isNotCheckTeamBurstNextStep,
  isNotHaveBarrier,
  @JsonValue('isPhase')
  isPhase,
  @JsonValue('IsSameSqaudCount')
  isSameSquadCount,
  @JsonValue('IsSameSqaudUp')
  isSameSquadUp,
  isSearchElementId,
  isStun,
  isWeaponType,
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum FunctionStatus { on, off }

@JsonSerializable(explicitToJson: true)
class FunctionData {
  final int id;
  @JsonKey(name: 'group_id')
  final int groupId;
  final int level;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  // equipment lines are BuffEtc
  final BuffType buff;
  @JsonKey(name: 'buff_remove')
  final BuffRemoveType buffRemove;
  @JsonKey(name: 'function_type')
  final FunctionType functionType;
  @JsonKey(name: 'function_value_type')
  final ValueType functionValueType;
  @JsonKey(name: 'function_standard')
  final StandardType functionStandard;
  @JsonKey(name: 'function_value')
  final int functionValue;
  // equipment lines have full_count 100, Grave S2 function 4 (stateEffect) has full_count 60
  // this seems to be proc count on timing_trigger_type, e.g. Grave's S2 has full_count 30/60 for two funcs
  // and those have OnHitNum for time_trigger_type
  @JsonKey(name: 'full_count')
  final int fullCount;
  // from Grave S2, the buffs that get displayed have false, the misc counters have true
  // need more research
  // Phantom S1E2 is a displayed buff with is_cancel true
  @JsonKey(name: 'is_cancel')
  final bool isCancel;
  @JsonKey(name: 'delay_type')
  final DurationType delayType;
  @JsonKey(name: 'delay_value')
  final int delayValue;
  @JsonKey(name: 'duration_type')
  final DurationType durationType;
  @JsonKey(name: 'duration_value')
  final int durationValue;
  @JsonKey(name: 'limit_value')
  final int limitValue;
  @JsonKey(name: 'function_target')
  final FunctionTargetType functionTarget;
  // might be possible that connected functions ignore this condition (from Phantom S1E2, which is linked to E1)
  @JsonKey(name: 'timing_trigger_type')
  final TimingTriggerType timingTriggerType;
  @JsonKey(name: 'timing_trigger_standard')
  final StandardType timingTriggerStandard;
  @JsonKey(name: 'timing_trigger_value')
  final int timingTriggerValue;
  @JsonKey(name: 'status_trigger_type')
  final StatusTriggerType statusTriggerType;
  @JsonKey(name: 'status_trigger_standard')
  final StandardType statusTriggerStandard;
  @JsonKey(name: 'status_trigger_value')
  final int statusTriggerValue;
  @JsonKey(name: 'status_trigger2_type')
  final StatusTriggerType statusTrigger2Type;
  @JsonKey(name: 'status_trigger2_standard')
  final StandardType statusTrigger2Standard;
  @JsonKey(name: 'status_trigger2_value')
  final int statusTrigger2Value;
  // best guess is whether to keep the function as on or off after trigger
  @JsonKey(name: 'keeping_type')
  final FunctionStatus keepingType;
  @JsonKey(name: 'buff_icon')
  final String buffIcon;

  // these are likely effects
  // "shotFxListType": "{None, Gear1, Gear2, Gear3}"
  @JsonKey(name: 'shot_fx_list_type')
  final String shotFxListType;
  // a bunch of fx_xxx_xxx_xxx string, probably linked to effects?
  @JsonKey(name: 'fx_prefab_01')
  final String fxPrefab01;
  // "fxTarget": "{User, Target, TargetMonsterDead}" (also some don't have these fxTargetXX fields)
  @JsonKey(name: 'fx_target_01')
  final String fxTarget01;
  // "fxSocketPoint": "{None, Center, Bottom, Head, Top, Cover, World, Core}"
  // (also some don't have these fxSocketPointXX fields)
  @JsonKey(name: 'fx_socket_point_01')
  final String fxSocketPoint01;
  @JsonKey(name: 'fx_prefab_02')
  final String fxPrefab02;
  @JsonKey(name: 'fx_target_02')
  final String fxTarget02;
  @JsonKey(name: 'fx_socket_point_02')
  final String fxSocketPoint02;
  @JsonKey(name: 'fx_prefab_03')
  final String fxPrefab03;
  @JsonKey(name: 'fx_target_03')
  final String fxTarget03;
  @JsonKey(name: 'fx_socket_point_03')
  final String fxSocketPoint03;
  @JsonKey(name: 'fx_prefab_full')
  final String fxPrefabFull;
  @JsonKey(name: 'fx_target_full')
  final String fxTargetFull;
  @JsonKey(name: 'fx_socket_point_full')
  final String fxSocketPointFull;
  @JsonKey(name: 'fx_prefab_01_arena')
  final String fxPrefab01Arena;
  @JsonKey(name: 'fx_target_01_arena')
  final String fxTarget01Arena;
  @JsonKey(name: 'fx_socket_point_01_arena')
  final String fxSocketPoint01Arena;
  @JsonKey(name: 'fx_prefab_02_arena')
  final String fxPrefab02Arena;
  @JsonKey(name: 'fx_target_02_arena')
  final String fxTarget02Arena;
  @JsonKey(name: 'fx_socket_point_02_arena')
  final String fxSocketPoint02Arena;
  @JsonKey(name: 'fx_prefab_03_arena')
  final String fxPrefab03Arena;
  @JsonKey(name: 'fx_target_03_arena')
  final String fxTarget03Arena;
  @JsonKey(name: 'fx_socket_point_03_arena')
  final String fxSocketPoint03Arena;

  @JsonKey(name: 'connected_function')
  final List<int> connectedFunction;

  FunctionData({
    this.id = 0,
    this.groupId = 0,
    this.level = 0,
    this.nameLocalkey = '',
    this.buff = BuffType.unknown,
    this.buffRemove = BuffRemoveType.unknown,
    this.functionType = FunctionType.unknown,
    this.functionValueType = ValueType.unknown,
    this.functionStandard = StandardType.unknown,
    this.functionValue = 0,
    this.fullCount = 0,
    this.isCancel = false,
    this.delayType = DurationType.unknown,
    this.delayValue = 0,
    this.durationType = DurationType.unknown,
    this.durationValue = 0,
    this.limitValue = 0,
    this.functionTarget = FunctionTargetType.unknown,
    this.timingTriggerType = TimingTriggerType.unknown,
    this.timingTriggerStandard = StandardType.unknown,
    this.timingTriggerValue = 0,
    this.statusTriggerType = StatusTriggerType.unknown,
    this.statusTriggerStandard = StandardType.unknown,
    this.statusTriggerValue = 0,
    this.statusTrigger2Type = StatusTriggerType.unknown,
    this.statusTrigger2Standard = StandardType.unknown,
    this.statusTrigger2Value = 0,
    this.keepingType = FunctionStatus.off,
    this.buffIcon = '',
    this.shotFxListType = '',
    this.fxPrefab01 = '',
    this.fxTarget01 = '',
    this.fxSocketPoint01 = '',
    this.fxPrefab02 = '',
    this.fxTarget02 = '',
    this.fxSocketPoint02 = '',
    this.fxPrefab03 = '',
    this.fxTarget03 = '',
    this.fxSocketPoint03 = '',
    this.fxPrefabFull = '',
    this.fxTargetFull = '',
    this.fxSocketPointFull = '',
    this.fxPrefab01Arena = '',
    this.fxTarget01Arena = '',
    this.fxSocketPoint01Arena = '',
    this.fxPrefab02Arena = '',
    this.fxTarget02Arena = '',
    this.fxSocketPoint02Arena = '',
    this.fxPrefab03Arena = '',
    this.fxTarget03Arena = '',
    this.fxSocketPoint03Arena = '',
    this.connectedFunction = const [],
  });

  factory FunctionData.fromJson(Map<String, dynamic> json) => _$FunctionDataFromJson(json);

  Map<String, dynamic> toJson() => _$FunctionDataToJson(this);
}
