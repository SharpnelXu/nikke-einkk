using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum DataValueType
{
    None = 0,
    Integer = 1,
    Percent = 2,
    Unknown = -1
}
