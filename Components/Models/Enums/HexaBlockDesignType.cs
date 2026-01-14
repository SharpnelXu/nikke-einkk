using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum HexaBlockDesignType
{
    Unknown = -1,
    None = 0,
    Type_C = 1,
    Type_I = 2,
    Type_A = 3
}
