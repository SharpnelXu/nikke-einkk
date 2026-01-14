using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum ShakeType
    {
        Unknown = -1,
        Fire_AR = 0,
        Fire_MG = 1,
        Fire_SMG = 2,
        Fire_RL = 3,
        Fire_SG = 4,
        Fire_SR = 5,
        Hit_RL = 6,
        CharacterSkillShake01 = 7,
        CharacterSkillShake02 = 8,
        CharacterSkillShake03 = 9,
        CharacterHit = 10,
        MonsterSkillCancel = 11,
        MonsterPartsBroken = 12,
        Monsterlanding = 13
    }
}
