using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum BuffType
{
    Etc = 2,
    Buff = 0,
    BuffEtc = 3,
    DeBuff = 1,
    DebuffEtc = 4,
    Unknown = -1
}
