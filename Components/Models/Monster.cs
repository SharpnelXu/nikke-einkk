using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models
{

    [JsonConverter(typeof(StringEnumConverter))]
    public enum PartsType
    {
        Unknown = -1,
        None = 0,
        Arm_Left = 1,
        Arm_Right = 2,
        Head = 3,
        Body_Lower = 4,
        Body_Upper = 5,
        Body = 6,
        Chest = 7,
        Belly = 8,
        Leg_Front_Left = 9,
        Leg_Front_Right = 10,
        Leg_Back_Left = 11,
        Leg_Back_Right = 12,
        Weapon_01 = 13,
        Weapon_02 = 14,
        Weapon_03 = 15,
        Weapon_04 = 16,
        Weapon_05 = 17,
        Weapon_06 = 18,
        Weapon_07 = 19,
        Weapon_08 = 20,
        Weapon_09 = 21,
        Weapon_10 = 22
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum MonsterDestroyAnimTrigger
    {
        Unknown = -1,
        None = 0,
        Destruction_01 = 1,
        Destruction_02 = 2,
        Destruction_03 = 3,
        Destruction_04 = 4
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum WeaponObject
    {
        [JsonProperty("unknown")]
        Unknown = -1,
        [JsonProperty("none")]
        None = 0,
        [JsonProperty("weapon_object_01")]
        Weapon_object_01,
        [JsonProperty("weapon_object_02")]
        Weapon_object_02,
        [JsonProperty("weapon_object_03")]
        Weapon_object_03,
        [JsonProperty("weapon_object_04")]
        Weapon_object_04,
        [JsonProperty("weapon_object_05")]
        Weapon_object_05,
        [JsonProperty("weapon_object_06")]
        Weapon_object_06,
        [JsonProperty("weapon_object_07")]
        Weapon_object_07,
        [JsonProperty("weapon_object_08")]
        Weapon_object_08,
        [JsonProperty("weapon_object_09")]
        Weapon_object_09,
        [JsonProperty("weapon_object_10")]
        Weapon_object_10,
        [JsonProperty("weapon_object_11")]
        Weapon_object_11,
        [JsonProperty("weapon_object_12")]
        Weapon_object_12,
        [JsonProperty("weapon_object_13")]
        Weapon_object_13,
        [JsonProperty("weapon_object_14")]
        Weapon_object_14,
        [JsonProperty("weapon_object_15")]
        Weapon_object_15,
        [JsonProperty("weapon_object_16")]
        Weapon_object_16,
        [JsonProperty("weapon_object_17")]
        Weapon_object_17,
        [JsonProperty("weapon_object_18")]
        Weapon_object_18,
        [JsonProperty("weapon_object_19")]
        Weapon_object_19,
        [JsonProperty("weapon_object_20")]
        Weapon_object_20,
    }

    [MemoryPackable]
    public partial class MonsterSkillInfoData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("skill_id", Order = 0)]
        public int SkillId { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("use_function_id_skill", Order = 1)]
        public int[] UseFunctionIds { get; set; } = [];

        [MemoryPackOrder(2)]
        [JsonProperty("hurt_function_id_skill", Order = 2)]
        public int[] HurtFunctionIds { get; set; } = [];
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum MonsterUiGrade
    {
        Unknown = -1,
        None = 0,
        Selfless = 1,
        Servant = 2,
        Master = 3,
        Lord = 4,
        Tyrant = 5,
        Heretic = 6,
        Queen = 7
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum NoneTargetCondition
    {
        Unknown = -1,
        Normal = 0,
        Last = 1,
        None = 2
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum FunctionNoneTargetCondition
    {
        Unknown = -1,
        Normal = 0,
        NoAllMonster = 1,
        ExcludeSpawnAndCountCheck = 2
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum SpawnType
    {
        Unknown = -1,
        None = 0,
        Normal = 1,
        Dash = 2,
        Jump = 3,
        Drop = 4,
        Random = 5,
        Teleport = 6,
        Animation = 7
    }

    [MemoryPackable]
    public partial class MonsterData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public long Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("element_id", Order = 1)]
        public int[] ElementIds { get; set; } = [];

        [MemoryPackOrder(2)]
        [JsonProperty("monster_model_id", Order = 2)]
        public int MonsterModelId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("ui_grade", Order = 2)]
        public MonsterUiGrade UiGrade { get; set; } = MonsterUiGrade.None;

        [MemoryPackOrder(3)]
        [JsonProperty("name_localkey", Order = 3)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("appearance_localkey", Order = 4)]
        public string AppearanceKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("description_localkey", Order = 5)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("is_irregular", Order = 6)]
        public bool IsIrregular { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("hp_ratio", Order = 7)]
        public int HpRatio { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("attack_ratio", Order = 8)]
        public int AttackRatio { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("defence_ratio", Order = 9)]
        public int DefenceRatio { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("energy_resist_ratio", Order = 10)]
        public int EnergyResistRatio { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("metal_resist_ratio", Order = 11)]
        public int MetalResistRatio { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("bio_resist_ratio", Order = 12)]
        public int BioResistRatio { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("detector_center", Order = 13)]
        public int DetectorCenter { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("detector_radius", Order = 14)]
        public int DetectorRadius { get; set; }

        [MemoryPackOrder(15)]
        [JsonProperty("nonetarget", Order = 15)]
        public NoneTargetCondition Nonetarget { get; set; } = NoneTargetCondition.Normal;

        [MemoryPackOrder(16)]
        [JsonProperty("functionnonetarget", Order = 16)]
        public FunctionNoneTargetCondition FunctionNonetarget { get; set; } = FunctionNoneTargetCondition.Normal;

        [MemoryPackOrder(17)]
        [JsonProperty("spot_ai", Order = 17)]
        public string SpotAi { get; set; } = string.Empty;

        [MemoryPackOrder(18)]
        [JsonProperty("spot_ai_defense", Order = 18)]
        public string SpotAiDefense { get; set; } = string.Empty;

        [MemoryPackOrder(19)]
        [JsonProperty("spot_ai_basedefense", Order = 19)]
        public string SpotAiBaseDefense { get; set; } = string.Empty;

        [MemoryPackOrder(20)]
        [JsonProperty("spot_move_speed", Order = 20)]
        public int SpotMoveSpeed { get; set; }

        [MemoryPackOrder(21)]
        [JsonProperty("spot_acceleration_time", Order = 21)]
        public int SpotAccelerationTime { get; set; }

        [MemoryPackOrder(22)]
        [JsonProperty("fixed_spawn_type", Order = 22)]
        public SpawnType FixedSpawnType { get; set; } = SpawnType.None;

        [MemoryPackOrder(23)]
        [JsonProperty("spot_rand_ratio_normal", Order = 23)]
        public int SpotRandRatioNormal { get; set; }

        [MemoryPackOrder(24)]
        [JsonProperty("spot_rand_ratio_jump", Order = 24)]
        public int SpotRandRatioJump { get; set; }

        [MemoryPackOrder(25)]
        [JsonProperty("spot_rand_ratio_drop", Order = 25)]
        public int SpotRandRatioDrop { get; set; }

        [MemoryPackOrder(26)]
        [JsonProperty("spot_rand_ratio_dash", Order = 26)]
        public int SpotRandRatioDash { get; set; }

        [MemoryPackOrder(27)]
        [JsonProperty("spot_rand_ratio_teleport", Order = 27)]
        public int SpotRandRatioTeleport { get; set; }

        [MemoryPackOrder(28)]
        [JsonProperty("passive_skill_id", Order = 28)]
        public int PassiveSkillId { get; set; }

        [MemoryPackOrder(28)]
        [JsonProperty("skill_data", Order = 28)]
        public MonsterSkillInfoData[] SkillData { get; set; } = [];

        [MemoryPackOrder(29)]
        [JsonProperty("statenhance_id", Order = 29)]
        public int StatEnhanceId { get; set; }
    }

    [MemoryPackable]
    public partial class MonsterStatEnhanceData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group_id", Order = 1)]
        public int GroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("lv", Order = 2)]
        public int Lv { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("level_hp", Order = 3)]
        public long LevelHp { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("level_attack", Order = 4)]
        public int LevelAttack { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("level_defence", Order = 5)]
        public int LevelDefence { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("level_statdamageratio", Order = 6)]
        public int LevelStatDamageRatio { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("level_energy_resist", Order = 7)]
        public int LevelEnergyResist { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("level_metal_resist", Order = 8)]
        public int LevelMetalResist { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("level_bio_resist", Order = 9)]
        public int LevelBioResist { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("level_projectile_hp", Order = 10)]
        public int LevelProjectileHp { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("level_broken_hp", Order = 11)]
        public long LevelBrokenHp { get; set; }
    }

    [MemoryPackable]
    public partial class MonsterPartData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("monster_model_id", Order = 1)]
        public int MonsterModelId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("parts_name_localkey", Order = 2, DefaultValueHandling = DefaultValueHandling.Ignore)]
        public string? PartsNameLocalKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("damage_hp_ratio", Order = 2)]
        public int DamageHpRatio { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("hp_ratio", Order = 3)]
        public int HpRatio { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("defence_ratio", Order = 4)]
        public int DefenceRatio { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("destroy_after_anim", Order = 5, DefaultValueHandling = DefaultValueHandling.Ignore)]
        public bool DestroyAfterAnim { get; set; } = false;

        [MemoryPackOrder(6)]
        [JsonProperty("destroy_after_movable", Order = 6)]
        public bool DestroyAfterMovable { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("passive_skill_id", Order = 7)]
        public int PassiveSkillId { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("visible_hp", Order = 8)]
        public bool VisibleHp { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("linked_parts_id", Order = 9)]
        public int LinkedPartsId { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("weapon_object", Order = 10)]
        public string[] WeaponObject { get; set; } = [];

        [MemoryPackOrder(11)]
        [JsonProperty("weapon_object_enum", Order = 11)]
        public WeaponObject[] WeaponObjectEnum { get; set; } = [];

        [MemoryPackOrder(12)]
        [JsonProperty("parts_type", Order = 12)]
        [JsonConverter(typeof(StringEnumConverter))]
        public PartsType PartsType { get; set; } = PartsType.Unknown;

        [MemoryPackOrder(13)]
        [JsonProperty("parts_object", Order = 13)]
        public string[] PartsObject { get; set; } = [];

        [MemoryPackOrder(14)]
        [JsonProperty("energy_resist_ratio", Order = 5)]
        public int EnergyResistRatio { get; set; }

        [MemoryPackOrder(15)]
        [JsonProperty("metal_resist_ratio", Order = 5)]
        public int MetalResistRatio { get; set; }

        [MemoryPackOrder(16)]
        [JsonProperty("bio_resist_ratio", Order = 5)]
        public int BioResistRatio { get; set; }

        [MemoryPackOrder(17)]
        [JsonProperty("attack_ratio", Order = 3)]
        public int AttackRatio { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("parts_skin", Order = 18, DefaultValueHandling = DefaultValueHandling.Ignore)]
        public string? PartsSkin { get; set; } = string.Empty;

        [MemoryPackOrder(19)]
        [JsonProperty("monster_destroy_anim_trigger", Order = 19)]
        [JsonConverter(typeof(StringEnumConverter))]
        public MonsterDestroyAnimTrigger DestroyAnimTrigger { get; set; } = MonsterDestroyAnimTrigger.Unknown;

        [MemoryPackOrder(20)]
        [JsonProperty("is_main_part", Order = 20)]
        public bool IsMainPart { get; set; }

        [MemoryPackOrder(21)]
        [JsonProperty("is_parts_damage_able", Order = 21)]
        public bool IsPartsDamageAble { get; set; }
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum MonsterStageLevelChangeCondition
    {
        Unknown = -1,
        None = 0,
        DamageDoneToTargetMonster = 1,
    }

    [MemoryPackable]
    public partial class MonsterStageLevelChangeData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group", Order = 1)]
        public int Group { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("step", Order = 2)]
        public int Step { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("condition_type", Order = 3)]
        public MonsterStageLevelChangeCondition ConditionType { get; set; } = MonsterStageLevelChangeCondition.None;

        [MemoryPackOrder(4)]
        [JsonProperty("condition_value_min", Order = 4)]
        public long ConditionValueMin { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("condition_value_max", Order = 5)]
        public long ConditionValueMax { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("monster_stage_lv", Order = 6)]
        public int MonsterStageLv { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("passive_skill_id", Order = 7)]
        public int PassiveSkillId { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("target_passive_skill_id", Order = 8)]
        public int TargetPassiveSkillId { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("gimmickobject_lv_control", Order = 9)]
        public int GimmickObjectLvControl { get; set; }
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum ObjectPositionType
    {
        Unknown = -1,
        None = 0,
        Local = 1,
        World = 2,
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum CancelType
    {
        Unknown = -1,
        None = 0,
        BreakCol = 1,
        BrokenParts = 2,
        BrokenParts_OnlyCasting = 3,
        BrokenParts_HurtCount = 4,
        BrokenParts_UntilEnd = 5,
        BreakCol_SkipCasting = 6
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum SkillAnimationNumber
    {
        Unknown = -1,
        None = 0,
        Shot_01 = 1,
        Shot_02 = 2,
        Shot_03 = 3,
        Shot_04 = 4,
        Shot_05 = 5,
        Shot_06 = 6,
        Shot_07 = 7,
        Shot_08 = 8,
        Shot_09 = 9,
        Shot_10 = 10,
        Shot_11 = 11,
        Shot_12 = 12,
        Shot_13 = 13,
        Shot_14 = 14,
        Shot_15 = 15,
        Shot_16 = 16,
        Shot_17 = 17,
        Shot_18 = 18,
        Shot_19 = 19,
        Shot_20 = 20,
        Shot_21 = 21,
        Shot_22 = 22,
        Shot_23 = 23,
        Shot_24 = 24,
        Shot_25 = 25,
        Shot_26 = 26,
        Shot_27 = 27,
        Shot_28 = 28,
        Shot_29 = 29,
        Shot_30 = 30,
        Shot_31 = 31,
        Shot_32 = 32,
        Shot_33 = 33,
        Shot_34 = 34,
        Shot_35 = 35,
        Shot_36 = 36,
        Shot_37 = 37,
        Shot_38 = 38,
        Shot_39 = 39,
        Shot_40 = 40,
        Shot_41 = 41,
        Shot_42 = 42,
        Shot_43 = 43,
        Shot_44 = 44,
        Shot_45 = 45,
        Shot_46 = 46,
        Shot_47 = 47,
        Shot_48 = 48,
        Shot_49 = 49,
        Shot_50 = 50,
        Shot_51 = 51,
        Shot_52 = 52,
        Shot_53 = 53,
        Shot_54 = 54,
        Shot_55 = 55,
        Shot_56 = 56,
        Shot_57 = 57,
        Shot_58 = 58,
        Shot_59 = 59,
        Shot_60 = 60,
        Shot_61 = 61,
        Shot_62 = 62,
        Shot_63 = 63,
        Shot_64 = 64,
        Shot_65 = 65,
        Shot_66 = 66,
        Shot_67 = 67,
        Shot_68 = 68,
        Shot_69 = 69,
        Shot_70 = 70,
        Shot_71 = 71,
        Shot_72 = 72,
        Shot_73 = 73,
        Shot_74 = 74,
        Shot_75 = 75,
        Shot_76 = 76,
        Shot_77 = 77,
        Shot_78 = 78,
        Shot_79 = 79,
        Shot_80 = 80,
        Shot_81 = 81,
        Shot_82 = 82,
        Shot_83 = 83,
        Shot_84 = 84,
        Shot_85 = 85,
        Shot_86 = 86,
        Shot_87 = 87,
        Shot_88 = 88,
        Shot_89 = 89,
        Shot_90 = 90,
        Shot_91 = 91,
        Shot_92 = 92,
        Shot_93 = 93,
        Shot_94 = 94,
        Shot_95 = 95,
        Shot_96 = 96,
        Shot_97 = 97,
        Shot_98 = 98,
        Shot_99 = 99
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum MonsterSkillvalueType
    {
        Unknown = -1,
        None = 0,
        Percent = 1,
        Integer = 2
    }

    [MemoryPackable]
    public partial class MonsterSkillData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string? NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string? DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("skill_icon", Order = 3)]
        public string SkillIcon { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("skill_ani_number", Order = 4)]
        public SkillAnimationNumber AnimationNumber { get; set; } = SkillAnimationNumber.None;

        [MemoryPackOrder(5)]
        [JsonProperty("weapon_type", Order = 5)]
        [JsonConverter(typeof(StringEnumConverter))]
        public WeaponType WeaponType { get; set; } = WeaponType.None;

        [MemoryPackOrder(33)]
        [JsonProperty("prefer_target", Order = 6)]
        [JsonConverter(typeof(StringEnumConverter))]
        public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

        [MemoryPackOrder(34)]
        [JsonProperty("show_lock_on", Order = 7)]
        public bool ShowLockOn { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("attack_type", Order = 8)]
        [JsonConverter(typeof(StringEnumConverter))]
        public AttackType AttackType { get; set; } = AttackType.None;

        [MemoryPackOrder(7)]
        [JsonProperty("fire_type", Order = 9)]
        [JsonConverter(typeof(StringEnumConverter))]
        public FireType FireType { get; set; } = FireType.None;

        [MemoryPackOrder(20)]
        [JsonProperty("casting_time", Order = 10)]
        public int CastingTime { get; set; }

        [MemoryPackOrder(21)]
        [JsonProperty("break_object", Order = 11)]
        public string[] BreakObjects { get; set; } = [];

        [MemoryPackOrder(22)]
        [JsonProperty("break_object_hp_raito", Order = 12)]
        public int BreakObjectHpRatio { get; set; }

        [MemoryPackOrder(23)]
        [JsonProperty("move_object", Order = 12)]
        public string[] MoveObject { get; set; } = [];

        [MemoryPackOrder(25)]
        [JsonProperty("skill_value_type_01", Order = 13)]
        [JsonConverter(typeof(StringEnumConverter))]
        public MonsterSkillvalueType SkillValueType1 { get; set; } = MonsterSkillvalueType.None;

        [MemoryPackOrder(26)]
        [JsonProperty("skill_value_01", Order = 14)]
        public long SkillValue1 { get; set; }

        [MemoryPackOrder(27)]
        [JsonProperty("skill_value_type_02", Order = 15)]
        [JsonConverter(typeof(StringEnumConverter))]
        public MonsterSkillvalueType SkillValueType2 { get; set; } = MonsterSkillvalueType.None;

        [MemoryPackOrder(28)]
        [JsonProperty("skill_value_02", Order = 16)]
        public long SkillValue2 { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("shot_count", Order = 17)]
        public int ShotCount { get; set; }

        [MemoryPackOrder(24)]
        [JsonProperty("delay_time", Order = 18)]
        public int DelayTime { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("shot_timing", Order = 19)]
        [JsonConverter(typeof(StringEnumConverter))]
        public ShotTiming ShotTiming { get; set; } = ShotTiming.None;

        [MemoryPackOrder(10)]
        [JsonProperty("penetration", Order = 20)]
        public int Penetration { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("projectile_speed", Order = 21)]
        public int ProjectileSpeed { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("projectile_hp_ratio", Order = 22)]
        public int ProjectileHpRatio { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("projectile_def_ratio", Order = 22)]
        public int ProjectileDefRatio { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("projectile_radius_object", Order = 23)]
        public int ProjectileRadiusObject { get; set; }

        [MemoryPackOrder(15)]
        [JsonProperty("projectile_radius", Order = 24)]
        public int ProjectileRadius { get; set; }

        [MemoryPackOrder(16)]
        [JsonProperty("spot_explosion_range", Order = 25)]
        public int ExplosionRange { get; set; }

        [MemoryPackOrder(17)]
        [JsonProperty("is_destroyable_projectile", Order = 26)]
        public bool IsDestroyableProjectile { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("relate_anim", Order = 27)]
        public bool RelateAnim { get; set; }

        [MemoryPackOrder(19)]
        [JsonProperty("deceleration_rate", Order = 28)]
        public int DecelerationRate { get; set; }

        [MemoryPackOrder(29)]
        [JsonProperty("target_character_ratio", Order = 29)]
        public int TargetCharacterRatio { get; set; }

        [MemoryPackOrder(30)]
        [JsonProperty("target_cover_ratio", Order = 30)]
        public int TargetCoverRatio { get; set; }

        [MemoryPackOrder(31)]
        [JsonProperty("target_nothing_ratio", Order = 31)]
        public int TargetNothingRatio { get; set; }

        [MemoryPackOrder(32)]
        [JsonProperty("weapon_object_enum", Order = 31)]
        [JsonConverter(typeof(StringEnumConverter))]
        public WeaponObject WeaponObjectEnum { get; set; } = WeaponObject.None;

        [MemoryPackOrder(32)]
        [JsonProperty("calling_group_id", Order = 32)]
        public int CallingGroupId { get; set; }

        [MemoryPackOrder(35)]
        [JsonProperty("target_count", Order = 33)]
        public int TargetCount { get; set; }

        [MemoryPackOrder(36)]
        [JsonProperty("object_resource", Order = 34)]
        public string[] ObjectResources { get; set; } = [];

        [MemoryPackOrder(37)]
        [JsonProperty("object_position_type", Order = 35)]
        [JsonConverter(typeof(StringEnumConverter))]
        public ObjectPositionType ObjectPositionType { get; set; } = ObjectPositionType.None;

        [MemoryPackOrder(38)]
        [JsonProperty("object_position", Order = 36)]
        public double[] ObjectPosition { get; set; } = [0.0, 0.0, 0.0];

        [MemoryPackOrder(39)]
        [JsonProperty("is_using_timeline", Order = 37)]
        public bool IsUsingTimeline { get; set; }

        [MemoryPackOrder(40)]
        [JsonProperty("control_gauge", Order = 38)]
        public int ControlGauge { get; set; }

        [MemoryPackOrder(41)]
        [JsonProperty("control_parts", Order = 39)]
        public PartsType[] ControlParts { get; set; } = [];

        [MemoryPackOrder(42)]
        [JsonProperty("cancel_type", Order = 42)]
        [JsonConverter(typeof(StringEnumConverter))]
        public CancelType CancelType { get; set; } = CancelType.None;

        [MemoryPackOrder(43)]
        [JsonProperty("linked_parts", Order = 41)]
        [JsonConverter(typeof(StringEnumConverter))]
        public PartsType LinkedParts { get; set; } = PartsType.None;
    }
}
