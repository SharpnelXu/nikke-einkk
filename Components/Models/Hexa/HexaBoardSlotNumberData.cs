using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBoardSlotNumberData 
{

    [JsonProperty("slot_no")]
    [MemoryPackOrder(0)]
    public int Slot_no { get; set; }
}
