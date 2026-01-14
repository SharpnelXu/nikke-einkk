using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum PartsType
{
    Unknown = -1,
    None = 0,
    Arm_Left = 1,
    Arm_Right = 2,
    Head = 3,
    Body_Lower = 4,
    Body_Upper = 5,
    Body = 6,
    Chest = 7,
    Belly = 8,
    Leg_Front_Left = 9,
    Leg_Front_Right = 10,
    Leg_Back_Left = 11,
    Leg_Back_Right = 12,
    Weapon_01 = 13,
    Weapon_02 = 14,
    Weapon_03 = 15,
    Weapon_04 = 16,
    Weapon_05 = 17,
    Weapon_06 = 18,
    Weapon_07 = 19,
    Weapon_08 = 20,
    Weapon_09 = 21,
    Weapon_10 = 22
}
