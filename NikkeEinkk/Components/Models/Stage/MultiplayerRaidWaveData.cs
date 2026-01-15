using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Stage;

[MemoryPackable]
public partial class MultiplayerRaidWaveData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("name", Order = 1)]
    public string Name { get; set; } = string.Empty;

    [MemoryPackOrder(2)]
    [JsonProperty("player_count", Order = 2)]
    public int PlayerCount { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("character_select_time_limit", Order = 3)]
    public int CharacterSelectTimeLimit { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("character_lv", Order = 4)]
    public int CharacterLevel { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("stage_level", Order = 5)]
    public int StageLevel { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("monster_stage_lv", Order = 6)]
    public int MonsterStageLevel { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("dynamic_object_stage_lv", Order = 7)]
    public int DynamicObjectStageLevel { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("cover_stage_lv", Order = 8)]
    public int CoverStageLevel { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("monster_stage_lv_change_group", Order = 9)]
    public int MonsterStageLevelChangeGroup { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("spot_id", Order = 10)]
    public int SpotId { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("monster_stage_lv_change_group_easy", Order = 11)]
    public int MonsterStageLvChangeGroupEasy { get; set; }

    [MemoryPackOrder(12)]
    [JsonProperty("spot_id_easy", Order = 12)]
    public int SpotIdEasy { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("condition_reward_group", Order = 13)]
    public int ConditionRewardGroup { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("reward_limit_count", Order = 14)]
    public int RewardLimitCount { get; set; }

    [MemoryPackOrder(15)]
    [JsonProperty("rank_condition_reward_group", Order = 15)]
    public int RankConditionRewardGroup { get; set; }
}
