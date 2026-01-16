using Microsoft.Extensions.Options;
using NikkeEinkk.Components.Models;

namespace NikkeEinkk.Tests;

public class NikkeDatabaseTests
{
    private static NikkeDatabase CreateDatabase()
    {
        var options = Options.Create(new NikkeDatabaseOptions
        {
            DataPath = "D:/github/nikke-einkk-data/Release/data/global"
        });
        return new NikkeDatabase(options);
    }

    [Fact]
    public void LoadDatabase_ShouldLoadWordRecords()
    {
        // Arrange
        var db = CreateDatabase();

        // Act
        var result = db.LoadDatabase();

        // Assert
        Assert.True(result, "loadDatabase() should return true");
        Assert.True(db.Initialized, "Initialized should be true");
        Assert.True(db.WordRecordTable.Count > 0, "WordRecordTable should have entries");
    }
}
