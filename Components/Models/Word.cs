using MemoryPack;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    /// <summary>
    /// Enum representing the type of resource
    /// </summary>
    public enum ResourceType
    {
        Unknown = 0,
        Image = 1,
        Locale = 2
    }
    
    /// <summary>
    /// JSON converter for ResourceType enum to handle string/int conversion
    /// </summary>
    public class ResourceTypeConverter : JsonConverter<ResourceType>
    {
        public override ResourceType Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            // If the JSON value is a string
            if (reader.TokenType == JsonTokenType.String)
            {
                string value = reader.GetString() ?? string.Empty;
                return value.ToLowerInvariant() switch
                {
                    "image" => ResourceType.Image,
                    "locale" => ResourceType.Locale,
                    _ => ResourceType.Unknown
                };
            }
            
            // If the JSON value is a number
            if (reader.TokenType == JsonTokenType.Number)
            {
                int value = reader.GetInt32();
                return value switch
                {
                    1 => ResourceType.Image,
                    2 => ResourceType.Locale,
                    _ => ResourceType.Unknown
                };
            }
            
            return ResourceType.Unknown;
        }
        
        public override void Write(Utf8JsonWriter writer, ResourceType value, JsonSerializerOptions options)
        {
            // Write as string values in JSON for better readability
            string stringValue = value switch
            {
                ResourceType.Image => "image",
                ResourceType.Locale => "locale",
                _ => "unknown"
            };
            
            writer.WriteStringValue(stringValue);
        }
    }
    /// <summary>
    /// Represents a record in the WordTable
    /// </summary>
    [MemoryPackable]
    public partial class Word
    {
        /// <summary>
        /// Unique identifier for the word
        /// </summary>
        [MemoryPackOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        /// <summary>
        /// Group identifier
        /// </summary>
        [MemoryPackOrder(1)]
        [JsonPropertyName("group")]
        public string Group { get; set; } = string.Empty;

        /// <summary>
        /// Page number in the word table
        /// </summary>
        [MemoryPackOrder(2)]
        [JsonPropertyName("page_number")]
        public int PageNumber { get; set; }

        /// <summary>
        /// Order within the page/group
        /// </summary>
        [MemoryPackOrder(3)]
        [JsonPropertyName("order")]
        public int Order { get; set; }

        /// <summary>
        /// Type of resource (image, locale, etc.)
        /// </summary>
        [MemoryPackOrder(4)]
        [JsonPropertyName("resource_type")]
        [JsonConverter(typeof(ResourceTypeConverter))]
        [MemoryPackAllowSerialize]
        public ResourceType ResourceType { get; set; } = ResourceType.Unknown;

        /// <summary>
        /// Value of the resource
        /// </summary>
        [MemoryPackOrder(5)]
        [JsonPropertyName("resource_value")]
        public string ResourceValue { get; set; } = string.Empty;
    }
}