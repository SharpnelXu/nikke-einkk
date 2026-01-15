using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum RaptureStageLevelChangeCondition
{
    Unknown = -1,
    None = 0,
    DamageDoneToTargetMonster = 1,
}
