using NikkeEinkk.Components.Converter;
using NikkeEinkk.Components.Models;
using NikkeEinkk.Components.Models.Enums;
using NikkeEinkk.Components.Models.Hexa;
using NikkeEinkk.Components.Models.Items;
using NikkeEinkk.Components.Models.Nikke;
using NikkeEinkk.Components.Models.Rapture;
using NikkeEinkk.Components.Models.Shop;
using NikkeEinkk.Components.Models.Stage;
using ValueType = NikkeEinkk.Components.Models.Enums.ValueType;

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

        result &= await DeserializeFile<CoverStatEnhanceRecord>(
            inputPath + "CoverStatEnhanceTable" + inputExtension,
            outputPath + "CoverStatEnhanceTable" + outputExtension
        );

        result &= await DeserializeFile<CurrencyData>(
            inputPath + "CurrencyTable" + inputExtension,
            outputPath + "CurrencyTable" + outputExtension
        );

        result &= await DeserializeFile<CustomPackageSlotData>(
            inputPath + "CustomPackageGroupTable" + inputExtension,
            outputPath + "CustomPackageGroupTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(ProductType), (int)item.ProductType))
                {
                    unknownEnums.Add($"New ProductType enum value: {(int)item.ProductType}");
                    item.ProductType = ProductType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<CustomPackageShopData>(
            inputPath + "CustomPackageShopTable" + inputExtension,
            outputPath + "CustomPackageShopTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(BuyLimitType), (int)item.BuyLimitType))
                {
                    unknownEnums.Add($"New ProductType enum value: {(int)item.BuyLimitType}");
                    item.BuyLimitType = BuyLimitType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<FavoriteItemLevelData>(
            inputPath + "FavoriteItemLevelTable" + inputExtension,
            outputPath + "FavoriteItemLevelTable" + outputExtension
        );

        result &= await DeserializeFile<FavoriteItemData>(
            inputPath + "FavoriteItemTable" + inputExtension,
            outputPath + "FavoriteItemTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(FavoriteItemType), (int)item.FavoriteType))
                {
                    unknownEnums.Add($"New FavoriteItemType enum value: {(int)item.FavoriteType}");
                    item.FavoriteType = FavoriteItemType.Unknown;
                }
                if (!Enum.IsDefined(typeof(Rarity), (int)item.FavoriteRare))
                {
                    unknownEnums.Add($"New FavoriteItemType enum value: {(int)item.FavoriteRare}");
                    item.FavoriteRare = Rarity.Unknown;
                }
            }
        );

        result &= await DeserializeFile<FunctionData>(
            inputPath + "FunctionTable" + inputExtension,
            outputPath + "FunctionTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(BuffType), (int)item.BuffType))
                {
                    unknownEnums.Add($"New BuffType enum value: {(int)item.BuffType}");
                    item.BuffType = BuffType.Unknown;
                }
                if (!Enum.IsDefined(typeof(BuffRemoveType), (int)item.BuffRemoveType))
                {
                    unknownEnums.Add($"New BuffRemoveType enum value: {(int)item.BuffRemoveType}");
                    item.BuffRemoveType = BuffRemoveType.Unknown;
                }
                if (!Enum.IsDefined(typeof(FunctionType), (int)item.FunctionType))
                {
                    unknownEnums.Add($"New FunctionType enum value: {(int)item.FunctionType}");
                    item.FunctionType = FunctionType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ValueType), (int)item.FunctionValueType))
                {
                    unknownEnums.Add($"New ValueType enum value: {(int)item.FunctionValueType}");
                    item.FunctionValueType = ValueType.Unknown;
                }
                if (!Enum.IsDefined(typeof(StandardType), (int)item.FunctionStandard))
                {
                    unknownEnums.Add($"New StandardType enum value: {(int)item.FunctionStandard}");
                    item.FunctionStandard = StandardType.Unknown;
                }
                if (!Enum.IsDefined(typeof(DurationType), (int)item.DelayType))
                {
                    unknownEnums.Add($"New DurationType (DelayType) enum value: {(int)item.DelayType}");
                    item.DelayType = DurationType.Unknown;
                }
                if (!Enum.IsDefined(typeof(DurationType), (int)item.DurationType))
                {
                    unknownEnums.Add($"New DurationType enum value: {(int)item.DurationType}");
                    item.DurationType = DurationType.Unknown;
                }
                if (!Enum.IsDefined(typeof(FunctionTargetType), (int)item.FunctionTarget))
                {
                    unknownEnums.Add($"New FunctionTargetType enum value: {(int)item.FunctionTarget}");
                    item.FunctionTarget = FunctionTargetType.Unknown;
                }
                if (!Enum.IsDefined(typeof(TimingTriggerType), (int)item.TimingTriggerType))
                {
                    unknownEnums.Add($"New TimingTriggerType enum value: {(int)item.TimingTriggerType}");
                    item.TimingTriggerType = TimingTriggerType.Unknown;
                }
                if (!Enum.IsDefined(typeof(StandardType), (int)item.TimingTriggerStandard))
                {
                    unknownEnums.Add($"New StandardType (TimingTriggerStandard) enum value: {(int)item.TimingTriggerStandard}");
                    item.TimingTriggerStandard = StandardType.Unknown;
                }
                if (!Enum.IsDefined(typeof(StatusTriggerType), (int)item.StatusTriggerType))
                {
                    unknownEnums.Add($"New StatusTriggerType enum value: {(int)item.StatusTriggerType}");
                    item.StatusTriggerType = StatusTriggerType.Unknown;
                }
                if (!Enum.IsDefined(typeof(StandardType), (int)item.StatusTriggerStandard))
                {
                    unknownEnums.Add($"New StandardType (StatusTriggerStandard) enum value: {(int)item.StatusTriggerStandard}");
                    item.StatusTriggerStandard = StandardType.Unknown;
                }
                if (!Enum.IsDefined(typeof(StatusTriggerType), (int)item.StatusTrigger2Type))
                {
                    unknownEnums.Add($"New StatusTriggerType (StatusTrigger2Type) enum value: {(int)item.StatusTrigger2Type}");
                    item.StatusTrigger2Type = StatusTriggerType.Unknown;
                }
                if (!Enum.IsDefined(typeof(StandardType), (int)item.StatusTrigger2Standard))
                {
                    unknownEnums.Add($"New StandardType (StatusTrigger2Standard) enum value: {(int)item.StatusTrigger2Standard}");
                    item.StatusTrigger2Standard = StandardType.Unknown;
                }
                if (!Enum.IsDefined(typeof(FunctionStatus), (int)item.KeepingType))
                {
                    unknownEnums.Add($"New FunctionStatus enum value: {(int)item.KeepingType}");
                    item.KeepingType = FunctionStatus.Unknown;
                }
                if (!Enum.IsDefined(typeof(ShotFx), (int)item.ShotFxListType))
                {
                    unknownEnums.Add($"New ShotFx enum value: {(int)item.ShotFxListType}");
                    item.ShotFxListType = ShotFx.Unknown;
                }
                if (!Enum.IsDefined(typeof(FxTarget), (int)item.FxTarget01))
                {
                    unknownEnums.Add($"New FxTarget enum value: {(int)item.FxTarget01}");
                    item.FxTarget01 = FxTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(SocketPoint), (int)item.FxSocketPoint01))
                {
                    unknownEnums.Add($"New SocketPoint enum value: {(int)item.FxSocketPoint01}");
                    item.FxSocketPoint01 = SocketPoint.Unknown;
                }
                if (!Enum.IsDefined(typeof(FxTarget), (int)item.FxTarget02))
                {
                    unknownEnums.Add($"New FxTarget enum value: {(int)item.FxTarget02}");
                    item.FxTarget02 = FxTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(SocketPoint), (int)item.FxSocketPoint02))
                {
                    unknownEnums.Add($"New SocketPoint enum value: {(int)item.FxSocketPoint02}");
                    item.FxSocketPoint02 = SocketPoint.Unknown;
                }
                if (!Enum.IsDefined(typeof(FxTarget), (int)item.FxTarget03))
                {
                    unknownEnums.Add($"New FxTarget enum value: {(int)item.FxTarget03}");
                    item.FxTarget03 = FxTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(SocketPoint), (int)item.FxSocketPoint03))
                {
                    unknownEnums.Add($"New SocketPoint enum value: {(int)item.FxSocketPoint03}");
                    item.FxSocketPoint03 = SocketPoint.Unknown;
                }
                if (!Enum.IsDefined(typeof(FxTarget), (int)item.FxTargetFull))
                {
                    unknownEnums.Add($"New FxTarget enum value: {(int)item.FxTargetFull}");
                    item.FxTargetFull = FxTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(SocketPoint), (int)item.FxSocketPointFull))
                {
                    unknownEnums.Add($"New SocketPoint enum value: {(int)item.FxSocketPointFull}");
                    item.FxSocketPointFull = SocketPoint.Unknown;
                }
                if (!Enum.IsDefined(typeof(FxTarget), (int)item.FxTarget01Arena))
                {
                    unknownEnums.Add($"New FxTarget enum value: {(int)item.FxTarget01Arena}");
                    item.FxTarget01Arena = FxTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(SocketPoint), (int)item.FxSocketPoint01Arena))
                {
                    unknownEnums.Add($"New SocketPoint enum value: {(int)item.FxSocketPoint01Arena}");
                    item.FxSocketPoint01Arena = SocketPoint.Unknown;
                }
                if (!Enum.IsDefined(typeof(FxTarget), (int)item.FxTarget02Arena))
                {
                    unknownEnums.Add($"New FxTarget enum value: {(int)item.FxTarget02Arena}");
                    item.FxTarget02Arena = FxTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(SocketPoint), (int)item.FxSocketPoint02Arena))
                {
                    unknownEnums.Add($"New SocketPoint enum value: {(int)item.FxSocketPoint02Arena}");
                    item.FxSocketPoint02Arena = SocketPoint.Unknown;
                }
                if (!Enum.IsDefined(typeof(FxTarget), (int)item.FxTarget03Arena))
                {
                    unknownEnums.Add($"New FxTarget enum value: {(int)item.FxTarget03Arena}");
                    item.FxTarget03Arena = FxTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(SocketPoint), (int)item.FxSocketPoint03Arena))
                {
                    unknownEnums.Add($"New SocketPoint enum value: {(int)item.FxSocketPoint03Arena}");
                    item.FxSocketPoint03Arena = SocketPoint.Unknown;
                }
            }
        );

        result &= await DeserializeFile<InAppShopData>(
            inputPath + "InAppShopManagerTable" + inputExtension,
            outputPath + "InAppShopManagerTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(MainCategoryType), (int)item.MainCategoryType))
                {
                    unknownEnums.Add($"New MainCategoryType enum value: {(int)item.MainCategoryType}");
                    item.MainCategoryType = MainCategoryType.Unknown;
                }
                if (!Enum.IsDefined(typeof(RenewType), (int)item.RenewType))
                {
                    unknownEnums.Add($"New RenewType enum value: {(int)item.RenewType}");
                    item.RenewType = RenewType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ShopType), (int)item.ShopType))
                {
                    unknownEnums.Add($"New ShopType enum value: {(int)item.ShopType}");
                    item.ShopType = ShopType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ShopCategory), (int)item.ShopCategory))
                {
                    unknownEnums.Add($"New ShopCategory enum value: {(int)item.ShopCategory}");
                    item.ShopCategory = ShopCategory.Unknown;
                }
            }
        );

        result &= await DeserializeFile<ConsumeItemData>(
            inputPath + "ItemConsumeTable" + inputExtension,
            outputPath + "ItemConsumeTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(UseConditionType), (int)item.UseConditionType))
                {
                    unknownEnums.Add($"New UseConditionType enum value: {(int)item.UseConditionType}");
                    item.UseConditionType = UseConditionType.Unknown;
                }
                if (!Enum.IsDefined(typeof(UseType), (int)item.UseType))
                {
                    unknownEnums.Add($"New UseType enum value: {(int)item.UseType}");
                    item.UseType = UseType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ItemType), (int)item.ItemType))
                {
                    unknownEnums.Add($"New ItemType enum value: {(int)item.ItemType}");
                    item.ItemType = ItemType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ItemSubType), (int)item.ItemSubType))
                {
                    unknownEnums.Add($"New ItemSubType enum value: {(int)item.ItemSubType}");
                    item.ItemSubType = ItemSubType.Unknown;
                }
                if (!Enum.IsDefined(typeof(Rarity), (int)item.ItemRarity))
                {
                    unknownEnums.Add($"New ItemRarity enum value: {(int)item.ItemRarity}");
                    item.ItemRarity = Rarity.Unknown;
                }
                if (!Enum.IsDefined(typeof(PercentDisplayType), (int)item.PercentDisplayType))
                {
                    unknownEnums.Add($"New PercentDisplayType enum value: {(int)item.PercentDisplayType}");
                    item.PercentDisplayType = PercentDisplayType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<EquipmentData>(
            inputPath + "ItemEquipTable" + inputExtension,
            outputPath + "ItemEquipTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(ItemType), (int)item.ItemType))
                {
                    unknownEnums.Add($"New ItemType enum value: {(int)item.ItemType}");
                    item.ItemType = ItemType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ItemSubType), (int)item.ItemSubType))
                {
                    unknownEnums.Add($"New ItemSubType enum value: {(int)item.ItemSubType}");
                    item.ItemSubType = ItemSubType.Unknown;
                }
                if (!Enum.IsDefined(typeof(EquipItemRarity), (int)item.EquipItemRarity))
                {
                    unknownEnums.Add($"New EquipItemRarity enum value: {(int)item.EquipItemRarity}");
                    item.EquipItemRarity = EquipItemRarity.Unknown;
                }
            }
        );

        result &= await DeserializeFile<HarmonyCubeLevelData>(
            inputPath + "ItemHarmonyCubeLevelTable" + inputExtension,
            outputPath + "ItemHarmonyCubeLevelTable" + outputExtension
        );

        result &= await DeserializeFile<HarmonyCubeData>(
            inputPath + "ItemHarmonyCubeTable" + inputExtension,
            outputPath + "ItemHarmonyCubeTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(ItemType), (int)item.ItemType))
                {
                    unknownEnums.Add($"New ItemType enum value: {(int)item.ItemType}");
                    item.ItemType = ItemType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ItemSubType), (int)item.ItemSubType))
                {
                    unknownEnums.Add($"New ItemSubType enum value: {(int)item.ItemSubType}");
                    item.ItemSubType = ItemSubType.Unknown;
                }
                if (!Enum.IsDefined(typeof(Rarity), (int)item.ItemRare))
                {
                    unknownEnums.Add($"New Rarity enum value: {(int)item.ItemRare}");
                    item.ItemRare = Rarity.Unknown;
                }
                if (!Enum.IsDefined(typeof(NikkeCharacterClass), (int)item.NikkeCharacterClass))
                {
                    unknownEnums.Add($"New NikkeClass enum value: {(int)item.NikkeCharacterClass}");
                    item.NikkeCharacterClass = NikkeCharacterClass.Unknown;
                }
            }
        );

        result &= await DeserializeFile<MaterialItemData>(
            inputPath + "ItemMaterialTable" + inputExtension,
            outputPath + "ItemMaterialTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(ItemType), (int)item.ItemType))
                {
                    unknownEnums.Add($"New ItemType enum value: {(int)item.ItemType}");
                    item.ItemType = ItemType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ItemSubType), (int)item.ItemSubType))
                {
                    unknownEnums.Add($"New ItemSubType enum value: {(int)item.ItemSubType}");
                    item.ItemSubType = ItemSubType.Unknown;
                }
                if (!Enum.IsDefined(typeof(Rarity), (int)item.ItemRarity))
                {
                    unknownEnums.Add($"New Rarity enum value: {(int)item.ItemRarity}");
                    item.ItemRarity = Rarity.Unknown;
                }
                if (!Enum.IsDefined(typeof(MaterialType), (int)item.MaterialType))
                {
                    unknownEnums.Add($"New MaterialType enum value: {(int)item.MaterialType}");
                    item.MaterialType = MaterialType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<PieceItemData>(
            inputPath + "ItemPieceTable" + inputExtension,
            outputPath + "ItemPieceTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(ItemType), (int)item.ItemType))
                {
                    unknownEnums.Add($"New ItemType enum value: {(int)item.ItemType}");
                    item.ItemType = ItemType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ItemSubType), (int)item.ItemSubType))
                {
                    unknownEnums.Add($"New ItemSubType enum value: {(int)item.ItemSubType}");
                    item.ItemSubType = ItemSubType.Unknown;
                }
                if (!Enum.IsDefined(typeof(Rarity), (int)item.ItemRarity))
                {
                    unknownEnums.Add($"New Rarity enum value: {(int)item.ItemRarity}");
                    item.ItemRarity = Rarity.Unknown;
                }
                if (!Enum.IsDefined(typeof(UseType), (int)item.UseType))
                {
                    unknownEnums.Add($"New UseType enum value: {(int)item.UseType}");
                    item.UseType = UseType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<MidasProductData>(
            inputPath + "MidasProductTable" + inputExtension,
            outputPath + "MidasProductTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(ProductItemType), (int)item.ItemType))
                {
                    unknownEnums.Add($"New ProductItemType enum value: {(int)item.ItemType}");
                    item.ItemType = ProductItemType.Currency;
                }
                if (!Enum.IsDefined(typeof(MidasProductType), (int)item.ProductType))
                {
                    unknownEnums.Add($"New MidasProductType enum value: {(int)item.ProductType}");
                    item.ProductType = MidasProductType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<RapturePartData>(
            inputPath + "MonsterPartsTable" + inputExtension,
            outputPath + "MonsterPartsTable" + outputExtension,
            processItem: (mpkItem) =>
            {
                // Fix for known issue in MPK data where some MonsterParts have invalid PartsType
                if (string.IsNullOrWhiteSpace(mpkItem.PartsNameLocalKey))
                {
                    mpkItem.PartsNameLocalKey = null;
                }
                if (string.IsNullOrWhiteSpace(mpkItem.PartsSkin))
                {
                    mpkItem.PartsSkin = null;
                }
                if ((int)mpkItem.PartsType >= Enum.GetValues<PartsType>().Length)
                {
                    unknownEnums.Add($"New PartsType enum value: {(int)mpkItem.PartsType}");
                    mpkItem.PartsType = PartsType.Unknown;
                }
                if ((int)mpkItem.DestroyAnimTrigger >= Enum.GetValues<RaptureDestroyAnimTrigger>().Length)
                {
                    unknownEnums.Add($"New RaptureDestroyAnimTrigger enum value: {(int)mpkItem.DestroyAnimTrigger}");
                    mpkItem.DestroyAnimTrigger = RaptureDestroyAnimTrigger.Unknown;
                }
            }
        );

        result &= await DeserializeFile<RaptureSkillData>(
            inputPath + "MonsterSkillTable" + inputExtension,
            outputPath + "MonsterSkillTable" + outputExtension,
            processItem: (item) =>
            {
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
                if (!Enum.IsDefined(typeof(FireType), (int)item.FireType))
                {
                    unknownEnums.Add($"New FireType enum value: {(int)item.FireType}");
                    item.FireType = FireType.Unknown;
                }
                if (!Enum.IsDefined(typeof(ShotTiming), (int)item.ShotTiming))
                {
                    unknownEnums.Add($"New ShotTiming enum value: {(int)item.ShotTiming}");
                    item.ShotTiming = ShotTiming.Unknown;
                }
                if (!Enum.IsDefined(typeof(WeaponObject), (int)item.WeaponObjectEnum))
                {
                    unknownEnums.Add($"New WeaponObject enum value: {(int)item.WeaponObjectEnum}");
                    item.WeaponObjectEnum = WeaponObject.Unknown;
                }
                if (!Enum.IsDefined(typeof(PreferTarget), (int)item.PreferTarget))
                {
                    unknownEnums.Add($"New PreferTarget enum value: {(int)item.PreferTarget}");
                    item.PreferTarget = PreferTarget.Unknown;
                }
                if (!Enum.IsDefined(typeof(ObjectPositionType), (int)item.ObjectPositionType))
                {
                    unknownEnums.Add($"New ObjectPositionType enum value: {(int)item.ObjectPositionType}");
                    item.ObjectPositionType = ObjectPositionType.Unknown;
                }
                if (!Enum.IsDefined(typeof(SkillAnimationNumber), (int)item.AnimationNumber))
                {
                    unknownEnums.Add($"New SkillAnimationNumber enum value: {(int)item.AnimationNumber}");
                    item.AnimationNumber = SkillAnimationNumber.Unknown;
                }
                if (!Enum.IsDefined(typeof(CancelType), (int)item.CancelType))
                {
                    unknownEnums.Add($"New CancelType enum value: {(int)item.CancelType}");
                    item.CancelType = CancelType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<RaptureStageLevelChangeData>(
            inputPath + "MonsterStageLvChangeTable" + inputExtension,
            outputPath + "MonsterStageLvChangeTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(RaptureStageLevelChangeCondition), (int)item.ConditionType))
                {
                    unknownEnums.Add($"New RaptureStageLevelChangeCondition enum value: {(int)item.ConditionType}");
                    item.ConditionType = RaptureStageLevelChangeCondition.Unknown;
                }
            }
        );

        result &= await DeserializeFile<RaptureStatEnhanceData>(
            inputPath + "MonsterStatEnhanceTable" + inputExtension,
            outputPath + "MonsterStatEnhanceTable" + outputExtension
        );


        result &= await DeserializeFile<RaptureData>(
            inputPath + "MonsterTable" + inputExtension,
            outputPath + "MonsterTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(RaptureUiGrade), (int)item.UiGrade))
                {
                    unknownEnums.Add($"New RaptureUiGrade enum value: {(int)item.UiGrade}");
                    item.UiGrade = RaptureUiGrade.Unknown;
                }
                if (!Enum.IsDefined(typeof(SpawnType), (int)item.FixedSpawnType))
                {
                    unknownEnums.Add($"New SpawnType enum value: {(int)item.FixedSpawnType}");
                    item.FixedSpawnType = SpawnType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<MultiplayerRaidWaveData>(
            inputPath + "MultiRaidTable" + inputExtension,
            outputPath + "MultiRaidTable" + outputExtension
        );

        result &= await DeserializeFile<PackageProductData>(
            inputPath + "PackageGroupTable" + inputExtension,
            outputPath + "PackageGroupTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(ProductType), (int)item.ProductType))
                {
                    unknownEnums.Add($"New ProductType enum value: {(int)item.ProductType}");
                    item.ProductType = ProductType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<PackageListData>(
            inputPath + "PackageListTable" + inputExtension,
            outputPath + "PackageListTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(BuyLimitType), (int)item.BuyLimitType))
                {
                    unknownEnums.Add($"New BuyLimitType enum value: {(int)item.BuyLimitType}");
                    item.BuyLimitType = BuyLimitType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<SkillInfoData>(
            inputPath + "SkillInfoTable" + inputExtension,
            outputPath + "SkillInfoTable" + outputExtension
        );

        result &= await DeserializeFile<SoloRaidWaveData>(
            inputPath + "SoloRaidPresetTable" + inputExtension,
            outputPath + "SoloRaidPresetTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(SoloRaidDifficultyType), (int)item.DifficultyType))
                {
                    unknownEnums.Add($"New SoloRaidDifficultyType enum value: {(int)item.DifficultyType}");
                    item.DifficultyType = SoloRaidDifficultyType.Unknown;
                }
                if (!Enum.IsDefined(typeof(QuickBattleType), (int)item.QuickBattleType))
                {
                    unknownEnums.Add($"New QuickBattleType enum value: {(int)item.QuickBattleType}");
                    item.QuickBattleType = QuickBattleType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<StateEffectData>(
            inputPath + "StateEffectTable" + inputExtension,
            outputPath + "StateEffectTable" + outputExtension
        );

        result &= await DeserializeFile<StepUpPackageData>(
            inputPath + "StepUpPackageListTable" + inputExtension,
            outputPath + "StepUpPackageListTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(BuyLimitType), (int)item.BuyLimitType))
                {
                    unknownEnums.Add($"New BuyLimitType enum value: {(int)item.BuyLimitType}");
                    item.BuyLimitType = BuyLimitType.Unknown;
                }
            }
        );

        List<string> waveDataFiles = [
            "wave_campaign_hard_001",
            "wave_campaign_hard_002",
            "wave_campaign_hard_003",
            "wave_campaign_hard_004",
            "wave_campaign_hard_005",
            "wave_campaign_hard_006",
            "wave_campaign_hard_007",
            "wave_campaign_hard_008",
            "wave_campaign_hard_009",
            "wave_campaign_hard_010",
            "wave_campaign_hard_011",
            "wave_campaign_hard_012",
            "wave_campaign_hard_013",
            "wave_campaign_hard_014",
            "wave_campaign_hard_015",
            "wave_campaign_hard_016",
            "wave_campaign_normal_001",
            "wave_campaign_normal_002",
            "wave_campaign_normal_003",
            "wave_campaign_normal_004",
            "wave_campaign_normal_005",
            "wave_campaign_normal_006",
            "wave_campaign_normal_007",
            "wave_campaign_normal_008",
            "wave_campaign_normal_009",
            "wave_campaign_normal_010",
            "wave_campaign_normal_011",
            "wave_campaign_normal_012",
            "wave_campaign_normal_013",
            "wave_campaign_normal_014",
            "wave_campaign_normal_015",
            "wave_campaign_normal_016",
            "wave_campaign_normal_017",
            "wave_etc_001",
            "wave_eventdungeon_001",
            "wave_eventdungeon_002",
            "wave_eventdungeon_003",
            "wave_eventdungeon_004",
            "wave_eventdungeon_005",
            "wave_eventdungeon_006",
            "wave_eventdungeon_007",
            "wave_eventdungeon_008",
            "wave_eventdungeon_009",
            "wave_eventdungeon_010",
            "wave_eventdungeon_011",
            "wave_eventdungeon_012",
            "wave_eventdungeon_013",
            "wave_eventdungeon_014",
            "wave_eventdungeon_015",
            "wave_eventdungeon_016",
            "wave_eventdungeon_017",
            "wave_eventdungeon_018",
            "wave_eventdungeon_019",
            "wave_eventdungeon_020",
            "wave_eventdungeon_021",
            "wave_eventdungeon_022",
            "wave_eventdungeon_023",
            "wave_eventquest_001",
            "wave_favoriteitem_001",
            "wave_Intercept_001",
            "wave_lostsector_001",
            "wave_lostsector_002",
            "wave_lostsector_003",
            "wave_lostsector_004",
            "wave_lostsector_005",
            "wave_lostsector_006",
            "wave_lostsector_007",
            "wave_lostsector_008",
            "wave_sidestory_001",
            "wave_simulationroom_001",
            "wave_simulationroom_002",
            "wave_simulationroom_003",
            "wave_simulationroom_004",
            "wave_simulationroom_005",
            "wave_test_001",
            "wave_test_002",
            "wave_test_003",
            "wave_test_004",
            "wave_test_005",
            "wave_test_006",
            "wave_tower_default_001",
            "wave_tower_default_002",
            "wave_tower_default_003",
            "wave_tower_default_004",
            "wave_tower_default_005",
            "wave_tower_default_006",
            "wave_tower_default_007",
            "wave_tower_default_008",
            "wave_tower_default_009",
            "wave_tower_default_010",
            "wave_tower_default_011",
            "wave_tower_default_012",
            "wave_tower_default_013",
            "wave_tower_elysion_001",
            "wave_tower_elysion_002",
            "wave_tower_elysion_003",
            "wave_tower_elysion_004",
            "wave_tower_elysion_005",
            "wave_tower_elysion_006",
            "wave_tower_elysion_007",
            "wave_tower_elysion_008",
            "wave_tower_elysion_009",
            "wave_tower_elysion_010",
            "wave_tower_elysion_011",
            "wave_tower_elysion_012",
            "wave_tower_missilis_001",
            "wave_tower_missilis_002",
            "wave_tower_missilis_003",
            "wave_tower_missilis_004",
            "wave_tower_missilis_005",
            "wave_tower_missilis_006",
            "wave_tower_missilis_007",
            "wave_tower_missilis_008",
            "wave_tower_missilis_009",
            "wave_tower_missilis_010",
            "wave_tower_missilis_011",
            "wave_tower_missilis_012",
            "wave_tower_tetra_001",
            "wave_tower_tetra_002",
            "wave_tower_tetra_003",
            "wave_tower_tetra_004",
            "wave_tower_tetra_005",
            "wave_tower_tetra_006",
            "wave_tower_tetra_007",
            "wave_tower_tetra_008",
            "wave_tower_tetra_009",
            "wave_tower_tetra_010",
            "wave_tower_tetra_011",
            "wave_tower_tetra_012",
            "wave_tower_pilgrim_001",
            "wave_tower_pilgrim_002",
            "wave_tower_pilgrim_003",
            "wave_tower_pilgrim_004",
            "wave_tower_pilgrim_005",
            "wave_tower_pilgrim_006",
            "wave_tower_pilgrim_007",
            "wave_tower_pilgrim_008",
            "wave_tower_pilgrim_009",
            "wave_tower_pilgrim_010",
            "wave_tower_pilgrim_011",
            "wave_tower_pilgrim_012"
        ];
        foreach (string table in waveDataFiles) {
            result &= await DeserializeFile<WaveData>(
                inputPath + "WaveDataTable." + table + inputExtension,
                outputPath + "WaveDataTable." + table + outputExtension,
                processItem: (item) =>
                {
                    if (!Enum.IsDefined(typeof(UiTheme), (int)item.UiTheme))
                    {
                        unknownEnums.Add($"New UiTheme enum value: {(int)item.UiTheme}");
                        item.UiTheme = UiTheme.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(SpotMod), (int)item.SpotMod))
                    {
                        unknownEnums.Add($"New SpotMod enum value: {(int)item.SpotMod}");
                        item.SpotMod = SpotMod.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(Theme), (int)item.Theme))
                    {
                        unknownEnums.Add($"New Theme enum value: {(int)item.Theme}");
                        item.Theme = Theme.Unknown;
                    }
                    if (!Enum.IsDefined(typeof(ThemeTime), (int)item.ThemeTime))
                    {
                        unknownEnums.Add($"New ThemeTime enum value: {(int)item.ThemeTime}");
                        item.ThemeTime = ThemeTime.Unknown;
                    }
                }
            );
        }

        result &= await DeserializeFile<OutpostBattleStaticInfo>(
            inputPath + "OutpostBattleTable" + inputExtension,
            outputPath + "OutpostBattleTable" + outputExtension,
            processItem: (item) =>
            {
                for (var i = 0; i < item.OutpostRewardList.Length; i++)
                {
                    var rewardItem = item.OutpostRewardList[i];
                    if (!Enum.IsDefined(typeof(PrepareRewardType), (int)rewardItem.ItemType))
                    {
                        unknownEnums.Add($"New PrepareRewardType enum value: {(int)rewardItem.ItemType} in OutpostBattleStaticInfo ID {item.Id}");
                        rewardItem.ItemType = PrepareRewardType.Unknown;
                    }
                }
            }
        );

        result &= await DeserializeFile<HexaBiosRecord>(
            inputPath + "HexaBiosTable" + inputExtension,
            outputPath + "HexaBiosTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(AttackType), (int)item.Element))
                {
                    unknownEnums.Add($"New AttackType enum value: {(int)item.Element} in HexaBiosTable ID {item.Id}");
                    item.Element = AttackType.Unknown;
                }
                if (string.IsNullOrWhiteSpace(item.Name_localkey))
                {
                    item.Name_localkey = null;
                }
                if (string.IsNullOrWhiteSpace(item.Description_localkey))
                {
                    item.Description_localkey = null;
                }
                if (string.IsNullOrWhiteSpace(item.Resource_id))
                {
                    item.Resource_id = null;
                }
            }
        );

        result &= await DeserializeFile<HexaBiosUndefinedRecord>(
            inputPath + "HexaBiosUndefinedTable" + inputExtension,
            outputPath + "HexaBiosUndefinedTable" + outputExtension,
            processItem: (item) =>
            {
                if (string.IsNullOrWhiteSpace(item.Name_localkey))
                {
                    item.Name_localkey = null;
                }
                if (string.IsNullOrWhiteSpace(item.Description_localkey))
                {
                    item.Description_localkey = null;
                }
                if (string.IsNullOrWhiteSpace(item.Resource_id))
                {
                    item.Resource_id = null;
                }
            }
        );

        result &= await DeserializeFile<HexaBiosOptionRecord>(
            inputPath + "HexaBiosOptionTable" + inputExtension,
            outputPath + "HexaBiosOptionTable" + outputExtension,
            processItem: (item) =>
            {
                if (string.IsNullOrWhiteSpace(item.State_effect_localkey))
                {
                    item.State_effect_localkey = null;
                }
            }
        );

        result &= await DeserializeFile<HexaBiosOptionRandomRecord>(
            inputPath + "HexaBiosOptionRandomTable" + inputExtension,
            outputPath + "HexaBiosOptionRandomTable" + outputExtension
        );

        result &= await DeserializeFile<HexaBlockRecord>(
            inputPath + "HexaBlockTable" + inputExtension,
            outputPath + "HexaBlockTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(HexaBlockDesignType), (int)item.Block_type))
                {
                    unknownEnums.Add($"New HexaBlockDesignType enum value: {(int)item.Block_type} in HexaBlockTable ID {item.Id}");
                    item.Block_type = HexaBlockDesignType.Unknown;
                }
                if (!Enum.IsDefined(typeof(AttackType), (int)item.Element))
                {
                    unknownEnums.Add($"New AttackType enum value: {(int)item.Element} in HexaBlockTable ID {item.Id}");
                    item.Element = AttackType.Unknown;
                }
                if (string.IsNullOrWhiteSpace(item.Name_localkey))
                {
                    item.Name_localkey = null;
                }
                if (string.IsNullOrWhiteSpace(item.Description_localkey))
                {
                    item.Description_localkey = null;
                }
            }
        );

        result &= await DeserializeFile<HexaBlockUndefinedRecord>(
            inputPath + "HexaBlockUndefinedTable" + inputExtension,
            outputPath + "HexaBlockUndefinedTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(HexaBlockDesignType), (int)item.Block_type))
                {
                    unknownEnums.Add($"New HexaBlockDesignType enum value: {(int)item.Block_type} in HexaBlockUndefinedTable ID {item.Id}");
                    item.Block_type = HexaBlockDesignType.Unknown;
                }
            }
        );

        result &= await DeserializeFile<HexaBoardSlotRecord>(
            inputPath + "HexaBoardSlotTable" + inputExtension,
            outputPath + "HexaBoardSlotTable" + outputExtension
        );

        result &= await DeserializeFile<HexaFunctionGroupRecord>(
            inputPath + "HexaFunctionGroupTable" + inputExtension,
            outputPath + "HexaFunctionGroupTable" + outputExtension
        );

        result &= await DeserializeFile<HexaFunctionRecord>(
            inputPath + "HexaFunctionTable" + inputExtension,
            outputPath + "HexaFunctionTable" + outputExtension,
            processItem: (item) =>
            {
                if (!Enum.IsDefined(typeof(HexaBiosFilterType), (int)item.Bios_type))
                {
                    unknownEnums.Add($"New HexaBiosFilterType enum value: {(int)item.Bios_type} in HexaFunctionTable ID {item.Id}");
                    item.Bios_type = HexaBiosFilterType.Unknown;
                }

                if (string.IsNullOrWhiteSpace(item.Resource_id))
                {
                    item.Resource_id = null;
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
