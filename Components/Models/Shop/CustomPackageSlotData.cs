using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Shop;

[MemoryPackable]
public partial class CustomPackageSlotData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("custom_group_id", Order = 1)]
    public int CustomGroupId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("slot_number", Order = 2)]
    public int SlotNumber { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("product_type", Order = 3)]

    public ProductType ProductType { get; set; } = ProductType.Unknown;

    [MemoryPackOrder(4)]
    [JsonProperty("product_id", Order = 4)]
    public int ProductId { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("product_value", Order = 5)]
    public int ProductValue { get; set; }
}
