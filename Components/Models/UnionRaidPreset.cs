using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum DifficultyType
    {
        Unknown = -1,
        Normal = 1,
        Hard = 2
    }

    [MemoryPackable]
    public partial class UnionRaidPreset
    {
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; }

        [JsonProperty("preset_group_id")]
        [MemoryPackOrder(1)]
        public int PresetGroupId { get; set; }

        [JsonProperty("difficulty_type")]
        [MemoryPackOrder(2)]
        [JsonConverter(typeof(StringEnumConverter))]
        public DifficultyType DifficultyType { get; set; }

        [JsonProperty("wave_order")]
        [MemoryPackOrder(3)]
        public int WaveOrder { get; set; }

        [JsonProperty("wave")]
        [MemoryPackOrder(4)]
        public int Wave { get; set; }

        [JsonProperty("wave_change_step")]
        [MemoryPackOrder(5)]
        public int WaveChangeStep { get; set; }

        [JsonProperty("monster_stage_lv")]
        [MemoryPackOrder(6)]
        public int MonsterStageLv { get; set; }

        [JsonProperty("monster_stage_lv_change_group")]
        [MemoryPackOrder(7)]
        public int MonsterStageLvChangeGroup { get; set; }

        [JsonProperty("dynamic_object_stage_lv")]
        [MemoryPackOrder(8)]
        public int DynamicObjectStageLv { get; set; }

        [JsonProperty("cover_stage_lv")]
        [MemoryPackOrder(9)]
        public int CoverStageLv { get; set; }

        [JsonProperty("spot_autocontrol")]
        [MemoryPackOrder(10)]
        public bool SpotAutocontrol { get; set; }

        [JsonProperty("wave_name")]
        [MemoryPackOrder(11)]
        public string WaveName { get; set; } = string.Empty;

        [JsonProperty("wave_description")]
        [MemoryPackOrder(12)]
        public string WaveDescription { get; set; } = string.Empty;

        [JsonProperty("monster_image_si")]
        [MemoryPackOrder(13)]
        public string MonsterImageSi { get; set; } = string.Empty;

        [JsonProperty("monster_image")]
        [MemoryPackOrder(14)]
        public string MonsterImage { get; set; } = string.Empty;

        [JsonProperty("monster_spine", DefaultValueHandling = DefaultValueHandling.Ignore)]
        [MemoryPackOrder(15)]
        public int MonsterSpine { get; set; } = 0;

        [JsonProperty("monster_spine_scale")]
        [MemoryPackOrder(16)]
        public int MonsterSpineScale { get; set; }

        [JsonProperty("reward_id")]
        [MemoryPackOrder(17)]
        public int RewardId { get; set; }
    }
}