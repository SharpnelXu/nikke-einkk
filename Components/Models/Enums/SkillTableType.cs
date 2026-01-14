using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum SkillTableType
    {
        Unknown = -1,
        None = 0,
        StateEffect = 1,
        CharacterSkill = 2
    }
}
