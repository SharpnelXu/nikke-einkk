using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Shop;

[MemoryPackable]
public partial class PackageListData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("package_shop_id", Order = 1)]
    public int PackageShopId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("package_order", Order = 2)]
    public int PackageOrder { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("product_id", Order = 3)]
    public int ProductId { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("name_localkey", Order = 4)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("description_localkey", Order = 5)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(6)]
    [JsonProperty("product_resource_id", Order = 6)]
    public string ProductResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(7)]
    [JsonProperty("buy_limit_type", Order = 7)]
    public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.Account;

    [MemoryPackOrder(8)]
    [JsonProperty("is_limit", Order = 8)]
    public bool IsLimited { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("buy_limit_count", Order = 9)]
    public int BuyLimitCount { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("is_active", Order = 10)]
    public bool IsActive { get; set; }
}
