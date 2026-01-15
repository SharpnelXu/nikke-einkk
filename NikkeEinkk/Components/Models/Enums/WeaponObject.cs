using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum WeaponObject
{
    [JsonProperty("unknown")]
    Unknown = -1,
    [JsonProperty("none")]
    None = 0,
    [JsonProperty("weapon_object_01")]
    Weapon_object_01,
    [JsonProperty("weapon_object_02")]
    Weapon_object_02,
    [JsonProperty("weapon_object_03")]
    Weapon_object_03,
    [JsonProperty("weapon_object_04")]
    Weapon_object_04,
    [JsonProperty("weapon_object_05")]
    Weapon_object_05,
    [JsonProperty("weapon_object_06")]
    Weapon_object_06,
    [JsonProperty("weapon_object_07")]
    Weapon_object_07,
    [JsonProperty("weapon_object_08")]
    Weapon_object_08,
    [JsonProperty("weapon_object_09")]
    Weapon_object_09,
    [JsonProperty("weapon_object_10")]
    Weapon_object_10,
    [JsonProperty("weapon_object_11")]
    Weapon_object_11,
    [JsonProperty("weapon_object_12")]
    Weapon_object_12,
    [JsonProperty("weapon_object_13")]
    Weapon_object_13,
    [JsonProperty("weapon_object_14")]
    Weapon_object_14,
    [JsonProperty("weapon_object_15")]
    Weapon_object_15,
    [JsonProperty("weapon_object_16")]
    Weapon_object_16,
    [JsonProperty("weapon_object_17")]
    Weapon_object_17,
    [JsonProperty("weapon_object_18")]
    Weapon_object_18,
    [JsonProperty("weapon_object_19")]
    Weapon_object_19,
    [JsonProperty("weapon_object_20")]
    Weapon_object_20,
}
