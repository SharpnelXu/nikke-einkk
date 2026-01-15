using NikkeEinkk.Components.Converter;
using NikkeEinkk.Components.Models.Enums;
using NikkeEinkk.Components.Models.Nikke;
using NikkeEinkk.Components.Models.Stage;

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
        Console.WriteLine();

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

        result &= await DeserializeFile<UnionRaidWaveData>(
            inputPath + "UnionRaidPresetTable" + inputExtension,
            outputPath + "UnionRaidPresetTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(UnionRaidDifficultyType), (int)item.DifficultyType))
                {
                    unknownEnums.Add($"New UnionRaidDifficultyType enum value: {(int)item.DifficultyType}");
                    item.DifficultyType = UnionRaidDifficultyType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<AttractiveLevelRecord>(
            inputPath + "AttractiveLevelTable" + inputExtension,
            outputPath + "AttractiveLevelTable" + outputExtension
        );

        result &= await DeserializeFile<NikkeCharacterStatEnhanceRecord>(
            inputPath + "CharacterStatEnhanceTable" + inputExtension,
            outputPath + "CharacterStatEnhanceTable" + outputExtension
        );

        result &= await DeserializeFile<NikkeWeaponRecord>(
            inputPath + "CharacterShotTable" + inputExtension,
            outputPath + "CharacterShotTable" + outputExtension,
            processItem: (item) =>
            {
                // Ensure optional fields are null if empty
                if (string.IsNullOrWhiteSpace(item.HomingScript))
                {
                    item.HomingScript = null;
                }
                if (string.IsNullOrWhiteSpace(item.AimPrefab))
                {
                    item.AimPrefab = null;
                }
                if (!Enum.IsDefined(typeof(WeaponType), (int)item.WeaponType))
                {
                    unknownEnums.Add($"New WeaponType enum value: {(int)item.WeaponType}");
                    item.WeaponType = WeaponType.Unknown;
                }
                if (!Enum.IsDefined(typeof(AttackType), (int)item.AttackType))
                {
                    unknownEnums.Add($"New AttackType enum value: {(int)item.AttackType}");
                    item.AttackType = AttackType.Unknown;
                }
                if (!Enum.IsDefined(typeof(CounterType), (int)item.CounterEnermy))
                {
                    unknownEnums.Add($"New CounterType enum value: {(int)item.CounterEnermy}");
                    item.CounterEnermy = CounterType.Unknown;
                }
                if (!Enum.IsDefined(typeof(PreferTarget), (int)item.PreferTarget))
                {
                    unknownEnums.Add($"New PreferTarget enum value: {(int)item.PreferTarget}");
                    item.PreferTarget = PreferTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(PreferTargetCondition), (int)item.PreferTargetCondition))
                {
                    unknownEnums.Add($"New PreferTargetCondition enum value: {(int)item.PreferTargetCondition}");
                    item.PreferTargetCondition = PreferTargetCondition.Unknown;
                }
                if (!Enum.IsDefined(typeof(FireType), (int)item.FireType))
                {
                    unknownEnums.Add($"New FireType enum value: {(int)item.FireType}");
                    item.FireType = FireType.Unknown;
                }
                if (!Enum.IsDefined(typeof(InputType), (int)item.InputType))
                {
                    unknownEnums.Add($"New InputType enum value: {(int)item.InputType}");
                    item.InputType = InputType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ShakeType), (int)item.ShakeType))
                {
                    unknownEnums.Add($"New ShakeType enum value: {(int)item.ShakeType}");
                    item.ShakeType = ShakeType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<NikkeCharacterSkillData>(
                inputPath + "CharacterSkillTable" + inputExtension,
                outputPath + "CharacterSkillTable" + outputExtension,
                processItem: (item) =>
                {
                    // Ensure optional fields are null if empty
                    if (string.IsNullOrWhiteSpace(item.ResourceName))
                    {
                        item.ResourceName = null;
                    }
                    if (!Enum.IsDefined(typeof(AttackType), (int)item.AttackType))
                    {
                        unknownEnums.Add($"New AttackType enum value: {(int)item.AttackType}");
                        item.AttackType = AttackType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(CounterType), (int)item.CounterType))
                    {
                        unknownEnums.Add($"New CounterType enum value: {(int)item.CounterType}");
                        item.CounterType = CounterType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(PreferTarget), (int)item.PreferTarget))
                    {
                        unknownEnums.Add($"New PreferTarget enum value: {(int)item.PreferTarget}");
                        item.PreferTarget = PreferTarget.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(PreferTargetCondition), (int)item.PreferTargetCondition))
                    {
                        unknownEnums.Add($"New PreferTargetCondition enum value: {(int)item.PreferTargetCondition}");
                        item.PreferTargetCondition = PreferTargetCondition.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(CharacterSkillType), (int)item.SkillType))
                    {
                        unknownEnums.Add($"New CharacterSkillType enum value: {(int)item.SkillType}");
                        item.SkillType = CharacterSkillType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(DurationType), (int)item.DurationType))
                    {
                        unknownEnums.Add($"New DurationType enum value: {(int)item.DurationType}");
                        item.DurationType = DurationType.Unknown;
                    }
                }
            );

            result &= await DeserializeFile<NikkeCharacterStatRecord>(
                inputPath + "CharacterStatTable" + inputExtension,
                outputPath + "CharacterStatTable" + outputExtension
            );

            result &= await DeserializeFile<NikkeCharacterRecord>(
                inputPath + "CharacterTable" + inputExtension,
                outputPath + "CharacterTable" + outputExtension,
                processItem: (item) =>
                {
                    if (!Enum.IsDefined(typeof(Rarity), (int)item.OriginalRare))
                    {
                        unknownEnums.Add($"New Rarity enum value: {(int)item.OriginalRare}");
                        item.OriginalRare = Rarity.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(NikkeCharacterClass), (int)item.NikkeCharacterClass))
                    {
                        unknownEnums.Add($"New NikkeCharacterClass enum value: {(int)item.NikkeCharacterClass}");
                        item.NikkeCharacterClass = NikkeCharacterClass.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(BurstStep), (int)item.UseBurstSkill))
                    {
                        unknownEnums.Add($"New BurstStep enum value: {(int)item.UseBurstSkill}");
                        item.UseBurstSkill = BurstStep.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(BurstStep), (int)item.ChangeBurstStep))
                    {
                        unknownEnums.Add($"New BurstStep enum value: {(int)item.ChangeBurstStep}");
                        item.ChangeBurstStep = BurstStep.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(EffCategoryType), (int)item.EffCategoryType))
                    {
                        unknownEnums.Add($"New EffCategoryType enum value: {(int)item.EffCategoryType}");
                        item.EffCategoryType = EffCategoryType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(EffCategoryType), (int)item.CategoryType1))
                    {
                        unknownEnums.Add($"New EffCategoryType enum value: {(int)item.CategoryType1}");
                        item.CategoryType1 = EffCategoryType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(EffCategoryType), (int)item.CategoryType2))
                    {
                        unknownEnums.Add($"New EffCategoryType enum value: {(int)item.CategoryType2}");
                        item.CategoryType2 = EffCategoryType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(EffCategoryType), (int)item.CategoryType3))
                    {
                        unknownEnums.Add($"New EffCategoryType enum value: {(int)item.CategoryType3}");
                        item.CategoryType3 = EffCategoryType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(Corporation), (int)item.Corporation))
                    {
                        unknownEnums.Add($"New Corporation enum value: {(int)item.Corporation}");
                        item.Corporation = Corporation.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(CorporationSubType), (int)item.CorporationSubType))
                    {
                        unknownEnums.Add($"New CorporationSubType enum value: {(int)item.CorporationSubType}");
                        item.CorporationSubType = CorporationSubType.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(Squad), (int)item.Squad))
                    {
                        unknownEnums.Add($"New Squad enum value: {(int)item.Squad}");
                        item.Squad = Squad.Unknown;
                    }
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
        var fileName = inputPath.Substring(inputPath.LastIndexOf('\\') + 1);
        try
        {
            var records = await MpkToJsonConverter.ConvertMpkToJsonAsync(
                inputPath,
                outputPath,
                processItem
            );
            var result = records.Records.Length > 0;
            Console.WriteLine(result
                ? $"✓ Successfully converted {fileName} with {records.Records.Length} records."
                : $"✗ Failed to convert {fileName}.");
            return result;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error processing file {inputPath}: {ex.Message}");
            return false;
        }
    }
}
