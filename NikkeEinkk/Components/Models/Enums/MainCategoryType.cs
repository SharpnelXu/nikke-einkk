using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum MainCategoryType
{
    Unknown = -1,
    PopupPackageTab = 0,
    TimeLimitPackageTab = 1,
    RenewPackageTab = 2,
    CostumeTab = 3,
    CampaignPackageTab = 4,
    MonthlyAmountTab = 5,
    JewelTab = 6,
    PassCostumeTab = 7
}
