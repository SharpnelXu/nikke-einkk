using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ItemType
{
    Unknown = -1,
    None = 0,
    Equip = 1,
    Consume = 2,
    Material = 3,
    Piece = 4,
    HarmonyCube = 5
}
