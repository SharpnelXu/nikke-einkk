using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class HarmonyCubeData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("name_localkey", Order = 1)]
    public string NameLocalkey { get; set; } = string.Empty;

    [MemoryPackOrder(2)]
    [JsonProperty("description_localkey", Order = 2)]
    public string DescriptionLocalkey { get; set; } = string.Empty;

    [MemoryPackOrder(3)]
    [JsonProperty("location_id", Order = 3)]
    public int LocationId { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("location_localkey", Order = 4)]
    public string LocationLocalkey { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("order", Order = 5)]
    public int Order { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("resource_id", Order = 6)]
    public int ResourceId { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("bg", Order = 7)]
    public string Bg { get; set; } = string.Empty;

    [MemoryPackOrder(8)]
    [JsonProperty("bg_color", Order = 8)]
    public string BgColor { get; set; } = string.Empty;

    [MemoryPackOrder(9)]
    [JsonProperty("item_type", Order = 9)]

    public ItemType ItemType { get; set; } = ItemType.Unknown;

    [MemoryPackOrder(10)]
    [JsonProperty("item_sub_type", Order = 10)]

    public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

    [MemoryPackOrder(11)]
    [JsonProperty("item_rare", Order = 11)]

    public Rarity ItemRare { get; set; } = Rarity.R;

    [MemoryPackOrder(12)]
    [JsonProperty("class", Order = 12)]

    public NikkeCharacterClass NikkeCharacterClass { get; set; } = NikkeCharacterClass.None;

    [MemoryPackOrder(13)]
    [JsonProperty("level_enhance_id", Order = 13)]
    public int LevelEnhanceId { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("harmonycube_skill_group", Order = 14)]
    public HarmonyCubeSkillGroup[] HarmonyCubeSkillGroups { get; set; } = [];
}
