using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum UseConditionType
{
    Unknown = -1,
    None = 0,
    MissionClear = 1,
    StageClear = 2,
    Time = 3
}
