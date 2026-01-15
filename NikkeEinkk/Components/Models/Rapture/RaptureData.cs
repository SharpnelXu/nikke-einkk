using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Rapture;

[MemoryPackable]
public partial class RaptureData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public long Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("element_id", Order = 1)]
    public int[] ElementIds { get; set; } = [];

    [MemoryPackOrder(2)]
    [JsonProperty("monster_model_id", Order = 2)]
    public int MonsterModelId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("ui_grade", Order = 2)]
    public RaptureUiGrade UiGrade { get; set; } = RaptureUiGrade.None;

    [MemoryPackOrder(3)]
    [JsonProperty("name_localkey", Order = 3)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(4)]
    [JsonProperty("appearance_localkey", Order = 4)]
    public string AppearanceKey { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("description_localkey", Order = 5)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(6)]
    [JsonProperty("is_irregular", Order = 6)]
    public bool IsIrregular { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("hp_ratio", Order = 7)]
    public int HpRatio { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("attack_ratio", Order = 8)]
    public int AttackRatio { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("defence_ratio", Order = 9)]
    public int DefenceRatio { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("energy_resist_ratio", Order = 10)]
    public int EnergyResistRatio { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("metal_resist_ratio", Order = 11)]
    public int MetalResistRatio { get; set; }

    [MemoryPackOrder(12)]
    [JsonProperty("bio_resist_ratio", Order = 12)]
    public int BioResistRatio { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("detector_center", Order = 13)]
    public int DetectorCenter { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("detector_radius", Order = 14)]
    public int DetectorRadius { get; set; }

    [MemoryPackOrder(15)]
    [JsonProperty("nonetarget", Order = 15)]
    public NoneTargetCondition Nonetarget { get; set; } = NoneTargetCondition.Normal;

    [MemoryPackOrder(16)]
    [JsonProperty("functionnonetarget", Order = 16)]
    public FunctionNoneTargetCondition FunctionNonetarget { get; set; } = FunctionNoneTargetCondition.Normal;

    [MemoryPackOrder(17)]
    [JsonProperty("spot_ai", Order = 17)]
    public string SpotAi { get; set; } = string.Empty;

    [MemoryPackOrder(18)]
    [JsonProperty("spot_ai_defense", Order = 18)]
    public string SpotAiDefense { get; set; } = string.Empty;

    [MemoryPackOrder(19)]
    [JsonProperty("spot_ai_basedefense", Order = 19)]
    public string SpotAiBaseDefense { get; set; } = string.Empty;

    [MemoryPackOrder(20)]
    [JsonProperty("spot_move_speed", Order = 20)]
    public int SpotMoveSpeed { get; set; }

    [MemoryPackOrder(21)]
    [JsonProperty("spot_acceleration_time", Order = 21)]
    public int SpotAccelerationTime { get; set; }

    [MemoryPackOrder(22)]
    [JsonProperty("fixed_spawn_type", Order = 22)]
    public SpawnType FixedSpawnType { get; set; } = SpawnType.None;

    [MemoryPackOrder(23)]
    [JsonProperty("spot_rand_ratio_normal", Order = 23)]
    public int SpotRandRatioNormal { get; set; }

    [MemoryPackOrder(24)]
    [JsonProperty("spot_rand_ratio_jump", Order = 24)]
    public int SpotRandRatioJump { get; set; }

    [MemoryPackOrder(25)]
    [JsonProperty("spot_rand_ratio_drop", Order = 25)]
    public int SpotRandRatioDrop { get; set; }

    [MemoryPackOrder(26)]
    [JsonProperty("spot_rand_ratio_dash", Order = 26)]
    public int SpotRandRatioDash { get; set; }

    [MemoryPackOrder(27)]
    [JsonProperty("spot_rand_ratio_teleport", Order = 27)]
    public int SpotRandRatioTeleport { get; set; }

    [MemoryPackOrder(28)]
    [JsonProperty("passive_skill_id", Order = 28)]
    public int PassiveSkillId { get; set; }

    [MemoryPackOrder(28)]
    [JsonProperty("skill_data", Order = 28)]
    public RaptureSkillInfoData[] SkillData { get; set; } = [];

    [MemoryPackOrder(29)]
    [JsonProperty("statenhance_id", Order = 29)]
    public int StatEnhanceId { get; set; }
}
