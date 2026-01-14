using MemoryPack;
using System.Text.Json.Serialization;

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
        [JsonStringEnumMemberName("777")]
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
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("resource_id")]
        public int ResourceId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("additional_skins")]
        public string[] AdditionalSkins { get; set; } = [];

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("name_code")]
        public int NameCode { get; set; }

        /// <summary>
        /// Order identifier
        /// </summary>
        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("order")]
        public int Order { get; set; }

        /// <summary>
        /// Raw original rarity string
        /// </summary>
        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("original_rare")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Rarity OriginalRare { get; set; } = Rarity.R;

        /// <summary>
        /// Grade core identifier (1-11), use LimitBreak for readable format
        /// </summary>
        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("grade_core_id")]
        public int GradeCoreId { get; set; }

        /// <summary>
        /// Grow grade identifier (0 means no next grade)
        /// </summary>
        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("grow_grade")]
        public int GrowGrade { get; set; }

        /// <summary>
        /// Stat enhancement identifier for CharacterStatEnhanceTable & CharacterStatTable
        /// </summary>
        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("stat_enhance_id")]
        public int StatEnhanceId { get; set; }

        /// <summary>
        /// Raw corporation string
        /// </summary>
        [MemoryPackOrder(11)]
        [JsonPropertyOrder(32)]
        [JsonPropertyName("corporation")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Corporation Corporation { get; set; } = Corporation.None;

        /// <summary>
        /// Raw corporation sub type string
        /// </summary>
        [MemoryPackOrder(12)]
        [JsonPropertyOrder(33)]
        [JsonPropertyName("corporation_sub_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public CorporationSubType CorporationSubType { get; set; } = CorporationSubType.NORMAL;

        /// <summary>
        /// Raw character class string
        /// </summary>
        [MemoryPackOrder(13)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("class")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;

        // removed 3rd anni update
        // [MemoryPackOrder(14)]
        // [JsonPropertyOrder(11)]
        // [JsonPropertyName("surface_category")]
        // [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        // public int SurfaceCategory { get; set; } = 400002;

        /// <summary>
        /// Element ID list
        /// </summary>
        [MemoryPackOrder(15)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("element_id")]
        public int[] ElementId { get; set; } = [];

        /// <summary>
        /// Critical hit ratio
        /// </summary>
        [MemoryPackOrder(16)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("critical_ratio")]
        public int CriticalRatio { get; set; }

        /// <summary>
        /// Critical damage value
        /// </summary>
        [MemoryPackOrder(17)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("critical_damage")]
        public int CriticalDamage { get; set; }

        /// <summary>
        /// Shot identifier for CharacterShotTable
        /// </summary>
        [MemoryPackOrder(18)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("shot_id")]
        public int ShotId { get; set; }

        /// <summary>
        /// Bonus range minimum value
        /// </summary>
        [MemoryPackOrder(19)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("bonusrange_min")]
        public int BonusRangeMin { get; set; }

        /// <summary>
        /// Bonus range maximum value
        /// </summary>
        [MemoryPackOrder(20)]
        [JsonPropertyOrder(17)]
        [JsonPropertyName("bonusrange_max")]
        public int BonusRangeMax { get; set; }

        /// <summary>
        /// Raw burst skill usage string
        /// </summary>
        [MemoryPackOrder(21)]
        [JsonPropertyOrder(18)]
        [JsonPropertyName("use_burst_skill")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public BurstStep UseBurstSkill { get; set; } = BurstStep.None;

        /// <summary>
        /// Raw change burst step string
        /// </summary>
        [MemoryPackOrder(22)]
        [JsonPropertyOrder(19)]
        [JsonPropertyName("change_burst_step")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public BurstStep ChangeBurstStep { get; set; } = BurstStep.None;

        /// <summary>
        /// Burst apply delay
        /// </summary>
        [MemoryPackOrder(23)]
        [JsonPropertyOrder(20)]
        [JsonPropertyName("burst_apply_delay")]
        public int BurstApplyDelay { get; set; }

        /// <summary>
        /// Burst duration (500, 1000, 1500)
        /// </summary>
        [MemoryPackOrder(24)]
        [JsonPropertyOrder(21)]
        [JsonPropertyName("burst_duration")]
        public int BurstDuration { get; set; }

        /// <summary>
        /// Ultimate skill identifier
        /// </summary>
        [MemoryPackOrder(25)]
        [JsonPropertyOrder(22)]
        [JsonPropertyName("ulti_skill_id")]
        public int UltiSkillId { get; set; }

        /// <summary>
        /// Skill 1 identifier
        /// </summary>
        [MemoryPackOrder(26)]
        [JsonPropertyOrder(23)]
        [JsonPropertyName("skill1_id")]
        public int Skill1Id { get; set; }

        /// <summary>
        /// Raw skill 1 table string
        /// </summary>
        [MemoryPackOrder(27)]
        [JsonPropertyOrder(24)]
        [JsonPropertyName("skill1_table")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SkillType Skill1Table { get; set; } = SkillType.None;

        /// <summary>
        /// Skill 2 identifier
        /// </summary>
        [MemoryPackOrder(28)]
        [JsonPropertyOrder(25)]
        [JsonPropertyName("skill2_id")]
        public int Skill2Id { get; set; }

        /// <summary>
        /// Raw skill 2 table string
        /// </summary>
        [MemoryPackOrder(29)]
        [JsonPropertyOrder(26)]
        [JsonPropertyName("skill2_table")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SkillType Skill2Table { get; set; } = SkillType.None;

        /// <summary>
        /// Effect category type
        /// </summary>
        [MemoryPackOrder(30)]
        [JsonPropertyOrder(27)]
        [JsonPropertyName("eff_category_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public EffCategoryType EffCategoryType { get; set; } = EffCategoryType.None;

        /// <summary>
        /// Effect category value
        /// </summary>
        [MemoryPackOrder(31)]
        [JsonPropertyOrder(28)]
        [JsonPropertyName("eff_category_value")]
        public int EffCategoryValue { get; set; }

        /// <summary>
        /// Category type 1
        /// </summary>
        [MemoryPackOrder(32)]
        [JsonPropertyOrder(29)]
        [JsonPropertyName("category_type_1")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public EffCategoryType CategoryType1 { get; set; } = EffCategoryType.None;

        /// <summary>
        /// Category type 2
        /// </summary>
        [MemoryPackOrder(33)]
        [JsonPropertyOrder(30)]
        [JsonPropertyName("category_type_2")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public EffCategoryType CategoryType2 { get; set; } = EffCategoryType.None;

        /// <summary>
        /// Category type 3
        /// </summary>
        [MemoryPackOrder(34)]
        [JsonPropertyOrder(31)]
        [JsonPropertyName("category_type_3")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public EffCategoryType CategoryType3 { get; set; } = EffCategoryType.None;

        /// <summary>
        /// CV localization key
        /// </summary>
        [MemoryPackOrder(35)]
        [JsonPropertyOrder(34)]
        [JsonPropertyName("cv_localkey")]
        public string CvLocalkey { get; set; } = string.Empty;

        /// <summary>
        /// Squad identifier
        /// </summary>
        [MemoryPackOrder(36)]
        [JsonPropertyOrder(35)]
        [JsonPropertyName("squad")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Squad Squad { get; set; } = Squad.None;

        /// <summary>
        /// Piece identifier for upgrade to next gradeCore (ItemPieceTable)
        /// </summary>
        [MemoryPackOrder(37)]
        [JsonPropertyOrder(36)]
        [JsonPropertyName("piece_id")]
        public int PieceId { get; set; }

        /// <summary>
        /// Whether character is visible
        /// </summary>
        [MemoryPackOrder(38)]
        [JsonPropertyOrder(37)]
        [JsonPropertyName("is_visible")]
        public bool IsVisible { get; set; }

        /// <summary>
        /// Whether prism is active
        /// </summary>
        [MemoryPackOrder(39)]
        [JsonPropertyOrder(38)]
        [JsonPropertyName("prism_is_active")]
        public bool PrismIsActive { get; set; }

        /// <summary>
        /// Whether detail is closed
        /// </summary>
        [MemoryPackOrder(40)]
        [JsonPropertyOrder(39)]
        [JsonPropertyName("is_detail_close")]
        public bool IsDetailClose { get; set; }
    }
}