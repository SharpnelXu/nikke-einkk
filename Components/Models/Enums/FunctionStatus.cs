using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum FunctionStatus
{
    None = 0,
    On = 2,
    Off = 3,
    Unknown = -1
}
