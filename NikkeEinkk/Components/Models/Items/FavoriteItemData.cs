using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Items;

[MemoryPackable]
public partial class FavoriteItemData
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
    [JsonProperty("icon_resource_id", Order = 3)]
    public string IconResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(4)]
    [JsonProperty("img_resource_id", Order = 4)]
    public string ImgResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("prop_resource_id", Order = 5)]
    public string PropResourceId { get; set; } = string.Empty;

    [MemoryPackOrder(6)]
    [JsonProperty("order", Order = 6)]
    public int Order { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("favorite_rare", Order = 7)]

    public Rarity FavoriteRare { get; set; } = Rarity.R;

    [MemoryPackOrder(8)]
    [JsonProperty("favorite_type", Order = 8)]

    public FavoriteItemType FavoriteType { get; set; } = FavoriteItemType.Unknown;

    [MemoryPackOrder(9)]
    [JsonProperty("weapon_type", Order = 9)]

    public WeaponType WeaponType { get; set; } = WeaponType.None;

    [MemoryPackOrder(10)]
    [JsonProperty("name_code", Order = 10)]
    public int NameCode { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("max_level", Order = 11)]
    public int MaxLevel { get; set; }

    [MemoryPackOrder(12)]
    [JsonProperty("level_enhance_id", Order = 12)]
    public int LevelEnhanceId { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("probability_group", Order = 13)]
    public int ProbabilityGroup { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("collection_skill_group_data", Order = 14)]
    public CollectionItemSkillGroup[] CollectionSkills { get; set; } = [];

    [MemoryPackOrder(15)]
    [JsonProperty("favoriteitem_skill_group_data", Order = 15)]
    public FavoriteItemSkillGroup[] FavoriteItemSkills { get; set; } = [];

    [MemoryPackOrder(16)]
    [JsonProperty("albumcategory_id", Order = 16)]
    public int AlbumCategoryId { get; set; }
}
