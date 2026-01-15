using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class HarmonyCubeLevelData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("level_enhance_id", Order = 1)]
    public int LevelEnhanceId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("level", Order = 2)]
    public int Level { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("skill_levels", Order = 3)]
    public HarmonyCubeSkillLevel[] SkillLevels { get; set; } = [];

    [MemoryPackOrder(4)]
    [JsonProperty("material_id", Order = 4)]
    public int MaterialId { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("material_value", Order = 5)]
    public int MaterialValue { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("gold_value", Order = 6)]
    public int GoldValue { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("slot", Order = 7)]
    public int Slot { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("harmonycube_stats", Order = 8)]
    public HarmonyCubeStat[] Stats { get; set; } = [];
}
