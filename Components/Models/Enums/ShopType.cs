using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ShopType
{
    Unknown = -1,
    InAppShop = 0,
}
