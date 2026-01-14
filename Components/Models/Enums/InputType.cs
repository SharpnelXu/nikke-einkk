using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum InputType
    {
        Unknown = -1,
        NONE = 0,
        DOWN = 1,
        UP = 2,
        DOWN_Charge = 3
    }
}
