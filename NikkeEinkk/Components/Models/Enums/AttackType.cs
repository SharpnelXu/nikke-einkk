using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum AttackType
    {
        Unknown = -1,
        None = 0,
        Energy = 1,
        Bio = 3,
        Metal = 2,
        Fire = 4,
        Water = 5,
        Wind = 6,
        Iron = 7,
        Electronic = 8
    }
}
