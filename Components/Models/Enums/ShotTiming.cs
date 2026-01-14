using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum ShotTiming
    {
        Unknown = -1,
        None = 0,
        Concurrence = 1,
        Sequence = 2,
        ConcurrenceGroup = 3,
    }
}
