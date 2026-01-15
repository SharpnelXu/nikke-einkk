using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum PreferTargetCondition
    {
        Unknown = -1,
        None = 0,
        ExcludeSelf = 1,
        DestroyCover = 2,
        IncludeNoneTargetLast = 3,
        IncludeNoneTargetNone = 4,
        OnlySG = 5,
        OnlyAR = 6,
        OnlySMG = 7,
        OnlyMG = 8,
        OnlySR = 9,
        OnlyRL = 10,
        BurstStep1 = 11,
        BurstStep2 = 12,
        BurstStep3 = 13,
        OnlyFire = 14,
        OnlyWater = 15,
        OnlyWind = 16,
        OnlyElectronic = 17,
        OnlyIron = 18
    }
}
