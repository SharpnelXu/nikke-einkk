using MemoryPack;
using Newtonsoft.Json;
using ValueType = NikkeEinkk.Components.Models.Enums.ValueType;

namespace NikkeEinkk.Components.Models.Nikke;

[MemoryPackable]
public partial class SkillValueData
{
    [MemoryPackOrder(0)]
    [JsonProperty("skill_value_type", Order = 0)]
    public ValueType SkillValueType { get; set; } = ValueType.Unknown;

    [MemoryPackOrder(1)]
    [JsonProperty("skill_value", Order = 1)]
    public long SkillValue { get; set; }
}
