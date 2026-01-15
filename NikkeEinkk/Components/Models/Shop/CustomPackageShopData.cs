using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Shop;

[MemoryPackable]
public partial class CustomPackageShopData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("custom_shop_id", Order = 1)]
    public int CustomShopId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("custom_order", Order = 2)]
    public int CustomOrder { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("package_group_id", Order = 3)]
    public int PackageGroupId { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("custom_group_id", Order = 4)]
    public int CustomGroupId { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("custom_group_count", Order = 5)]
    public int CustomGroupCount { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("name_localkey", Order = 6)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(7)]
    [JsonProperty("description_localkey", Order = 7)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(8)]
    [JsonProperty("product_resource_id", Order = 8)]
    public string ProductResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(9)]
    [JsonProperty("buy_limit_type", Order = 9)]

    public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.None;

    [MemoryPackOrder(10)]
    [JsonProperty("is_limit", Order = 10)]
    public bool IsLimited { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("buy_limit_count", Order = 11)]
    public int BuyLimitCount { get; set; }

    [MemoryPackOrder(12)]
    [JsonProperty("is_free", Order = 12)]
    public bool IsFree { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("midas_product_id", Order = 13)]
    public int MidasProductId { get; set; }
}
