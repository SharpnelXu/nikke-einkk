using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum RaptureDestroyAnimTrigger
{
    Unknown = -1,
    None = 0,
    Destruction_01 = 1,
    Destruction_02 = 2,
    Destruction_03 = 3,
    Destruction_04 = 4
}
