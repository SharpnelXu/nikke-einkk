using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum CounterType
    {
        Unknown = -1,
        None = 0,
        Metal_Type = 1,
        Energy_Type = 2,
        Bio_Type = 3,
    }
}
