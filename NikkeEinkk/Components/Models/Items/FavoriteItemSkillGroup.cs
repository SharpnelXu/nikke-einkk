using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class FavoriteItemSkillGroup
{
    [MemoryPackOrder(0)]
    [JsonProperty("favorite_skill_id", Order = 0)]
    public int SkillId { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("skill_table", Order = 1)]

    public SkillTableType SkillTableType { get; set; } = SkillTableType.None;

    [MemoryPackOrder(2)]
    [JsonProperty("skill_change_slot", Order = 2)]
    public int SkillChangeSlot { get; set; }
}
