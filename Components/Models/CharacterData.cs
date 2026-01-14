using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    public enum Rarity
    {
        Unknown = -1,
        SSR = 3,
        SR = 2,
        R = 1
    }

    public enum NikkeClass
    {
        Unknown = -1,
        None = 0,
        Attacker = 1,
        Defender = 2,
        Supporter = 3,
        All = 4
    }

    public enum BurstStep
    {
        Unknown = -1,
        None = 0,
        Step1 = 1,
        Step2 = 2,
        Step3 = 3,
        StepFull = 4,
        AllStep = 5,
        NextStep = 6,
        KeepStep = 7
    }

    public enum Corporation
    {
        Unknown = -1,
        None = 0,
        ELYSION = 1,
        MISSILIS = 2,
        TETRA = 3,
        PILGRIM = 4,
        ALL = 5,
        RANDOM = 6,
        ABNORMAL = 7
    }

    public enum CorporationSubType
    {
        Unknown = -1,
        NORMAL = 0,
        OVERSPEC = 1,
    }

    public enum SkillType
    {
        Unknown = -1,
        None = 0,
        StateEffect = 1,
        CharacterSkill = 2
    }

    public enum EffCategoryType
    {
        Unknown = -1,
        None = 0,
        Air_Attacker = 1,
        Air_Defender = 2,
        Air_Supporter = 3,
        Attacker = 4,
        Defender = 5,
        Supporter = 6,
        Walk = 7,
        Fly = 8
    }

    public enum CategoryType
    {
        Unknown = -1,
        None = 0,
        Type1 = 1,
        Type2 = 2,
        Type3 = 3
    }

    public enum Squad
    {
        Unknown = -1,
        None = 0,
        Counters = 1,
        Absolute = 2,
        Scouting = 3,
        InfinityRail = 4,
        External = 5,
        RecallRelease = 6,
        Matis = 7,
        CafeSweety = 8,
        Triangle = 9,
        Talentum = 10,
        LittleCannon = 11,
        Protocol = 12,
        Unlimited = 13,
        ACPU = 14,
        MightyTools = 15,
        MasterHand = 16,
        SiegePerilous = 17,
        Seraphim = 18,
        Wardress = 19,
        MaidForYou = 20,
        Exotic = 21,
        LifeTonic = 22,
        Pioneer = 23,
        Inherit = 24,
        TheClown = 25,
        [JsonProperty("777")]
        _777 = 26,
        UnderworldQueen = 27,
        MMR = 28,
        Replace = 29,
        Humanity = 30,
        Company = 31,
        EventHero01 = 32,
        EventHero02 = 33,
        EventHero03 = 34,
        Archive = 35,
        Weissritter = 36,
        HeavyGram = 37,
        HappyZoo = 38,
        RealKindness = 39,
        Heretic = 40,
        A_F_F_ = 41,
        EnikkChild = 42,
        Aegis = 43,
        BotanicGarden = 44,
        PrimaDonna = 45,
        SchoolCircle = 46,
        Ce_01 = 47,
        Overseer = 48,
        Ce002_01 = 49,
        Ce002_02 = 50,
        Akademeia = 51,
        DazzlingPearl = 52,
        Goddess = 53,
        ElectricShock = 54,
        CE003 = 55,
        Rewind = 56,
        CE004 = 57,
        BestSeller = 58,
        OldTales = 59,
        CE005 = 60,
        CookingOil = 61,
        Incubator = 62,
        CE006_01 = 63,
        CE006_02 = 64,
        CE006_03 = 65,
        OverTheHorizon = 66,
        CE007 = 67
    }

    [MemoryPackable]
    public partial class NikkeCharacterData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("resource_id", Order = 3)]
        public int ResourceId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("additional_skins", Order = 4)]
        public string[] AdditionalSkins { get; set; } = [];

        [MemoryPackOrder(5)]
        [JsonProperty("name_code", Order = 5)]
        public int NameCode { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("order", Order = 6)]
        public int Order { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("original_rare", Order = 7)]
        [JsonConverter(typeof(StringEnumConverter))]
        public Rarity OriginalRare { get; set; } = Rarity.R;

        [MemoryPackOrder(8)]
        [JsonProperty("grade_core_id", Order = 8)]
        public int GradeCoreId { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("grow_grade", Order = 9)]
        public int GrowGrade { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("stat_enhance_id", Order = 10)]
        public int StatEnhanceId { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("corporation", Order = 32)]
        [JsonConverter(typeof(StringEnumConverter))]
        public Corporation Corporation { get; set; } = Corporation.None;

        [MemoryPackOrder(12)]
        [JsonProperty("corporation_sub_type", Order = 33, DefaultValueHandling = DefaultValueHandling.Ignore)]
        [JsonConverter(typeof(StringEnumConverter))]
        public CorporationSubType CorporationSubType { get; set; } = CorporationSubType.NORMAL;

        [MemoryPackOrder(13)]
        [JsonProperty("class", Order = 11)]
        [JsonConverter(typeof(StringEnumConverter))]
        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;
        
        [MemoryPackOrder(15)]
        [JsonProperty("element_id", Order = 12)]
        public int[] ElementId { get; set; } = [];

        [MemoryPackOrder(16)]
        [JsonProperty("critical_ratio", Order = 13)]
        public int CriticalRatio { get; set; }

        [MemoryPackOrder(17)]
        [JsonProperty("critical_damage", Order = 14)]
        public int CriticalDamage { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("shot_id", Order = 15)]
        public int ShotId { get; set; }

        [MemoryPackOrder(19)]
        [JsonProperty("bonusrange_min", Order = 16)]
        public int BonusRangeMin { get; set; }

        [MemoryPackOrder(20)]
        [JsonProperty("bonusrange_max", Order = 17)]
        public int BonusRangeMax { get; set; }

        [MemoryPackOrder(21)]
        [JsonProperty("use_burst_skill", Order = 18)]
        [JsonConverter(typeof(StringEnumConverter))]
        public BurstStep UseBurstSkill { get; set; } = BurstStep.None;

        [MemoryPackOrder(22)]
        [JsonProperty("change_burst_step", Order = 19)]
        [JsonConverter(typeof(StringEnumConverter))]
        public BurstStep ChangeBurstStep { get; set; } = BurstStep.None;

        [MemoryPackOrder(23)]
        [JsonProperty("burst_apply_delay", Order = 20)]
        public int BurstApplyDelay { get; set; }

        [MemoryPackOrder(24)]
        [JsonProperty("burst_duration", Order = 21)]
        public int BurstDuration { get; set; }

        [MemoryPackOrder(25)]
        [JsonProperty("ulti_skill_id", Order = 22)]
        public int UltiSkillId { get; set; }

        [MemoryPackOrder(26)]
        [JsonProperty("skill1_id", Order = 23)]
        public int Skill1Id { get; set; }

        [MemoryPackOrder(27)]
        [JsonProperty("skill1_table", Order = 24)]
        [JsonConverter(typeof(StringEnumConverter))]
        public SkillType Skill1Table { get; set; } = SkillType.None;

        [MemoryPackOrder(28)]
        [JsonProperty("skill2_id", Order = 25)]
        public int Skill2Id { get; set; }

        [MemoryPackOrder(29)]
        [JsonProperty("skill2_table", Order = 26)]
        [JsonConverter(typeof(StringEnumConverter))]
        public SkillType Skill2Table { get; set; } = SkillType.None;

        [MemoryPackOrder(30)]
        [JsonProperty("eff_category_type", Order = 27)]
        [JsonConverter(typeof(StringEnumConverter))]
        public EffCategoryType EffCategoryType { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(31)]
        [JsonProperty("eff_category_value", Order = 28)]
        public int EffCategoryValue { get; set; }

        [MemoryPackOrder(32)]
        [JsonProperty("category_type_1", Order = 29)]
        [JsonConverter(typeof(StringEnumConverter))]
        public EffCategoryType CategoryType1 { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(33)]
        [JsonProperty("category_type_2", Order = 30)]
        [JsonConverter(typeof(StringEnumConverter))]
        public EffCategoryType CategoryType2 { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(34)]
        [JsonProperty("category_type_3", Order = 31)]
        [JsonConverter(typeof(StringEnumConverter))]
        public EffCategoryType CategoryType3 { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(35)]
        [JsonProperty("cv_localkey", Order = 34)]
        public string CvLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(36)]
        [JsonProperty("squad", Order = 35)]
        [JsonConverter(typeof(StringEnumConverter))]
        public Squad Squad { get; set; } = Squad.None;

        [MemoryPackOrder(37)]
        [JsonProperty("piece_id", Order = 36)]
        public int PieceId { get; set; }

        [MemoryPackOrder(38)]
        [JsonProperty("is_visible", Order = 37)]
        public bool IsVisible { get; set; }

        [MemoryPackOrder(39)]
        [JsonProperty("prism_is_active", Order = 38)]
        public bool PrismIsActive { get; set; }

        [MemoryPackOrder(40)]
        [JsonProperty("is_detail_close", Order = 39)]
        public bool IsDetailClose { get; set; }
    }
}