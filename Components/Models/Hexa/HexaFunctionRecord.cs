using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaFunctionRecord
{

    [JsonProperty("id")]
    [MemoryPackOrder(0)]
    public int Id { get; set; }
    [JsonProperty("resource_id")]
    [MemoryPackOrder(1)]
    public string? Resource_id { get; set; }
    [JsonProperty("bios_type")]
    [MemoryPackOrder(2)]
    public HexaBiosFilterType Bios_type { get; set; }
    [JsonProperty("HexaFunctionPointData")]
    [MemoryPackOrder(3)]
    public List<HexaFunctionPointData> HexaFunctionPointData { get; set; } = [];
}
