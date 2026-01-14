using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum EffCategoryType
    {
        Unknown = -1,
        None = 0,
        Air_Attacker = 1,
        Air_Defender = 2,
        Air_Supporter = 3,
        Attacker = 4,
        Defender = 5,
        Supporter = 6,
        Walk = 7,
        Fly = 8
    }
}
