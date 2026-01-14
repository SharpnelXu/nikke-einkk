using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum UiTheme
{
    Unknown = -1,
    None = 0,
    CE002 = 1,
    CE004 = 2,
    CE006 = 3,
    CE007 = 4
}
