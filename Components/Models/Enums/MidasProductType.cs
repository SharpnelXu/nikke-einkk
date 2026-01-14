using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum MidasProductType
{
    Unknown = -1,
    None = 0,
    CashShop = 1,
    PackageShop = 2,
    PopupPackageShop = 3,
    PassShop = 4,
    MonthlyAmount = 5,
    CampaignPackageShop = 6,
    EventPassShop = 7,
    CostumeShop = 8,
    CharacterCostume = 9,
    StepUpPackageShop = 10,
    EventInAppShop = 11,
    CustomPackageShop = 12,
    PassCostumeShop = 13
}
