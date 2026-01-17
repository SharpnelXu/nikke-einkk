using System.IO.Compression;
using MemoryPack;
using NikkeEinkk.Components.Models.Locale;
using NikkeEinkk.Components.Models.Nikke;

namespace NikkeEinkk.Components.Models;

public class NikkeDatabase(string dataPath, bool isGlobal)
{
    public bool IsGlobal { get; } = isGlobal;
    public bool Initialized { get; set; }

    public SortedDictionary<int, AttractiveLevelRecord> AttractiveLevelTable = [];
    public SortedDictionary<int, SortedDictionary<int, NikkeCharacterRecord>> NikkeCharacterTable = [];
    public Dictionary<string, List<WordRecord>> WordTable = [];


    public Dictionary<string, Dictionary<string, Translation>> TranslationTable = [];

    public bool LoadDatabase()
    {
        var staticDataZipPath = Path.Combine(dataPath, "StaticData.zip");
        using (var archive = ZipFile.OpenRead(staticDataZipPath))
        {
            Initialized = LoadTable<AttractiveLevelRecord>(archive, "AttractiveLevelTable.mpk", ProcessAttractiveLevelRecords);
            Initialized &= LoadTable<WordRecord>(archive, "WordTable.mpk", ProcessWordRecords);
            Initialized &= LoadTable<NikkeCharacterRecord>(archive, "CharacterTable.mpk", ProcessNikkeCharacterRecords);
        }

        var localeZipPath = Path.Combine(dataPath, "Locale.zip");
        using (var archive = ZipFile.OpenRead(localeZipPath))
        {
            Initialized &= LoadLocale(archive, "Locale_Character");
        }

        return Initialized;
    }

    private bool LoadLocale(ZipArchive archive, string localeName)
    {
        var entryPath = $"{localeName}/{localeName}.json";
        var entry = archive.GetEntry(entryPath);
        if (entry == null) return false;

        using var entryStream = entry.Open();
        using var streamReader = new StreamReader(entryStream);
        var json = streamReader.ReadToEnd();
        var localeData = Newtonsoft.Json.JsonConvert.DeserializeObject<Translation[]>(json);
        if (localeData == null) return false;

        var translations = localeData.ToDictionary(transl => transl.Key, transl => transl);
        TranslationTable[localeName] = translations;

        return true;
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
        AttractiveLevelTable = new SortedDictionary<int, AttractiveLevelRecord>(
            items.ToDictionary(record => record.AttractiveLevel, record => record));
    }

    private void ProcessNikkeCharacterRecords(NikkeCharacterRecord[] items)
    {
        NikkeCharacterTable.Clear();

        foreach (var record in items)
        {
            if (!NikkeCharacterTable.TryGetValue(record.ResourceId, out var value))
            {
                value = new SortedDictionary<int, NikkeCharacterRecord>();
                NikkeCharacterTable[record.ResourceId] = value;
            }

            value[record.GradeCoreId] = record;
        }
    }
}
