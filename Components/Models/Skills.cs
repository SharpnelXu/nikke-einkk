using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
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

    public enum ValueType
    {
        None = 0,
        Integer = 1,
        Percent = 2,
        Unknown = -1
    }

    public enum BuffType
    {
        Etc = 2,
        Buff = 0,
        BuffEtc = 3,
        DeBuff = 1,
        DebuffEtc = 4,
        Unknown = -1
    }

    public enum BuffRemoveType
    {
        Resist = 0,
        Clear = 1,
        Etc = 2,
        Unknown = -1
    }


    public enum FunctionType // TypeDefIndex: 30933
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

    public enum StandardType
    {
        Unknown = -1,
        None = 0,
        User = 1,
        FunctionTarget = 2,
        TriggerTarget = 3
    }

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

    public enum FunctionStatus
    {
        None = 0,
        On = 2,
        Off = 3,
        Unknown = -1
    }

    public enum ShotFx
    {
        Unknown = -1,
        None = 0,
        Gear1 = 1,
        Gear2 = 2,
        Gear3 = 3,
    }

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

    public enum FxTarget
    {
        Unknown = -1,
        None = 0,
        User = 1,
        Target = 2,
        TargetMonsterDead = 3,
    }

    /// <summary>
    /// Represents skill value data containing type and value information
    /// </summary>
    [MemoryPackable]
    public partial class SkillValueData
    {
        /// <summary>
        /// Raw skill value type string
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("skill_value_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ValueType SkillValueType { get; set; } = ValueType.Unknown;

        /// <summary>
        /// Skill value numeric value
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("skill_value")]
        public long SkillValue { get; set; }
    }

    /// <summary>
    /// Represents character skill data
    /// </summary>
    [MemoryPackable]
    public partial class SkillData
    {
        /// <summary>
        /// Unique skill identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        /// <summary>
        /// Skill cooldown time
        /// </summary>
        [MemoryPackOrder(5)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("skill_cooltime")]
        public int SkillCooltime { get; set; }

        /// <summary>
        /// Raw attack type string
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("attack_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public AttackType AttackType { get; set; } = AttackType.None;

        /// <summary>
        /// Counter type information
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("counter_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public CounterType CounterType { get; set; } = CounterType.None;

        /// <summary>
        /// Raw preferred target string
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("prefer_target")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

        /// <summary>
        /// Raw preferred target condition string
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("prefer_target_condition")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PreferTargetCondition PreferTargetCondition { get; set; } = PreferTargetCondition.None;

        /// <summary>
        /// Raw skill type string
        /// </summary>
        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("skill_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public CharacterSkillType SkillType { get; set; } = CharacterSkillType.None;

        /// <summary>
        /// List of skill value data
        /// </summary>
        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("skill_value_data")]
        public SkillValueData[] SkillValueData { get; set; } = [];

        /// <summary>
        /// Raw duration type string
        /// </summary>
        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("duration_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public DurationType DurationType { get; set; } = DurationType.None;

        /// <summary>
        /// Duration value
        /// </summary>
        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("duration_value")]
        public int DurationValue { get; set; }

        /// <summary>
        /// Function IDs to execute before skill use
        /// </summary>
        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("before_use_function_id_list")]
        public int[] BeforeUseFunctionIdList { get; set; } = [];

        /// <summary>
        /// Function IDs to execute before hurt
        /// </summary>
        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("before_hurt_function_id_list")]
        public int[] BeforeHurtFunctionIdList { get; set; } = [];

        /// <summary>
        /// Function IDs to execute after skill use
        /// </summary>
        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("after_use_function_id_list")]
        public int[] AfterUseFunctionIdList { get; set; } = [];

        /// <summary>
        /// Function IDs to execute after hurt
        /// </summary>
        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("after_hurt_function_id_list")]
        public int[] AfterHurtFunctionIdList { get; set; } = [];

        /// <summary>
        /// Resource name for the skill
        /// </summary>
        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("resource_name")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull | JsonIgnoreCondition.WhenWritingDefault)]
        public string? ResourceName { get; set; } = string.Empty;

        /// <summary>
        /// Icon identifier
        /// </summary>
        [MemoryPackOrder(16)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("icon")]
        public string Icon { get; set; } = string.Empty;

        /// <summary>
        /// Shake effect identifier
        /// </summary>
        [MemoryPackOrder(15)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("shake_id")]
        public int ShakeId { get; set; }
    }

    /// <summary>
    /// Represents a skill function reference
    /// </summary>
    [MemoryPackable]
    public partial class SkillFunction
    {
        /// <summary>
        /// Function identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("function")]
        public int Function { get; set; }
    }

    /// <summary>
    /// Represents state effect data
    /// </summary>
    [MemoryPackable]
    public partial class StateEffectData
    {
        /// <summary>
        /// Unique state effect identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        /// <summary>
        /// Function IDs to use
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("use_function_id_list")]
        public int[] UseFunctionIdList { get; set; } = [];

        /// <summary>
        /// Function IDs for hurt effects
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("hurt_function_id_list")]
        public int[] HurtFunctionIdList { get; set; } = [];

        /// <summary>
        /// List of skill functions
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("functions")]
        public SkillFunction[] Functions { get; set; } = [];

        /// <summary>
        /// Icon identifier
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("icon")]
        public string Icon { get; set; } = string.Empty;
    }

    /// <summary>
    /// Represents function data with all related properties
    /// </summary>
    [MemoryPackable]
    public partial class FunctionData
    {
        /// <summary>
        /// Unique function identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        /// <summary>
        /// Function group identifier
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("group_id")]
        public int GroupId { get; set; }

        /// <summary>
        /// Function level
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("level")]
        public int Level { get; set; }

        /// <summary>
        /// Function battle power
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("function_battlepower")]
        public int FunctionBattlepower { get; set; }

        /// <summary>
        /// Name localization key
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("name_localkey")]
        public string? NameLocalkey { get; set; } = string.Empty;

        /// <summary>
        /// Description localization key
        /// </summary>
        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("description_localkey")]
        public string? DescriptionLocalkey { get; set; } = string.Empty;

        /// <summary>
        /// Raw buff type string
        /// </summary>
        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("buff")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public BuffType BuffType { get; set; } = BuffType.Unknown;

        /// <summary>
        /// Raw buff remove type string
        /// </summary>
        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("buff_remove")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public BuffRemoveType BuffRemoveType { get; set; } = BuffRemoveType.Clear;

        /// <summary>
        /// Raw function type string
        /// </summary>
        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("function_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FunctionType FunctionType { get; set; } = FunctionType.None;

        /// <summary>
        /// Raw function value type string
        /// </summary>
        [MemoryPackOrder(10)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("function_value_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ValueType FunctionValueType { get; set; } = ValueType.None;

        /// <summary>
        /// Raw function standard string
        /// </summary>
        [MemoryPackOrder(9)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("function_standard")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StandardType FunctionStandard { get; set; } = StandardType.None;

        /// <summary>
        /// Function value
        /// </summary>
        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("function_value")]
        public long FunctionValue { get; set; }

        /// <summary>
        /// Full count value
        /// </summary>
        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("full_count")]
        public int FullCount { get; set; }

        /// <summary>
        /// Whether function is cancellable
        /// </summary>
        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("is_cancel")]
        public bool IsCancel { get; set; }

        /// <summary>
        /// Raw delay type string
        /// </summary>
        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("delay_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public DurationType DelayType { get; set; } = DurationType.None;

        /// <summary>
        /// Delay value
        /// </summary>
        [MemoryPackOrder(15)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("delay_value")]
        public int DelayValue { get; set; }

        /// <summary>
        /// Raw duration type string
        /// </summary>
        [MemoryPackOrder(16)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("duration_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public DurationType DurationType { get; set; } = DurationType.None;

        /// <summary>
        /// Duration value
        /// </summary>
        [MemoryPackOrder(17)]
        [JsonPropertyOrder(17)]
        [JsonPropertyName("duration_value")]
        public int DurationValue { get; set; }

        /// <summary>
        /// Limit value
        /// </summary>
        [MemoryPackOrder(18)]
        [JsonPropertyOrder(18)]
        [JsonPropertyName("limit_value")]
        public int LimitValue { get; set; }

        /// <summary>
        /// Raw function target string
        /// </summary>
        [MemoryPackOrder(19)]
        [JsonPropertyOrder(19)]
        [JsonPropertyName("function_target")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FunctionTargetType FunctionTarget { get; set; } = FunctionTargetType.None;

        /// <summary>
        /// Raw timing trigger type string
        /// </summary>
        [MemoryPackOrder(20)]
        [JsonPropertyOrder(20)]
        [JsonPropertyName("timing_trigger_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public TimingTriggerType TimingTriggerType { get; set; } = TimingTriggerType.None;

        /// <summary>
        /// Raw timing trigger standard string
        /// </summary>
        [MemoryPackOrder(21)]
        [JsonPropertyOrder(21)]
        [JsonPropertyName("timing_trigger_standard")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StandardType TimingTriggerStandard { get; set; } = StandardType.None;

        /// <summary>
        /// Timing trigger value
        /// </summary>
        [MemoryPackOrder(22)]
        [JsonPropertyOrder(22)]
        [JsonPropertyName("timing_trigger_value")]
        public int TimingTriggerValue { get; set; }

        /// <summary>
        /// Raw status trigger type string
        /// </summary>
        [MemoryPackOrder(23)]
        [JsonPropertyOrder(23)]
        [JsonPropertyName("status_trigger_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StatusTriggerType StatusTriggerType { get; set; } = StatusTriggerType.None;

        /// <summary>
        /// Raw status trigger standard string
        /// </summary>
        [MemoryPackOrder(24)]
        [JsonPropertyOrder(24)]
        [JsonPropertyName("status_trigger_standard")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StandardType StatusTriggerStandard { get; set; } = StandardType.None;

        /// <summary>
        /// Status trigger value
        /// </summary>
        [MemoryPackOrder(25)]
        [JsonPropertyOrder(25)]
        [JsonPropertyName("status_trigger_value")]
        public long StatusTriggerValue { get; set; }

        /// <summary>
        /// Raw status trigger 2 type string
        /// </summary>
        [MemoryPackOrder(26)]
        [JsonPropertyOrder(26)]
        [JsonPropertyName("status_trigger2_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StatusTriggerType StatusTrigger2Type { get; set; } = StatusTriggerType.None;

        /// <summary>
        /// Raw status trigger 2 standard string
        /// </summary>
        [MemoryPackOrder(27)]
        [JsonPropertyOrder(27)]
        [JsonPropertyName("status_trigger2_standard")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StandardType StatusTrigger2Standard { get; set; } = StandardType.None;

        /// <summary>
        /// Status trigger 2 value
        /// </summary>
        [MemoryPackOrder(28)]
        [JsonPropertyOrder(28)]
        [JsonPropertyName("status_trigger2_value")]
        public long StatusTrigger2Value { get; set; }

        /// <summary>
        /// Raw keeping type string
        /// </summary>
        [MemoryPackOrder(29)]
        [JsonPropertyOrder(29)]
        [JsonPropertyName("keeping_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FunctionStatus KeepingType { get; set; } = FunctionStatus.Off;

        /// <summary>
        /// Buff icon identifier
        /// </summary>
        [MemoryPackOrder(30)]
        [JsonPropertyOrder(30)]
        [JsonPropertyName("buff_icon")]
        public string BuffIcon { get; set; } = string.Empty;

        /// <summary>
        /// Element reaction icon
        /// </summary>
        [MemoryPackOrder(31)]
        [JsonPropertyOrder(31)]
        [JsonPropertyName("element_reaction_icon")]
        public string? ElementReactionIcon { get; set; } = string.Empty;

        /// <summary>
        /// Shot FX list type
        /// </summary>
        [MemoryPackOrder(32)]
        [JsonPropertyOrder(32)]
        [JsonPropertyName("shot_fx_list_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ShotFx ShotFxListType { get; set; } = ShotFx.None;

        /// <summary>
        /// FX prefab 01
        /// </summary>
        [MemoryPackOrder(33)]
        [JsonPropertyOrder(33)]
        [JsonPropertyName("fx_prefab_01")]
        public string? FxPrefab01 { get; set; } = string.Empty;

        /// <summary>
        /// FX target 01
        /// </summary>
        [MemoryPackOrder(34)]
        [JsonPropertyOrder(34)]
        [JsonPropertyName("fx_target_01")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FxTarget FxTarget01 { get; set; } = FxTarget.None;

        /// <summary>
        /// FX socket point 01
        /// </summary>
        [MemoryPackOrder(35)]
        [JsonPropertyOrder(35)]
        [JsonPropertyName("fx_socket_point_01")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SocketPoint FxSocketPoint01 { get; set; } = SocketPoint.None;

        /// <summary>
        /// FX prefab 02
        /// </summary>
        [MemoryPackOrder(36)]
        [JsonPropertyOrder(36)]
        [JsonPropertyName("fx_prefab_02")]
        public string? FxPrefab02 { get; set; } = string.Empty;

        /// <summary>
        /// FX target 02
        /// </summary>
        [MemoryPackOrder(37)]
        [JsonPropertyOrder(37)]
        [JsonPropertyName("fx_target_02")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FxTarget FxTarget02 { get; set; } = FxTarget.None;

        /// <summary>
        /// FX socket point 02
        /// </summary>
        [MemoryPackOrder(38)]
        [JsonPropertyOrder(38)]
        [JsonPropertyName("fx_socket_point_02")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SocketPoint FxSocketPoint02 { get; set; } = SocketPoint.None;

        /// <summary>
        /// FX prefab 03
        /// </summary>
        [MemoryPackOrder(39)]
        [JsonPropertyOrder(39)]
        [JsonPropertyName("fx_prefab_03")]
        public string? FxPrefab03 { get; set; } = string.Empty;

        /// <summary>
        /// FX target 03
        /// </summary>
        [MemoryPackOrder(40)]
        [JsonPropertyOrder(40)]
        [JsonPropertyName("fx_target_03")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FxTarget FxTarget03 { get; set; } = FxTarget.None;

        /// <summary>
        /// FX socket point 03
        /// </summary>
        [MemoryPackOrder(41)]
        [JsonPropertyOrder(41)]
        [JsonPropertyName("fx_socket_point_03")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SocketPoint FxSocketPoint03 { get; set; } = SocketPoint.None;

        /// <summary>
        /// FX prefab full
        /// </summary>
        [MemoryPackOrder(42)]
        [JsonPropertyOrder(42)]
        [JsonPropertyName("fx_prefab_full")]
        public string? FxPrefabFull { get; set; } = string.Empty;

        /// <summary>
        /// FX target full
        /// </summary>
        [MemoryPackOrder(43)]
        [JsonPropertyOrder(43)]
        [JsonPropertyName("fx_target_full")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FxTarget FxTargetFull { get; set; } = FxTarget.None;

        /// <summary>
        /// FX socket point full
        /// </summary>
        [MemoryPackOrder(44)]
        [JsonPropertyOrder(44)]
        [JsonPropertyName("fx_socket_point_full")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SocketPoint FxSocketPointFull { get; set; } = SocketPoint.None;

        /// <summary>
        /// FX prefab 01 arena
        /// </summary>
        [MemoryPackOrder(45)]
        [JsonPropertyOrder(45)]
        [JsonPropertyName("fx_prefab_01_arena")]
        public string? FxPrefab01Arena { get; set; } = string.Empty;

        /// <summary>
        /// FX target 01 arena
        /// </summary>
        [MemoryPackOrder(46)]
        [JsonPropertyOrder(46)]
        [JsonPropertyName("fx_target_01_arena")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FxTarget FxTarget01Arena { get; set; } = FxTarget.None;

        /// <summary>
        /// FX socket point 01 arena
        /// </summary>
        [MemoryPackOrder(47)]
        [JsonPropertyOrder(47)]
        [JsonPropertyName("fx_socket_point_01_arena")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SocketPoint FxSocketPoint01Arena { get; set; } = SocketPoint.None;

        /// <summary>
        /// FX prefab 02 arena
        /// </summary>
        [MemoryPackOrder(48)]
        [JsonPropertyOrder(48)]
        [JsonPropertyName("fx_prefab_02_arena")]
        public string? FxPrefab02Arena { get; set; } = string.Empty;

        /// <summary>
        /// FX target 02 arena
        /// </summary>
        [MemoryPackOrder(49)]
        [JsonPropertyOrder(49)]
        [JsonPropertyName("fx_target_02_arena")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FxTarget FxTarget02Arena { get; set; } = FxTarget.None;

        /// <summary>
        /// FX socket point 02 arena
        /// </summary>
        [MemoryPackOrder(50)]
        [JsonPropertyOrder(50)]
        [JsonPropertyName("fx_socket_point_02_arena")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SocketPoint FxSocketPoint02Arena { get; set; } = SocketPoint.None;

        /// <summary>
        /// FX prefab 03 arena
        /// </summary>
        [MemoryPackOrder(51)]
        [JsonPropertyOrder(51)]
        [JsonPropertyName("fx_prefab_03_arena")]
        public string? FxPrefab03Arena { get; set; } = string.Empty;

        /// <summary>
        /// FX target 03 arena
        /// </summary>
        [MemoryPackOrder(52)]
        [JsonPropertyOrder(52)]
        [JsonPropertyName("fx_target_03_arena")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FxTarget FxTarget03Arena { get; set; } = FxTarget.None;

        /// <summary>
        /// FX socket point 03 arena
        /// </summary>
        [MemoryPackOrder(53)]
        [JsonPropertyOrder(53)]
        [JsonPropertyName("fx_socket_point_03_arena")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SocketPoint FxSocketPoint03Arena { get; set; } = SocketPoint.None;

        /// <summary>
        /// Connected function identifiers
        /// </summary>
        [MemoryPackOrder(54)]
        [JsonPropertyOrder(54)]
        [JsonPropertyName("connected_function")]
        public int[] ConnectedFunction { get; set; } = [];
    }

    /// <summary>
    /// Represents skill description value
    /// </summary>
    [MemoryPackable]
    public partial class SkillDescriptionValue
    {
        /// <summary>
        /// Description value string
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("description_value")]
        public string? Value { get; set; } = string.Empty;
    }

    /// <summary>
    /// Represents skill info data
    /// </summary>
    [MemoryPackable]
    public partial class SkillInfoData
    {
        /// <summary>
        /// Unique skill info identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        /// <summary>
        /// Skill group identifier
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("group_id")]
        public int GroupId { get; set; }

        /// <summary>
        /// Skill level
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("skill_level")]
        public int SkillLevel { get; set; }

        /// <summary>
        /// Next level identifier
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("next_level_id")]
        public int NextLevelId { get; set; }

        /// <summary>
        /// Level up cost identifier
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("level_up_cost_id")]
        public int LevelUpCostId { get; set; }

        /// <summary>
        /// Icon identifier
        /// </summary>
        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("icon")]
        public string Icon { get; set; } = string.Empty;

        /// <summary>
        /// Name localization key
        /// </summary>
        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("name_localkey")]
        public string NameLocalkey { get; set; } = string.Empty;

        /// <summary>
        /// Description localization key
        /// </summary>
        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        /// <summary>
        /// Info description localization key
        /// </summary>
        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("info_description_localkey")]
        public string InfoDescriptionLocalkey { get; set; } = string.Empty;

        /// <summary>
        /// Description values list
        /// </summary>
        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("description_value_list")]
        public SkillDescriptionValue[] DescriptionValues { get; set; } = [];
    }
}