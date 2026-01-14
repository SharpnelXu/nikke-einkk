using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class FavoriteItemLevelData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("level_enhance_id", Order = 1)]
    public int LevelEnhanceId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("grade", Order = 2)]
    public int Grade { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("level", Order = 3)]
    public int Level { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("favoriteitem_stat_data", Order = 4)]
    public FavoriteItemStat[] Stats { get; set; } = [];

    [MemoryPackOrder(5)]
    [JsonProperty("collection_skill_level_data", Order = 5)]
    public CollectionItemSkillLevel[] SkillLevels { get; set; } = [];
}
