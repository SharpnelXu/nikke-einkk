using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum CancelType
{
    Unknown = -1,
    None = 0,
    BreakCol = 1,
    BrokenParts = 2,
    BrokenParts_OnlyCasting = 3,
    BrokenParts_HurtCount = 4,
    BrokenParts_UntilEnd = 5,
    BreakCol_SkipCasting = 6
}
