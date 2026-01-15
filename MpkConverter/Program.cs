using NikkeEinkk.Components.Converter;
using NikkeEinkk.Components.Models.Enums;
using NikkeEinkk.Components.Models.Nikke;

namespace MpkConverter;

public class Program
{
    static async Task Main(string[] args)
    {
        var inputPath = ".\\";
        var outputPath = ".\\";

        if (args.Length >= 1)
        {
            inputPath = args[0];
            if (args.Length >= 2)
            {
                outputPath = args[1];
            }
        }

        Console.WriteLine($"Input path: {inputPath}");
        Console.WriteLine($"Output path: {outputPath}");

        await DeserializeFiles(inputPath, outputPath);
    }

    private static async Task DeserializeFiles(string inputPath, string outputPath)
    {
        const string inputExtension = ".mpk";
        const string outputExtension = ".json";
        var result = true;
        HashSet<string> unknownEnums = [];
        result &= await DeserializeFile<WordRecord>(
            inputPath + "WordTable" + inputExtension,
            outputPath + "WordTable" + outputExtension,
            processItem: item =>
            {
                if (Enum.IsDefined(typeof(ResourceType), (int)item.ResourceType)) return;
                unknownEnums.Add($"New ResourceType enum value: {(int)item.ResourceType}");
                item.ResourceType = ResourceType.Unknown;
            }
        );

        if (unknownEnums.Count > 0)
        {
            Console.WriteLine();
            Console.WriteLine("=== Unknown Enum Values Detected ===");
            foreach (var warning in unknownEnums)
            {
                Console.WriteLine(warning);
            }
            Console.WriteLine("====================================");
        }
        // Print summary
        Console.WriteLine();
        Console.WriteLine("===========================================");
        Console.WriteLine(result
            ? "✓ All tables converted successfully!"
            : "✗ Some tables failed conversion. Check the output above for details.");
        Console.WriteLine("===========================================");
    }

    private static async Task<bool> DeserializeFile<TItem>(
        string inputPath,
        string? outputPath = null,
        Action<TItem>? processItem = null
    )
    {
        try
        {
            var records = await MpkToJsonConverter.ConvertMpkToJsonAsync(
                inputPath,
                outputPath,
                processItem
            );
            return records.Records.Length > 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error processing file {inputPath}: {ex.Message}");
            return false;
        }
    }
}
