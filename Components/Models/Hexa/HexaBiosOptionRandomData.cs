using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBiosOptionRandomData
{

    [JsonProperty("option_id")]
    [MemoryPackOrder(0)]
    public int Option_id { get; set; }

    [JsonProperty("ratio")]
    [MemoryPackOrder(1)]
    public int Ratio { get; set; }
}
