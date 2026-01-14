using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ShopCategory
{
    Unknown = -1,
    JewelShop = 0,
    PackageShop = 1,
    TimeLimitPackageShop = 2,
    RenewPackageShop = 3,
    PopupPackageShop = 4,
    CostumeShop = 5,
    MonthlyAmountShop = 6,
    CampaignPackageShop = 7,
    StepUpPackageShop = 8,
    CustomPackageShop = 10,
    PassCostumeShop = 11
}
