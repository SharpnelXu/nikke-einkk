using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum SocketPoint
{
    Unknown = -1,
    None = 0,
    Top = 1,
    Center = 2,
    Head = 6,
    Cover = 4,
    Bottom = 3,
    World = 7,
    Core = 5
}
