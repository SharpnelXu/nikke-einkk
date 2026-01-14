using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Rapture;

[MemoryPackable]
public partial class RaptureStageLevelChangeData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("group", Order = 1)]
    public int Group { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("step", Order = 2)]
    public int Step { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("condition_type", Order = 3)]
    public RaptureStageLevelChangeCondition ConditionType { get; set; } = RaptureStageLevelChangeCondition.None;

    [MemoryPackOrder(4)]
    [JsonProperty("condition_value_min", Order = 4)]
    public long ConditionValueMin { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("condition_value_max", Order = 5)]
    public long ConditionValueMax { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("monster_stage_lv", Order = 6)]
    public int MonsterStageLv { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("passive_skill_id", Order = 7)]
    public int PassiveSkillId { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("target_passive_skill_id", Order = 8)]
    public int TargetPassiveSkillId { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("gimmickobject_lv_control", Order = 9)]
    public int GimmickObjectLvControl { get; set; }
}
