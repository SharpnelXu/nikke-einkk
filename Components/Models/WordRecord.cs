using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class WordRecord
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("group")]
        public string Group { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("page_number")]
        public int PageNumber { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("order")]
        public int Order { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("resource_type")]
        [MemoryPackAllowSerialize]
        public ResourceType ResourceType { get; set; } = ResourceType.Unknown;

        [MemoryPackOrder(5)]
        [JsonProperty("resource_value")]
        public string ResourceValue { get; set; } = string.Empty;
    }
}
