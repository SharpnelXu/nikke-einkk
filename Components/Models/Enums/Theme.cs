using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum Theme
{
    Unknown = -1,
    None = 0,
    CityForest = 1,
    CityForestUnder = 2,
    CityForestmbg002 = 3,
    Desert = 4,
    Desertmbg001 = 5,
    GreatHole = 6,
    IceLand = 7,
    Wasteland = 8,
    ArcCity = 9,
    ArcOut = 10,
    ArcLAB = 11,
    Tower = 12,
    MissilesTower = 13,
    ElysionTower = 14,
    TetraTower = 15,
    PilgrimTower = 16,
    VillageCity = 17,
    VillageOut = 18,
    Gravedigger = 19,
    Stormbringer = 20,
    Lostsector = 21,
    NormalArena = 22,
    SpecialArena = 23,
    ChampionArena = 24,
    Volcano = 25,
    ArkCityDay = 26,
    Ocean = 27,
    Oceanbbg004 = 28,
    Simulation = 29,
    RedOcean = 30,
    RedOceanFarSea = 31,
    SwamplandJungle = 32,
    Surface = 33,
    MotherwhaleField = 34,
    WhiteArkcity = 35
}
