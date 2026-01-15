using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum PercentDisplayType
{
    None = 0,
    Percent = 1,
    Random = 2,
    Unknown = -1
}
