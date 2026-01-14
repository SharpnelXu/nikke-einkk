using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class HarmonyCubeSkillGroup
{
    [MemoryPackOrder(0)]
    [JsonProperty("skill_group_id", Order = 0)]
    public int SkillGroupId { get; set; }
}
