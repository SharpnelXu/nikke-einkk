using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models;

[MemoryPackable]
public partial class NikkeCharacterSkillData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("skill_cooltime", Order = 1)]
    public int SkillCooltime { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("attack_type", Order = 2)]
    public AttackType AttackType { get; set; } = AttackType.None;

    [MemoryPackOrder(2)]
    [JsonProperty("counter_type", Order = 3)]
    public CounterType CounterType { get; set; } = CounterType.None;

    [MemoryPackOrder(3)]
    [JsonProperty("prefer_target", Order = 4)]
    public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

    [MemoryPackOrder(4)]
    [JsonProperty("prefer_target_condition", Order = 5)]
    public PreferTargetCondition PreferTargetCondition { get; set; } = PreferTargetCondition.None;

    [MemoryPackOrder(6)]
    [JsonProperty("skill_type", Order = 6)]
    public CharacterSkillType SkillType { get; set; } = CharacterSkillType.None;

    [MemoryPackOrder(7)]
    [JsonProperty("skill_value_data", Order = 7)]
    public SkillValueData[] SkillValueData { get; set; } = [];

    [MemoryPackOrder(8)]
    [JsonProperty("duration_type", Order = 8)]
    public DurationType DurationType { get; set; } = DurationType.None;

    [MemoryPackOrder(9)]
    [JsonProperty("duration_value", Order = 9)]
    public int DurationValue { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("before_use_function_id_list", Order = 10)]
    public int[] BeforeUseFunctionIdList { get; set; } = [];

    [MemoryPackOrder(11)]
    [JsonProperty("before_hurt_function_id_list", Order = 11)]
    public int[] BeforeHurtFunctionIdList { get; set; } = [];

    [MemoryPackOrder(12)]
    [JsonProperty("after_use_function_id_list", Order = 12)]
    public int[] AfterUseFunctionIdList { get; set; } = [];

    [MemoryPackOrder(13)]
    [JsonProperty("after_hurt_function_id_list", Order = 13)]
    public int[] AfterHurtFunctionIdList { get; set; } = [];

    [MemoryPackOrder(14)]
    [JsonProperty("resource_name", Order = 14, NullValueHandling = NullValueHandling.Ignore)]
    public string? ResourceName { get; set; }

    [MemoryPackOrder(16)]
    [JsonProperty("icon", Order = 15)]
    public string Icon { get; set; } = string.Empty;

    [MemoryPackOrder(15)]
    [JsonProperty("shake_id", Order = 16)]
    public int ShakeId { get; set; }
}
