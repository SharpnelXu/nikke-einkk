using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum FxTarget
{
    Unknown = -1,
    None = 0,
    User = 1,
    Target = 2,
    TargetMonsterDead = 3,
}
