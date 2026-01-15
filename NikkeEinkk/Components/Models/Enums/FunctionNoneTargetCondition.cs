using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum FunctionNoneTargetCondition
{
    Unknown = -1,
    Normal = 0,
    NoAllMonster = 1,
    ExcludeSpawnAndCountCheck = 2
}
