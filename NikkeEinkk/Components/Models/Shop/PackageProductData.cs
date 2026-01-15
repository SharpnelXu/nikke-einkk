using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Shop;

[MemoryPackable]
public partial class PackageProductData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("package_group_id", Order = 1)]
    public int PackageGroupId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("product_type", Order = 2)]

    public ProductType ProductType { get; set; } = ProductType.Item;

    [MemoryPackOrder(3)]
    [JsonProperty("product_id", Order = 3)]
    public int ProductId { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("product_value", Order = 4)]
    public int ProductValue { get; set; }
}
