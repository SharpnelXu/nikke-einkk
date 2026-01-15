using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Stage
{
    [MemoryPackable]
    public partial class SoloRaidWaveData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("preset_group_id", Order = 1)]
        public int PresetGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("difficulty_type", Order = 2)]
        public SoloRaidDifficultyType DifficultyType { get; set; } = SoloRaidDifficultyType.Common;

        [MemoryPackOrder(3)]
        [JsonProperty("quick_battle_type", Order = 3)]
        public QuickBattleType QuickBattleType { get; set; } = QuickBattleType.None;

        [MemoryPackOrder(4)]
        [JsonProperty("character_lv", Order = 4)]
        public int CharacterLevel { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("wave_open_condition", Order = 5)]
        public int WaveOpenCondition { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("wave_order", Order = 6)]
        public int WaveOrder { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("wave", Order = 7)]
        public int Wave { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("monster_stage_lv", Order = 8)]
        public int MonsterStageLevel { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("monster_stage_lv_change_group", Order = 9)]
        public int MonsterStageLevelChangeGroup { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("dynamic_object_stage_lv", Order = 10)]
        public int DynamicObjectStageLevel { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("cover_stage_lv", Order = 11)]
        public int CoverStageLevel { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("spot_autocontrol", Order = 12)]
        public bool SpotAutocontrol { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("wave_name", Order = 13)]
        public string WaveName { get; set; } = string.Empty;

        [MemoryPackOrder(14)]
        [JsonProperty("wave_description", Order = 14)]
        public string WaveDescription { get; set; } = string.Empty;

        [MemoryPackOrder(15)]
        [JsonProperty("monster_image_si", Order = 15)]
        public string MonsterImageSi { get; set; } = string.Empty;

        [MemoryPackOrder(16)]
        [JsonProperty("monster_image", Order = 16)]
        public string MonsterImage { get; set; } = string.Empty;

        [MemoryPackOrder(17)]
        [JsonProperty("first_clear_reward_id", Order = 17)]
        public int FirstClearRewardId { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("reward_id", Order = 18)]
        public int RewardId { get; set; }
    }
}
