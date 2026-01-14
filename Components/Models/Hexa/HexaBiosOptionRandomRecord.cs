using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBiosOptionRandomRecord
{

    [JsonProperty("id")]
    [MemoryPackOrder(0)]
    public int Id { get; set; }

    [JsonProperty("option_group")]
    [MemoryPackOrder(1)]
    public int Option_group { get; set; }

    [JsonProperty("HexaBiosOptionRandomData")]
    [MemoryPackOrder(2)]
    public List<Hexa.HexaBiosOptionRandomData> HexaBiosOptionRandomData { get; set; } = [];
}
