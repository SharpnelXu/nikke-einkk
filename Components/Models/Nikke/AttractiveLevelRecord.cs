using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Nikke
{
    [MemoryPackable]
    public partial class AttractiveLevelRecord
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("attractive_level")]
        public int AttractiveLevel { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("attractive_point")]
        public int AttractivePoint { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("attacker_hp_rate")]
        public int AttackerHpRate { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("attacker_attack_rate")]
        public int AttackerAttackRate { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("attacker_defence_rate")]
        public int AttackerDefenceRate { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("attacker_energy_resist_rate")]
        public int AttackerEnergyResistRate { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("attacker_metal_resist_rate")]
        public int AttackerMetalResistRate { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("attacker_bio_resist_rate")]
        public int AttackerBioResistRate { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("defender_hp_rate")]
        public int DefenderHpRate { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("defender_attack_rate")]
        public int DefenderAttackRate { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("defender_defence_rate")]
        public int DefenderDefenceRate { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("defender_energy_resist_rate")]
        public int DefenderEnergyResistRate { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("defender_metal_resist_rate")]
        public int DefenderMetalResistRate { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("defender_bio_resist_rate")]
        public int DefenderBioResistRate { get; set; }

        [MemoryPackOrder(15)]
        [JsonProperty("supporter_hp_rate")]
        public int SupporterHpRate { get; set; }

        [MemoryPackOrder(16)]
        [JsonProperty("supporter_attack_rate")]
        public int SupporterAttackRate { get; set; }

        [MemoryPackOrder(17)]
        [JsonProperty("supporter_defence_rate")]
        public int SupporterDefenceRate { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("supporter_energy_resist_rate")]
        public int SupporterEnergyResistRate { get; set; }

        [MemoryPackOrder(19)]
        [JsonProperty("supporter_metal_resist_rate")]
        public int SupporterMetalResistRate { get; set; }

        [MemoryPackOrder(20)]
        [JsonProperty("supporter_bio_resist_rate")]
        public int SupporterBioResistRate { get; set; }
    }
}