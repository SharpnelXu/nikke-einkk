using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum QuickBattleType
{
    Unknown = -1,
    None = 0,
    StageClear = 1,
    StandardBattlePower = 2
}
