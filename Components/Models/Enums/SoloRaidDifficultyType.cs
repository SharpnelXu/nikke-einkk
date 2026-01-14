using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum SoloRaidDifficultyType
{
    Unknown = -1,
    None = 0,
    Common = 1,
    Trial = 2
}
