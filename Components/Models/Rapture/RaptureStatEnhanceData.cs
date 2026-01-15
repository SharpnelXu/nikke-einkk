using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Rapture;

[MemoryPackable]
public partial class RaptureStatEnhanceData
{
    [MemoryPackOrder(0)]
    [JsonProperty("id", Order = 0)]
    public int Id { get; set; }

    [MemoryPackOrder(1)]
    [JsonProperty("group_id", Order = 1)]
    public int GroupId { get; set; }

    [MemoryPackOrder(2)]
    [JsonProperty("lv", Order = 2)]
    public int Lv { get; set; }

    [MemoryPackOrder(3)]
    [JsonProperty("level_hp", Order = 3)]
    public long LevelHp { get; set; }

    [MemoryPackOrder(4)]
    [JsonProperty("level_attack", Order = 4)]
    public int LevelAttack { get; set; }

    [MemoryPackOrder(5)]
    [JsonProperty("level_defence", Order = 5)]
    public int LevelDefence { get; set; }

    [MemoryPackOrder(6)]
    [JsonProperty("level_statdamageratio", Order = 6)]
    public int LevelStatDamageRatio { get; set; }

    [MemoryPackOrder(7)]
    [JsonProperty("level_energy_resist", Order = 7)]
    public int LevelEnergyResist { get; set; }

    [MemoryPackOrder(8)]
    [JsonProperty("level_metal_resist", Order = 8)]
    public int LevelMetalResist { get; set; }

    [MemoryPackOrder(9)]
    [JsonProperty("level_bio_resist", Order = 9)]
    public int LevelBioResist { get; set; }

    [MemoryPackOrder(10)]
    [JsonProperty("level_projectile_hp", Order = 10)]
    public int LevelProjectileHp { get; set; }

    [MemoryPackOrder(11)]
    [JsonProperty("level_broken_hp", Order = 11)]
    public long LevelBrokenHp { get; set; }
}
