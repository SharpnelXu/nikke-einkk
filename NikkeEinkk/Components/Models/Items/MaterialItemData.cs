using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class MaterialItemData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("name_localkey", Order = 1)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(2)]
    [JsonProperty("description_localkey", Order = 2)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(3)]
    [JsonProperty("resource_id", Order = 3)]
    public string ResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(4)]
    [JsonProperty("item_type", Order = 4)]

    public ItemType ItemType { get; set; } = ItemType.Unknown;

    [MemoryPackOrder(5)]
    [JsonProperty("item_sub_type", Order = 5)]

    public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

    [MemoryPackOrder(6)]
    [JsonProperty("item_rare", Order = 6)]

    public Rarity ItemRarity { get; set; } = Rarity.R;

    [MemoryPackOrder(7)]
    [JsonProperty("item_value", Order = 7)]
    public int ItemValue { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("material_type", Order = 8)]

    public MaterialType MaterialType { get; set; } = MaterialType.Unknown;

    [MemoryPackOrder(9)]
    [JsonProperty("material_value", Order = 9)]
    public int MaterialValue { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("stack_max", Order = 10)]
    public int StackMax { get; set; }
}
