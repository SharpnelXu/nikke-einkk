using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class CurrencyData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("name_localkey", Order = 1)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(2)]
    [JsonProperty("description_localkey", Order = 2)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(3)]
    [JsonProperty("resource_id", Order = 3)]
    public int ResourceId { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("is_visible_to_inventory", Order = 4)]
    public bool IsVisibleInInventory { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("max_value", Order = 5)]
    public long MaxValue { get; set; }
}
