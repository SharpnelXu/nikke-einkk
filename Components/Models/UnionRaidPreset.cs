using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class UnionRaidPreset
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("preset_group_id")]
        public int PresetGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("difficulty_type")]
        public UnionRaidDifficultyType DifficultyType { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("wave_order")]
        public int WaveOrder { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("wave")]
        public int Wave { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("wave_change_step")]
        public int WaveChangeStep { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("monster_stage_lv")]
        public int MonsterStageLv { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("monster_stage_lv_change_group")]
        public int MonsterStageLvChangeGroup { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("dynamic_object_stage_lv")]
        public int DynamicObjectStageLv { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("cover_stage_lv")]
        public int CoverStageLv { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("spot_autocontrol")]
        public bool SpotAutocontrol { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("wave_name")]
        public string WaveName { get; set; } = string.Empty;

        [MemoryPackOrder(12)]
        [JsonProperty("wave_description")]
        public string WaveDescription { get; set; } = string.Empty;

        [MemoryPackOrder(13)]
        [JsonProperty("monster_image_si")]
        public string MonsterImageSi { get; set; } = string.Empty;

        [MemoryPackOrder(14)]
        [JsonProperty("monster_image")]
        public string MonsterImage { get; set; } = string.Empty;

        [MemoryPackOrder(15)]
        [JsonProperty("monster_spine", DefaultValueHandling = DefaultValueHandling.Ignore)]
        public int MonsterSpine { get; set; } = 0;

        [MemoryPackOrder(16)]
        [JsonProperty("monster_spine_scale")]
        public int MonsterSpineScale { get; set; }

        [MemoryPackOrder(17)]
        [JsonProperty("reward_id")]
        public int RewardId { get; set; }
    }
}
