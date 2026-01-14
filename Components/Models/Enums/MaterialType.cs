using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum MaterialType
{
    Unknown = -1,
    None = 0,
    All = 1,
    Corporation = 2,
    Character = 3,
    Squad = 4,
    FavoriteItem = 5
}
