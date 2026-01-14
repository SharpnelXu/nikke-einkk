using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaFunctionPointData
{

    [JsonProperty("point_rare")]
    [MemoryPackOrder(0)]
    public int Point_rare { get; set; }
}
