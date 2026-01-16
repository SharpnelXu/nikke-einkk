using NikkeEinkk.Components.Models;

namespace NikkeEinkk.Tests;

public class NikkeDatabaseTests
{
    private const string GlobalDataPath = "D:/github/nikke-einkk-data/Release/data/global";
    private const string CnDataPath = "D:/github/nikke-einkk-data/Release/data/cn";

    [Fact]
    public void LoadDatabase_Global_ShouldLoadWordRecords()
    {
        // Arrange
        var db = new NikkeDatabase(GlobalDataPath, isGlobal: true);

        // Act
        var result = db.LoadDatabase();

        // Assert
        Assert.True(result, "LoadDatabase() should return true");
        Assert.True(db.Initialized, "Initialized should be true");
        Assert.True(db.IsGlobal, "IsGlobal should be true");
        Assert.True(db.WordTable.Count > 0, "WordTable should have entries");
        Assert.True(db.AttractiveLevelTable.Count > 0, "AttractiveLevelTable should have entries");
    }
}
