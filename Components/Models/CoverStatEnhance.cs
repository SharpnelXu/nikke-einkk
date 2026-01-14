using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    /// <summary>
    /// Represents a record in the CoverStatEnhanceTable
    /// </summary>
    [MemoryPackable]
    public partial class CoverStatEnhance
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
        [JsonPropertyName("lv")]
        [JsonPropertyOrder(1)]
        public int Level { get; set; }

        /// <summary>
        /// Grade HP enhancement value
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyName("level_hp")]
        [JsonPropertyOrder(2)]
        public long LevelHp { get; set; }

        /// <summary>
        /// Grade attack enhancement value
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyName("level_defence")]
        [JsonPropertyOrder(3)]
        public int LevelDefence { get; set; }
    }
}