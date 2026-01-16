using System.IO.Compression;
using MemoryPack;
using Microsoft.Extensions.Options;
using NikkeEinkk.Components.Models.Nikke;

namespace NikkeEinkk.Components.Models;

public class NikkeDatabase
{
    private readonly string _dataPath;

    public bool IsGlobal { get; set; } = true;
    public bool Initialized { get; set; } = false;

    public Dictionary<String, List<WordRecord>> WordRecordTable = [];

    public NikkeDatabase(IOptions<NikkeDatabaseOptions> options)
    {
        _dataPath = options.Value.DataPath;
    }

    public bool LoadDatabase()
    {
        var staticDataZipPath = Path.Combine(_dataPath, "StaticData.zip");
        using (var archive = ZipFile.OpenRead(staticDataZipPath))
        {
            var wordRecordEntry = archive.GetEntry("WordTable.mpk");
            if (wordRecordEntry == null) return false;

            using (var entryStream = wordRecordEntry.Open())
            using (var memoryStream = new MemoryStream())
            {
                entryStream.CopyTo(memoryStream);
                var data = memoryStream.ToArray();
                var items = MemoryPackSerializer.Deserialize<WordRecord[]>(data);
                if (items == null) return false;

                WordRecordTable = items
                    .GroupBy(w => w.Group)
                    .ToDictionary(g => g.Key, g => g.ToList());

                Initialized = true;
            }
        }

        return Initialized;
    }
}
