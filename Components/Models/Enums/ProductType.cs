using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum ProductType
{
    Unknown = -1,
    None = 0,
    User_exp = 1,
    Char_exp = 2,
    Currency = 3,
    Character = 4,
    Item = 5,
    Frame = 6,
    AttractivePoint = 7,
    Bgm = 8,
    Point = 9,
    LiveWallpaper = 10,
    Memorial = 11,
    CharacterCostume = 12,
    ItemRandom = 13,
    InfraCoreExp = 14,
    ItemRandomBox = 15,
    Equipment_None = 16,
    Equipment_MISSILIS = 17,
    Equipment_ELYSION = 18,
    Equipment_TETRA = 19,
    Equipment_PILGRIM = 20,
    Equipment_Random_01 = 21,
    Equipment_Random_02 = 22,
    Equipment_Random_03 = 23,
    PassPoint = 41,
    Equipment_ABNORMAL = 42,
    FavoriteItem = 43,
    ProfileCardObject = 44,
    ProfileRandomBox = 45,
    UserTitle = 46,
    LobbyDecoBackground = 47,
    SurfaceCurrency = 48,
    SurfaceItem = 49,
    HexaBios = 50,
    HexaBiosUndefined = 51,
    HexaBlock = 52,
    HexaBlockUndefined = 53
}
