using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
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

    public enum MonsterDestroyAnimTrigger
    {
        Unknown = -1,
        None = 0,
        Destruction_01 = 1,
        Destruction_02 = 2,
        Destruction_03 = 3,
        Destruction_04 = 4
    }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum WeaponObject
    {
        [JsonStringEnumMemberName("unknown")]
        Unknown = -1,
        [JsonStringEnumMemberName("none")]
        None = 0,
        [JsonStringEnumMemberName("weapon_object_01")]
        Weapon_object_01,
        [JsonStringEnumMemberName("weapon_object_02")]
        Weapon_object_02,
        [JsonStringEnumMemberName("weapon_object_03")]
        Weapon_object_03,
        [JsonStringEnumMemberName("weapon_object_04")]
        Weapon_object_04,
        [JsonStringEnumMemberName("weapon_object_05")]
        Weapon_object_05,
        [JsonStringEnumMemberName("weapon_object_06")]
        Weapon_object_06,
        [JsonStringEnumMemberName("weapon_object_07")]
        Weapon_object_07,
        [JsonStringEnumMemberName("weapon_object_08")]
        Weapon_object_08,
        [JsonStringEnumMemberName("weapon_object_09")]
        Weapon_object_09,
        [JsonStringEnumMemberName("weapon_object_10")]
        Weapon_object_10,
        [JsonStringEnumMemberName("weapon_object_11")]
        Weapon_object_11,
        [JsonStringEnumMemberName("weapon_object_12")]
        Weapon_object_12,
        [JsonStringEnumMemberName("weapon_object_13")]
        Weapon_object_13,
        [JsonStringEnumMemberName("weapon_object_14")]
        Weapon_object_14,
        [JsonStringEnumMemberName("weapon_object_15")]
        Weapon_object_15,
        [JsonStringEnumMemberName("weapon_object_16")]
        Weapon_object_16,
        [JsonStringEnumMemberName("weapon_object_17")]
        Weapon_object_17,
        [JsonStringEnumMemberName("weapon_object_18")]
        Weapon_object_18,
        [JsonStringEnumMemberName("weapon_object_19")]
        Weapon_object_19,
        [JsonStringEnumMemberName("weapon_object_20")]
        Weapon_object_20,
        // Unknown = -1,
        // None = 0,
        // Weapon_object_01,
        // Weapon_object_02,
        // Weapon_object_03,
        // Weapon_object_04,
        // Weapon_object_05,
        // Weapon_object_06,
        // Weapon_object_07,
        // Weapon_object_08,
        // Weapon_object_09,
        // Weapon_object_10,
        // Weapon_object_11,
        // Weapon_object_12,
        // Weapon_object_13,
        // Weapon_object_14,
        // Weapon_object_15,
        // Weapon_object_16,
        // Weapon_object_17,
        // Weapon_object_18,
        // Weapon_object_19,
        // Weapon_object_20,
    }

    [MemoryPackable]
    public partial class MonsterSkillInfoData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("skill_id")]
        public int SkillId { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("use_function_id_skill")]
        public int[] UseFunctionIds { get; set; } = [];

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("hurt_function_id_skill")]
        public int[] HurtFunctionIds { get; set; } = [];
    }

    [JsonConverter(typeof(JsonStringEnumConverter))]
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

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum NoneTargetCondition
    {
        Unknown = -1,
        Normal = 0,
        Last = 1,
        None = 2
    }
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum FunctionNoneTargetCondition
    {
        Unknown = -1,
        Normal = 0,
        NoAllMonster = 1,
        ExcludeSpawnAndCountCheck = 2
    }

    [JsonConverter(typeof(JsonStringEnumConverter))]
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
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public long Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("element_id")]
        public int[] ElementIds { get; set; } = [];

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("monster_model_id")]
        public int MonsterModelId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("ui_grade")]
        public MonsterUiGrade UiGrade { get; set; } = MonsterUiGrade.None;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("appearance_localkey")]
        public string AppearanceKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("is_irregular")]
        public bool IsIrregular { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("hp_ratio")]
        public int HpRatio { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("attack_ratio")]
        public int AttackRatio { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("defence_ratio")]
        public int DefenceRatio { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("energy_resist_ratio")]
        public int EnergyResistRatio { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("metal_resist_ratio")]
        public int MetalResistRatio { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("bio_resist_ratio")]
        public int BioResistRatio { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("detector_center")]
        public int DetectorCenter { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("detector_radius")]
        public int DetectorRadius { get; set; }

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("nonetarget")]
        public NoneTargetCondition Nonetarget { get; set; } = NoneTargetCondition.Normal;

        [MemoryPackOrder(16)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("functionnonetarget")]
        public FunctionNoneTargetCondition FunctionNonetarget { get; set; } = FunctionNoneTargetCondition.Normal;

        [MemoryPackOrder(17)]
        [JsonPropertyOrder(17)]
        [JsonPropertyName("spot_ai")]
        public string SpotAi { get; set; } = string.Empty;

        [MemoryPackOrder(18)]
        [JsonPropertyOrder(18)]
        [JsonPropertyName("spot_ai_defense")]
        public string SpotAiDefense { get; set; } = string.Empty;

        [MemoryPackOrder(19)]
        [JsonPropertyOrder(19)]
        [JsonPropertyName("spot_ai_basedefense")]
        public string SpotAiBaseDefense { get; set; } = string.Empty;

        [MemoryPackOrder(20)]
        [JsonPropertyOrder(20)]
        [JsonPropertyName("spot_move_speed")]
        public int SpotMoveSpeed { get; set; }

        [MemoryPackOrder(21)]
        [JsonPropertyOrder(21)]
        [JsonPropertyName("spot_acceleration_time")]
        public int SpotAccelerationTime { get; set; }

        [MemoryPackOrder(22)]
        [JsonPropertyOrder(22)]
        [JsonPropertyName("fixed_spawn_type")]
        public SpawnType FixedSpawnType { get; set; } = SpawnType.None;

        [MemoryPackOrder(23)]
        [JsonPropertyOrder(23)]
        [JsonPropertyName("spot_rand_ratio_normal")]
        public int SpotRandRatioNormal { get; set; }

        [MemoryPackOrder(24)]
        [JsonPropertyOrder(24)]
        [JsonPropertyName("spot_rand_ratio_jump")]
        public int SpotRandRatioJump { get; set; }

        [MemoryPackOrder(25)]
        [JsonPropertyOrder(25)]
        [JsonPropertyName("spot_rand_ratio_drop")]
        public int SpotRandRatioDrop { get; set; }

        [MemoryPackOrder(26)]
        [JsonPropertyOrder(26)]
        [JsonPropertyName("spot_rand_ratio_dash")]
        public int SpotRandRatioDash { get; set; }

        [MemoryPackOrder(27)]
        [JsonPropertyOrder(27)]
        [JsonPropertyName("spot_rand_ratio_teleport")]
        public int SpotRandRatioTeleport { get; set; }

        [MemoryPackOrder(28)]
        [JsonPropertyOrder(28)]
        [JsonPropertyName("passive_skill_id")]
        public int PassiveSkillId { get; set; }

        [MemoryPackOrder(28)]
        [JsonPropertyOrder(28)]
        [JsonPropertyName("skill_data")]
        public MonsterSkillInfoData[] SkillData { get; set; } = [];

        [MemoryPackOrder(29)]
        [JsonPropertyOrder(29)]
        [JsonPropertyName("statenhance_id")]
        public int StatEnhanceId { get; set; }
    }

    /// <summary>
    /// Monster stat enhancement data from MonsterStatEnhanceTable
    /// </summary>
    [MemoryPackable]
    public partial class MonsterStatEnhanceData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("group_id")]
        public int GroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("lv")]
        public int Lv { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("level_hp")]
        public long LevelHp { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("level_attack")]
        public int LevelAttack { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("level_defence")]
        public int LevelDefence { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("level_statdamageratio")]
        public int LevelStatDamageRatio { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("level_energy_resist")]
        public int LevelEnergyResist { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("level_metal_resist")]
        public int LevelMetalResist { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("level_bio_resist")]
        public int LevelBioResist { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("level_projectile_hp")]
        public int LevelProjectileHp { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("level_broken_hp")]
        public long LevelBrokenHp { get; set; }
    }

    /// <summary>
    /// Monster part data from MonsterPartsTable
    /// </summary>
    [MemoryPackable]
    public partial class MonsterPartData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("monster_model_id")]
        public int MonsterModelId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("parts_name_localkey")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault | JsonIgnoreCondition.WhenWritingNull)]
        public string? PartsNameLocalKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("damage_hp_ratio")]
        public int DamageHpRatio { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("hp_ratio")]
        public int HpRatio { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("defence_ratio")]
        public int DefenceRatio { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("destroy_after_anim")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public bool DestroyAfterAnim { get; set; } = false;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("destroy_after_movable")]
        public bool DestroyAfterMovable { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("passive_skill_id")]
        public int PassiveSkillId { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("visible_hp")]
        public bool VisibleHp { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("linked_parts_id")]
        public int LinkedPartsId { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("weapon_object")]
        public string[] WeaponObject { get; set; } = [];

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("weapon_object_enum")]
        public WeaponObject[] WeaponObjectEnum { get; set; } = [];

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("parts_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PartsType PartsType { get; set; } = PartsType.Unknown;

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("parts_object")]
        public string[] PartsObject { get; set; } = [];

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("energy_resist_ratio")]
        public int EnergyResistRatio { get; set; }

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("metal_resist_ratio")]
        public int MetalResistRatio { get; set; }

        [MemoryPackOrder(16)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("bio_resist_ratio")]
        public int BioResistRatio { get; set; }

        [MemoryPackOrder(17)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("attack_ratio")]
        public int AttackRatio { get; set; }


        [MemoryPackOrder(18)]
        [JsonPropertyOrder(18)]
        [JsonPropertyName("parts_skin")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault | JsonIgnoreCondition.WhenWritingNull)]
        public string? PartsSkin { get; set; } = string.Empty;

        [MemoryPackOrder(19)]
        [JsonPropertyOrder(19)]
        [JsonPropertyName("monster_destroy_anim_trigger")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public MonsterDestroyAnimTrigger DestroyAnimTrigger { get; set; } = MonsterDestroyAnimTrigger.Unknown;

        [MemoryPackOrder(20)]
        [JsonPropertyOrder(20)]
        [JsonPropertyName("is_main_part")]
        public bool IsMainPart { get; set; }

        [MemoryPackOrder(21)]
        [JsonPropertyOrder(21)]
        [JsonPropertyName("is_parts_damage_able")]
        public bool IsPartsDamageAble { get; set; }
    }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum MonsterStageLevelChangeCondition
    {
        Unknown = -1,
        None = 0,
        DamageDoneToTargetMonster = 1,
    }

    /// <summary>
    /// Monster stage level change data from MonsterStageLvChangeTable
    /// </summary>
    [MemoryPackable]
    public partial class MonsterStageLevelChangeData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("group")]
        public int Group { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("step")]
        public int Step { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("condition_type")]
        public MonsterStageLevelChangeCondition ConditionType { get; set; } = MonsterStageLevelChangeCondition.None;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("condition_value_min")]
        public long ConditionValueMin { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("condition_value_max")]
        public long ConditionValueMax { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("monster_stage_lv")]
        public int MonsterStageLv { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("passive_skill_id")]
        public int PassiveSkillId { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("target_passive_skill_id")]
        public int TargetPassiveSkillId { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("gimmickobject_lv_control")]
        public int GimmickObjectLvControl { get; set; }
    }

    public enum ObjectPositionType
    {
        Unknown = -1,
        None = 0,
        Local = 1,
        World = 2,
    }

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

    [JsonConverter(typeof(JsonStringEnumConverter))]
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

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum MonsterSkillvalueType
    {
        Unknown = -1,
        None = 0,
        Percent = 1,
        Integer = 2
    }

    /// <summary>
    /// Monster skill data from MonsterSkillTable
    /// </summary>
    [MemoryPackable]
    public partial class MonsterSkillData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string? NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string? DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("skill_icon")]
        public string SkillIcon { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("skill_ani_number")]
        public SkillAnimationNumber AnimationNumber { get; set; } = SkillAnimationNumber.None;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("weapon_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public WeaponType WeaponType { get; set; } = WeaponType.None;

        [MemoryPackOrder(33)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("prefer_target")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

        [MemoryPackOrder(34)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("show_lock_on")]
        public bool ShowLockOn { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("attack_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public AttackType AttackType { get; set; } = AttackType.None;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("fire_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FireType FireType { get; set; } = FireType.None;

        [MemoryPackOrder(20)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("casting_time")]
        public int CastingTime { get; set; }

        [MemoryPackOrder(21)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("break_object")]
        public string[] BreakObjects { get; set; } = [];

        [MemoryPackOrder(22)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("break_object_hp_raito")]
        public int BreakObjectHpRatio { get; set; }

        [MemoryPackOrder(23)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("move_object")]
        public string[] MoveObject { get; set; } = [];

        [MemoryPackOrder(25)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("skill_value_type_01")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public MonsterSkillvalueType SkillValueType1 { get; set; } = MonsterSkillvalueType.None;

        [MemoryPackOrder(26)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("skill_value_01")]
        public long SkillValue1 { get; set; }

        [MemoryPackOrder(27)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("skill_value_type_02")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public MonsterSkillvalueType SkillValueType2 { get; set; } = MonsterSkillvalueType.None;

        [MemoryPackOrder(28)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("skill_value_02")]
        public long SkillValue2 { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(17)]
        [JsonPropertyName("shot_count")]
        public int ShotCount { get; set; }

        [MemoryPackOrder(24)]
        [JsonPropertyOrder(18)]
        [JsonPropertyName("delay_time")]
        public int DelayTime { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(19)]
        [JsonPropertyName("shot_timing")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ShotTiming ShotTiming { get; set; } = ShotTiming.None;

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(20)]
        [JsonPropertyName("penetration")]
        public int Penetration { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(21)]
        [JsonPropertyName("projectile_speed")]
        public int ProjectileSpeed { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(22)]
        [JsonPropertyName("projectile_hp_ratio")]
        public int ProjectileHpRatio { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(22)]
        [JsonPropertyName("projectile_def_ratio")]
        public int ProjectileDefRatio { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(23)]
        [JsonPropertyName("projectile_radius_object")]
        public int ProjectileRadiusObject { get; set; }

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(24)]
        [JsonPropertyName("projectile_radius")]
        public int ProjectileRadius { get; set; }

        [MemoryPackOrder(16)]
        [JsonPropertyOrder(25)]
        [JsonPropertyName("spot_explosion_range")]
        public int ExplosionRange { get; set; }

        [MemoryPackOrder(17)]
        [JsonPropertyOrder(26)]
        [JsonPropertyName("is_destroyable_projectile")]
        public bool IsDestroyableProjectile { get; set; }

        [MemoryPackOrder(18)]
        [JsonPropertyOrder(27)]
        [JsonPropertyName("relate_anim")]
        public bool RelateAnim { get; set; }

        [MemoryPackOrder(19)]
        [JsonPropertyOrder(28)]
        [JsonPropertyName("deceleration_rate")]
        public int DecelerationRate { get; set; }

        [MemoryPackOrder(29)]
        [JsonPropertyOrder(29)]
        [JsonPropertyName("target_character_ratio")]
        public int TargetCharacterRatio { get; set; }

        [MemoryPackOrder(30)]
        [JsonPropertyOrder(30)]
        [JsonPropertyName("target_cover_ratio")]
        public int TargetCoverRatio { get; set; }

        [MemoryPackOrder(31)]
        [JsonPropertyOrder(31)]
        [JsonPropertyName("target_nothing_ratio")]
        public int TargetNothingRatio { get; set; }

        [MemoryPackOrder(32)]
        [JsonPropertyOrder(31)]
        [JsonPropertyName("weapon_object_enum")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public WeaponObject WeaponObjectEnum { get; set; } = WeaponObject.None;

        [MemoryPackOrder(32)]
        [JsonPropertyOrder(32)]
        [JsonPropertyName("calling_group_id")]
        public int CallingGroupId { get; set; }

        [MemoryPackOrder(35)]
        [JsonPropertyOrder(33)]
        [JsonPropertyName("target_count")]
        public int TargetCount { get; set; }

        [MemoryPackOrder(36)]
        [JsonPropertyOrder(34)]
        [JsonPropertyName("object_resource")]
        public string[] ObjectResources { get; set; } = [];

        [MemoryPackOrder(37)]
        [JsonPropertyOrder(35)]
        [JsonPropertyName("object_position_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ObjectPositionType ObjectPositionType { get; set; } = ObjectPositionType.None;

        [MemoryPackOrder(38)]
        [JsonPropertyOrder(36)]
        [JsonPropertyName("object_position")]
        public double[] ObjectPosition { get; set; } = [0.0, 0.0, 0.0];

        [MemoryPackOrder(39)]
        [JsonPropertyOrder(37)]
        [JsonPropertyName("is_using_timeline")]
        public bool IsUsingTimeline { get; set; }

        [MemoryPackOrder(40)]
        [JsonPropertyOrder(38)]
        [JsonPropertyName("control_gauge")]
        public int ControlGauge { get; set; }

        [MemoryPackOrder(41)]
        [JsonPropertyOrder(39)]
        [JsonPropertyName("control_parts")]
        public PartsType[] ControlParts { get; set; } = [];

        [MemoryPackOrder(42)]
        [JsonPropertyOrder(42)]
        [JsonPropertyName("cancel_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public CancelType CancelType { get; set; } = CancelType.None;

        [MemoryPackOrder(43)]
        [JsonPropertyOrder(41)]
        [JsonPropertyName("linked_parts")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PartsType LinkedParts { get; set; } = PartsType.None;
    }
}