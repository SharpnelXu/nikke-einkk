using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Rapture;

[MemoryPackable]
public partial class RapturePartData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("monster_model_id", Order = 1)]
    public int MonsterModelId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("parts_name_localkey", Order = 2, DefaultValueHandling = DefaultValueHandling.Ignore)]
    public string? PartsNameLocalKey { get; set; } = string.Empty;

    [MemoryPackOrder(2)]
    [JsonProperty("damage_hp_ratio", Order = 2)]
    public int DamageHpRatio { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("hp_ratio", Order = 3)]
    public int HpRatio { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("defence_ratio", Order = 4)]
    public int DefenceRatio { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("destroy_after_anim", Order = 5, DefaultValueHandling = DefaultValueHandling.Ignore)]
    public bool DestroyAfterAnim { get; set; } = false;

    [MemoryPackOrder(6)]
    [JsonProperty("destroy_after_movable", Order = 6)]
    public bool DestroyAfterMovable { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("passive_skill_id", Order = 7)]
    public int PassiveSkillId { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("visible_hp", Order = 8)]
    public bool VisibleHp { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("linked_parts_id", Order = 9)]
    public int LinkedPartsId { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("weapon_object", Order = 10)]
    public string[] WeaponObject { get; set; } = [];

    [MemoryPackOrder(11)]
    [JsonProperty("weapon_object_enum", Order = 11)]
    public WeaponObject[] WeaponObjectEnum { get; set; } = [];

    [MemoryPackOrder(12)]
    [JsonProperty("parts_type", Order = 12)]
    [JsonConverter(typeof(StringEnumConverter))]
    public PartsType PartsType { get; set; } = PartsType.Unknown;

    [MemoryPackOrder(13)]
    [JsonProperty("parts_object", Order = 13)]
    public string[] PartsObject { get; set; } = [];

    [MemoryPackOrder(14)]
    [JsonProperty("energy_resist_ratio", Order = 5)]
    public int EnergyResistRatio { get; set; }

    [MemoryPackOrder(15)]
    [JsonProperty("metal_resist_ratio", Order = 5)]
    public int MetalResistRatio { get; set; }

    [MemoryPackOrder(16)]
    [JsonProperty("bio_resist_ratio", Order = 5)]
    public int BioResistRatio { get; set; }

    [MemoryPackOrder(17)]
    [JsonProperty("attack_ratio", Order = 3)]
    public int AttackRatio { get; set; }

    [MemoryPackOrder(18)]
    [JsonProperty("parts_skin", Order = 18, DefaultValueHandling = DefaultValueHandling.Ignore)]
    public string? PartsSkin { get; set; } = string.Empty;

    [MemoryPackOrder(19)]
    [JsonProperty("monster_destroy_anim_trigger", Order = 19)]
    [JsonConverter(typeof(StringEnumConverter))]
    public RaptureDestroyAnimTrigger DestroyAnimTrigger { get; set; } = RaptureDestroyAnimTrigger.Unknown;

    [MemoryPackOrder(20)]
    [JsonProperty("is_main_part", Order = 20)]
    public bool IsMainPart { get; set; }

    [MemoryPackOrder(21)]
    [JsonProperty("is_parts_damage_able", Order = 21)]
    public bool IsPartsDamageAble { get; set; }
}
