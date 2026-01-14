using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Nikke
{
    [MemoryPackable]
    public partial class CoverStatEnhanceRecord
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("lv", Order = 1)]
        public int Level { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("level_hp", Order = 2)]
        public long LevelHp { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("level_defence", Order = 3)]
        public int LevelDefence { get; set; }
    }
}
