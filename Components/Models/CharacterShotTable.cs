using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum WeaponType
    {
        Unknown = -1,
        None = 0,
        AR = 1,
        RL = 2,
        SR = 3,
        MG = 4,
        SG = 5,
        AS = 6,
        GL = 7,
        PS = 8,
        SMG = 9
    }

    public enum AttackType
    {
        Unknown = -1,
        None = 0,
        Energy = 1,
        Bio = 3,
        Metal = 2,
        Fire = 4,
        Water = 5,
        Wind = 6,
        Iron = 7,
        Electronic = 8
    }

    public enum CounterType
    {
        Unknown = -1,
        None = 0,
        Metal_Type = 1,
        Energy_Type = 2,
        Bio_Type = 3,
    }

    public enum PreferTarget 
    {
        Unknown = -1,
        None = 0,
        Attacker = 1,
        Defender = 2,
        Supporter = 3,
        AttackerRandom = 4,
        DefenderRandom = 5,
        SupporterRandom = 6,
        Front = 7,
        Back = 8,
        Left = 9,
        Right = 10,
        LowHP = 11,
        HighHP = 12,
        HighMaxHP = 13,
        LowDefence = 14,
        HighDefence = 15,
        LowAttack = 16,
        HighAttack = 17,
        LowHPLastSelf = 18,
        HighHPLastSelf = 19,
        LowDefenceLastSelf = 20,
        HighDefenceLastSelf = 21,
        LowAttackLastSelf = 22,
        HighAttackLastSelf = 23,
        TargetSR = 24,
        TargetAR = 25,
        TargetAS = 26,
        TargetRL = 27,
        TargetGL = 28,
        TargetPS = 29,
        BurstStep = 30,
        Random = 31,
        LowHPFirstSelf = 32,
        HighHPFirstSelf = 33,
        LowDefenceFirstSelf = 34,
        HighDefenceFirstSelf = 35,
        LowAttackFirstSelf = 36,
        HighAttackFirstSelf = 37,
        NearbyAllyTarget = 38,
        NearbyEnemyTarget = 39,
        NearbyAllyLastSelf = 40,
        Fire = 41,
        Water = 42,
        Wind = 43,
        Electronic = 44,
        Iron = 45,
        NotStun = 46,
        LowHPCover = 47,
        LowHPRatio = 48,
        HighHPRatio = 49,
        LowMaxHP = 50,
        HaveDebuff = 51,
        HaveBuff = 52,
        NearAim = 53,
        LongInitChargeTime = 54
    }
    
    public enum PreferTargetCondition 
    {
        Unknown = -1,
        None = 0,
        ExcludeSelf = 1,
        DestroyCover = 2,
        IncludeNoneTargetLast = 3,
        IncludeNoneTargetNone = 4,
        OnlySG = 5,
        OnlyAR = 6,
        OnlySMG = 7,
        OnlyMG = 8,
        OnlySR = 9,
        OnlyRL = 10,
        BurstStep1 = 11,
        BurstStep2 = 12,
        BurstStep3 = 13,
        OnlyFire = 14,
        OnlyWater = 15,
        OnlyWind = 16,
        OnlyElectronic = 17,
        OnlyIron = 18
    }

    public enum ShotTiming
    {
        Unknown = -1,
        None = 0,
        Concurrence = 1,
        Sequence = 2,
        ConcurrenceGroup = 3,
    }

    public enum FireType
    {
        Unknown = -1,
        None = 0,
        Instant = 1,
        ProjectileCurve = 2,
        ProjectileDirect = 3,
        HomingProjectile = 4,
        MultiTarget = 5,
        Blow = 6,
        Suicide = 7,
        Calling = 8,
        InstantAll = 9,
        InstantNumber = 10,
        ObjectCreate = 11,
        Summon = 12,
        Barrier = 13,
        Range = 14,
        NormalCalling = 15,
        InstantAll_FrontRay = 16,
        StickyProjectileDirect = 17,
        ObjectCreateToDecoy = 18,
        MechaShiftyShot = 19,
        ProjectileCurveV2 = 20
    }

    public enum InputType
    {
        Unknown = -1,
        NONE = 0,
        DOWN = 1,
        UP = 2,
        DOWN_Charge = 3
    }

    public enum ShakeType
    {
        Unknown = -1,
        Fire_AR = 0,
        Fire_MG = 1,
        Fire_SMG = 2,
        Fire_RL = 3,
        Fire_SG = 4,
        Fire_SR = 5,
        Hit_RL = 6,
        CharacterSkillShake01 = 7,
        CharacterSkillShake02 = 8,
        CharacterSkillShake03 = 9,
        CharacterHit = 10,
        MonsterSkillCancel = 11,
        MonsterPartsBroken = 12,
        Monsterlanding = 13
    }

    [MemoryPackable]
    public partial class CharacterShotTable
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string? NameLocalkey { get; set; } = string.Empty;
        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string? DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("camera_work")]
        public string CameraWork { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("weapon_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public WeaponType WeaponType { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("attack_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public AttackType AttackType { get; set; } = AttackType.None;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("counter_enermy")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public CounterType CounterEnermy { get; set; } = CounterType.None;

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("prefer_target")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("prefer_target_condition")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PreferTargetCondition PreferTargetCondition { get; set; } = PreferTargetCondition.None;

        [MemoryPackOrder(17)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("shot_timing")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ShotTiming ShotTiming { get; set; } = ShotTiming.None;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("fire_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FireType FireType { get; set; } = FireType.None;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("input_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public InputType InputType { get; set; } = InputType.NONE;

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("is_targeting")]
        public bool IsTargeting { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("damage")]
        public int Damage { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("shot_count")]
        public int ShotCount { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("muzzle_count")]
        public int MuzzleCount { get; set; }

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("multi_target_count")]
        public int MultiTargetCount { get; set; }

        [MemoryPackOrder(16)]
        [JsonPropertyOrder(17)]
        [JsonPropertyName("center_shot_count")]
        public int CenterShotCount { get; set; }

        [MemoryPackOrder(18)]
        [JsonPropertyOrder(18)]
        [JsonPropertyName("max_ammo")]
        public int MaxAmmo { get; set; }

        [MemoryPackOrder(19)]
        [JsonPropertyOrder(19)]
        [JsonPropertyName("maintain_fire_stance")]
        public int MaintainFireStance { get; set; }

        [MemoryPackOrder(20)]
        [JsonPropertyOrder(20)]
        [JsonPropertyName("uptype_fire_timing")]
        public int UptypeFireTiming { get; set; }

        [MemoryPackOrder(21)]
        [JsonPropertyOrder(21)]
        [JsonPropertyName("reload_time")]
        public int ReloadTime { get; set; }

        [MemoryPackOrder(22)]
        [JsonPropertyOrder(22)]
        [JsonPropertyName("reload_bullet")]
        public int ReloadBullet { get; set; }

        [MemoryPackOrder(23)]
        [JsonPropertyOrder(23)]
        [JsonPropertyName("reload_start_ammo")]
        public int ReloadStartAmmo { get; set; }

        [MemoryPackOrder(24)]
        [JsonPropertyOrder(24)]
        [JsonPropertyName("rate_of_fire_reset_time")]
        public int RateOfFireResetTime { get; set; }

        [MemoryPackOrder(25)]
        [JsonPropertyOrder(25)]
        [JsonPropertyName("rate_of_fire")]
        public int RateOfFire { get; set; }

        [MemoryPackOrder(26)]
        [JsonPropertyOrder(26)]
        [JsonPropertyName("end_rate_of_fire")]
        public int EndRateOfFire { get; set; }

        [MemoryPackOrder(27)]
        [JsonPropertyOrder(27)]
        [JsonPropertyName("rate_of_fire_change_pershot")]
        public int RateOfFireChangePershot { get; set; }

        [MemoryPackOrder(28)]
        [JsonPropertyOrder(28)]
        [JsonPropertyName("burst_energy_pershot")]
        public int BurstEnergyPershot { get; set; }

        [MemoryPackOrder(29)]
        [JsonPropertyOrder(29)]
        [JsonPropertyName("target_burst_energy_pershot")]
        public int TargetBurstEnergyPershot { get; set; }

        [MemoryPackOrder(31)]
        [JsonPropertyOrder(30)]
        [JsonPropertyName("spot_first_delay")]
        public int SpotFirstDelay { get; set; }

        [MemoryPackOrder(32)]
        [JsonPropertyOrder(31)]
        [JsonPropertyName("spot_last_delay")]
        public int SpotLastDelay { get; set; }

        [MemoryPackOrder(33)]
        [JsonPropertyOrder(32)]
        [JsonPropertyName("start_accuracy_circle_scale")]
        public int StartAccuracyCircleScale { get; set; }

        [MemoryPackOrder(34)]
        [JsonPropertyOrder(33)]
        [JsonPropertyName("end_accuracy_circle_scale")]
        public int EndAccuracyCircleScale { get; set; }

        [MemoryPackOrder(35)]
        [JsonPropertyOrder(34)]
        [JsonPropertyName("accuracy_change_pershot")]
        public int AccuracyChangePershot { get; set; }

        [MemoryPackOrder(36)]
        [JsonPropertyOrder(35)]
        [JsonPropertyName("accuracy_change_speed")]
        public int AccuracyChangeSpeed { get; set; }

        [MemoryPackOrder(37)]
        [JsonPropertyOrder(36)]
        [JsonPropertyName("auto_start_accuracy_circle_scale")]
        public int AutoStartAccuracyCircleScale { get; set; }

        [MemoryPackOrder(38)]
        [JsonPropertyOrder(37)]
        [JsonPropertyName("auto_end_accuracy_circle_scale")]
        public int AutoEndAccuracyCircleScale { get; set; }

        [MemoryPackOrder(39)]
        [JsonPropertyOrder(38)]
        [JsonPropertyName("auto_accuracy_change_pershot")]
        public int AutoAccuracyChangePershot { get; set; }

        [MemoryPackOrder(40)]
        [JsonPropertyOrder(39)]
        [JsonPropertyName("auto_accuracy_change_speed")]
        public int AutoAccuracyChangeSpeed { get; set; }

        [MemoryPackOrder(41)]
        [JsonPropertyOrder(40)]
        [JsonPropertyName("zoom_rate")]
        public int ZoomRate { get; set; }

        [MemoryPackOrder(42)]
        [JsonPropertyOrder(41)]
        [JsonPropertyName("multi_aim_range")]
        public int MultiAimRange { get; set; }

        [MemoryPackOrder(43)]
        [JsonPropertyOrder(42)]
        [JsonPropertyName("spot_projectile_speed")]
        public int SpotProjectileSpeed { get; set; }

        [MemoryPackOrder(44)]
        [JsonPropertyOrder(43)]
        [JsonPropertyName("charge_time")]
        public int ChargeTime { get; set; }

        [MemoryPackOrder(45)]
        [JsonPropertyOrder(44)]
        [JsonPropertyName("full_charge_damage")]
        public int FullChargeDamage { get; set; }

        [MemoryPackOrder(46)]
        [JsonPropertyOrder(45)]
        [JsonPropertyName("full_charge_burst_energy")]
        public int FullChargeBurstEnergy { get; set; }

        [MemoryPackOrder(47)]
        [JsonPropertyOrder(46)]
        [JsonPropertyName("spot_radius_object")]
        public int SpotRadiusObject { get; set; }

        [MemoryPackOrder(48)]
        [JsonPropertyOrder(47)]
        [JsonPropertyName("spot_radius")]
        public int SpotRadius { get; set; }

        [MemoryPackOrder(49)]
        [JsonPropertyOrder(48)]
        [JsonPropertyName("spot_explosion_range")]
        public int SpotExplosionRange { get; set; }

        [MemoryPackOrder(50)]
        [JsonPropertyOrder(49)]
        [JsonPropertyName("homing_script")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull | JsonIgnoreCondition.WhenWritingDefault)]
        public string? HomingScript { get; set; } = string.Empty;

        [MemoryPackOrder(51)]
        [JsonPropertyOrder(50)]
        [JsonPropertyName("core_damage_rate")]
        public int CoreDamageRate { get; set; }

        [MemoryPackOrder(30)]
        [JsonPropertyOrder(51)]
        [JsonPropertyName("penetration")]
        public int Penetration { get; set; }

        [MemoryPackOrder(52)]
        [JsonPropertyOrder(52)]
        [JsonPropertyName("use_function_id_list")]
        public int[] UseFunctionIdList { get; set; } = [];

        [MemoryPackOrder(53)]
        [JsonPropertyOrder(53)]
        [JsonPropertyName("hurt_function_id_list")]
        public int[] HurtFunctionIdList { get; set; } = [];

        [MemoryPackOrder(54)]
        [JsonPropertyOrder(54)]
        [JsonPropertyName("shake_id")]
        public int ShakeId { get; set; }

        [MemoryPackOrder(55)]
        [JsonPropertyOrder(55)]
        [JsonPropertyName("ShakeType")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ShakeType ShakeType { get; set; } = ShakeType.Fire_AR;

        [MemoryPackOrder(56)]
        [JsonPropertyOrder(56)]
        [JsonPropertyName("ShakeWeight")]
        public int ShakeWeight { get; set; }

        [MemoryPackOrder(57)]
        [JsonPropertyOrder(57)]
        [JsonPropertyName("aim_prefab")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull | JsonIgnoreCondition.WhenWritingDefault)]
        public string? AimPrefab { get; set; } = string.Empty;
    }
}