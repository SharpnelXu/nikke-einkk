using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Stage;

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
