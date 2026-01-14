using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    /// <summary>
    /// Represents a record in the CharacterStatTable
    /// </summary>
    [MemoryPackable]
    public partial class CharacterStat
    {
        /// <summary>
        /// Unique identifier
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyName("id")]
        [JsonPropertyOrder(0)]
        public int Id { get; set; }

        /// <summary>
        /// Character group identifier
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyName("group")]
        [JsonPropertyOrder(1)]
        public int Group { get; set; }

        /// <summary>
        /// Character level
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyName("level")]
        [JsonPropertyOrder(2)]
        public int Level { get; set; }

        /// <summary>
        /// Level HP stat value
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyName("level_hp")]
        [JsonPropertyOrder(3)]
        public long LevelHp { get; set; }

        /// <summary>
        /// Level attack stat value
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyName("level_attack")]
        [JsonPropertyOrder(4)]
        public int LevelAttack { get; set; }

        /// <summary>
        /// Level defence stat value
        /// </summary>
        [MemoryPackOrder(5)]
        [JsonPropertyName("level_defence")]
        [JsonPropertyOrder(5)]
        public int LevelDefence { get; set; }

        /// <summary>
        /// Level energy resist stat value
        /// </summary>
        [MemoryPackOrder(6)]
        [JsonPropertyName("level_energy_resist")]
        [JsonPropertyOrder(6)]
        public int LevelEnergyResist { get; set; }

        /// <summary>
        /// Level metal resist stat value
        /// </summary>
        [MemoryPackOrder(7)]
        [JsonPropertyName("level_metal_resist")]
        [JsonPropertyOrder(7)]
        public int LevelMetalResist { get; set; }

        /// <summary>
        /// Level bio resist stat value
        /// </summary>
        [MemoryPackOrder(8)]
        [JsonPropertyName("level_bio_resist")]
        [JsonPropertyOrder(8)]
        public int LevelBioResist { get; set; }
    }
}