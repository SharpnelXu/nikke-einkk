using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Shop;

[MemoryPackable]
public partial class MidasProductData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("product_type", Order = 1)]

    public MidasProductType ProductType { get; set; } = MidasProductType.CashShop;

    [MemoryPackOrder(2)]
    [JsonProperty("product_id", Order = 2)]
    public int ProductId { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("item_type", Order = 3)]

    public ProductItemType ItemType { get; set; } = ProductItemType.Currency;

    [MemoryPackOrder(4)]
    [JsonProperty("midas_product_id_proximabeta", Order = 4)]
    public string ProximaBetaProductId { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("midas_product_id_gamamobi", Order = 5)]
    public string GamamobiProductId { get; set; } = string.Empty;

    [MemoryPackOrder(6)]
    [JsonProperty("is_free", Order = 6)]
    public bool IsFree { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("cost", Order = 7)]
    public string Cost { get; set; } = "0";
}
