using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ProductItemType
{
    Unknown = -1,
    Currency = 0,
    Item = 1
}
