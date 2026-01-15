using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum RaptureUiGrade
{
    Unknown = -1,
    None = 0,
    Selfless = 1,
    Servant = 2,
    Master = 3,
    Lord = 4,
    Tyrant = 5,
    Heretic = 6,
    Queen = 7
}
