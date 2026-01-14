using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class WaveMonster
    {
        [MemoryPackOrder(0)]
        [JsonProperty("wave_monster_id", Order = 0)]
        public long MonsterId { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("spawn_type", Order = 1)]
        public SpawnType SpawnType { get; set; }
    }

    [MemoryPackable]
    public partial class WavePathData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("wave_path", Order = 0)]
        public string? Path { get; set; } = string.Empty;

        [MemoryPackOrder(1)]
        [JsonProperty("private_monster_count", Order = 1)]
        public int PrivateMonsterCount { get; set; } = -1;

        [MemoryPackOrder(2)]
        [JsonProperty("wave_monster_list", Order = 2)]
        public WaveMonster[] MonsterList { get; set; } = [];
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum SpotMod
    {
        Unknown = -1,
        None = 0,
        Campaign = 1,
        Arena = 2,
        Survive = 3,
        Defense = 4,
        Destroy = 5,
        Escape = 6,
        Intercept = 7,
        UnionRaid = 8,
        ShootingRange = 9,
        BaseDefense = 10,
        Cooperation = 11,
        Campaign_SD = 12,
        Defense_SD = 13,
        BaseDefense_SD = 14,
        ShootingRange_SD = 15,
        SoloRaid_Common = 16,
        SoloRaid_Trial = 17,
        Campaign_CE002 = 18,
        Cooperation_CE002 = 19,
        UnionRaid_Trial = 20,
        Cabal_MecaShifty = 21,
        Cabal_Shifty = 22,
        Cabal_Syuen = 23,
        SoloRaid_Museum = 24,
        SoloRaid_Museum_Nolimit = 25
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum UiTheme
    {
        Unknown = -1,
        None = 0,
        CE002 = 1,
        CE004 = 2,
        CE006 = 3,
        CE007 = 4
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum Theme
    {
        Unknown = -1,
        None = 0,
        CityForest = 1,
        CityForestUnder = 2,
        CityForestmbg002 = 3,
        Desert = 4,
        Desertmbg001 = 5,
        GreatHole = 6,
        IceLand = 7,
        Wasteland = 8,
        ArcCity = 9,
        ArcOut = 10,
        ArcLAB = 11,
        Tower = 12,
        MissilesTower = 13,
        ElysionTower = 14,
        TetraTower = 15,
        PilgrimTower = 16,
        VillageCity = 17,
        VillageOut = 18,
        Gravedigger = 19,
        Stormbringer = 20,
        Lostsector = 21,
        NormalArena = 22,
        SpecialArena = 23,
        ChampionArena = 24,
        Volcano = 25,
        ArkCityDay = 26,
        Ocean = 27,
        Oceanbbg004 = 28,
        Simulation = 29,
        RedOcean = 30,
        RedOceanFarSea = 31,
        SwamplandJungle = 32,
        Surface = 33,
        MotherwhaleField = 34,
        WhiteArkcity = 35
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ThemeTime
    {
        Unknown = -1,
        Day = 1,
        Twilight = 2,
        Night = 3,
        Smog = 4,
        Elysion = 5,
        Missilis = 6,
        Tetra = 7,
        Pilgrim = 8
    }

    [MemoryPackable]
    public partial class WaveData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("stage_id", Order = 0)]
        public int StageId { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group_id", Order = 1)]
        public string GroupId { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("spot_mod", Order = 2)]
        public SpotMod SpotMod { get; set; } = SpotMod.None;

        [MemoryPackOrder(2)]
        [JsonProperty("ui_theme", Order = 2)]
        public UiTheme UiTheme { get; set; } = UiTheme.None;

        [MemoryPackOrder(3)]
        [JsonProperty("battle_time", Order = 3)]
        public int BattleTime { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("mod_value", Order = 3)]
        public string ModValue { get; set; } = "0";

        [MemoryPackOrder(4)]
        [JsonProperty("monster_count", Order = 4)]
        public int MonsterCount { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("use_intro_scene", Order = 5)]
        public bool UseIntroScene { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("wave_repeat", Order = 6)]
        public bool WaveRepeat { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("point_data", Order = 7)]
        public string PointData { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonProperty("point_data_fly", Order = 8)]
        public string PointDataFly { get; set; } = string.Empty;

        [MemoryPackOrder(9)]
        [JsonProperty("background_name", Order = 9)]
        public string BackgroundName { get; set; } = string.Empty;

        [MemoryPackOrder(10)]
        [JsonProperty("theme", Order = 10)]
        public Theme Theme { get; set; } = Theme.None;

        [MemoryPackOrder(11)]
        [JsonProperty("theme_time", Order = 11)]
        public ThemeTime ThemeTime { get; set; } = ThemeTime.Day;

        [MemoryPackOrder(12)]
        [JsonProperty("stage_info_bg", Order = 12)]
        public string StageInfoBg { get; set; } = string.Empty;

        [MemoryPackOrder(13)]
        [JsonProperty("target_list", Order = 13)]
        public long[] TargetList { get; set; } = [];

        [MemoryPackOrder(14)]
        [JsonProperty("wave_data", Order = 14)]
        public WavePathData[] WavePathData { get; set; } = [];

        [MemoryPackOrder(15)]
        [JsonProperty("close_monster_count", Order = 15)]
        public int CloseMonsterCount { get; set; }

        [MemoryPackOrder(16)]
        [JsonProperty("mid_monster_count", Order = 16)]
        public int MidMonsterCount { get; set; }

        [MemoryPackOrder(17)]
        [JsonProperty("far_monster_count", Order = 17)]
        public int FarMonsterCount { get; set; }
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum QuickBattleType
    {
        Unknown = -1,
        None = 0,
        StageClear = 1,
        StandardBattlePower = 2
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum SoloRaidDifficultyType
    {
        Unknown = -1,
        None = 0,
        Common = 1,
        Trial = 2
    }

    [MemoryPackable]
    public partial class SoloRaidWaveData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("preset_group_id", Order = 1)]
        public int PresetGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("difficulty_type", Order = 2)]
        public SoloRaidDifficultyType DifficultyType { get; set; } = SoloRaidDifficultyType.Common;

        [MemoryPackOrder(3)]
        [JsonProperty("quick_battle_type", Order = 3)]
        public QuickBattleType QuickBattleType { get; set; } = QuickBattleType.None;

        [MemoryPackOrder(4)]
        [JsonProperty("character_lv", Order = 4)]
        public int CharacterLevel { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("wave_open_condition", Order = 5)]
        public int WaveOpenCondition { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("wave_order", Order = 6)]
        public int WaveOrder { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("wave", Order = 7)]
        public int Wave { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("monster_stage_lv", Order = 8)]
        public int MonsterStageLevel { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("monster_stage_lv_change_group", Order = 9)]
        public int MonsterStageLevelChangeGroup { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("dynamic_object_stage_lv", Order = 10)]
        public int DynamicObjectStageLevel { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("cover_stage_lv", Order = 11)]
        public int CoverStageLevel { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("spot_autocontrol", Order = 12)]
        public bool SpotAutocontrol { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("wave_name", Order = 13)]
        public string WaveName { get; set; } = string.Empty;

        [MemoryPackOrder(14)]
        [JsonProperty("wave_description", Order = 14)]
        public string WaveDescription { get; set; } = string.Empty;

        [MemoryPackOrder(15)]
        [JsonProperty("monster_image_si", Order = 15)]
        public string MonsterImageSi { get; set; } = string.Empty;

        [MemoryPackOrder(16)]
        [JsonProperty("monster_image", Order = 16)]
        public string MonsterImage { get; set; } = string.Empty;

        [MemoryPackOrder(17)]
        [JsonProperty("first_clear_reward_id", Order = 17)]
        public int FirstClearRewardId { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("reward_id", Order = 18)]
        public int RewardId { get; set; }
    }

    [MemoryPackable]
    public partial class MultiplayerRaidData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name", Order = 1)]
        public string Name { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("player_count", Order = 2)]
        public int PlayerCount { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("character_select_time_limit", Order = 3)]
        public int CharacterSelectTimeLimit { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("character_lv", Order = 4)]
        public int CharacterLevel { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("stage_level", Order = 5)]
        public int StageLevel { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("monster_stage_lv", Order = 6)]
        public int MonsterStageLevel { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("dynamic_object_stage_lv", Order = 7)]
        public int DynamicObjectStageLevel { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("cover_stage_lv", Order = 8)]
        public int CoverStageLevel { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("monster_stage_lv_change_group", Order = 9)]
        public int MonsterStageLevelChangeGroup { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("spot_id", Order = 10)]
        public int SpotId { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("monster_stage_lv_change_group_easy", Order = 11)]
        public int MonsterStageLvChangeGroupEasy { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("spot_id_easy", Order = 12)]
        public int SpotIdEasy { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("condition_reward_group", Order = 13)]
        public int ConditionRewardGroup { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("reward_limit_count", Order = 14)]
        public int RewardLimitCount { get; set; }

        [MemoryPackOrder(15)]
        [JsonProperty("rank_condition_reward_group", Order = 15)]
        public int RankConditionRewardGroup { get; set; }
    }
}