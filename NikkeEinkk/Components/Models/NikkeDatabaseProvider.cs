using Microsoft.Extensions.Options;

namespace NikkeEinkk.Components.Models;

public class NikkeDatabaseProvider
{
    public NikkeDatabase Global { get; }
    public NikkeDatabase Cn { get; }

    public NikkeDatabaseProvider(IOptions<NikkeDatabaseOptions> options)
    {
        Global = new NikkeDatabase(options.Value.GlobalDataPath, isGlobal: true);
        Cn = new NikkeDatabase(options.Value.CnDataPath, isGlobal: false);
    }

    public void LoadAll()
    {
        Global.LoadDatabase();
        Cn.LoadDatabase();
    }

    public NikkeDatabase GetDatabase(bool isGlobal) => isGlobal ? Global : Cn;
}

