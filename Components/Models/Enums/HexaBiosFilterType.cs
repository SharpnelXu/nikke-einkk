using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum HexaBiosFilterType
{
    Unknown = -1,
    None = 0,
    MAIN = 1,
    SUB_01 = 2,
    SUB_02 = 3
}
