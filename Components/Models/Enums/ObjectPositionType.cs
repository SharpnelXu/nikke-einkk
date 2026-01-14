using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ObjectPositionType
{
    Unknown = -1,
    None = 0,
    Local = 1,
    World = 2,
}
