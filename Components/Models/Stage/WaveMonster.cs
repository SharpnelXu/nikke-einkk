using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Stage;

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
