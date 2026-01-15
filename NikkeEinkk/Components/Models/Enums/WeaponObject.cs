using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum WeaponObject
{
    [EnumMember(Value = "unknown")]
    Unknown = -1,
    [EnumMember(Value = "none")]
    None = 0,
    [EnumMember(Value = "weapon_object_01")]
    Weapon_object_01,
    [EnumMember(Value = "weapon_object_02")]
    Weapon_object_02,
    [EnumMember(Value = "weapon_object_03")]
    Weapon_object_03,
    [EnumMember(Value = "weapon_object_04")]
    Weapon_object_04,
    [EnumMember(Value = "weapon_object_05")]
    Weapon_object_05,
    [EnumMember(Value = "weapon_object_06")]
    Weapon_object_06,
    [EnumMember(Value = "weapon_object_07")]
    Weapon_object_07,
    [EnumMember(Value = "weapon_object_08")]
    Weapon_object_08,
    [EnumMember(Value = "weapon_object_09")]
    Weapon_object_09,
    [EnumMember(Value = "weapon_object_10")]
    Weapon_object_10,
    [EnumMember(Value = "weapon_object_11")]
    Weapon_object_11,
    [EnumMember(Value = "weapon_object_12")]
    Weapon_object_12,
    [EnumMember(Value = "weapon_object_13")]
    Weapon_object_13,
    [EnumMember(Value = "weapon_object_14")]
    Weapon_object_14,
    [EnumMember(Value = "weapon_object_15")]
    Weapon_object_15,
    [EnumMember(Value = "weapon_object_16")]
    Weapon_object_16,
    [EnumMember(Value = "weapon_object_17")]
    Weapon_object_17,
    [EnumMember(Value = "weapon_object_18")]
    Weapon_object_18,
    [EnumMember(Value = "weapon_object_19")]
    Weapon_object_19,
    [EnumMember(Value = "weapon_object_20")]
    Weapon_object_20,
}
