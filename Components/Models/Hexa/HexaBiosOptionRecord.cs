using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBiosOptionRecord
{
    [JsonProperty("id")]
    [MemoryPackOrder(0)]
    public int Id { get; set; }

    [JsonProperty("order")]
    [MemoryPackOrder(1)]
    public int Order { get; set; }

    [JsonProperty("option_rare")]
    [MemoryPackOrder(2)]
    public int Option_rare { get; set; }

    [JsonProperty("state_effect_localkey")]
    [MemoryPackOrder(3)]
    public string? State_effect_localkey { get; set; }

    [JsonProperty("function_id")]
    [MemoryPackOrder(4)]
    public int Function_id { get; set; }

    [JsonProperty("HexaBiosOptionRandomData")]
    [MemoryPackOrder(5)]
    public List<HexaBiosOptionStateEffectStepData> HexaBiosOptionRandomData { get; set; } = [];
}
