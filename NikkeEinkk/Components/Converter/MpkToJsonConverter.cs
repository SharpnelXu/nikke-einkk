using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models;

namespace NikkeEinkk.Components.Converter;

public static class MpkToJsonConverter
{
    public static async Task<TableContainer<TItem>> ConvertMpkToJsonAsync<TItem>(
        string inputPath,
        string? outputPath = null,
        Action<TItem>? processItem = null)
    {
        // Read all bytes from the .mpk file
        var bytes = await File.ReadAllBytesAsync(inputPath);
        var container = new TableContainer<TItem>();

        try
        {
            var items = MemoryPackSerializer.Deserialize<TItem[]>(bytes);
            if (items != null)
            {
                if (processItem != null)
                {
                    foreach (var item in items)
                    {
                        processItem(item);
                    }
                }

                container.Records = items;
            }
            else
            {
                throw new InvalidOperationException($"Failed to deserialize MPK as {typeof(TItem).Name}[]");
            }
        }
        catch (Exception ex)
        {
            throw new InvalidOperationException("Error deserializing MPK file", ex);
        }

        // If outputPath is provided, save the result as JSON
        if (!string.IsNullOrEmpty(outputPath))
        {
            var jsonString = JsonConvert.SerializeObject(container, Formatting.Indented);
            await File.WriteAllTextAsync(outputPath, jsonString);
        }

        return container;
    }
}
