using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk;

public class TestEnumSerialization
{
    public static void TestSquadEnum()
    {
        // Test the Squad enum with _777
        var testObject = new { squad = Squad._777 };

        var json = JsonConvert.SerializeObject(testObject, Formatting.Indented);

        Console.WriteLine("Serialized JSON:");
        Console.WriteLine(json);

        // Should output: { "squad": "777" }

        // Test deserialization
        var deserialized = JsonConvert.DeserializeObject<dynamic>(json);
        Console.WriteLine($"\nDeserialized squad value: {deserialized.squad}");

        // Test other squad values
        var testObject2 = new { squad = Squad.Counters };
        var json2 = JsonConvert.SerializeObject(testObject2, Formatting.Indented);
        Console.WriteLine($"\nCounters enum: {json2}");
    }
}

