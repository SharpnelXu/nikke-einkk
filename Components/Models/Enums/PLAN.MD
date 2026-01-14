# PLAN

Read the file and do the following:
1. If the first object is an enum, move the enum into Enum folder under `namespace NikkeEinkk.Components.Models.Enums`
2. Remove the enum in the original file.
3. Import `namespace NikkeEinkk.Components.Models.Enums` in the original file if not already.
4. Repeat for a max of three enums in the file.

E.g.

```csharp
namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter), typeof(CamelCaseNamingStrategy))]
    public enum ResourceType
    {
        Unknown = 0,
        Image = 1,
        Locale = 2
    }
}
```

```csharp
namespace NikkeEinkk.Components.Models.Enums

[JsonConverter(typeof(StringEnumConverter))]
public enum Rarity
{
    Unknown = -1,
    SSR = 3,
    SR = 2,
    R = 1
}
```
