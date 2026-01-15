using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Nikke;

[MemoryPackable]
public partial class StateEffectData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("use_function_id_list", Order = 1)]
    public int[] UseFunctionIdList { get; set; } = [];

    [MemoryPackOrder(2)]
    [JsonProperty("hurt_function_id_list", Order = 2)]
    public int[] HurtFunctionIdList { get; set; } = [];

    [MemoryPackOrder(3)]
    [JsonProperty("functions", Order = 3)]
    public SkillFunction[] Functions { get; set; } = [];

    [MemoryPackOrder(4)]
    [JsonProperty("icon", Order = 4)]
    public string Icon { get; set; } = string.Empty;
}
