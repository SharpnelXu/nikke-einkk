using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum BuyLimitType
{
    Unknown = -1,
    None = 0,
    Account = 1,
    Daily = 2,
    Weekly = 3,
    Monthly = 4,
    Renew = 5
}
