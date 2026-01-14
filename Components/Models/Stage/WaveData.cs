using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Stage;

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
