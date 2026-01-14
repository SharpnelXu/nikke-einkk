using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class CharacterStat
    {
        [MemoryPackOrder(0)]
        [JsonPropertyName("id")]
        [JsonPropertyOrder(0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyName("group")]
        [JsonPropertyOrder(1)]
        public int Group { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyName("level")]
        [JsonPropertyOrder(2)]
        public int Level { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyName("level_hp")]
        [JsonPropertyOrder(3)]
        public long LevelHp { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyName("level_attack")]
        [JsonPropertyOrder(4)]
        public int LevelAttack { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyName("level_defence")]
        [JsonPropertyOrder(5)]
        public int LevelDefence { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyName("level_energy_resist")]
        [JsonPropertyOrder(6)]
        public int LevelEnergyResist { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyName("level_metal_resist")]
        [JsonPropertyOrder(7)]
        public int LevelMetalResist { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyName("level_bio_resist")]
        [JsonPropertyOrder(8)]
        public int LevelBioResist { get; set; }
    }
}