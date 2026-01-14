using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
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
    
    [JsonConverter(typeof(StringEnumConverter))]
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

    [JsonConverter(typeof(StringEnumConverter))]
    public enum CounterType
    {
        Unknown = -1,
        None = 0,
        Metal_Type = 1,
        Energy_Type = 2,
        Bio_Type = 3,
    }

    [JsonConverter(typeof(StringEnumConverter))]
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
    
    [JsonConverter(typeof(StringEnumConverter))]
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

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ShotTiming
    {
        Unknown = -1,
        None = 0,
        Concurrence = 1,
        Sequence = 2,
        ConcurrenceGroup = 3,
    }

    [JsonConverter(typeof(StringEnumConverter))]
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

    [JsonConverter(typeof(StringEnumConverter))]
    public enum InputType
    {
        Unknown = -1,
        NONE = 0,
        DOWN = 1,
        UP = 2,
        DOWN_Charge = 3
    }
    
    [JsonConverter(typeof(StringEnumConverter))]
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
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string? NameLocalkey { get; set; } = string.Empty;
        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string? DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("camera_work", Order = 3)]
        public string CameraWork { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("weapon_type", Order = 4)]
        public WeaponType WeaponType { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("attack_type", Order = 5)]
        public AttackType AttackType { get; set; } = AttackType.None;

        [MemoryPackOrder(7)]
        [JsonProperty("counter_enermy", Order = 6)]
        public CounterType CounterEnermy { get; set; } = CounterType.None;

        [MemoryPackOrder(10)]
        [JsonProperty("prefer_target", Order = 7)]
        public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

        [MemoryPackOrder(11)]
        [JsonProperty("prefer_target_condition", Order = 8)]
        public PreferTargetCondition PreferTargetCondition { get; set; } = PreferTargetCondition.None;

        [MemoryPackOrder(17)]
        [JsonProperty("shot_timing", Order = 9)]
        public ShotTiming ShotTiming { get; set; } = ShotTiming.None;

        [MemoryPackOrder(5)]
        [JsonProperty("fire_type", Order = 10)]
        public FireType FireType { get; set; } = FireType.None;

        [MemoryPackOrder(8)]
        [JsonProperty("input_type", Order = 11)]
        public InputType InputType { get; set; } = InputType.NONE;

        [MemoryPackOrder(9)]
        [JsonProperty("is_targeting", Order = 12)]
        public bool IsTargeting { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("damage", Order = 13)]
        public int Damage { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("shot_count", Order = 14)]
        public int ShotCount { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("muzzle_count", Order = 15)]
        public int MuzzleCount { get; set; }

        [MemoryPackOrder(15)]
        [JsonProperty("multi_target_count", Order = 16)]
        public int MultiTargetCount { get; set; }

        [MemoryPackOrder(16)]
        [JsonProperty("center_shot_count", Order = 17)]
        public int CenterShotCount { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("max_ammo", Order = 18)]
        public int MaxAmmo { get; set; }

        [MemoryPackOrder(19)]
        [JsonProperty("maintain_fire_stance", Order = 19)]
        public int MaintainFireStance { get; set; }

        [MemoryPackOrder(20)]
        [JsonProperty("uptype_fire_timing", Order = 20)]
        public int UptypeFireTiming { get; set; }

        [MemoryPackOrder(21)]
        [JsonProperty("reload_time", Order = 21)]
        public int ReloadTime { get; set; }

        [MemoryPackOrder(22)]
        [JsonProperty("reload_bullet", Order = 22)]
        public int ReloadBullet { get; set; }

        [MemoryPackOrder(23)]
        [JsonProperty("reload_start_ammo", Order = 23)]
        public int ReloadStartAmmo { get; set; }

        [MemoryPackOrder(24)]
        [JsonProperty("rate_of_fire_reset_time", Order = 24)]
        public int RateOfFireResetTime { get; set; }

        [MemoryPackOrder(25)]
        [JsonProperty("rate_of_fire", Order = 25)]
        public int RateOfFire { get; set; }

        [MemoryPackOrder(26)]
        [JsonProperty("end_rate_of_fire", Order = 26)]
        public int EndRateOfFire { get; set; }

        [MemoryPackOrder(27)]
        [JsonProperty("rate_of_fire_change_pershot", Order = 27)]
        public int RateOfFireChangePershot { get; set; }

        [MemoryPackOrder(28)]
        [JsonProperty("burst_energy_pershot", Order = 28)]
        public int BurstEnergyPershot { get; set; }

        [MemoryPackOrder(29)]
        [JsonProperty("target_burst_energy_pershot", Order = 29)]
        public int TargetBurstEnergyPershot { get; set; }

        [MemoryPackOrder(31)]
        [JsonProperty("spot_first_delay", Order = 30)]
        public int SpotFirstDelay { get; set; }

        [MemoryPackOrder(32)]
        [JsonProperty("spot_last_delay", Order = 31)]
        public int SpotLastDelay { get; set; }

        [MemoryPackOrder(33)]
        [JsonProperty("start_accuracy_circle_scale", Order = 32)]
        public int StartAccuracyCircleScale { get; set; }

        [MemoryPackOrder(34)]
        [JsonProperty("end_accuracy_circle_scale", Order = 33)]
        public int EndAccuracyCircleScale { get; set; }

        [MemoryPackOrder(35)]
        [JsonProperty("accuracy_change_pershot", Order = 34)]
        public int AccuracyChangePershot { get; set; }

        [MemoryPackOrder(36)]
        [JsonProperty("accuracy_change_speed", Order = 35)]
        public int AccuracyChangeSpeed { get; set; }

        [MemoryPackOrder(37)]
        [JsonProperty("auto_start_accuracy_circle_scale", Order = 36)]
        public int AutoStartAccuracyCircleScale { get; set; }

        [MemoryPackOrder(38)]
        [JsonProperty("auto_end_accuracy_circle_scale", Order = 37)]
        public int AutoEndAccuracyCircleScale { get; set; }

        [MemoryPackOrder(39)]
        [JsonProperty("auto_accuracy_change_pershot", Order = 38)]
        public int AutoAccuracyChangePershot { get; set; }

        [MemoryPackOrder(40)]
        [JsonProperty("auto_accuracy_change_speed", Order = 39)]
        public int AutoAccuracyChangeSpeed { get; set; }

        [MemoryPackOrder(41)]
        [JsonProperty("zoom_rate", Order = 40)]
        public int ZoomRate { get; set; }

        [MemoryPackOrder(42)]
        [JsonProperty("multi_aim_range", Order = 41)]
        public int MultiAimRange { get; set; }

        [MemoryPackOrder(43)]
        [JsonProperty("spot_projectile_speed", Order = 42)]
        public int SpotProjectileSpeed { get; set; }

        [MemoryPackOrder(44)]
        [JsonProperty("charge_time", Order = 43)]
        public int ChargeTime { get; set; }

        [MemoryPackOrder(45)]
        [JsonProperty("full_charge_damage", Order = 44)]
        public int FullChargeDamage { get; set; }

        [MemoryPackOrder(46)]
        [JsonProperty("full_charge_burst_energy", Order = 45)]
        public int FullChargeBurstEnergy { get; set; }

        [MemoryPackOrder(47)]
        [JsonProperty("spot_radius_object", Order = 46)]
        public int SpotRadiusObject { get; set; }

        [MemoryPackOrder(48)]
        [JsonProperty("spot_radius", Order = 47)]
        public int SpotRadius { get; set; }

        [MemoryPackOrder(49)]
        [JsonProperty("spot_explosion_range", Order = 48)]
        public int SpotExplosionRange { get; set; }

        [MemoryPackOrder(50)]
        [JsonProperty("homing_script", Order = 49, NullValueHandling = NullValueHandling.Ignore)]
        public string? HomingScript { get; set; }

        [MemoryPackOrder(51)]
        [JsonProperty("core_damage_rate", Order = 50)]
        public int CoreDamageRate { get; set; }

        [MemoryPackOrder(30)]
        [JsonProperty("penetration", Order = 51)]
        public int Penetration { get; set; }

        [MemoryPackOrder(52)]
        [JsonProperty("use_function_id_list", Order = 52)]
        public int[] UseFunctionIdList { get; set; } = [];

        [MemoryPackOrder(53)]
        [JsonProperty("hurt_function_id_list", Order = 53)]
        public int[] HurtFunctionIdList { get; set; } = [];

        [MemoryPackOrder(54)]
        [JsonProperty("shake_id", Order = 54)]
        public int ShakeId { get; set; }

        [MemoryPackOrder(55)]
        [JsonProperty("ShakeType", Order = 55)]
        public ShakeType ShakeType { get; set; } = ShakeType.Fire_AR;

        [MemoryPackOrder(56)]
        [JsonProperty("ShakeWeight", Order = 56)]
        public int ShakeWeight { get; set; }

        [MemoryPackOrder(57)]
        [JsonProperty("aim_prefab", Order = 57, NullValueHandling = NullValueHandling.Ignore)]
        public string? AimPrefab { get; set; }
    }
}