using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum CorporationSubType
    {
        Unknown = -1,
        NORMAL = 0,
        OVERSPEC = 1,
    }
}
