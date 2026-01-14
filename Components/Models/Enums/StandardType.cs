using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum StandardType
{
    Unknown = -1,
    None = 0,
    User = 1,
    FunctionTarget = 2,
    TriggerTarget = 3
}
