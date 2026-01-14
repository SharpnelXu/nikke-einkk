using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Shop;

[MemoryPackable]
public partial class InAppShopData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("main_category_type", Order = 1)]

    public MainCategoryType MainCategoryType { get; set; } = MainCategoryType.Unknown;

    [MemoryPackOrder(2)]
    [JsonProperty("order_group_id", Order = 2)]
    public int OrderGroupId { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("name_localkey", Order = 3)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(4)]
    [JsonProperty("description_localkey", Order = 4)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("main_category_icon_name", Order = 5)]
    public string IconName { get; set; } = string.Empty;

    [MemoryPackOrder(6)]
    [JsonProperty("sub_category_id", Order = 6)]
    public int SubCategoryId { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("sub_category_name_localkey", Order = 7)]
    public string? SubCategoryNameKey { get; set; } = string.Empty;

    [MemoryPackOrder(8)]
    [JsonProperty("package_shop_id", Order = 8)]
    public int PackageShopId { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("is_hide_if_not_valid", Order = 9)]
    public bool HideIfNotValid { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("renew_type", Order = 10)]

    public RenewType RenewType { get; set; } = RenewType.NoRenew;

    [MemoryPackOrder(11)]
    [JsonProperty("start_date", Order = 11)]
    public DateTime StartDate { get; set; } = new DateTime(2000, 1, 1, 0, 0, 0, DateTimeKind.Utc);

    [MemoryPackOrder(12)]
    [JsonProperty("end_date", Order = 12)]
    public DateTime EndDate { get; set; } = new DateTime(2099, 12, 31, 0, 0, 0, DateTimeKind.Utc);

    [MemoryPackOrder(13)]
    [JsonProperty("date_ui_control", Order = 13)]
    public bool DateUiControl { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("shop_type", Order = 14)]

    public ShopType ShopType { get; set; } = ShopType.InAppShop;

    [MemoryPackOrder(15)]
    [JsonProperty("shop_category", Order = 15)]

    public ShopCategory ShopCategory { get; set; } = ShopCategory.Unknown;

    [MemoryPackOrder(16)]
    [JsonProperty("shop_prefab_name", Order = 16)]
    public string ShopPrefabName { get; set; } = string.Empty;
}
