using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Nikke;

[MemoryPackable]
public partial class SkillValueData
{
    [MemoryPackOrder(0)]
    [JsonProperty("skill_value_type", Order = 0)]
    public DataValueType SkillValueType { get; set; } = DataValueType.Unknown;

    [MemoryPackOrder(1)]
    [JsonProperty("skill_value", Order = 1)]
    public long SkillValue { get; set; }
}
