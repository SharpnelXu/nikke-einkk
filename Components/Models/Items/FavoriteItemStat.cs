using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class FavoriteItemStat
{
    [MemoryPackOrder(0)]
    [JsonProperty("stat_type", Order = 0)]

    public StatType StatType { get; set; } = StatType.None;

    [MemoryPackOrder(1)]
    [JsonProperty("stat_value", Order = 1)]
    public int Value { get; set; }
}
