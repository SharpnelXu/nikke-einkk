using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Rapture;

[MemoryPackable]
public partial class RaptureSkillInfoData
{
    [MemoryPackOrder(0)]
    [JsonProperty("skill_id", Order = 0)]
    public int SkillId { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("use_function_id_skill", Order = 1)]
    public int[] UseFunctionIds { get; set; } = [];

    [MemoryPackOrder(2)]
    [JsonProperty("hurt_function_id_skill", Order = 2)]
    public int[] HurtFunctionIds { get; set; } = [];
}
