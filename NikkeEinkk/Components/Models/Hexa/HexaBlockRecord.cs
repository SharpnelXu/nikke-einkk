using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBlockRecord
{
    [JsonProperty("id")]
    [MemoryPackOrder(0)]
    public int Id { get; set; }

    [JsonProperty("block_group")]
    [MemoryPackOrder(1)]
    public int Block_group { get; set; }

    [JsonProperty("name_localkey")]
    [MemoryPackOrder(2)]
    public string? Name_localkey { get; set; }

    [JsonProperty("description_localkey")]
    [MemoryPackOrder(3)]
    public string? Description_localkey { get; set; }

    [JsonProperty("block_type")]
    [MemoryPackOrder(4)]
    public HexaBlockDesignType Block_type { get; set; }

    [JsonProperty("block_rare")]
    [MemoryPackOrder(5)]
    public int Block_rare { get; set; }

    [JsonProperty("element")]
    [MemoryPackOrder(6)]
    public AttackType Element { get; set; }

    [JsonProperty("attak")]
    [MemoryPackOrder(7)]
    public int Attak { get; set; }

    [JsonProperty("hp")]
    [MemoryPackOrder(8)]
    public int Hp { get; set; }

    [JsonProperty("defence")]
    [MemoryPackOrder(9)]
    public int Defence { get; set; }

    [JsonProperty("function_group")]
    [MemoryPackOrder(10)]
    public int Function_group { get; set; }
}
