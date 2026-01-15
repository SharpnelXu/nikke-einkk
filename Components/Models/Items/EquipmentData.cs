using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class EquipmentData
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
    [JsonProperty("resource_id", Order = 3)]
    public string ResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(4)]
    [JsonProperty("item_type", Order = 4)]
    public ItemType ItemType { get; set; } = ItemType.Unknown;

    [MemoryPackOrder(5)]
    [JsonProperty("item_sub_type", Order = 5)]
    public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

    [MemoryPackOrder(6)]
    [JsonProperty("class", Order = 6)]
    public NikkeCharacterClass NikkeCharacterClass { get; set; } = NikkeCharacterClass.None;

    [MemoryPackOrder(7)]
    [JsonProperty("item_rare", Order = 7)]
    public EquipItemRarity EquipItemRarity { get; set; } = EquipItemRarity.Unknown;

    [MemoryPackOrder(8)]
    [JsonProperty("grade_core_id", Order = 8)]
    public int GradeCoreId { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("grow_grade", Order = 9)]
    public int GrowGrade { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("stat", Order = 10)]
    public EquipmentStat[] Stat { get; set; } = [];

    [MemoryPackOrder(11)]
    [JsonProperty("option_slot", Order = 11)]
    public EquipmentOptionSlot[] OptionSlots { get; set; } = [];

    [MemoryPackOrder(12)]
    [JsonProperty("option_cost", Order = 12)]
    public int OptionCost { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("option_change_cost", Order = 13)]
    public int OptionChangeCost { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("option_lock_cost", Order = 14)]
    public int OptionLockCost { get; set; }
}
