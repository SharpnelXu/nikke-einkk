using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ShotFx
{
    Unknown = -1,
    None = 0,
    Gear1 = 1,
    Gear2 = 2,
    Gear3 = 3,
}
