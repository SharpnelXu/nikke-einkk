using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum StatType
{
    Unknown = -1,
    Atk = 1,
    Defence = 3,
    Hp = 2,
    None = 0,
    EnergyResist = 4,
    MetalResist = 5,
    BioResist = 6
}
