using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum RenewType
{
    Unknown = -1,
    None = 0,
    AutoDay = 1,
    AutoWeek = 2,
    AutoMonth = 3,
    EachUser = 4,
    ManualRenew = 5,
    NoRenew = 6
}
