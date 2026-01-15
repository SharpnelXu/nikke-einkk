using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items
{
    [MemoryPackable]
    public partial class PieceItemData
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
        [JsonProperty("item_type", Order = 4)]

        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(5)]
        [JsonProperty("item_sub_type", Order = 5)]

        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(6)]
        [JsonProperty("item_rare", Order = 6)]

        public Rarity ItemRarity { get; set; } = Rarity.R;

        [MemoryPackOrder(7)]
        [JsonProperty("corporation", Order = 7)]

        public Corporation Corporation { get; set; } = Corporation.None;

        [MemoryPackOrder(8)]
        [JsonProperty("corporation_sub_type", Order = 8, DefaultValueHandling = DefaultValueHandling.Ignore)]

        public CorporationSubType CorporationSubType { get; set; } = CorporationSubType.NORMAL;

        [MemoryPackOrder(9)]
        [JsonProperty("class", Order = 9)]

        public NikkeCharacterClass NikkeCharacterClass { get; set; } = NikkeCharacterClass.None;

        [MemoryPackOrder(10)]
        [JsonProperty("use_type", Order = 10)]

        public UseType UseType { get; set; } = UseType.Unknown;

        [MemoryPackOrder(11)]
        [JsonProperty("use_id", Order = 11)]
        public int UseId { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("use_value", Order = 12)]
        public int UseValue { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("use_limit_count", Order = 13)]
        public bool UseLimitCount { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("use_limit_count_value", Order = 14, DefaultValueHandling = DefaultValueHandling.Ignore)]
        public int UseLimitCountValue { get; set; } = 0;

        [MemoryPackOrder(15)]
        [JsonProperty("stack_max", Order = 15)]
        public int StackMax { get; set; }
    }
}
