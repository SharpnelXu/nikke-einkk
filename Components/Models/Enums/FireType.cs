using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum FireType
    {
        Unknown = -1,
        None = 0,
        Instant = 1,
        ProjectileCurve = 2,
        ProjectileDirect = 3,
        HomingProjectile = 4,
        MultiTarget = 5,
        Blow = 6,
        Suicide = 7,
        Calling = 8,
        InstantAll = 9,
        InstantNumber = 10,
        ObjectCreate = 11,
        Summon = 12,
        Barrier = 13,
        Range = 14,
        NormalCalling = 15,
        InstantAll_FrontRay = 16,
        StickyProjectileDirect = 17,
        ObjectCreateToDecoy = 18,
        MechaShiftyShot = 19,
        ProjectileCurveV2 = 20
    }
}
