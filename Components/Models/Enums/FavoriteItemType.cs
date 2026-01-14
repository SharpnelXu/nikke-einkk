using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum FavoriteItemType
{
    Unknown = -1,
    None = 0,
    Collection = 1,
    Favorite = 2
}
