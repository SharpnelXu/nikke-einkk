using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Nikke;

[MemoryPackable]
public partial class FunctionData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("group_id", Order = 1)]
    public int GroupId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("level", Order = 2)]
    public int Level { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("function_battlepower", Order = 3)]
    public int FunctionBattlepower { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("name_localkey", Order = 4)]
    public string? NameLocalkey { get; set; } = string.Empty;

    [MemoryPackOrder(5)]
    [JsonProperty("description_localkey", Order = 5)]
    public string? DescriptionLocalkey { get; set; } = string.Empty;

    [MemoryPackOrder(6)]
    [JsonProperty("buff", Order = 6)]
    public BuffType BuffType { get; set; } = BuffType.Unknown;

    [MemoryPackOrder(7)]
    [JsonProperty("buff_remove", Order = 7)]
    public BuffRemoveType BuffRemoveType { get; set; } = BuffRemoveType.Clear;

    [MemoryPackOrder(8)]
    [JsonProperty("function_type", Order = 8)]
    public FunctionType FunctionType { get; set; } = FunctionType.None;

    [MemoryPackOrder(10)]
    [JsonProperty("function_value_type", Order = 9)]
    public DataValueType FunctionValueType { get; set; } = DataValueType.None;

    [MemoryPackOrder(9)]
    [JsonProperty("function_standard", Order = 10)]
    public StandardType FunctionStandard { get; set; } = StandardType.None;

    [MemoryPackOrder(11)]
    [JsonProperty("function_value", Order = 11)]
    public long FunctionValue { get; set; }

    [MemoryPackOrder(12)]
    [JsonProperty("full_count", Order = 12)]
    public int FullCount { get; set; }

    [MemoryPackOrder(13)]
    [JsonProperty("is_cancel", Order = 13)]
    public bool IsCancel { get; set; }

    [MemoryPackOrder(14)]
    [JsonProperty("delay_type", Order = 14)]
    public DurationType DelayType { get; set; } = DurationType.None;

    [MemoryPackOrder(15)]
    [JsonProperty("delay_value", Order = 15)]
    public int DelayValue { get; set; }

    [MemoryPackOrder(16)]
    [JsonProperty("duration_type", Order = 16)]
    public DurationType DurationType { get; set; } = DurationType.None;

    [MemoryPackOrder(17)]
    [JsonProperty("duration_value", Order = 17)]
    public int DurationValue { get; set; }

    [MemoryPackOrder(18)]
    [JsonProperty("limit_value", Order = 18)]
    public int LimitValue { get; set; }

    [MemoryPackOrder(19)]
    [JsonProperty("function_target", Order = 19)]
    public FunctionTargetType FunctionTarget { get; set; } = FunctionTargetType.None;

    [MemoryPackOrder(20)]
    [JsonProperty("timing_trigger_type", Order = 20)]
    public TimingTriggerType TimingTriggerType { get; set; } = TimingTriggerType.None;

    [MemoryPackOrder(21)]
    [JsonProperty("timing_trigger_standard", Order = 21)]
    public StandardType TimingTriggerStandard { get; set; } = StandardType.None;

    [MemoryPackOrder(22)]
    [JsonProperty("timing_trigger_value", Order = 22)]
    public int TimingTriggerValue { get; set; }

    [MemoryPackOrder(23)]
    [JsonProperty("status_trigger_type", Order = 23)]
    public StatusTriggerType StatusTriggerType { get; set; } = StatusTriggerType.None;

    [MemoryPackOrder(24)]
    [JsonProperty("status_trigger_standard", Order = 24)]
    public StandardType StatusTriggerStandard { get; set; } = StandardType.None;

    [MemoryPackOrder(25)]
    [JsonProperty("status_trigger_value", Order = 25)]
    public long StatusTriggerValue { get; set; }

    [MemoryPackOrder(26)]
    [JsonProperty("status_trigger2_type", Order = 26)]
    public StatusTriggerType StatusTrigger2Type { get; set; } = StatusTriggerType.None;

    [MemoryPackOrder(27)]
    [JsonProperty("status_trigger2_standard", Order = 27)]
    public StandardType StatusTrigger2Standard { get; set; } = StandardType.None;

    [MemoryPackOrder(28)]
    [JsonProperty("status_trigger2_value", Order = 28)]
    public long StatusTrigger2Value { get; set; }

    [MemoryPackOrder(29)]
    [JsonProperty("keeping_type", Order = 29)]
    public FunctionStatus KeepingType { get; set; } = FunctionStatus.Off;

    [MemoryPackOrder(30)]
    [JsonProperty("buff_icon", Order = 30)]
    public string BuffIcon { get; set; } = string.Empty;

    [MemoryPackOrder(31)]
    [JsonProperty("element_reaction_icon", Order = 31)]
    public string? ElementReactionIcon { get; set; } = string.Empty;

    [MemoryPackOrder(32)]
    [JsonProperty("shot_fx_list_type", Order = 32)]
    public ShotFx ShotFxListType { get; set; } = ShotFx.None;

    [MemoryPackOrder(33)]
    [JsonProperty("fx_prefab_01", Order = 33)]
    public string? FxPrefab01 { get; set; } = string.Empty;

    [MemoryPackOrder(34)]
    [JsonProperty("fx_target_01", Order = 34)]
    public FxTarget FxTarget01 { get; set; } = FxTarget.None;

    [MemoryPackOrder(35)]
    [JsonProperty("fx_socket_point_01", Order = 35)]
    public SocketPoint FxSocketPoint01 { get; set; } = SocketPoint.None;

    [MemoryPackOrder(36)]
    [JsonProperty("fx_prefab_02", Order = 36)]
    public string? FxPrefab02 { get; set; } = string.Empty;

    [MemoryPackOrder(37)]
    [JsonProperty("fx_target_02", Order = 37)]
    public FxTarget FxTarget02 { get; set; } = FxTarget.None;

    [MemoryPackOrder(38)]
    [JsonProperty("fx_socket_point_02", Order = 38)]
    public SocketPoint FxSocketPoint02 { get; set; } = SocketPoint.None;

    [MemoryPackOrder(39)]
    [JsonProperty("fx_prefab_03", Order = 39)]
    public string? FxPrefab03 { get; set; } = string.Empty;

    [MemoryPackOrder(40)]
    [JsonProperty("fx_target_03", Order = 40)]
    public FxTarget FxTarget03 { get; set; } = FxTarget.None;

    [MemoryPackOrder(41)]
    [JsonProperty("fx_socket_point_03", Order = 41)]
    public SocketPoint FxSocketPoint03 { get; set; } = SocketPoint.None;

    [MemoryPackOrder(42)]
    [JsonProperty("fx_prefab_full", Order = 42)]
    public string? FxPrefabFull { get; set; } = string.Empty;

    [MemoryPackOrder(43)]
    [JsonProperty("fx_target_full", Order = 43)]
    public FxTarget FxTargetFull { get; set; } = FxTarget.None;

    [MemoryPackOrder(44)]
    [JsonProperty("fx_socket_point_full", Order = 44)]
    public SocketPoint FxSocketPointFull { get; set; } = SocketPoint.None;

    [MemoryPackOrder(45)]
    [JsonProperty("fx_prefab_01_arena", Order = 45)]
    public string? FxPrefab01Arena { get; set; } = string.Empty;

    [MemoryPackOrder(46)]
    [JsonProperty("fx_target_01_arena", Order = 46)]
    public FxTarget FxTarget01Arena { get; set; } = FxTarget.None;

    [MemoryPackOrder(47)]
    [JsonProperty("fx_socket_point_01_arena", Order = 47)]
    public SocketPoint FxSocketPoint01Arena { get; set; } = SocketPoint.None;

    [MemoryPackOrder(48)]
    [JsonProperty("fx_prefab_02_arena", Order = 48)]
    public string? FxPrefab02Arena { get; set; } = string.Empty;

    [MemoryPackOrder(49)]
    [JsonProperty("fx_target_02_arena", Order = 49)]
    public FxTarget FxTarget02Arena { get; set; } = FxTarget.None;

    [MemoryPackOrder(50)]
    [JsonProperty("fx_socket_point_02_arena", Order = 50)]
    public SocketPoint FxSocketPoint02Arena { get; set; } = SocketPoint.None;

    [MemoryPackOrder(51)]
    [JsonProperty("fx_prefab_03_arena", Order = 51)]
    public string? FxPrefab03Arena { get; set; } = string.Empty;

    [MemoryPackOrder(52)]
    [JsonProperty("fx_target_03_arena", Order = 52)]
    public FxTarget FxTarget03Arena { get; set; } = FxTarget.None;

    [MemoryPackOrder(53)]
    [JsonProperty("fx_socket_point_03_arena", Order = 53)]
    public SocketPoint FxSocketPoint03Arena { get; set; } = SocketPoint.None;

    [MemoryPackOrder(54)]
    [JsonProperty("connected_function", Order = 54)]
    public int[] ConnectedFunction { get; set; } = [];
}
