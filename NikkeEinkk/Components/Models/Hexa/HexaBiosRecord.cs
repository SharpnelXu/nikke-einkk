using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models.Hexa
{
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosRecord
    {
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; }

        [JsonProperty("bios_group")]
        [MemoryPackOrder(1)]
        public int Bios_group { get; set; }

        [JsonProperty("name_localkey")]
        [MemoryPackOrder(2)]
        public string? Name_localkey { get; set; }

        [JsonProperty("description_localkey")]
        [MemoryPackOrder(3)]
        public string? Description_localkey { get; set; }

        [JsonProperty("resource_id")]
        [MemoryPackOrder(4)]
        public string? Resource_id { get; set; }

        [JsonProperty("bios_rare")]
        [MemoryPackOrder(5)]
        public int Bios_rare { get; set; }

        [JsonProperty("element")]
        [MemoryPackOrder(6)]
        public AttackType Element { get; set; }

        [JsonProperty("main_option")]
        [MemoryPackOrder(7)]
        public int Main_option { get; set; }

        [JsonProperty("sub_01_option")]
        [MemoryPackOrder(8)]
        public int Sub_01_option { get; set; }


        [JsonProperty("sub_02_option")]
        [MemoryPackOrder(9)]
        public int Sub_02_option { get; set; }
    }
}
