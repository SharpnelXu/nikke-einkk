using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    public partial class JsonTableContainer<TItem>
    {
        /// <summary>
        /// Version of the word table format
        /// </summary>
        [JsonPropertyName("version")]
        public string Version { get; set; } = "0.0.1";

        /// <summary>
        /// Collection of word records
        /// </summary>
        [JsonPropertyName("records")]
        public TItem[] Records { get; set; } = Array.Empty<TItem>();
    }
}