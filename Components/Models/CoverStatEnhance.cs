using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class CoverStatEnhance
    {
        [MemoryPackOrder(0)]
        [JsonPropertyName("id")]
        [JsonPropertyOrder(0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyName("lv")]
        [JsonPropertyOrder(1)]
        public int Level { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyName("level_hp")]
        [JsonPropertyOrder(2)]
        public long LevelHp { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyName("level_defence")]
        [JsonPropertyOrder(3)]
        public int LevelDefence { get; set; }
    }
}