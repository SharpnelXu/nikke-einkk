using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Shop;

[MemoryPackable]
public partial class StepUpPackageData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("stepup_group_id", Order = 1)]
    public int StepUpGroupId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("package_group_id", Order = 2)]
    public int PackageGroupId { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("step", Order = 3)]
    public int Step { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("previous_package_id", Order = 4)]
    public int PreviousPackageId { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("is_last_step", Order = 5)]
    public bool IsLastStep { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("product_effieciency", Order = 6)]
    public int ProductEfficiency { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("buy_limit_type", Order = 7)]
    public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.Account;

    [MemoryPackOrder(8)]
    [JsonProperty("is_limit", Order = 8)]
    public bool IsLimited { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("buy_limit_count", Order = 9)]
    public int BuyLimitCount { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("is_free", Order = 10)]
    public bool IsFree { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("midas_product_id", Order = 11)]
    public int MidasProductId { get; set; }

    [MemoryPackOrder(12)]
    [JsonProperty("name_localkey", Order = 12)]
    public string NameKey { get; set; } = string.Empty;

    [MemoryPackOrder(13)]
    [JsonProperty("description_localkey", Order = 13)]
    public string DescriptionKey { get; set; } = string.Empty;

    [MemoryPackOrder(14)]
    [JsonProperty("product_resource_id", Order = 14)]
    public string ProductResourceId { get; set; } = string.Empty;
}
