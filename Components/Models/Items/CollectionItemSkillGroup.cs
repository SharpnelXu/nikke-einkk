using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class CollectionItemSkillGroup
{
    [MemoryPackOrder(0)]
    [JsonProperty("collection_skill_id", Order = 0)]
    public int SkillGroupId { get; set; }
}
