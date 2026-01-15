using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using NikkeEinkk.Components.Models.Enums;
using NikkeEinkk.Components.Models.Enums.Converters;

namespace NikkeEinkk.Components.Models.Rapture;

[MemoryPackable]
public partial class RaptureSkillData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("name_localkey", Order = 1)]
    public string? NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(2)]
    [JsonProperty("description_localkey", Order = 2)]
    public string? DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(3)]
    [JsonProperty("skill_icon", Order = 3)]
    public string SkillIcon { get; set; } = string.Empty;

    [MemoryPackOrder(4)]
    [JsonProperty("skill_ani_number", Order = 4)]
    public SkillAnimationNumber AnimationNumber { get; set; } = SkillAnimationNumber.None;

    [MemoryPackOrder(5)]
    [JsonProperty("weapon_type", Order = 5)]
    [JsonConverter(typeof(StringEnumConverter))]
    public WeaponType WeaponType { get; set; } = WeaponType.None;

    [MemoryPackOrder(33)]
    [JsonProperty("prefer_target", Order = 6)]
    [JsonConverter(typeof(StringEnumConverter))]
    public PreferTarget PreferTarget { get; set; } = PreferTarget.None;

    [MemoryPackOrder(34)]
    [JsonProperty("show_lock_on", Order = 7)]
    public bool ShowLockOn { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("attack_type", Order = 8)]
    [JsonConverter(typeof(StringEnumConverter))]
    public AttackType AttackType { get; set; } = AttackType.None;

    [MemoryPackOrder(7)]
    [JsonProperty("fire_type", Order = 9)]
    [JsonConverter(typeof(StringEnumConverter))]
    public FireType FireType { get; set; } = FireType.None;

    [MemoryPackOrder(20)]
    [JsonProperty("casting_time", Order = 10)]
    public int CastingTime { get; set; }

    [MemoryPackOrder(21)]
    [JsonProperty("break_object", Order = 11)]
    public string[] BreakObjects { get; set; } = [];

    [MemoryPackOrder(22)]
    [JsonProperty("break_object_hp_raito", Order = 12)]
    public int BreakObjectHpRatio { get; set; }

    [MemoryPackOrder(23)]
    [JsonProperty("move_object", Order = 12)]
    public string[] MoveObject { get; set; } = [];

    [MemoryPackOrder(25)]
    [JsonProperty("skill_value_type_01", Order = 13)]
    [JsonConverter(typeof(StringEnumConverter))]
    public RaptureSkillvalueType SkillValueType1 { get; set; } = RaptureSkillvalueType.None;

    [MemoryPackOrder(26)]
    [JsonProperty("skill_value_01", Order = 14)]
    public long SkillValue1 { get; set; }

    [MemoryPackOrder(27)]
    [JsonProperty("skill_value_type_02", Order = 15)]
    [JsonConverter(typeof(StringEnumConverter))]
    public RaptureSkillvalueType SkillValueType2 { get; set; } = RaptureSkillvalueType.None;

    [MemoryPackOrder(28)]
    [JsonProperty("skill_value_02", Order = 16)]
    public long SkillValue2 { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("shot_count", Order = 17)]
    public int ShotCount { get; set; }

    [MemoryPackOrder(24)]
    [JsonProperty("delay_time", Order = 18)]
    public int DelayTime { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("shot_timing", Order = 19)]
    [JsonConverter(typeof(StringEnumConverter))]
    public ShotTiming ShotTiming { get; set; } = ShotTiming.None;

    [MemoryPackOrder(10)]
    [JsonProperty("penetration", Order = 20)]
    public int Penetration { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("projectile_speed", Order = 21)]
    public int ProjectileSpeed { get; set; }

    [MemoryPackOrder(12)]
    [JsonProperty("projectile_hp_ratio", Order = 22)]
    public int ProjectileHpRatio { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("projectile_def_ratio", Order = 22)]
    public int ProjectileDefRatio { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("projectile_radius_object", Order = 23)]
    public int ProjectileRadiusObject { get; set; }

    [MemoryPackOrder(15)]
    [JsonProperty("projectile_radius", Order = 24)]
    public int ProjectileRadius { get; set; }

    [MemoryPackOrder(16)]
    [JsonProperty("spot_explosion_range", Order = 25)]
    public int ExplosionRange { get; set; }

    [MemoryPackOrder(17)]
    [JsonProperty("is_destroyable_projectile", Order = 26)]
    public bool IsDestroyableProjectile { get; set; }

    [MemoryPackOrder(18)]
    [JsonProperty("relate_anim", Order = 27)]
    public bool RelateAnim { get; set; }

    [MemoryPackOrder(19)]
    [JsonProperty("deceleration_rate", Order = 28)]
    public int DecelerationRate { get; set; }

    [MemoryPackOrder(29)]
    [JsonProperty("target_character_ratio", Order = 29)]
    public int TargetCharacterRatio { get; set; }

    [MemoryPackOrder(30)]
    [JsonProperty("target_cover_ratio", Order = 30)]
    public int TargetCoverRatio { get; set; }

    [MemoryPackOrder(31)]
    [JsonProperty("target_nothing_ratio", Order = 31)]
    public int TargetNothingRatio { get; set; }

    [MemoryPackOrder(32)]
    [JsonProperty("weapon_object_enum", Order = 31)]
    [JsonConverter(typeof(StringEnumConverter))]
    public WeaponObject WeaponObjectEnum { get; set; } = WeaponObject.None;

    [MemoryPackOrder(32)]
    [JsonProperty("calling_group_id", Order = 32)]
    public int CallingGroupId { get; set; }

    [MemoryPackOrder(35)]
    [JsonProperty("target_count", Order = 33)]
    public int TargetCount { get; set; }

    [MemoryPackOrder(36)]
    [JsonProperty("object_resource", Order = 34)]
    public string[] ObjectResources { get; set; } = [];

    [MemoryPackOrder(37)]
    [JsonProperty("object_position_type", Order = 35)]
    [JsonConverter(typeof(StringEnumConverter))]
    public ObjectPositionType ObjectPositionType { get; set; } = ObjectPositionType.None;

    [MemoryPackOrder(38)]
    [JsonProperty("object_position", Order = 36)]
    [JsonConverter(typeof(DoubleArrayConverter))]
    public double[] ObjectPosition { get; set; } = [0.0, 0.0, 0.0];

    [MemoryPackOrder(39)]
    [JsonProperty("is_using_timeline", Order = 37)]
    public bool IsUsingTimeline { get; set; }

    [MemoryPackOrder(40)]
    [JsonProperty("control_gauge", Order = 38)]
    public int ControlGauge { get; set; }

    [MemoryPackOrder(41)]
    [JsonProperty("control_parts", Order = 39)]
    public PartsType[] ControlParts { get; set; } = [];

    [MemoryPackOrder(42)]
    [JsonProperty("cancel_type", Order = 42)]
    [JsonConverter(typeof(StringEnumConverter))]
    public CancelType CancelType { get; set; } = CancelType.None;

    [MemoryPackOrder(43)]
    [JsonProperty("linked_parts", Order = 41)]
    [JsonConverter(typeof(StringEnumConverter))]
    public PartsType LinkedParts { get; set; } = PartsType.None;
}
