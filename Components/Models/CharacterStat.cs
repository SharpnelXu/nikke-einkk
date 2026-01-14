using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class CharacterStat
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group", Order = 1)]
        public int Group { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("level", Order = 2)]
        public int Level { get; set; }

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
        [JsonProperty("level_energy_resist", Order = 6)]
        public int LevelEnergyResist { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("level_metal_resist", Order = 7)]
        public int LevelMetalResist { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("level_bio_resist", Order = 8)]
        public int LevelBioResist { get; set; }
    }
}