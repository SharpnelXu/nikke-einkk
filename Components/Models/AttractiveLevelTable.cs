using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    /// <summary>
    /// Represents a record in the AttractiveLevelTable
    /// </summary>
    [MemoryPackable]
    public partial class AttractiveLevelTable
    {
        /// <summary>
        /// Unique identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        /// <summary>
        /// Attractive level
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyName("attractive_level")]
        public int AttractiveLevel { get; set; }

        /// <summary>
        /// Attractive point requirement
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyName("attractive_point")]
        public int AttractivePoint { get; set; }

        /// <summary>
        /// Attacker HP rate bonus
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyName("attacker_hp_rate")]
        public int AttackerHpRate { get; set; }

        /// <summary>
        /// Attacker attack rate bonus
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyName("attacker_attack_rate")]
        public int AttackerAttackRate { get; set; }

        /// <summary>
        /// Attacker defence rate bonus
        /// </summary>
        [MemoryPackOrder(5)]
        [JsonPropertyName("attacker_defence_rate")]
        public int AttackerDefenceRate { get; set; }

        /// <summary>
        /// Attacker energy resist rate bonus
        /// </summary>
        [MemoryPackOrder(6)]
        [JsonPropertyName("attacker_energy_resist_rate")]
        public int AttackerEnergyResistRate { get; set; }

        /// <summary>
        /// Attacker metal resist rate bonus
        /// </summary>
        [MemoryPackOrder(7)]
        [JsonPropertyName("attacker_metal_resist_rate")]
        public int AttackerMetalResistRate { get; set; }

        /// <summary>
        /// Attacker bio resist rate bonus
        /// </summary>
        [MemoryPackOrder(8)]
        [JsonPropertyName("attacker_bio_resist_rate")]
        public int AttackerBioResistRate { get; set; }

        /// <summary>
        /// Defender HP rate bonus
        /// </summary>
        [MemoryPackOrder(9)]
        [JsonPropertyName("defender_hp_rate")]
        public int DefenderHpRate { get; set; }

        /// <summary>
        /// Defender attack rate bonus
        /// </summary>
        [MemoryPackOrder(10)]
        [JsonPropertyName("defender_attack_rate")]
        public int DefenderAttackRate { get; set; }

        /// <summary>
        /// Defender defence rate bonus
        /// </summary>
        [MemoryPackOrder(11)]
        [JsonPropertyName("defender_defence_rate")]
        public int DefenderDefenceRate { get; set; }

        /// <summary>
        /// Defender energy resist rate bonus
        /// </summary>
        [MemoryPackOrder(12)]
        [JsonPropertyName("defender_energy_resist_rate")]
        public int DefenderEnergyResistRate { get; set; }

        /// <summary>
        /// Defender metal resist rate bonus
        /// </summary>
        [MemoryPackOrder(13)]
        [JsonPropertyName("defender_metal_resist_rate")]
        public int DefenderMetalResistRate { get; set; }

        /// <summary>
        /// Defender bio resist rate bonus
        /// </summary>
        [MemoryPackOrder(14)]
        [JsonPropertyName("defender_bio_resist_rate")]
        public int DefenderBioResistRate { get; set; }

        /// <summary>
        /// Supporter HP rate bonus
        /// </summary>
        [MemoryPackOrder(15)]
        [JsonPropertyName("supporter_hp_rate")]
        public int SupporterHpRate { get; set; }

        /// <summary>
        /// Supporter attack rate bonus
        /// </summary>
        [MemoryPackOrder(16)]
        [JsonPropertyName("supporter_attack_rate")]
        public int SupporterAttackRate { get; set; }

        /// <summary>
        /// Supporter defence rate bonus
        /// </summary>
        [MemoryPackOrder(17)]
        [JsonPropertyName("supporter_defence_rate")]
        public int SupporterDefenceRate { get; set; }

        /// <summary>
        /// Supporter energy resist rate bonus
        /// </summary>
        [MemoryPackOrder(18)]
        [JsonPropertyName("supporter_energy_resist_rate")]
        public int SupporterEnergyResistRate { get; set; }

        /// <summary>
        /// Supporter metal resist rate bonus
        /// </summary>
        [MemoryPackOrder(19)]
        [JsonPropertyName("supporter_metal_resist_rate")]
        public int SupporterMetalResistRate { get; set; }

        /// <summary>
        /// Supporter bio resist rate bonus
        /// </summary>
        [MemoryPackOrder(20)]
        [JsonPropertyName("supporter_bio_resist_rate")]
        public int SupporterBioResistRate { get; set; }
    }
}