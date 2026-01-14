using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum Rarity
    {
        Unknown = -1,
        SSR = 3,
        SR = 2,
        R = 1
    }
}
