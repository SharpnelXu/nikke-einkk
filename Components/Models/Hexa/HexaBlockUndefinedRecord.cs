using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBlockUndefinedRecord
{
    [JsonProperty("id")]
    [MemoryPackOrder(0)]
    public int Id { get; set; }

    [JsonProperty("name_localkey")]
    [MemoryPackOrder(1)]
    public string? Name_localkey { get; set; }

    [JsonProperty("description_localkey")]
    [MemoryPackOrder(2)]
    public string? Description_localkey { get; set; }

    [JsonProperty("block_type")]
    [MemoryPackOrder(3)]
    public HexaBlockDesignType Block_type { get; set; }

    [JsonProperty("block_rare")]
    [MemoryPackOrder(4)]
    public int Block_rare { get; set; }

    [JsonProperty("block_group")]
    [MemoryPackOrder(5)]
    public int Block_group { get; set; }
}
