using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBoardSlotRecord
{

    [JsonProperty("id")]
    [MemoryPackOrder(0)]
    public int Id { get; set; }
    [JsonProperty("slot_lock")]
    [MemoryPackOrder(1)]
    public bool Slot_lock { get; set; }
    [JsonProperty("lock_group")]
    [MemoryPackOrder(2)]
    public int Lock_group { get; set; }
    [JsonProperty("currency_id")]
    [MemoryPackOrder(3)]
    public int Currency_id { get; set; }
    [JsonProperty("currency_value")]
    [MemoryPackOrder(4)]
    public int Currency_value { get; set; }
    [JsonProperty("HexaBoardSlotNumberData")]
    [MemoryPackOrder(5)]
    public List<HexaBoardSlotNumberData> HexaBoardSlotNumberData { get; set; } = [];
}
