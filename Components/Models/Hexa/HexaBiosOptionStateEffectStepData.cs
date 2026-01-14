using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBiosOptionStateEffectStepData
{

    [JsonProperty("need_point")]
    [MemoryPackOrder(0)]
    public int Need_point { get; set; }

    [JsonProperty("state_effect_id")]
    [MemoryPackOrder(1)]
    public int State_effect_id { get; set; }
}
