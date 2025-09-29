import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nikke_einkk/model/common.dart';
import 'package:nikke_einkk/module/common/format_helper.dart';

part '../generated/model/skills.g.dart';

// "skillType": "{SetBuff, InstantNumber, InstantArea, InstallBarrier, InstantAll, InstantCircle, InstallDecoy,
// ChangeWeapon, LaunchWeapon, LaserBeam, Stigma, InstantCircleSeparate, HitMonsterGetBuff, ExplosiveCircuit, InstantSequentialAttack}"
@JsonEnum(fieldRename: FieldRename.pascal)
enum CharacterSkillType {
  none(0),
  instantAll(1),
  instantNumber(2),
  aimingExplosion(3),
  aimingPenetration(4),
  installDrone(5),
  installBarrier(6),
  changeWeapon(7),
  setBuff(8),
  instantSkill(9),
  custom191Ulti(10),
  launchWeapon(11),
  targetShot(12),
  instantCircle(13),
  instantLine(14),
  instantArea(15),
  installDecoy(16),
  multiTarget(17),
  laserBeam(18),
  stigma(19),
  maxHPInstantNumber(20),
  instantCircleSeparate(21),
  hitMonsterGetBuff(22),
  explosiveCircuit(23),
  instantSequentialAttack(24),
  reFullChargeHitDamage(25),
  instantAllParts(26),
  targetHitCountGetBuff(27),
  healCharge(28),
  unknown(-1);

  const CharacterSkillType(this.value);
  final int value;

  bool get isDamage => [
    instantAll,
    instantNumber,
    instantCircle,
    instantLine,
    instantArea,
    instantCircleSeparate,
    instantSequentialAttack,
    instantAllParts,
  ].contains(this);

  static final Map<String, CharacterSkillType> _reverseMap = Map.fromIterable(
    CharacterSkillType.values,
    key: (v) => (v as CharacterSkillType).name.pascal,
  );

  static CharacterSkillType fromName(String? name) {
    return _reverseMap[name] ?? CharacterSkillType.unknown;
  }

  static List<CharacterSkillType> sorted = CharacterSkillType.values.toList().sorted(
    (a, b) => a.name.compareTo(b.name),
  );
}

// "durationType": "{TimeSec, None, Shots, Battles}"
// from functionTable: hits, timeSecBattles
//
// Battles: Cindy's S2 E3 has duration value 1, not sure what it means for DurationType.battles
// TimeSecBattles: Flora's S1 E1 has an absurdly large value, not sure why (1000000 = 10000 seconds?)
@JsonEnum(fieldRename: FieldRename.pascal)
enum DurationType {
  none,
  timeSec,
  shots,
  battles,
  hits,
  timeSecBattles,
  @JsonValue('TimeSec_Ver2')
  timeSecVer2,
  @JsonValue('Hits_Ver2')
  hitsVer2,
  reloadAllAmmoCount,
  unknown;

  static final Map<String, DurationType> _reverseMap = Map.fromIterable(
    DurationType.values,
    key: (v) => (v as DurationType).jsonKey,
  );

  bool get isTimed => this == DurationType.timeSec || this == DurationType.timeSecVer2;
  bool get isDurationBuff => isTimed || this == DurationType.timeSecBattles;
  bool get isHits => this == DurationType.hits || this == DurationType.hitsVer2;
  bool get isShots => this == DurationType.shots;

  String get jsonKey {
    switch (this) {
      case DurationType.timeSecVer2:
        return 'TimeSec_Ver2';
      case DurationType.hitsVer2:
        return 'Hits_Ver2';
      default:
        return name.pascal;
    }
  }

  static DurationType fromName(String? name) {
    return _reverseMap[name] ?? DurationType.unknown;
  }
}

// "skillValueType": "{None, Integer, Percent}"
@JsonEnum(fieldRename: FieldRename.pascal)
enum ValueType {
  none,
  integer,
  percent,
  unknown;

  static final Map<String, ValueType> _reverseMap = Map.fromIterable(
    ValueType.values,
    key: (v) => (v as ValueType).name.pascal,
  );

  static ValueType fromName(String? name) {
    return _reverseMap[name] ?? ValueType.unknown;
  }
}

@JsonSerializable(createToJson: false)
class SkillValueData {
  @JsonKey(name: 'skill_value_type')
  final String rawSkillValueType;
  ValueType get skillValueType => ValueType.fromName(rawSkillValueType);

  @JsonKey(name: 'skill_value')
  final int skillValue;

  SkillValueData({this.rawSkillValueType = '', this.skillValue = 0});

  factory SkillValueData.fromJson(Map<String, dynamic> json) => _$SkillValueDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class SkillData {
  final int id;
  @JsonKey(name: 'skill_cooltime')
  final int skillCooltime;
  @JsonKey(name: 'attack_type')
  final String rawAttackType;
  AttackType get attackType => AttackType.fromName(rawAttackType);
  // "counterType": "{Metal_Type, Energy_Type, Bio_Type}", this is probably not used
  @JsonKey(name: 'counter_type')
  final String counterType;
  @JsonKey(name: 'prefer_target')
  final String rawPreferTarget;
  PreferTarget get preferTarget => PreferTarget.fromName(rawPreferTarget);
  @JsonKey(name: 'prefer_target_condition')
  final String rawPreferTargetCondition;
  PreferTargetCondition get preferTargetCondition => PreferTargetCondition.fromName(rawPreferTargetCondition);
  @JsonKey(name: 'skill_type')
  final String rawSkillType;
  CharacterSkillType get skillType => CharacterSkillType.fromName(rawSkillType);
  @JsonKey(name: 'skill_value_data')
  final List<SkillValueData> skillValueData;
  @JsonKey(name: 'duration_type')
  final String rawDurationType;
  DurationType get durationType => DurationType.fromName(rawDurationType);
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

  List<int> get allValidFuncIds =>
      [
        ...beforeUseFunctionIdList,
        ...beforeHurtFunctionIdList,
        ...afterUseFunctionIdList,
        ...afterHurtFunctionIdList,
      ].where((id) => id != 0).toList();

  List<int> get validPreFuncIds =>
      [...beforeUseFunctionIdList, ...beforeHurtFunctionIdList].where((id) => id != 0).toList();

  List<int> get validPostFuncIds =>
      [...afterUseFunctionIdList, ...afterHurtFunctionIdList].where((id) => id != 0).toList();

  SkillData({
    this.id = 0,
    this.skillCooltime = 0,
    this.rawAttackType = '',
    this.counterType = '',
    this.rawPreferTarget = '',
    this.rawPreferTargetCondition = '',
    this.rawSkillType = '',
    this.skillValueData = const [],
    this.rawDurationType = '',
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

  int getSkillValue(int index) {
    return skillValueData[index].skillValue;
  }
}

@JsonSerializable(createToJson: false)
class SkillFunction {
  final int function;

  SkillFunction({this.function = 0});

  factory SkillFunction.fromJson(Map<String, dynamic> json) => _$SkillFunctionFromJson(json);
}

// State Effects directly call functions, probably add buffs?
@JsonSerializable(createToJson: false)
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

  List<int> get allValidFuncIds =>
      [
        ...useFunctionIdList,
        ...hurtFunctionIdList,
        ...functions.map((func) => func.function),
      ].where((id) => id != 0).toList();

  StateEffectData({
    this.id = 0,
    this.useFunctionIdList = const [],
    this.hurtFunctionIdList = const [],
    this.functions = const [],
    this.icon = '',
  });

  factory StateEffectData.fromJson(Map<String, dynamic> json) => _$StateEffectDataFromJson(json);
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
  unknown;

  static final Map<String, BuffType> _reverseMap = Map.fromIterable(
    BuffType.values,
    key: (v) => v == BuffType.deBuffEtc ? 'DebuffEtc' : (v as BuffType).name.pascal,
  );

  static BuffType fromName(String? name) {
    return _reverseMap[name] ?? BuffType.unknown;
  }

  bool get isBuff => this == buff || this == buffEtc;
  bool get isDeBuff => this == deBuffEtc || this == deBuff;
}

// "buffRemove": "{Etc, Clear, Resist}"
// not sure if this is the same as buffType, probably not the same
@JsonEnum(fieldRename: FieldRename.pascal)
enum BuffRemoveType {
  etc,
  clear,
  resist,
  unknown;

  bool get canRemove => this == clear;

  static final Map<String, BuffRemoveType> _reverseMap = Map.fromIterable(
    BuffRemoveType.values,
    key: (v) => (v as BuffRemoveType).name.pascal,
  );

  static BuffRemoveType fromName(String? name) {
    return _reverseMap[name] ?? BuffRemoveType.unknown;
  }
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum FunctionType {
  none(0),
  statAtk(1),
  healCharacter(2),
  healCover(3),
  attention(4),
  allAmmo(5),
  stun(6),
  autoTargeting(7),
  statAccuracyCircle(8),
  statCritical(9),
  statShotCount(10),
  statChargeDamage(11),
  statExplosion(12),
  statReloadTime(13),
  statAmmo(14),
  statDef(15),
  statRateOfFire(16),
  skillCooltime(17),
  immuneStun(18),
  statUltiGaugeSec(19),
  statUltiGaugeKill(20),
  statUltiGaugeUseSkill(21),
  statUltiGaugeSkillHit(22),
  statUltiGaugeShotHit(23),
  statUltiGaugeHurt(24),
  statUltiGaugeEmptyAmmo(25),
  gainUltiGauge(26),
  gainAmmo(27),
  damageEnergy(28),
  damageMetal(29),
  damageBio(30),
  taunt(31),
  drainHp(32),
  drainUltiGauge(33),
  immuneEnergy(34),
  immuneMetal(35),
  immuneBio(36),
  immuneDamage(37),
  @JsonValue('ImmuneDamage_MainHP')
  immuneDamageMainHp(38),
  ignoreDamage(39),
  immortal(40),
  gravityBomb(41),
  damageReduction(42),
  damageShare(43),
  damageRatioEnergy(44),
  damageRatioMetal(45),
  damageRatioBio(46),
  gaugeShield(47),
  statProjectileSpeed(48),
  useSkill1(49),
  useSkill2(50),
  statCriticalDamage(51),
  healVariation(52),
  healShare(53),
  statPenetration(54),
  linkAtk(55),
  linkDef(56),
  statFirstDelay(57),
  statEnergyResist(58),
  statMetalResist(59),
  statBioResist(60),
  statChargeTime(61),
  drainHpBuff(62),
  statHp(63),
  defIgnoreDamage(64),
  atkChangHpRate(65),
  defChangHpRate(66),
  forcedStop(67),
  damageRecoverHeal(68),
  fullBurstDamage(69),
  infection(70),
  resurrection(71),
  useCharacterSkillId(72),
  immuneForcedStop(73),
  immuneGravityBomb(74),
  damage(75),
  damageRatioUp(76),
  buffRemove(77),
  debuffRemove(78),
  incReactTime(79),
  incElementDmg(80),
  changeCoolTimeSkill1(81),
  changeCoolTimeSkill2(82),
  changeCoolTimeUlti(83),
  changeCoolTimeAll(84),
  statEndRateOfFire(85),
  statRateOfFirePerShot(86),
  coreShotDamageChange(87),
  coreShotDamageRateChange(88),
  debuffImmune(89),
  incBurstDuration(90),
  changeHp(91),
  plusBuffCount(92),
  plusDebuffCount(93),
  statHpHeal(94),
  addDamage(95),
  breakDamage(96),
  hpProportionDamage(97),
  normalStatCritical(98),
  copyAtk(99),
  copyDef(100),
  copyHp(101),
  firstBurstGaugeSpeedUp(102),
  instantDeath(103),
  immuneInstantDeath(104),
  changeCurrentHpValue(105),
  singleBurstDamage(106),
  hide(107),
  statAmmoLoad(108),
  coverResurrection(109),
  immuneOtherElement(110),
  burstGaugeCharge(111),
  partsDamage(112),
  projectileDamage(113),
  silence(114),
  windReduction(115),
  electronicReduction(116),
  fireReduction(117),
  waterReduction(118),
  ironReduction(119),
  changeMaxSkillCoolTime1(120),
  changeMaxSkillCoolTime2(121),
  changeMaxSkillCoolTimeUlti(122),
  healDecoy(123),
  transformation(124),
  immortalValue(125),
  statMaintainFireStance(126),
  atkChangeMaxHpRate(127),
  overHealSave(128),
  chargeTimeChangetoDamage(129),
  timingTriggerValueChange(130),
  targetGroupid(131),
  finalStatHp(132),
  finalStatHpHeal(133),
  cycleUse(134),
  damageShareInstant(135),
  targetPartsId(136),
  partsHpChangeUIOff(137),
  partsHpChangeUIOn(138),
  statBonusRangeMax(139),
  statBonusRangeMin(140),
  uncoverable(141),
  callingMonster(142),
  statBurstSkillCoolTime(143),
  immuneChangeCoolTimeUlti(144),
  shareDamageIncrease(145),
  fullChargeHitDamageRepeat(146),
  chargeDamageChangeMaxStatAmmo(147),
  statSpotRadius(148),
  penetrationDamage(149),
  damageShareInstantUnable(150),
  damageFunctionUnable(151),
  statChargeTimeImmune(152),
  allStepBurstKeepStep(153),
  allStepBurstNextStep(154),
  incBarrierHp(155),
  healBarrier(156),
  explosiveCircuitAccrueDamageRatio(157),
  atkReplaceMaxHpRate(158),
  fixStatReloadTime(159),
  defIgnoreDamageRatio(160),
  changeNormalDefIgnoreDamage(161),
  bonusRangeDamageChange(162),
  givingHealVariation(163),
  removeFunctionGroup(164),
  normalDamageRatioChange(165),
  normalStatCriticalDamage(166),
  functionOverlapChange(167),
  durationValueChange(168),
  durationDamageRatio(169),
  repeatUseBurstStep(170),
  partsImmuneDamage(171),
  barrierDamage(172),
  currentHpRatioDamage(173),
  statReloadBulletRatio(174),
  immuneAttention(175),
  immuneInstallBarrier(176),
  immuneTaunt(177),
  fullCountDamageRatio(178),
  addIncElementDmgType(179),
  changeUseBurstSkill(180),
  changeChangeBurstStep(181),
  stickyProjectileExplosion(182),
  stickyProjectileCollisionDamage(183),
  projectileExplosionDamage(184),
  stickyProjectileInstantExplosion(185),
  minusDebuffCount(186),
  atkBuffChange(187),
  outBonusRangeDamageChange(188),
  instantAllBurstDamage(189),
  plusInstantSkillTargetNum(190),
  statInstantSkillRange(191),
  damageFunctionTargetGroupId(192),
  damageFunctionValueChange(193),
  dmgReductionExcludingBreakCol(194),
  changeHurtFxExcludingBreakCol(195),
  focusAttack(196),
  immediatelyBuffCheckImmune(197),
  durationBuffCheckImmune(198),
  immediatelyDebuffCheckImmune(199),
  durationDebuffCheckImmune(200),
  noOverlapStatAmmo(201),
  durationDamage(202),
  defIgnoreSkillDamageInstant(203),
  emptyFunction(204),
  damageShareLowestPriority(205),
  forcedReload(206),
  statDefNoneBreakCol(207),
  changeHealChargeValue(208),
  unknown(-1);

  const FunctionType(this.value);
  final int value;

  static final Map<String, FunctionType> _reverseMap = Map.fromIterable(
    FunctionType.values,
    key: (v) => (v as FunctionType).jsonKey,
  );

  String get jsonKey => this == FunctionType.immuneDamageMainHp ? 'ImmuneDamage_MainHP' : name.pascal;

  static FunctionType fromName(String name) {
    return _reverseMap[name] ?? FunctionType.unknown;
  }

  static List<FunctionType> sorted = FunctionType.values.toList().sorted((a, b) => a.name.compareTo(b.name));
}

// functionTarget may not mean the actual function target based on Flora's Skill 2 (checks teammates on both sides
// but triggerStandard is functionTarget which is self)
@JsonEnum(fieldRename: FieldRename.pascal)
enum StandardType {
  unknown,
  none,
  user,
  functionTarget,
  triggerTarget;

  static final Map<String, StandardType> _reverseMap = Map.fromIterable(
    StandardType.values,
    key: (v) => (v as StandardType).name.pascal,
  );

  static StandardType fromName(String? name) {
    return _reverseMap[name] ?? StandardType.unknown;
  }
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum FunctionTargetType {
  unknown,
  none,
  self,
  target,
  targetCover,
  allCharacter,
  allMonster,
  userCover;

  static final Map<String, FunctionTargetType> _reverseMap = Map.fromIterable(
    FunctionTargetType.values,
    key: (v) => (v as FunctionTargetType).name.pascal,
  );

  static FunctionTargetType fromName(String? name) {
    return _reverseMap[name] ?? FunctionTargetType.unknown;
  }
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum TimingTriggerType {
  none(0),
  onStart(1),
  onShotRatio(2),
  onUseAmmo(3),
  onUseBurstSkill(4),
  onHitNumberOver(5),
  onFullChargeShot(6),
  onHurtRatio(7),
  onHurtCount(8),
  onFunctionBuffCheck(9),
  onFunctionDebuffCheck(10),
  onSquadHurtRatio(11),
  onSquadHurtCount(12),
  onCoverHurtRatio(13),
  onCoverHurtCount(14),
  onHpRatioUnder(15),
  onHpRatioUp(16),
  onAmmoRatioUnder(17),
  onAmmoRatioUp(18),
  onShooterCount(19),
  onKillRatio(20),
  onFunctionOn(21),
  onEnterBurstStep(22),
  onFullCount(23),
  onCoverDestroyRatio(24),
  onBurstSkillStep(25),
  onSpawnMonster(26),
  onFullChargeHit(27),
  onAttackRatio(28),
  onLastShotHit(29),
  onSkillUse(30),
  onHitNum(31),
  onFullBurstTimeOverRatio(32),
  onPartsHitNum(33),
  onPartsHitRatio(34),
  onPartsHitNumOnce(35),
  onPartsHitRatioOnce(36),
  onLastAmmoUse(37),
  onSpawnTarget(38),
  onHitRatio(39),
  onDead(40),
  onTeamHpRatioUnder(41),
  onResurrection(42),
  onEndFullBurst(43),
  onNikkeDead(44),
  onCriticalHitNum(45),
  onCriticalHitRatio(46),
  onCriticalHitNumOnce(47),
  onCriticalHitRatioOnce(48),
  onHealedBy(49),
  onMonsterDead(50),
  onFullCharge(51),
  onInstallBarrier(52),
  onHealCover(53),
  onInstantDeath(54),
  onCoreHitRatioOnce(55),
  onCoreHitNumOnce(56),
  onCoreHitRatio(57),
  onCoreHitNum(58),
  onFullChargeNum(59),
  onFullChargeShotNum(60),
  onFullChargeHitNum(61),
  onSummonMonster(62),
  onAfterTimeSec(63),
  onPelletHitNum(64),
  onPelletHitPerShot(65),
  onPartsBrokenNum(66),
  onCheckTime(67),
  onPartsHurtCount(68),
  onPartsHurtRatio(69),
  onUserPartsDestroy(70),
  onEnemyDead(71),
  onBurstSkillUseNum(72),
  onFullChargePartsHitNum(73),
  onKeepFullcharge(74),
  onEndReload(75),
  onTeamHpRatioUp(76),
  onHurtDecoyNum(77),
  onFunctionOff(78),
  onHitNumExceptCore(79),
  onShotNotFullCharge(80),
  onKeepFullChargeShotUnder(81),
  onSpawnEnemy(82),
  onUseTeamAmmo(83),
  onPelletCriticalHitNum(84),
  onSpawnMonsterExcludeNoneType(85),
  onFunctionDamageCriticalHit(86),
  onFullChargeBonusRangeHitNum(87),
  onKeepFullChargeShot(88),
  onDeadComplete(89),
  unknown(-1);

  const TimingTriggerType(this.value);
  final int value;

  static List<TimingTriggerType> sorted = TimingTriggerType.values.toList().sorted((a, b) => a.name.compareTo(b.name));

  static final Map<String, TimingTriggerType> _reverseMap = Map.fromIterable(
    TimingTriggerType.values,
    key: (v) => (v as TimingTriggerType).name.pascal,
  );

  static TimingTriggerType fromName(String? name) {
    return _reverseMap[name] ?? TimingTriggerType.unknown;
  }
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum StatusTriggerType {
  none(0),
  isAmmoRatioUnder(1),
  isAmmoRatioUp(2),
  isAmmoCount(3),
  isAmmoCountUnder(4),
  isAmmoCountUp(5),
  isShooterCount(6),
  isShooterUnder(7),
  isShooterUp(8),
  @JsonValue('IsSameSqaudCount')
  isSameSquadCount(9),
  isSameSquadUnder(10),
  @JsonValue('IsSameSqaudUp')
  isSameSquadUp(11),
  isHpRatioUnder(12),
  isHpRatioUp(13),
  isStun(14),
  isFunctionBuffCheck(15),
  isFunctionDebuffCheck(16),
  isForcedStop(17),
  isFunctionOn(18),
  isFullCount(19),
  isFunctionCount(20), // cn only
  isBurstStepState(21),
  alwaysRecursive(22),
  isUseAmmo(23),
  isPhase(24),
  isPhaseUp(25),
  isPhaseUnder(26),
  isBurstSkillStep(27),
  isCheckMonster(28),
  isCover(29),
  isSearchElementId(30),
  isWeaponType(31),
  isClassType(32),
  isCheckTarget(33),
  isCheckDebuff(34),
  isHaveDecoy(35),
  isFullCharge(36),
  isHaveBarrier(37),
  isBurstMember(38),
  isNotBurstMember(39),
  isHighHpValue(40),
  isNotHaveBarrier(41),
  isExplosiveCircuitOff(42),
  isAlive(43),
  isHighMaxHpValue(44),
  isFunctionOff(45),
  isCheckFunctionOverlapUp(46),
  isCheckPartsId(47),
  isCheckPosition(48),
  isCheckMonsterType(49),
  isCheckTeamBurstNextStep(50),
  isNotCheckTeamBurstNextStep(51),
  isCharacter(52),
  isFunctionTypeOffCheck(53),
  isCheckEnemyNikke(54),
  isBurstStepCheck(55),
  isCheckMonsterExcludeNoneType(56),
  isNotHaveCover(57),
  isHaveCover(58),
  @JsonValue('IsSameSqaud')
  isSameSquad(59),
  isCheckGradeUnder(60),
  unknown(-1);

  const StatusTriggerType(this.value);
  final int value;

  static final Map<String, StatusTriggerType> _reverseMap = Map.fromIterable(
    StatusTriggerType.values,
    key: (v) {
      switch (v as StatusTriggerType) {
        case isSameSquadCount:
          return 'IsSameSqaudCount';
        case isSameSquadUp:
          return 'IsSameSqaudUp';
        case isSameSquad:
          return 'IsSameSqaud';
        default:
          return v.name.pascal;
      }
    },
  );

  static StatusTriggerType fromName(String? name) {
    if (name == 'isPhase') {
      return StatusTriggerType.isPhase;
    }
    return _reverseMap[name] ?? StatusTriggerType.unknown;
  }

  static List<StatusTriggerType> sorted = StatusTriggerType.values.toList().sorted((a, b) => a.name.compareTo(b.name));
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum FunctionStatus {
  on,
  off,
  unknown;

  static final Map<String, FunctionStatus> _reverseMap = Map.fromIterable(
    FunctionStatus.values,
    key: (v) => (v as FunctionStatus).name.pascal,
  );

  static FunctionStatus fromName(String? name) {
    return _reverseMap[name] ?? FunctionStatus.unknown;
  }
}

@JsonSerializable(createToJson: false)
class FunctionData {
  final int id;
  @JsonKey(name: 'group_id')
  final int groupId;
  final int level;
  @JsonKey(name: 'name_localkey')
  final String? nameLocalkey;
  // equipment lines are BuffEtc
  @JsonKey(name: 'buff')
  final String rawBuffType;
  BuffType get buff => BuffType.fromName(rawBuffType);
  @JsonKey(name: 'buff_remove')
  final String rawBuffRemove;
  BuffRemoveType get buffRemove => BuffRemoveType.fromName(rawBuffRemove);
  @JsonKey(name: 'function_type')
  final String rawFunctionType;
  @JsonKey(name: 'function_value_type')
  final String rawFunctionValueType;
  ValueType get functionValueType => ValueType.fromName(rawFunctionValueType);
  @JsonKey(name: 'function_standard')
  final String rawFunctionStandard;
  StandardType get functionStandard => StandardType.fromName(rawFunctionStandard);
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
  final String rawDelayType;
  DurationType get delayType => DurationType.fromName(rawDelayType);
  @JsonKey(name: 'delay_value')
  final int delayValue;
  @JsonKey(name: 'duration_type')
  final String rawDurationType;
  DurationType get durationType => DurationType.fromName(rawDurationType);
  @JsonKey(name: 'duration_value')
  final int durationValue;
  @JsonKey(name: 'limit_value')
  final int limitValue;
  @JsonKey(name: 'function_target')
  final String rawFunctionTarget;
  FunctionTargetType get functionTarget => FunctionTargetType.fromName(rawFunctionTarget);
  // might be possible that connected functions ignore this condition (from Phantom S1E2, which is linked to E1)
  @JsonKey(name: 'timing_trigger_type')
  final String rawTimingTriggerType;
  TimingTriggerType get timingTriggerType => TimingTriggerType.fromName(rawTimingTriggerType);
  @JsonKey(name: 'timing_trigger_standard')
  final String rawTimingTriggerStandard;
  StandardType get timingTriggerStandard => StandardType.fromName(rawTimingTriggerStandard);
  @JsonKey(name: 'timing_trigger_value')
  final int timingTriggerValue;
  @JsonKey(name: 'status_trigger_type')
  final String rawStatusTriggerType;
  StatusTriggerType get statusTriggerType => StatusTriggerType.fromName(rawStatusTriggerType);
  @JsonKey(name: 'status_trigger_standard')
  final String rawStatusTriggerStandard;
  StandardType get statusTriggerStandard => StandardType.fromName(rawStatusTriggerStandard);
  @JsonKey(name: 'status_trigger_value')
  final int statusTriggerValue;
  @JsonKey(name: 'status_trigger2_type')
  final String rawStatusTrigger2Type;
  StatusTriggerType get statusTrigger2Type => StatusTriggerType.fromName(rawStatusTrigger2Type);
  @JsonKey(name: 'status_trigger2_standard')
  final String rawStatusTrigger2Standard;
  StandardType get statusTrigger2Standard => StandardType.fromName(rawStatusTrigger2Standard);
  @JsonKey(name: 'status_trigger2_value')
  final int statusTrigger2Value;
  // best guess is whether to keep the function as on or off after trigger
  // based on conditional max hp cube, this should also dictates if a function should be triggered?
  // but Elegg's skill2 is onHitNum with keepingType on, and statusTrigger
  @JsonKey(name: 'keeping_type')
  final String rawKeepingType;
  FunctionStatus get keepingType => FunctionStatus.fromName(rawKeepingType);
  @JsonKey(name: 'buff_icon')
  final String buffIcon;

  // these are likely effects
  // "shotFxListType": "{None, Gear1, Gear2, Gear3}"
  @JsonKey(name: 'shot_fx_list_type')
  final String? shotFxListType;
  // a bunch of fx_xxx_xxx_xxx string, probably linked to effects?
  @JsonKey(name: 'fx_prefab_01')
  final String? fxPrefab01;
  // "fxTarget": "{User, Target, TargetMonsterDead}" (also some don't have these fxTargetXX fields)
  @JsonKey(name: 'fx_target_01')
  final String? fxTarget01;
  // "fxSocketPoint": "{None, Center, Bottom, Head, Top, Cover, World, Core}"
  // (also some don't have these fxSocketPointXX fields)
  @JsonKey(name: 'fx_socket_point_01')
  final String? fxSocketPoint01;
  @JsonKey(name: 'fx_prefab_02')
  final String? fxPrefab02;
  @JsonKey(name: 'fx_target_02')
  final String? fxTarget02;
  @JsonKey(name: 'fx_socket_point_02')
  final String? fxSocketPoint02;
  @JsonKey(name: 'fx_prefab_03')
  final String? fxPrefab03;
  @JsonKey(name: 'fx_target_03')
  final String? fxTarget03;
  @JsonKey(name: 'fx_socket_point_03')
  final String? fxSocketPoint03;
  @JsonKey(name: 'fx_prefab_full')
  final String? fxPrefabFull;
  @JsonKey(name: 'fx_target_full')
  final String? fxTargetFull;
  @JsonKey(name: 'fx_socket_point_full')
  final String? fxSocketPointFull;
  @JsonKey(name: 'fx_prefab_01_arena')
  final String? fxPrefab01Arena;
  @JsonKey(name: 'fx_target_01_arena')
  final String? fxTarget01Arena;
  @JsonKey(name: 'fx_socket_point_01_arena')
  final String? fxSocketPoint01Arena;
  @JsonKey(name: 'fx_prefab_02_arena')
  final String? fxPrefab02Arena;
  @JsonKey(name: 'fx_target_02_arena')
  final String? fxTarget02Arena;
  @JsonKey(name: 'fx_socket_point_02_arena')
  final String? fxSocketPoint02Arena;
  @JsonKey(name: 'fx_prefab_03_arena')
  final String? fxPrefab03Arena;
  @JsonKey(name: 'fx_target_03_arena')
  final String? fxTarget03Arena;
  @JsonKey(name: 'fx_socket_point_03_arena')
  final String? fxSocketPoint03Arena;

  @JsonKey(name: 'connected_function')
  final List<int> connectedFunction;

  @JsonKey(name: 'description_localkey')
  final String? descriptionLocalkey;
  @JsonKey(name: 'element_reaction_icon')
  final String? elementReactionIcon;
  @JsonKey(name: 'function_battlepower')
  final int? functionBattlepower;

  FunctionType get functionType => FunctionType.fromName(rawFunctionType);

  FunctionData({
    this.id = 0,
    this.groupId = 0,
    this.level = 0,
    this.nameLocalkey,
    this.rawBuffType = '',
    this.rawBuffRemove = '',
    this.rawFunctionType = '',
    this.rawFunctionValueType = '',
    this.rawFunctionStandard = '',
    this.functionValue = 0,
    this.fullCount = 0,
    this.isCancel = false,
    this.rawDelayType = '',
    this.delayValue = 0,
    this.rawDurationType = '',
    this.durationValue = 0,
    this.limitValue = 0,
    this.rawFunctionTarget = '',
    this.rawTimingTriggerType = '',
    this.rawTimingTriggerStandard = '',
    this.timingTriggerValue = 0,
    this.rawStatusTriggerType = '',
    this.rawStatusTriggerStandard = '',
    this.statusTriggerValue = 0,
    this.rawStatusTrigger2Type = '',
    this.rawStatusTrigger2Standard = '',
    this.statusTrigger2Value = 0,
    this.rawKeepingType = '',
    this.buffIcon = '',
    this.shotFxListType,
    this.fxPrefab01,
    this.fxTarget01,
    this.fxSocketPoint01,
    this.fxPrefab02,
    this.fxTarget02,
    this.fxSocketPoint02,
    this.fxPrefab03,
    this.fxTarget03,
    this.fxSocketPoint03,
    this.fxPrefabFull,
    this.fxTargetFull,
    this.fxSocketPointFull,
    this.fxPrefab01Arena,
    this.fxTarget01Arena,
    this.fxSocketPoint01Arena,
    this.fxPrefab02Arena,
    this.fxTarget02Arena,
    this.fxSocketPoint02Arena,
    this.fxPrefab03Arena,
    this.fxTarget03Arena,
    this.fxSocketPoint03Arena,
    this.connectedFunction = const [],
    this.descriptionLocalkey,
    this.elementReactionIcon,
    this.functionBattlepower,
  });

  factory FunctionData.fromJson(Map<String, dynamic> json) => _$FunctionDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class SkillDescriptionValue {
  @JsonKey(name: 'description_value')
  final String? value;

  SkillDescriptionValue({this.value});

  factory SkillDescriptionValue.fromJson(Map<String, dynamic> json) => _$SkillDescriptionValueFromJson(json);
}

@JsonSerializable(createToJson: false)
class SkillInfoData {
  final int id;
  @JsonKey(name: 'group_id')
  final int groupId;
  @JsonKey(name: 'skill_level')
  final int skillLevel;
  @JsonKey(name: 'next_level_id')
  final int nextLevelId;
  @JsonKey(name: 'level_up_cost_id')
  final int levelUpCostId;
  final String icon;
  @JsonKey(name: 'name_localkey')
  final String nameLocalkey;
  @JsonKey(name: 'description_localkey')
  final String descriptionLocalkey;
  @JsonKey(name: 'info_description_localkey')
  final String infoDescriptionLocalkey;
  @JsonKey(name: 'description_value_list')
  final List<SkillDescriptionValue> descriptionValues;

  SkillInfoData({
    this.id = 0,
    this.groupId = 0,
    this.skillLevel = 0,
    this.nextLevelId = 0,
    this.levelUpCostId = 0,
    this.icon = '',
    this.nameLocalkey = '',
    this.descriptionLocalkey = '',
    this.infoDescriptionLocalkey = '',
    this.descriptionValues = const [],
  });

  factory SkillInfoData.fromJson(Map<String, dynamic> json) => _$SkillInfoDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class WordGroupData {
  final int id;
  final String group;
  @JsonKey(name: 'page_number')
  final int pageNumber;
  final int order;
  @JsonKey(name: 'resource_type')
  final String resourceType;
  @JsonKey(name: 'resource_value')
  final String resourceValue;

  WordGroupData({
    this.id = 0,
    this.group = '',
    this.pageNumber = 0,
    this.order = 0,
    this.resourceType = '',
    this.resourceValue = '',
  });

  factory WordGroupData.fromJson(Map<String, dynamic> json) => _$WordGroupDataFromJson(json);
}

enum Source { skill1, skill2, burst, equip, cube, doll, raptureSkill, bullet, rapturePassive }
