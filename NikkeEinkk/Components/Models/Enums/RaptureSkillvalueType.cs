using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum RaptureSkillvalueType
    {
        Unknown = -1,
        None = 0,
        Percent = 1,
        Integer = 2
    }
}
