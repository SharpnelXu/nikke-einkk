using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ThemeTime
{
    Unknown = -1,
    Day = 1,
    Twilight = 2,
    Night = 3,
    Smog = 4,
    Elysion = 5,
    Missilis = 6,
    Tetra = 7,
    Pilgrim = 8
}
