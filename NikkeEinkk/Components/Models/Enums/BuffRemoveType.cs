using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum BuffRemoveType
{
    Resist = 0,
    Clear = 1,
    Etc = 2,
    Unknown = -1
}
