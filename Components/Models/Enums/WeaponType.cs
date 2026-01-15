using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum WeaponType
    {
        Unknown = -1,
        None = 0,
        AR = 1,
        RL = 2,
        SR = 3,
        MG = 4,
        SG = 5,
        AS = 6,
        GL = 7,
        PS = 8,
        SMG = 9
    }
}
