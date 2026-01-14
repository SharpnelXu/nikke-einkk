using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum SpotMod
{
    Unknown = -1,
    None = 0,
    Campaign = 1,
    Arena = 2,
    Survive = 3,
    Defense = 4,
    Destroy = 5,
    Escape = 6,
    Intercept = 7,
    UnionRaid = 8,
    ShootingRange = 9,
    BaseDefense = 10,
    Cooperation = 11,
    Campaign_SD = 12,
    Defense_SD = 13,
    BaseDefense_SD = 14,
    ShootingRange_SD = 15,
    SoloRaid_Common = 16,
    SoloRaid_Trial = 17,
    Campaign_CE002 = 18,
    Cooperation_CE002 = 19,
    UnionRaid_Trial = 20,
    Cabal_MecaShifty = 21,
    Cabal_Shifty = 22,
    Cabal_Syuen = 23,
    SoloRaid_Museum = 24,
    SoloRaid_Museum_Nolimit = 25
}
