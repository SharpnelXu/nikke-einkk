using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Nikke;

[MemoryPackable]
public partial class SkillFunction
{
    [MemoryPackOrder(0)]
    [JsonProperty("function", Order = 0)]
    public int Function { get; set; }
}
