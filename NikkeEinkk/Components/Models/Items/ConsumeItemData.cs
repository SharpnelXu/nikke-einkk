using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class ConsumeItemData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("use_condition_type", Order = 1)]

    public UseConditionType UseConditionType { get; set; } = UseConditionType.Unknown;

    [MemoryPackOrder(2)]
    [JsonProperty("use_condition_value", Order = 2)]
    public int UseConditionValue { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("name_localkey", Order = 3)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(4)]
    [JsonProperty("description_localkey", Order = 4)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("resource_id", Order = 5)]
    public string ResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(6)]
    [JsonProperty("item_type", Order = 6)]

    public ItemType ItemType { get; set; } = ItemType.Unknown;

    [MemoryPackOrder(7)]
    [JsonProperty("item_sub_type", Order = 7)]

    public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

    [MemoryPackOrder(8)]
    [JsonProperty("item_rare", Order = 8)]

    public Rarity ItemRarity { get; set; } = Rarity.R;

    [MemoryPackOrder(9)]
    [JsonProperty("use_type", Order = 9)]

    public UseType UseType { get; set; } = UseType.Unknown;

    [MemoryPackOrder(10)]
    [JsonProperty("use_id", Order = 10)]
    public int UseId { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("percent_display_type", Order = 11)]

    public PercentDisplayType PercentDisplayType { get; set; } = PercentDisplayType.None;

    [MemoryPackOrder(12)]
    [JsonProperty("use_value", Order = 12)]
    public int UseValue { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("use_frag_cost", Order = 13)]
    public int UseFragCost { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("use_limit_count", Order = 14)]
    public bool UseLimitCount { get; set; }

    [MemoryPackOrder(15)]
    [JsonProperty("use_limit_count_value", Order = 15, DefaultValueHandling = DefaultValueHandling.Ignore)]
    public int UseLimitCountValue { get; set; } = 0;

    [MemoryPackOrder(16)]
    [JsonProperty("stack_max", Order = 16)]
    public int StackMax { get; set; }
}
