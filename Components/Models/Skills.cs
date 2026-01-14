using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum CharacterSkillType
    {
        Unknown = -1,
        None = 0,
        InstantAll = 1,
        InstantNumber = 2,
        AimingExplosion = 3,
        AimingPenetration = 4,
        InstallDrone = 5,
        InstallBarrier = 6,
        ChangeWeapon = 7,
        SetBuff = 8,
        InstantSkill = 9,
        Custom191Ulti = 10,
        LaunchWeapon = 11,
        TargetShot = 12,
        InstantCircle = 13,
        InstantLine = 14,
        InstantArea = 15,
        InstallDecoy = 16,
        MultiTarget = 17,
        LaserBeam = 18,
        Stigma = 19,
        MaxHPInstantNumber = 20,
        InstantCircleSeparate = 21,
        HitMonsterGetBuff = 22,
        ExplosiveCircuit = 23,
        InstantSequentialAttack = 24,
        ReFullChargeHitDamage = 25,
        InstantAllParts = 26,
        TargetHitCountGetBuff = 27,
        HealCharge = 28,
        TargetingSequentialAttack = 29,
        InstantAllProjectile = 30
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum DurationType
    {
        Unknown = -1,
        TimeSec = 1,
        Shots = 2,
        Battles = 3,
        Hits = 4,
        SkillShots = 5,
        TimeSecBattles = 6,
        OnStun = 7,
        OnRemoveFunction = 8,
        Hits_Ver2 = 9,
        TimeSec_Ver2 = 10,
        TimeSec_Ver3 = 11,
        ReloadAllAmmoCount = 12,
        UncoverableCount = 13,
        ChangeWeaponUseCount = 14,
        None = 0
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ValueType
    {
        None = 0,
        Integer = 1,
        Percent = 2,
        Unknown = -1
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum BuffType
    {
        Etc = 2,
        Buff = 0,
        BuffEtc = 3,
        DeBuff = 1,
        DebuffEtc = 4,
        Unknown = -1
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum BuffRemoveType
    {
        Resist = 0,
        Clear = 1,
        Etc = 2,
        Unknown = -1
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum FunctionType 
    {
        Unknown = -1,
        None = 0,
        StatAtk = 1,
        HealCharacter = 2,
        HealCover = 3,
        Attention = 4,
        AllAmmo = 5,
        Stun = 6,
        AutoTargeting = 7,
        StatAccuracyCircle = 8,
        StatCritical = 9,
        StatShotCount = 10,
        StatChargeDamage = 11,
        StatExplosion = 12,
        StatReloadTime = 13,
        StatAmmo = 14,
        StatDef = 15,
        StatRateOfFire = 16,
        SkillCooltime = 17,
        ImmuneStun = 18,
        StatUltiGaugeSec = 19,
        StatUltiGaugeKill = 20,
        StatUltiGaugeUseSkill = 21,
        StatUltiGaugeSkillHit = 22,
        StatUltiGaugeShotHit = 23,
        StatUltiGaugeHurt = 24,
        StatUltiGaugeEmptyAmmo = 25,
        GainUltiGauge = 26,
        GainAmmo = 27,
        DamageEnergy = 28,
        DamageMetal = 29,
        DamageBio = 30,
        Taunt = 31,
        DrainHp = 32,
        DrainUltiGauge = 33,
        ImmuneEnergy = 34,
        ImmuneMetal = 35,
        ImmuneBio = 36,
        ImmuneDamage = 37,
        ImmuneDamage_MainHP = 38,
        IgnoreDamage = 39,
        Immortal = 40,
        GravityBomb = 41,
        DamageReduction = 42,
        DamageShare = 43,
        DamageRatioEnergy = 44,
        DamageRatioMetal = 45,
        DamageRatioBio = 46,
        GaugeShield = 47,
        StatProjectileSpeed = 48,
        UseSkill1 = 49,
        UseSkill2 = 50,
        StatCriticalDamage = 51,
        HealVariation = 52,
        HealShare = 53,
        StatPenetration = 54,
        LinkAtk = 55,
        LinkDef = 56,
        StatFirstDelay = 57,
        StatEnergyResist = 58,
        StatMetalResist = 59,
        StatBioResist = 60,
        StatChargeTime = 61,
        DrainHpBuff = 62,
        StatHp = 63,
        DefIgnoreDamage = 64,
        AtkChangHpRate = 65,
        DefChangHpRate = 66,
        ForcedStop = 67,
        DamageRecoverHeal = 68,
        FullBurstDamage = 69,
        Infection = 70,
        Resurrection = 71,
        UseCharacterSkillId = 72,
        ImmuneForcedStop = 73,
        ImmuneGravityBomb = 74,
        Damage = 75,
        DamageRatioUp = 76,
        BuffRemove = 77,
        DebuffRemove = 78,
        IncReactTime = 79,
        IncElementDmg = 80,
        ChangeCoolTimeSkill1 = 81,
        ChangeCoolTimeSkill2 = 82,
        ChangeCoolTimeUlti = 83,
        ChangeCoolTimeAll = 84,
        StatEndRateOfFire = 85,
        StatRateOfFirePerShot = 86,
        CoreShotDamageChange = 87,
        CoreShotDamageRateChange = 88,
        DebuffImmune = 89,
        IncBurstDuration = 90,
        ChangeHp = 91,
        PlusBuffCount = 92,
        PlusDebuffCount = 93,
        StatHpHeal = 94,
        AddDamage = 95,
        BreakDamage = 96,
        HpProportionDamage = 97,
        NormalStatCritical = 98,
        CopyAtk = 99,
        CopyDef = 100,
        CopyHp = 101,
        FirstBurstGaugeSpeedUp = 102,
        InstantDeath = 103,
        ImmuneInstantDeath = 104,
        ChangeCurrentHpValue = 105,
        SingleBurstDamage = 106,
        Hide = 107,
        StatAmmoLoad = 108,
        CoverResurrection = 109,
        ImmuneOtherElement = 110,
        BurstGaugeCharge = 111,
        PartsDamage = 112,
        ProjectileDamage = 113,
        Silence = 114,
        WindReduction = 115,
        ElectronicReduction = 116,
        FireReduction = 117,
        WaterReduction = 118,
        IronReduction = 119,
        ChangeMaxSkillCoolTime1 = 120,
        ChangeMaxSkillCoolTime2 = 121,
        ChangeMaxSkillCoolTimeUlti = 122,
        HealDecoy = 123,
        Transformation = 124,
        Immortal_value = 125,
        StatMaintainFireStance = 126,
        AtkChangeMaxHpRate = 127,
        OverHealSave = 128,
        ChargeTimeChangetoDamage = 129,
        TimingTriggerValueChange = 130,
        TargetGroupid = 131,
        FinalStatHp = 132,
        FinalStatHpHeal = 133,
        CycleUse = 134,
        DamageShareInstant = 135,
        TargetPartsId = 136,
        PartsHpChangeUIOff = 137,
        PartsHpChangeUIOn = 138,
        StatBonusRangeMax = 139,
        StatBonusRangeMin = 140,
        Uncoverable = 141,
        CallingMonster = 142,
        StatBurstSkillCoolTime = 143,
        ImmuneChangeCoolTimeUlti = 144,
        ShareDamageIncrease = 145,
        FullChargeHitDamageRepeat = 146,
        ChargeDamageChangeMaxStatAmmo = 147,
        StatSpotRadius = 148,
        PenetrationDamage = 149,
        DamageShareInstantUnable = 150,
        DamageFunctionUnable = 151,
        StatChargeTimeImmune = 152,
        AllStepBurstKeepStep = 153,
        AllStepBurstNextStep = 154,
        IncBarrierHp = 155,
        HealBarrier = 156,
        ExplosiveCircuitAccrueDamageRatio = 157,
        AtkReplaceMaxHpRate = 158,
        FixStatReloadTime = 159,
        DefIgnoreDamageRatio = 160,
        ChangeNormalDefIgnoreDamage = 161,
        BonusRangeDamageChange = 162,
        GivingHealVariation = 163,
        RemoveFunctionGroup = 164,
        NormalDamageRatioChange = 165,
        NormalStatCriticalDamage = 166,
        FunctionOverlapChange = 167,
        DurationValueChange = 168,
        DurationDamageRatio = 169,
        RepeatUseBurstStep = 170,
        PartsImmuneDamage = 171,
        BarrierDamage = 172,
        CurrentHpRatioDamage = 173,
        StatReloadBulletRatio = 174,
        ImmuneAttention = 175,
        ImmuneInstallBarrier = 176,
        ImmuneTaunt = 177,
        FullCountDamageRatio = 178,
        AddIncElementDmgType = 179,
        ChangeUseBurstSkill = 180,
        ChangeChangeBurstStep = 181,
        StickyProjectileExplosion = 182,
        StickyProjectileCollisionDamage = 183,
        ProjectileExplosionDamage = 184,
        StickyProjectileInstantExplosion = 185,
        MinusDebuffCount = 186,
        AtkBuffChange = 187,
        OutBonusRangeDamageChange = 188,
        InstantAllBurstDamage = 189,
        PlusInstantSkillTargetNum = 190,
        StatInstantSkillRange = 191,
        DamageFunctionTargetGroupId = 192,
        DamageFunctionValueChange = 193,
        DmgReductionExcludingBreakCol = 194,
        ChangeHurtFxExcludingBreakCol = 195,
        FocusAttack = 196,
        ImmediatelyBuffCheckImmune = 197,
        DurationBuffCheckImmune = 198,
        ImmediatelyDebuffCheckImmune = 199,
        DurationDebuffCheckImmune = 200,
        NoOverlapStatAmmo = 201,
        DurationDamage = 202,
        DefIgnoreSkillDamageInstant = 203,
        EmptyFunction = 204,
        DamageShareLowestPriority = 205,
        ForcedReload = 206,
        StatDefNoneBreakCol = 207,
        ChangeHealChargeValue = 208,
        FixStatChargeTime = 209,
        GrayScale = 210,
        ChangeMaxTargetingCount = 211,
        InstantSequentialAttackDamageRatio = 212,
        BarrierImmuneDamage = 213
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum StandardType
    {
        Unknown = -1,
        None = 0,
        User = 1,
        FunctionTarget = 2,
        TriggerTarget = 3
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum FunctionTargetType
    {
        Unknown = -1,
        None = 0,
        Self = 1,
        AllCharacter = 2,
        AllMonster = 3,
        Target = 4,
        UserCover = 5,
        TargetCover = 6,
        AllCharacterCover = 7
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum TimingTriggerType
    {
        Unknown = -1,
        None = 0,
        OnStart = 1,
        OnShotRatio = 2,
        OnUseAmmo = 3,
        OnUseBurstSkill = 4,
        OnHitNumberOver = 5,
        OnFullChargeShot = 6,
        OnHurtRatio = 7,
        OnHurtCount = 8,
        OnFunctionBuffCheck = 9,
        OnFunctionDebuffCheck = 10,
        OnSquadHurtRatio = 11,
        OnSquadHurtCount = 12,
        OnCoverHurtRatio = 13,
        OnCoverHurtCount = 14,
        OnHpRatioUnder = 15,
        OnHpRatioUp = 16,
        OnAmmoRatioUnder = 17,
        OnAmmoRatioUp = 18,
        OnShooterCount = 19,
        OnKillRatio = 20,
        OnFunctionOn = 21,
        OnEnterBurstStep = 22,
        OnFullCount = 23,
        OnCoverDestroyRatio = 24,
        OnBurstSkillStep = 25,
        OnSpawnMonster = 26,
        OnFullChargeHit = 27,
        OnAttackRatio = 28,
        OnLastShotHit = 29,
        OnSkillUse = 30,
        OnHitNum = 31,
        OnFullBurstTimeOverRatio = 32,
        OnPartsHitNum = 33,
        OnPartsHitRatio = 34,
        OnPartsHitNumOnce = 35,
        OnPartsHitRatioOnce = 36,
        OnLastAmmoUse = 37,
        OnSpawnTarget = 38,
        OnHitRatio = 39,
        OnDead = 40,
        OnTeamHpRatioUnder = 41,
        OnResurrection = 42,
        OnEndFullBurst = 43,
        OnNikkeDead = 44,
        OnCriticalHitNum = 45,
        OnCriticalHitRatio = 46,
        OnCriticalHitNumOnce = 47,
        OnCriticalHitRatioOnce = 48,
        OnHealedBy = 49,
        OnMonsterDead = 50,
        OnFullCharge = 51,
        OnInstallBarrier = 52,
        OnHealCover = 53,
        OnInstantDeath = 54,
        OnCoreHitRatioOnce = 55,
        OnCoreHitNumOnce = 56,
        OnCoreHitRatio = 57,
        OnCoreHitNum = 58,
        OnFullChargeNum = 59,
        OnFullChargeShotNum = 60,
        OnFullChargeHitNum = 61,
        OnSummonMonster = 62,
        OnAfterTimeSec = 63,
        OnPelletHitNum = 64,
        OnPelletHitPerShot = 65,
        OnPartsBrokenNum = 66,
        OnCheckTime = 67,
        OnPartsHurtCount = 68,
        OnPartsHurtRatio = 69,
        OnUserPartsDestroy = 70,
        OnEnemyDead = 71,
        OnBurstSkillUseNum = 72,
        OnFullChargePartsHitNum = 73,
        OnKeepFullcharge = 74,
        OnEndReload = 75,
        OnTeamHpRatioUp = 76,
        OnHurtDecoyNum = 77,
        OnFunctionOff = 78,
        OnHitNumExceptCore = 79,
        OnShotNotFullCharge = 80,
        OnKeepFullChargeShotUnder = 81,
        OnSpawnEnemy = 82,
        OnUseTeamAmmo = 83,
        OnPelletCriticalHitNum = 84,
        OnSpawnMonsterExcludeNoneType = 85,
        OnFunctionDamageCriticalHit = 86,
        OnFullChargeBonusRangeHitNum = 87,
        OnKeepFullChargeShot = 88,
        OnDeadComplete = 89,
        OnFullChargeCoreHitNum = 90
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum StatusTriggerType
    {
        Unknown = -1,
        None = 0,
        IsAmmoRatioUnder = 1,
        IsAmmoRatioUp = 2,
        IsAmmoCount = 3,
        IsAmmoCountUnder = 4,
        IsAmmoCountUp = 5,
        IsShooterCount = 6,
        IsShooterUnder = 7,
        IsShooterUp = 8,
        IsSameSqaudCount = 9,
        IsSameSqaudUnder = 10,
        IsSameSqaudUp = 11,
        IsHpRatioUnder = 12,
        IsHpRatioUp = 13,
        IsStun = 14,
        IsFunctionBuffCheck = 15,
        IsFunctionDebuffCheck = 16,
        IsForcedStop = 17,
        IsFunctionOn = 18,
        IsFullCount = 19,
        IsFunctionCount = 20,
        IsBurstStepState = 21,
        AlwaysRecursive = 22,
        IsUseAmmo = 23,
        IsPhase = 24,
        IsPhaseUp = 25,
        IsPhaseUnder = 26,
        IsBurstSkillStep = 27,
        IsCheckMonster = 28,
        IsCover = 29,
        IsSearchElementId = 30,
        IsWeaponType = 31,
        IsClassType = 32,
        IsCheckTarget = 33,
        IsCheckDebuff = 34,
        IsHaveDecoy = 35,
        IsFullCharge = 36,
        IsHaveBarrier = 37,
        IsBurstMember = 38,
        IsNotBurstMember = 39,
        IsHighHpValue = 40,
        IsNotHaveBarrier = 41,
        IsExplosiveCircuitOff = 42,
        IsAlive = 43,
        IsHighMaxHpValue = 44,
        IsFunctionOff = 45,
        IsCheckFunctionOverlapUp = 46,
        IsCheckPartsId = 47,
        IsCheckPosition = 48,
        IsCheckMonsterType = 49,
        IsCheckTeamBurstNextStep = 50,
        IsNotCheckTeamBurstNextStep = 51,
        IsCharacter = 52,
        IsFunctionTypeOffCheck = 53,
        IsCheckEnemyNikke = 54,
        IsBurstStepCheck = 55,
        IsCheckMonsterExcludeNoneType = 56,
        IsNotHaveCover = 57,
        IsHaveCover = 58,
        IsSameSqaud = 59,
        IsCheckGradeUnder = 60,
        IsCheckCharacter = 61,
        IsCheckNotTarget = 62,
        IsCheckFunctionOverlap = 63,
        IsFirstBurstMember = 64,
        IsNotFirstBurstMember = 65,
        IsCharging = 66
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum FunctionStatus
    {
        None = 0,
        On = 2,
        Off = 3,
        Unknown = -1
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ShotFx
    {
        Unknown = -1,
        None = 0,
        Gear1 = 1,
        Gear2 = 2,
        Gear3 = 3,
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum SocketPoint
    {
        Unknown = -1,
        None = 0,
        Top = 1,
        Center = 2,
        Head = 6,
        Cover = 4,
        Bottom = 3,
        World = 7,
        Core = 5
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum FxTarget
    {
        Unknown = -1,
        None = 0,
        User = 1,
        Target = 2,
        TargetMonsterDead = 3,
    }

    [MemoryPackable]
    public partial class SkillValueData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("skill_value_type", Order = 0)]
        public ValueType SkillValueType { get; set; } = ValueType.Unknown;

        [MemoryPackOrder(1)]
        [JsonProperty("skill_value", Order = 1)]
        public long SkillValue { get; set; }
    }

    [MemoryPackable]
    public partial class SkillData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("skill_cooltime", Order = 1)]
        public int SkillCooltime { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("attack_type", Order = 2)]
        public AttackType AttackType { get; set; } = AttackType.None;

        [MemoryPackOrder(2)]
        [JsonProperty("counter_type", Order = 3)]
        public CounterType CounterType { get; set; } = CounterType.None;

        [MemoryPackOrder(3)]
        [JsonProperty("prefer_target", Order = 4)]
        public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

        [MemoryPackOrder(4)]
        [JsonProperty("prefer_target_condition", Order = 5)]
        public PreferTargetCondition PreferTargetCondition { get; set; } = PreferTargetCondition.None;

        [MemoryPackOrder(6)]
        [JsonProperty("skill_type", Order = 6)]
        public CharacterSkillType SkillType { get; set; } = CharacterSkillType.None;

        [MemoryPackOrder(7)]
        [JsonProperty("skill_value_data", Order = 7)]
        public SkillValueData[] SkillValueData { get; set; } = [];

        [MemoryPackOrder(8)]
        [JsonProperty("duration_type", Order = 8)]
        public DurationType DurationType { get; set; } = DurationType.None;

        [MemoryPackOrder(9)]
        [JsonProperty("duration_value", Order = 9)]
        public int DurationValue { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("before_use_function_id_list", Order = 10)]
        public int[] BeforeUseFunctionIdList { get; set; } = [];

        [MemoryPackOrder(11)]
        [JsonProperty("before_hurt_function_id_list", Order = 11)]
        public int[] BeforeHurtFunctionIdList { get; set; } = [];

        [MemoryPackOrder(12)]
        [JsonProperty("after_use_function_id_list", Order = 12)]
        public int[] AfterUseFunctionIdList { get; set; } = [];

        [MemoryPackOrder(13)]
        [JsonProperty("after_hurt_function_id_list", Order = 13)]
        public int[] AfterHurtFunctionIdList { get; set; } = [];

        [MemoryPackOrder(14)]
        [JsonProperty("resource_name", Order = 14, NullValueHandling = NullValueHandling.Ignore)]
        public string? ResourceName { get; set; }

        [MemoryPackOrder(16)]
        [JsonProperty("icon", Order = 15)]
        public string Icon { get; set; } = string.Empty;

        [MemoryPackOrder(15)]
        [JsonProperty("shake_id", Order = 16)]
        public int ShakeId { get; set; }
    }

    [MemoryPackable]
    public partial class SkillFunction
    {
        [MemoryPackOrder(0)]
        [JsonProperty("function", Order = 0)]
        public int Function { get; set; }
    }

    [MemoryPackable]
    public partial class StateEffectData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("use_function_id_list", Order = 1)]
        public int[] UseFunctionIdList { get; set; } = [];

        [MemoryPackOrder(2)]
        [JsonProperty("hurt_function_id_list", Order = 2)]
        public int[] HurtFunctionIdList { get; set; } = [];

        [MemoryPackOrder(3)]
        [JsonProperty("functions", Order = 3)]
        public SkillFunction[] Functions { get; set; } = [];

        [MemoryPackOrder(4)]
        [JsonProperty("icon", Order = 4)]
        public string Icon { get; set; } = string.Empty;
    }

    [MemoryPackable]
    public partial class FunctionData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group_id", Order = 1)]
        public int GroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("level", Order = 2)]
        public int Level { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("function_battlepower", Order = 3)]
        public int FunctionBattlepower { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("name_localkey", Order = 4)]
        public string? NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("description_localkey", Order = 5)]
        public string? DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("buff", Order = 6)]
        public BuffType BuffType { get; set; } = BuffType.Unknown;

        [MemoryPackOrder(7)]
        [JsonProperty("buff_remove", Order = 7)]
        public BuffRemoveType BuffRemoveType { get; set; } = BuffRemoveType.Clear;

        [MemoryPackOrder(8)]
        [JsonProperty("function_type", Order = 8)]
        public FunctionType FunctionType { get; set; } = FunctionType.None;

        [MemoryPackOrder(10)]
        [JsonProperty("function_value_type", Order = 9)]
        public ValueType FunctionValueType { get; set; } = ValueType.None;

        [MemoryPackOrder(9)]
        [JsonProperty("function_standard", Order = 10)]
        public StandardType FunctionStandard { get; set; } = StandardType.None;

        [MemoryPackOrder(11)]
        [JsonProperty("function_value", Order = 11)]
        public long FunctionValue { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("full_count", Order = 12)]
        public int FullCount { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("is_cancel", Order = 13)]
        public bool IsCancel { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("delay_type", Order = 14)]
        public DurationType DelayType { get; set; } = DurationType.None;

        [MemoryPackOrder(15)]
        [JsonProperty("delay_value", Order = 15)]
        public int DelayValue { get; set; }

        [MemoryPackOrder(16)]
        [JsonProperty("duration_type", Order = 16)]
        public DurationType DurationType { get; set; } = DurationType.None;

        [MemoryPackOrder(17)]
        [JsonProperty("duration_value", Order = 17)]
        public int DurationValue { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("limit_value", Order = 18)]
        public int LimitValue { get; set; }

        [MemoryPackOrder(19)]
        [JsonProperty("function_target", Order = 19)]
        public FunctionTargetType FunctionTarget { get; set; } = FunctionTargetType.None;

        [MemoryPackOrder(20)]
        [JsonProperty("timing_trigger_type", Order = 20)]
        public TimingTriggerType TimingTriggerType { get; set; } = TimingTriggerType.None;

        [MemoryPackOrder(21)]
        [JsonProperty("timing_trigger_standard", Order = 21)]
        public StandardType TimingTriggerStandard { get; set; } = StandardType.None;

        [MemoryPackOrder(22)]
        [JsonProperty("timing_trigger_value", Order = 22)]
        public int TimingTriggerValue { get; set; }

        [MemoryPackOrder(23)]
        [JsonProperty("status_trigger_type", Order = 23)]
        public StatusTriggerType StatusTriggerType { get; set; } = StatusTriggerType.None;

        [MemoryPackOrder(24)]
        [JsonProperty("status_trigger_standard", Order = 24)]
        public StandardType StatusTriggerStandard { get; set; } = StandardType.None;

        [MemoryPackOrder(25)]
        [JsonProperty("status_trigger_value", Order = 25)]
        public long StatusTriggerValue { get; set; }

        [MemoryPackOrder(26)]
        [JsonProperty("status_trigger2_type", Order = 26)]
        public StatusTriggerType StatusTrigger2Type { get; set; } = StatusTriggerType.None;

        [MemoryPackOrder(27)]
        [JsonProperty("status_trigger2_standard", Order = 27)]
        public StandardType StatusTrigger2Standard { get; set; } = StandardType.None;

        [MemoryPackOrder(28)]
        [JsonProperty("status_trigger2_value", Order = 28)]
        public long StatusTrigger2Value { get; set; }

        [MemoryPackOrder(29)]
        [JsonProperty("keeping_type", Order = 29)]
        public FunctionStatus KeepingType { get; set; } = FunctionStatus.Off;

        [MemoryPackOrder(30)]
        [JsonProperty("buff_icon", Order = 30)]
        public string BuffIcon { get; set; } = string.Empty;

        [MemoryPackOrder(31)]
        [JsonProperty("element_reaction_icon", Order = 31)]
        public string? ElementReactionIcon { get; set; } = string.Empty;

        [MemoryPackOrder(32)]
        [JsonProperty("shot_fx_list_type", Order = 32)]
        public ShotFx ShotFxListType { get; set; } = ShotFx.None;

        [MemoryPackOrder(33)]
        [JsonProperty("fx_prefab_01", Order = 33)]
        public string? FxPrefab01 { get; set; } = string.Empty;

        [MemoryPackOrder(34)]
        [JsonProperty("fx_target_01", Order = 34)]
        public FxTarget FxTarget01 { get; set; } = FxTarget.None;

        [MemoryPackOrder(35)]
        [JsonProperty("fx_socket_point_01", Order = 35)]
        public SocketPoint FxSocketPoint01 { get; set; } = SocketPoint.None;

        [MemoryPackOrder(36)]
        [JsonProperty("fx_prefab_02", Order = 36)]
        public string? FxPrefab02 { get; set; } = string.Empty;

        [MemoryPackOrder(37)]
        [JsonProperty("fx_target_02", Order = 37)]
        public FxTarget FxTarget02 { get; set; } = FxTarget.None;

        [MemoryPackOrder(38)]
        [JsonProperty("fx_socket_point_02", Order = 38)]
        public SocketPoint FxSocketPoint02 { get; set; } = SocketPoint.None;

        [MemoryPackOrder(39)]
        [JsonProperty("fx_prefab_03", Order = 39)]
        public string? FxPrefab03 { get; set; } = string.Empty;

        [MemoryPackOrder(40)]
        [JsonProperty("fx_target_03", Order = 40)]
        public FxTarget FxTarget03 { get; set; } = FxTarget.None;

        [MemoryPackOrder(41)]
        [JsonProperty("fx_socket_point_03", Order = 41)]
        public SocketPoint FxSocketPoint03 { get; set; } = SocketPoint.None;

        [MemoryPackOrder(42)]
        [JsonProperty("fx_prefab_full", Order = 42)]
        public string? FxPrefabFull { get; set; } = string.Empty;

        [MemoryPackOrder(43)]
        [JsonProperty("fx_target_full", Order = 43)]
        public FxTarget FxTargetFull { get; set; } = FxTarget.None;

        [MemoryPackOrder(44)]
        [JsonProperty("fx_socket_point_full", Order = 44)]
        public SocketPoint FxSocketPointFull { get; set; } = SocketPoint.None;

        [MemoryPackOrder(45)]
        [JsonProperty("fx_prefab_01_arena", Order = 45)]
        public string? FxPrefab01Arena { get; set; } = string.Empty;

        [MemoryPackOrder(46)]
        [JsonProperty("fx_target_01_arena", Order = 46)]
        public FxTarget FxTarget01Arena { get; set; } = FxTarget.None;

        [MemoryPackOrder(47)]
        [JsonProperty("fx_socket_point_01_arena", Order = 47)]
        public SocketPoint FxSocketPoint01Arena { get; set; } = SocketPoint.None;

        [MemoryPackOrder(48)]
        [JsonProperty("fx_prefab_02_arena", Order = 48)]
        public string? FxPrefab02Arena { get; set; } = string.Empty;

        [MemoryPackOrder(49)]
        [JsonProperty("fx_target_02_arena", Order = 49)]
        public FxTarget FxTarget02Arena { get; set; } = FxTarget.None;

        [MemoryPackOrder(50)]
        [JsonProperty("fx_socket_point_02_arena", Order = 50)]
        public SocketPoint FxSocketPoint02Arena { get; set; } = SocketPoint.None;

        [MemoryPackOrder(51)]
        [JsonProperty("fx_prefab_03_arena", Order = 51)]
        public string? FxPrefab03Arena { get; set; } = string.Empty;

        [MemoryPackOrder(52)]
        [JsonProperty("fx_target_03_arena", Order = 52)]
        public FxTarget FxTarget03Arena { get; set; } = FxTarget.None;

        [MemoryPackOrder(53)]
        [JsonProperty("fx_socket_point_03_arena", Order = 53)]
        public SocketPoint FxSocketPoint03Arena { get; set; } = SocketPoint.None;

        [MemoryPackOrder(54)]
        [JsonProperty("connected_function", Order = 54)]
        public int[] ConnectedFunction { get; set; } = [];
    }

    [MemoryPackable]
    public partial class SkillDescriptionValue
    {
        [MemoryPackOrder(0)]
        [JsonProperty("description_value", Order = 0)]
        public string? Value { get; set; } = string.Empty;
    }

    [MemoryPackable]
    public partial class SkillInfoData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group_id", Order = 1)]
        public int GroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("skill_level", Order = 2)]
        public int SkillLevel { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("next_level_id", Order = 3)]
        public int NextLevelId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("level_up_cost_id", Order = 4)]
        public int LevelUpCostId { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("icon", Order = 5)]
        public string Icon { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("name_localkey", Order = 6)]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(7)]
        [JsonProperty("description_localkey", Order = 7)]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonProperty("info_description_localkey", Order = 8)]
        public string InfoDescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(9)]
        [JsonProperty("description_value_list", Order = 9)]
        public SkillDescriptionValue[] DescriptionValues { get; set; } = [];
    }
}