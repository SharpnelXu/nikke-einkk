using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class HarmonyCubeSkillLevel
{
    [MemoryPackOrder(0)]
    [JsonProperty("skill_level", Order = 0)]
    public int Level { get; set; }
}
