using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum UnionRaidDifficultyType
{
    Unknown = -1,
    Normal = 1,
    Hard = 2
}
