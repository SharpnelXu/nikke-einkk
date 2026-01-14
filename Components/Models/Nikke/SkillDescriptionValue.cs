using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Nikke;

[MemoryPackable]
public partial class SkillDescriptionValue
{
    [MemoryPackOrder(0)]
    [JsonProperty("description_value", Order = 0)]
    public string? Value { get; set; } = string.Empty;
}
