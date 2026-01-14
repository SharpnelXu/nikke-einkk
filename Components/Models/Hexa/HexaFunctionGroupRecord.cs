using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaFunctionGroupRecord
{

    [JsonProperty("id")]
    [MemoryPackOrder(0)]
    public int Id { get; set; }
    [JsonProperty("function_group")]
    [MemoryPackOrder(1)]
    public int Function_group { get; set; }
    [JsonProperty("ratio")]
    [MemoryPackOrder(2)]
    public int Ratio { get; set; }
    [JsonProperty("slot_1_function")]
    [MemoryPackOrder(3)]
    public int Slot_1_function { get; set; }
    [JsonProperty("slot_2_function")]
    [MemoryPackOrder(4)]
    public int Slot_2_function { get; set; }
    [JsonProperty("slot_3_function")]
    [MemoryPackOrder(5)]
    public int Slot_3_function { get; set; }
    [JsonProperty("order")]
    [MemoryPackOrder(6)]
    public int Order { get; set; }
}
