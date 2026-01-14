using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum NoneTargetCondition
{
    Unknown = -1,
    Normal = 0,
    Last = 1,
    None = 2
}
