using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum DurationType
{
    Unknown = -1,
    TimeSec = 1,
    Shots = 2,
    Battles = 3,
    Hits = 4,
    SkillShots = 5,
    TimeSecBattles = 6,
    OnStun = 7,
    OnRemoveFunction = 8,
    Hits_Ver2 = 9,
    TimeSec_Ver2 = 10,
    TimeSec_Ver3 = 11,
    ReloadAllAmmoCount = 12,
    UncoverableCount = 13,
    ChangeWeaponUseCount = 14,
    None = 0
}
