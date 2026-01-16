namespace NikkeEinkk.Components.Models;

public class NikkeDatabaseOptions
{
    public const string SectionName = "NikkeDatabase";

    public string GlobalDataPath { get; set; } = string.Empty;
    public string CnDataPath { get; set; } = string.Empty;
}

