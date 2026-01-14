using MemoryPack;
using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class JsonTableContainer<TItem>
    {
        [JsonProperty("version")]
        public string Version { get; set; } = "0.0.1";

        [JsonProperty("records")]
        public TItem[] Records { get; set; } = Array.Empty<TItem>();
    }
}