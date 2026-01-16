using System.IO.Compression;
using MemoryPack;
using NikkeEinkk.Components.Models.Nikke;

namespace NikkeEinkk.Components.Models;

public class NikkeDatabase(string dataPath, bool isGlobal)
{
    public bool IsGlobal { get; } = isGlobal;
    public bool Initialized { get; set; }

    public Dictionary<int, AttractiveLevelRecord> AttractiveLevelTable = [];
    public Dictionary<string, List<WordRecord>> WordTable = [];

    public bool LoadDatabase()
    {
        var staticDataZipPath = Path.Combine(dataPath, "StaticData.zip");
        using (var archive = ZipFile.OpenRead(staticDataZipPath))
        {
            Initialized = LoadTable<AttractiveLevelRecord>(archive, "AttractiveLevelTable.mpk", ProcessAttractiveLevelRecords);
            Initialized &= LoadTable<WordRecord>(archive, "WordTable.mpk", ProcessWordRecords);
        }

        return Initialized;
    }

    private static bool LoadTable<T>(ZipArchive archive, string entryName, Action<T[]> processItems)
    {
        var entry = archive.GetEntry(entryName);
        if (entry == null) return false;

        using var entryStream = entry.Open();
        using var memoryStream = new MemoryStream();
        entryStream.CopyTo(memoryStream);
        var data = memoryStream.ToArray();
        var items = MemoryPackSerializer.Deserialize<T[]>(data);
        if (items == null) return false;

        processItems(items);

        return true;
    }

    private void ProcessWordRecords(WordRecord[] items)
    {
        WordTable = items
            .GroupBy(record => record.Group)
            .ToDictionary(group => group.Key, group => group.OrderBy(record => record.Order).ToList());
    }

    private void ProcessAttractiveLevelRecords(AttractiveLevelRecord[] items)
    {
        AttractiveLevelTable = items.ToDictionary(record => record.AttractiveLevel, record => record);
    }
}
