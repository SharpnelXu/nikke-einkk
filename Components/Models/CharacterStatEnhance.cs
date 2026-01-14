using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    /// <summary>
    /// Represents a record in the CharacterStatEnhanceTable
    /// </summary>
    [MemoryPackable]
    public partial class CharacterStatEnhance
    {
        /// <summary>
        /// Unique identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyName("id")]
        [JsonPropertyOrder(0)]
        public int Id { get; set; }

        /// <summary>
        /// Grade ratio enhancement value
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyName("grade_ratio")]
        [JsonPropertyOrder(1)]
        public int GradeRatio { get; set; }

        /// <summary>
        /// Grade HP enhancement value
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyName("grade_hp")]
        [JsonPropertyOrder(2)]
        public long GradeHp { get; set; }

        /// <summary>
        /// Grade attack enhancement value
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyName("grade_attack")]
        [JsonPropertyOrder(3)]
        public int GradeAttack { get; set; }

        /// <summary>
        /// Grade defence enhancement value
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyName("grade_defence")]
        [JsonPropertyOrder(4)]
        public int GradeDefence { get; set; }

        /// <summary>
        /// Grade energy resist enhancement value
        /// </summary>
        [MemoryPackOrder(5)]
        [JsonPropertyName("grade_energy_resist")]
        [JsonPropertyOrder(5)]
        public int GradeEnergyResist { get; set; }

        /// <summary>
        /// Grade metal resist enhancement value
        /// </summary>
        [MemoryPackOrder(6)]
        [JsonPropertyName("grade_metal_resist")]
        [JsonPropertyOrder(6)]
        public int GradeMetalResist { get; set; }

        /// <summary>
        /// Grade bio resist enhancement value
        /// </summary>
        [MemoryPackOrder(7)]
        [JsonPropertyName("grade_bio_resist")]
        [JsonPropertyOrder(7)]
        public int GradeBioResist { get; set; }

        /// <summary>
        /// Core HP enhancement value
        /// </summary>
        [MemoryPackOrder(8)]
        [JsonPropertyName("core_hp")]
        [JsonPropertyOrder(8)]
        public long CoreHp { get; set; }

        /// <summary>
        /// Core attack enhancement value
        /// </summary>
        [MemoryPackOrder(9)]
        [JsonPropertyName("core_attack")]
        [JsonPropertyOrder(9)]
        public int CoreAttack { get; set; }

        /// <summary>
        /// Core defence enhancement value
        /// </summary>
        [MemoryPackOrder(10)]
        [JsonPropertyName("core_defence")]
        [JsonPropertyOrder(10)]
        public int CoreDefence { get; set; }

        /// <summary>
        /// Core energy resist enhancement value
        /// </summary>
        [MemoryPackOrder(11)]
        [JsonPropertyName("core_energy_resist")]
        [JsonPropertyOrder(11)]
        public int CoreEnergyResist { get; set; }

        /// <summary>
        /// Core metal resist enhancement value
        /// </summary>
        [MemoryPackOrder(12)]
        [JsonPropertyName("core_metal_resist")]
        [JsonPropertyOrder(12)]
        public int CoreMetalResist { get; set; }

        /// <summary>
        /// Core bio resist enhancement value
        /// </summary>
        [MemoryPackOrder(13)]
        [JsonPropertyName("core_bio_resist")]
        [JsonPropertyOrder(13)]
        public int CoreBioResist { get; set; }
    }
}