using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class CollectionItemSkillLevel
{
    [MemoryPackOrder(0)]
    [JsonProperty("collection_skill_level", Order = 0)]
    public int Level { get; set; }
}
