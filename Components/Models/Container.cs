using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
    public partial class JsonTableContainer<TItem>
    {
        [JsonPropertyName("version")]
        public string Version { get; set; } = "0.0.1";

        [JsonPropertyName("records")]
        public TItem[] Records { get; set; } = Array.Empty<TItem>();
    }
}