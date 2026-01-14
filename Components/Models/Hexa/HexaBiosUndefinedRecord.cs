using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Hexa;

[MemoryPackable(SerializeLayout.Explicit)]
public partial class HexaBiosUndefinedRecord 
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
    [JsonProperty("resource_id")]
    [MemoryPackOrder(3)]
    public string? Resource_id { get; set; }
    [JsonProperty("bios_rare")]
    [MemoryPackOrder(4)]
    public int Bios_rare { get; set; }
    [JsonProperty("bios_group")]
    [MemoryPackOrder(5)]
    public int Bios_group { get; set; }
}
