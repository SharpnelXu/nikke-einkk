using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums;

[JsonConverter(typeof(StringEnumConverter))]
public enum UseType
{
    Unknown = -1,
    None = 0,
    Char_Exp = 1,
    Currency = 2,
    SelectBox = 3,
    Item = 4,
    SummonCharacter = 5,
    SummonRandomCharacter = 6,
    CurrencyTimeReward = 7,
    BundleBox = 8,
    ItemRandomBox = 9,
    SelectBoxRow = 10,
    SelectBoxRowCharacter = 11,
    EquipCombination = 12,
    MVGGold = 13,
    MVGCore = 14,
    MVGCollectable = 15
}
