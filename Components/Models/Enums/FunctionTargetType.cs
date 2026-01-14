using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum FunctionTargetType
{
    Unknown = -1,
    None = 0,
    Self = 1,
    AllCharacter = 2,
    AllMonster = 3,
    Target = 4,
    UserCover = 5,
    TargetCover = 6,
    AllCharacterCover = 7
}
