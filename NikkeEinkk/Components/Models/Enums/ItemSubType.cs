using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ItemSubType
{
    Unknown = -1,
    None = 0,
    Module_A = 1,
    Module_B = 2,
    Module_C = 3,
    Module_D = 4,
    Box = 5,
    Char_Material = 6,
    Equip_Material = 7,
    Attack_Equip_Material = 8,
    Defence_Equip_Material = 9,
    Support_Equip_Material = 10,
    AttractiveMaterial = 11,
    CharacterPiece = 12,
    SummonPiece = 13,
    MaterialPiece = 14,
    TimeReward = 15,
    OutpostBuild_Material = 16,
    RecycleRoom_Material = 17,
    HarmonyCube = 18,
    HarmonyCube_Material = 19,
    BundleBox = 20,
    ItemRandomBoxList = 21,
    ItemRandomBoxNormal = 22,
    EventCurrencyMaterial = 23,
    EventTicketMaterial = 24,
    EquipmentOptionMaterial = 25,
    CharacterSkillMaterial = 26,
    SetNickNameMaterial = 27,
    CharacterSkillResetMaterial = 28,
    SynchroSlotOpenMaterial = 29,
    FavoriteMaterial = 30,
    FavoriteTranscendMaterial = 31,
    ProfileCardTicketMaterial = 32,
    ProfileRandomBox = 33,
    EquipmentOptionDisposableFixMaterial = 34,
    EquipCombination = 35,
    EventItem = 36,
    ArcadeItem = 37
}
