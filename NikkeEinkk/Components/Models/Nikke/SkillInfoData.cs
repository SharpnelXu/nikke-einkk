using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Nikke
{
    [MemoryPackable]
    public partial class SkillInfoData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group_id", Order = 1)]
        public int GroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("skill_level", Order = 2)]
        public int SkillLevel { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("next_level_id", Order = 3)]
        public int NextLevelId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("level_up_cost_id", Order = 4)]
        public int LevelUpCostId { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("icon", Order = 5)]
        public string Icon { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("name_localkey", Order = 6)]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(7)]
        [JsonProperty("description_localkey", Order = 7)]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonProperty("info_description_localkey", Order = 8)]
        public string InfoDescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(9)]
        [JsonProperty("description_value_list", Order = 9)]
        public SkillDescriptionValue[] DescriptionValues { get; set; } = [];
    }
}
