using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class EquipmentOptionSlot
{
    [MemoryPackOrder(0)]
    [JsonProperty("option_slot", Order = 0)]
    public int OptionSlotValue { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("option_slot_success_ratio", Order = 1)]
    public int OptionSlotSuccessRatio { get; set; }
}
