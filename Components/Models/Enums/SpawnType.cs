using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum SpawnType
{
    Unknown = -1,
    None = 0,
    Normal = 1,
    Dash = 2,
    Jump = 3,
    Drop = 4,
    Random = 5,
    Teleport = 6,
    Animation = 7
}
