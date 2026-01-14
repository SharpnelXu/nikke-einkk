using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class NikkeCharacterStatEnhanceRecord
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("grade_ratio", Order = 1)]
        public int GradeRatio { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("grade_hp", Order = 2)]
        public long GradeHp { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("grade_attack", Order = 3)]
        public int GradeAttack { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("grade_defence", Order = 4)]
        public int GradeDefence { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("grade_energy_resist", Order = 5)]
        public int GradeEnergyResist { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("grade_metal_resist", Order = 6)]
        public int GradeMetalResist { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("grade_bio_resist", Order = 7)]
        public int GradeBioResist { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("core_hp", Order = 8)]
        public long CoreHp { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("core_attack", Order = 9)]
        public int CoreAttack { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("core_defence", Order = 10)]
        public int CoreDefence { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("core_energy_resist", Order = 11)]
        public int CoreEnergyResist { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("core_metal_resist", Order = 12)]
        public int CoreMetalResist { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("core_bio_resist", Order = 13)]
        public int CoreBioResist { get; set; }
    }
}
