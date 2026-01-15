using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum Corporation
    {
        Unknown = -1,
        None = 0,
        ELYSION = 1,
        MISSILIS = 2,
        TETRA = 3,
        PILGRIM = 4,
        ALL = 5,
        RANDOM = 6,
        ABNORMAL = 7
    }
}
