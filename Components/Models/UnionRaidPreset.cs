using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum DifficultyType
    {
        Unknown = -1,
        Normal = 1,
        Hard = 2
    }

    [MemoryPackable]
    public partial class UnionRaidPreset
    {
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; }

        [JsonPropertyName("preset_group_id")]
        [MemoryPackOrder(1)]
        public int PresetGroupId { get; set; }

        [JsonPropertyName("difficulty_type")]
        [MemoryPackOrder(2)]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public DifficultyType DifficultyType { get; set; }

        [JsonPropertyName("wave_order")]
        [MemoryPackOrder(3)]
        public int WaveOrder { get; set; }

        [JsonPropertyName("wave")]
        [MemoryPackOrder(4)]
        public int Wave { get; set; }

        [JsonPropertyName("wave_change_step")]
        [MemoryPackOrder(5)]
        public int WaveChangeStep { get; set; }

        [JsonPropertyName("monster_stage_lv")]
        [MemoryPackOrder(6)]
        public int MonsterStageLv { get; set; }

        [JsonPropertyName("monster_stage_lv_change_group")]
        [MemoryPackOrder(7)]
        public int MonsterStageLvChangeGroup { get; set; }

        [JsonPropertyName("dynamic_object_stage_lv")]
        [MemoryPackOrder(8)]
        public int DynamicObjectStageLv { get; set; }

        [JsonPropertyName("cover_stage_lv")]
        [MemoryPackOrder(9)]
        public int CoverStageLv { get; set; }

        [JsonPropertyName("spot_autocontrol")]
        [MemoryPackOrder(10)]
        public bool SpotAutocontrol { get; set; }

        [JsonPropertyName("wave_name")]
        [MemoryPackOrder(11)]
        public string WaveName { get; set; } = string.Empty;

        [JsonPropertyName("wave_description")]
        [MemoryPackOrder(12)]
        public string WaveDescription { get; set; } = string.Empty;

        [JsonPropertyName("monster_image_si")]
        [MemoryPackOrder(13)]
        public string MonsterImageSi { get; set; } = string.Empty;

        [JsonPropertyName("monster_image")]
        [MemoryPackOrder(14)]
        public string MonsterImage { get; set; } = string.Empty;

        [JsonPropertyName("monster_spine")]
        [MemoryPackOrder(15)]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int MonsterSpine { get; set; } = 0;

        [JsonPropertyName("monster_spine_scale")]
        [MemoryPackOrder(16)]
        public int MonsterSpineScale { get; set; }

        [JsonPropertyName("reward_id")]
        [MemoryPackOrder(17)]
        public int RewardId { get; set; }
    }
}