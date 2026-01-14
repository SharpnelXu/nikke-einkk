using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum ItemType
    {
        Unknown = -1,
        None = 0,
        Equip = 1,
        Consume = 2,
        Material = 3,
        Piece = 4,
        HarmonyCube = 5
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum EquipItemRarity
    {
        Unknown = -1,
        None = 0,
        T1 = 1,
        T2 = 2,
        T3 = 3,
        T4 = 4,
        T5 = 5,
        T6 = 6,
        T7 = 7,
        T8 = 8,
        T9 = 9,
        T10 = 10
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ItemSubType
    {
        Unknown = -1,
        None = 0,
        Module_A = 1,
        Module_B = 2,
        Module_C = 3,
        Module_D = 4,
        Box = 5,
        Char_Material = 6,
        Equip_Material = 7,
        Attack_Equip_Material = 8,
        Defence_Equip_Material = 9,
        Support_Equip_Material = 10,
        AttractiveMaterial = 11,
        CharacterPiece = 12,
        SummonPiece = 13,
        MaterialPiece = 14,
        TimeReward = 15,
        OutpostBuild_Material = 16,
        RecycleRoom_Material = 17,
        HarmonyCube = 18,
        HarmonyCube_Material = 19,
        BundleBox = 20,
        ItemRandomBoxList = 21,
        ItemRandomBoxNormal = 22,
        EventCurrencyMaterial = 23,
        EventTicketMaterial = 24,
        EquipmentOptionMaterial = 25,
        CharacterSkillMaterial = 26,
        SetNickNameMaterial = 27,
        CharacterSkillResetMaterial = 28,
        SynchroSlotOpenMaterial = 29,
        FavoriteMaterial = 30,
        FavoriteTranscendMaterial = 31,
        ProfileCardTicketMaterial = 32,
        ProfileRandomBox = 33,
        EquipmentOptionDisposableFixMaterial = 34,
        EquipCombination = 35,
        EventItem = 36,
        ArcadeItem = 37
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum StatType
    {
        Unknown = -1,
        Atk = 1,
        Defence = 3,
        Hp = 2,
        None = 0,
        EnergyResist = 4,
        MetalResist = 5,
        BioResist = 6
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum FavoriteItemType
    {
        Unknown = -1,
        None = 0,
        Collection = 1,
        Favorite = 2
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum UseConditionType
    {
        Unknown = -1,
        None = 0,
        MissionClear = 1,
        StageClear = 2,
        Time = 3
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum UseType
    {
        Unknown = -1,
        None = 0,
        Char_Exp = 1,
        Currency = 2,
        SelectBox = 3,
        Item = 4,
        SummonCharacter = 5,
        SummonRandomCharacter = 6,
        CurrencyTimeReward = 7,
        BundleBox = 8,
        ItemRandomBox = 9,
        SelectBoxRow = 10,
        SelectBoxRowCharacter = 11,
        EquipCombination = 12,
        MVGGold = 13,
        MVGCore = 14,
        MVGCollectable = 15
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum PercentDisplayType
    {
        None = 0,
        Percent = 1,
        Random = 2,
        Unknown = -1
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum MaterialType
    {
        Unknown = -1,
        None = 0,
        All = 1,
        Corporation = 2,
        Character = 3,
        Squad = 4,
        FavoriteItem = 5
    }

    [MemoryPackable]
    public partial class EquipmentData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("resource_id", Order = 3)]
        public string ResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("item_type", Order = 4)]
        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(5)]
        [JsonProperty("item_sub_type", Order = 5)]
        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(6)]
        [JsonProperty("class", Order = 6)]
        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;

        [MemoryPackOrder(7)]
        [JsonProperty("item_rare", Order = 7)]
        public EquipItemRarity EquipItemRarity { get; set; } = EquipItemRarity.Unknown;

        [MemoryPackOrder(8)]
        [JsonProperty("grade_core_id", Order = 8)]
        public int GradeCoreId { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("grow_grade", Order = 9)]
        public int GrowGrade { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("stat", Order = 10)]
        public EquipmentStat[] Stat { get; set; } = [];

        [MemoryPackOrder(11)]
        [JsonProperty("option_slot", Order = 11)]
        public OptionSlot[] OptionSlots { get; set; } = [];

        [MemoryPackOrder(12)]
        [JsonProperty("option_cost", Order = 12)]
        public int OptionCost { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("option_change_cost", Order = 13)]
        public int OptionChangeCost { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("option_lock_cost", Order = 14)]
        public int OptionLockCost { get; set; }
    }

    [MemoryPackable]
    public partial class EquipmentStat
    {
        [MemoryPackOrder(0)]
        [JsonProperty("stat_type", Order = 0)]

        public StatType StatType { get; set; } = StatType.None;

        [MemoryPackOrder(1)]
        [JsonProperty("stat_value", Order = 1)]
        public int StatValue { get; set; }
    }

    [MemoryPackable]
    public partial class OptionSlot
    {
        [MemoryPackOrder(0)]
        [JsonProperty("option_slot", Order = 0)]
        public int OptionSlotValue { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("option_slot_success_ratio", Order = 1)]
        public int OptionSlotSuccessRatio { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeSkillGroup
    {
        [MemoryPackOrder(0)]
        [JsonProperty("skill_group_id", Order = 0)]
        public int SkillGroupId { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("location_id", Order = 3)]
        public int LocationId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("location_localkey", Order = 4)]
        public string LocationLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("order", Order = 5)]
        public int Order { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("resource_id", Order = 6)]
        public int ResourceId { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("bg", Order = 7)]
        public string Bg { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonProperty("bg_color", Order = 8)]
        public string BgColor { get; set; } = string.Empty;

        [MemoryPackOrder(9)]
        [JsonProperty("item_type", Order = 9)]

        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(10)]
        [JsonProperty("item_sub_type", Order = 10)]

        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(11)]
        [JsonProperty("item_rare", Order = 11)]

        public Rarity ItemRare { get; set; } = Rarity.R;

        [MemoryPackOrder(12)]
        [JsonProperty("class", Order = 12)]

        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;

        [MemoryPackOrder(13)]
        [JsonProperty("level_enhance_id", Order = 13)]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("harmonycube_skill_group", Order = 14)]
        public HarmonyCubeSkillGroup[] HarmonyCubeSkillGroups { get; set; } = [];
    }

    [MemoryPackable]
    public partial class HarmonyCubeSkillLevel
    {
        [MemoryPackOrder(0)]
        [JsonProperty("skill_level", Order = 0)]
        public int Level { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeStat
    {
        [MemoryPackOrder(0)]
        [JsonProperty("stat_type", Order = 0)]

        public StatType StatType { get; set; } = StatType.None;

        [MemoryPackOrder(1)]
        [JsonProperty("stat_rate", Order = 1)]
        public int Rate { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeLevelData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("level_enhance_id", Order = 1)]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("level", Order = 2)]
        public int Level { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("skill_levels", Order = 3)]
        public HarmonyCubeSkillLevel[] SkillLevels { get; set; } = [];

        [MemoryPackOrder(4)]
        [JsonProperty("material_id", Order = 4)]
        public int MaterialId { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("material_value", Order = 5)]
        public int MaterialValue { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("gold_value", Order = 6)]
        public int GoldValue { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("slot", Order = 7)]
        public int Slot { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("harmonycube_stats", Order = 8)]
        public HarmonyCubeStat[] Stats { get; set; } = [];
    }

    [MemoryPackable]
    public partial class CollectionItemSkillGroup
    {
        [MemoryPackOrder(0)]
        [JsonProperty("collection_skill_id", Order = 0)]
        public int SkillGroupId { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemSkillGroup
    {
        [MemoryPackOrder(0)]
        [JsonProperty("favorite_skill_id", Order = 0)]
        public int SkillId { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("skill_table", Order = 1)]

        public SkillType SkillTable { get; set; } = SkillType.None;

        [MemoryPackOrder(2)]
        [JsonProperty("skill_change_slot", Order = 2)]
        public int SkillChangeSlot { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("icon_resource_id", Order = 3)]
        public string IconResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("img_resource_id", Order = 4)]
        public string ImgResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("prop_resource_id", Order = 5)]
        public string PropResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("order", Order = 6)]
        public int Order { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("favorite_rare", Order = 7)]

        public Rarity FavoriteRare { get; set; } = Rarity.R;

        [MemoryPackOrder(8)]
        [JsonProperty("favorite_type", Order = 8)]

        public FavoriteItemType FavoriteType { get; set; } = FavoriteItemType.Unknown;

        [MemoryPackOrder(9)]
        [JsonProperty("weapon_type", Order = 9)]

        public WeaponType WeaponType { get; set; } = WeaponType.None;

        [MemoryPackOrder(10)]
        [JsonProperty("name_code", Order = 10)]
        public int NameCode { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("max_level", Order = 11)]
        public int MaxLevel { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("level_enhance_id", Order = 12)]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("probability_group", Order = 13)]
        public int ProbabilityGroup { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("collection_skill_group_data", Order = 14)]
        public CollectionItemSkillGroup[] CollectionSkills { get; set; } = [];

        [MemoryPackOrder(15)]
        [JsonProperty("favoriteitem_skill_group_data", Order = 15)]
        public FavoriteItemSkillGroup[] FavoriteItemSkills { get; set; } = [];

        [MemoryPackOrder(16)]
        [JsonProperty("albumcategory_id", Order = 16)]
        public int AlbumCategoryId { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemStat
    {
        [MemoryPackOrder(0)]
        [JsonProperty("stat_type", Order = 0)]

        public StatType StatType { get; set; } = StatType.None;

        [MemoryPackOrder(1)]
        [JsonProperty("stat_value", Order = 1)]
        public int Value { get; set; }
    }

    [MemoryPackable]
    public partial class CollectionItemSkillLevel
    {
        [MemoryPackOrder(0)]
        [JsonProperty("collection_skill_level", Order = 0)]
        public int Level { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemLevelData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("level_enhance_id", Order = 1)]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("grade", Order = 2)]
        public int Grade { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("level", Order = 3)]
        public int Level { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("favoriteitem_stat_data", Order = 4)]
        public FavoriteItemStat[] Stats { get; set; } = [];

        [MemoryPackOrder(5)]
        [JsonProperty("collection_skill_level_data", Order = 5)]
        public CollectionItemSkillLevel[] SkillLevels { get; set; } = [];
    }

    [MemoryPackable]
    public partial class PackageListData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("package_shop_id", Order = 1)]
        public int PackageShopId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("package_order", Order = 2)]
        public int PackageOrder { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("product_id", Order = 3)]
        public int ProductId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("name_localkey", Order = 4)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("description_localkey", Order = 5)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("product_resource_id", Order = 6)]
        public string ProductResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(7)]
        [JsonProperty("buy_limit_type", Order = 7)]
        public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.Account;

        [MemoryPackOrder(8)]
        [JsonProperty("is_limit", Order = 8)]
        public bool IsLimited { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("buy_limit_count", Order = 9)]
        public int BuyLimitCount { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("is_active", Order = 10)]
        public bool IsActive { get; set; }
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ShopCategory
    {
        Unknown = -1,
        JewelShop = 0,
        PackageShop = 1,
        TimeLimitPackageShop = 2,
        RenewPackageShop = 3,
        PopupPackageShop = 4,
        CostumeShop = 5,
        MonthlyAmountShop = 6,
        CampaignPackageShop = 7,
        StepUpPackageShop = 8,
        CustomPackageShop = 10,
        PassCostumeShop = 11
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ProductType
    {
        Unknown = -1,
        None = 0,
        User_exp = 1,
        Char_exp = 2,
        Currency = 3,
        Character = 4,
        Item = 5,
        Frame = 6,
        AttractivePoint = 7,
        Bgm = 8,
        Point = 9,
        LiveWallpaper = 10,
        Memorial = 11,
        CharacterCostume = 12,
        ItemRandom = 13,
        InfraCoreExp = 14,
        ItemRandomBox = 15,
        Equipment_None = 16,
        Equipment_MISSILIS = 17,
        Equipment_ELYSION = 18,
        Equipment_TETRA = 19,
        Equipment_PILGRIM = 20,
        Equipment_Random_01 = 21,
        Equipment_Random_02 = 22,
        Equipment_Random_03 = 23,
        PassPoint = 41,
        Equipment_ABNORMAL = 42,
        FavoriteItem = 43,
        ProfileCardObject = 44,
        ProfileRandomBox = 45,
        UserTitle = 46,
        LobbyDecoBackground = 47,
        SurfaceCurrency = 48,
        SurfaceItem = 49,
        HexaBios = 50,
        HexaBiosUndefined = 51,
        HexaBlock = 52,
        HexaBlockUndefined = 53
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ProductItemType
    {
        Unknown = -1,
        Currency = 0,
        Item = 1
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum MidasProductType
    {
        Unknown = -1,
        None = 0,
        CashShop = 1,
        PackageShop = 2,
        PopupPackageShop = 3,
        PassShop = 4,
        MonthlyAmount = 5,
        CampaignPackageShop = 6,
        EventPassShop = 7,
        CostumeShop = 8,
        CharacterCostume = 9,
        StepUpPackageShop = 10,
        EventInAppShop = 11,
        CustomPackageShop = 12,
        PassCostumeShop = 13
    }


    [JsonConverter(typeof(StringEnumConverter))]
    public enum BuyLimitType
    {
        Unknown = -1,
        None = 0,
        Account = 1,
        Daily = 2,
        Weekly = 3,
        Monthly = 4,
        Renew = 5
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum MainCategoryType
    {
        Unknown = -1,
        PopupPackageTab = 0,
        TimeLimitPackageTab = 1,
        RenewPackageTab = 2,
        CostumeTab = 3,
        CampaignPackageTab = 4,
        MonthlyAmountTab = 5,
        JewelTab = 6,
        PassCostumeTab = 7
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum RenewType
    {
        Unknown = -1,
        None = 0,
        AutoDay = 1,
        AutoWeek = 2,
        AutoMonth = 3,
        EachUser = 4,
        ManualRenew = 5,
        NoRenew = 6
    }

    [JsonConverter(typeof(StringEnumConverter))]
    public enum ShopType
    {
        Unknown = -1,
        InAppShop = 0,
    }

    [MemoryPackable]
    public partial class InAppShopData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("main_category_type", Order = 1)]

        public MainCategoryType MainCategoryType { get; set; } = MainCategoryType.Unknown;

        [MemoryPackOrder(2)]
        [JsonProperty("order_group_id", Order = 2)]
        public int OrderGroupId { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("name_localkey", Order = 3)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("description_localkey", Order = 4)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("main_category_icon_name", Order = 5)]
        public string IconName { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("sub_category_id", Order = 6)]
        public int SubCategoryId { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("sub_category_name_localkey", Order = 7)]
        public string? SubCategoryNameKey { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonProperty("package_shop_id", Order = 8)]
        public int PackageShopId { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("is_hide_if_not_valid", Order = 9)]
        public bool HideIfNotValid { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("renew_type", Order = 10)]

        public RenewType RenewType { get; set; } = RenewType.NoRenew;

        [MemoryPackOrder(11)]
        [JsonProperty("start_date", Order = 11)]
        public DateTime StartDate { get; set; } = new DateTime(2000, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        [MemoryPackOrder(12)]
        [JsonProperty("end_date", Order = 12)]
        public DateTime EndDate { get; set; } = new DateTime(2099, 12, 31, 0, 0, 0, DateTimeKind.Utc);

        [MemoryPackOrder(13)]
        [JsonProperty("date_ui_control", Order = 13)]
        public bool DateUiControl { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("shop_type", Order = 14)]

        public ShopType ShopType { get; set; } = ShopType.InAppShop;

        [MemoryPackOrder(15)]
        [JsonProperty("shop_category", Order = 15)]

        public ShopCategory ShopCategory { get; set; } = ShopCategory.Unknown;

        [MemoryPackOrder(16)]
        [JsonProperty("shop_prefab_name", Order = 16)]
        public string ShopPrefabName { get; set; } = string.Empty;
    }

    [MemoryPackable]
    public partial class PackageProductData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("package_group_id", Order = 1)]
        public int PackageGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("product_type", Order = 2)]

        public ProductType ProductType { get; set; } = ProductType.Item;

        [MemoryPackOrder(3)]
        [JsonProperty("product_id", Order = 3)]
        public int ProductId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("product_value", Order = 4)]
        public int ProductValue { get; set; }
    }

    [MemoryPackable]
    public partial class CurrencyData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("resource_id", Order = 3)]
        public int ResourceId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("is_visible_to_inventory", Order = 4)]
        public bool IsVisibleInInventory { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("max_value", Order = 5)]
        public long MaxValue { get; set; }
    }

    [MemoryPackable]
    public partial class StepUpPackageData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("stepup_group_id", Order = 1)]
        public int StepUpGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("package_group_id", Order = 2)]
        public int PackageGroupId { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("step", Order = 3)]
        public int Step { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("previous_package_id", Order = 4)]
        public int PreviousPackageId { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("is_last_step", Order = 5)]
        public bool IsLastStep { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("product_effieciency", Order = 6)]
        public int ProductEfficiency { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("buy_limit_type", Order = 7)]
        public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.Account;

        [MemoryPackOrder(8)]
        [JsonProperty("is_limit", Order = 8)]
        public bool IsLimited { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("buy_limit_count", Order = 9)]
        public int BuyLimitCount { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("is_free", Order = 10)]
        public bool IsFree { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("midas_product_id", Order = 11)]
        public int MidasProductId { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("name_localkey", Order = 12)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(13)]
        [JsonProperty("description_localkey", Order = 13)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(14)]
        [JsonProperty("product_resource_id", Order = 14)]
        public string ProductResourceId { get; set; } = string.Empty;
    }

    [MemoryPackable]
    public partial class CustomPackageShopData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("custom_shop_id", Order = 1)]
        public int CustomShopId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("custom_order", Order = 2)]
        public int CustomOrder { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("package_group_id", Order = 3)]
        public int PackageGroupId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("custom_group_id", Order = 4)]
        public int CustomGroupId { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("custom_group_count", Order = 5)]
        public int CustomGroupCount { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("name_localkey", Order = 6)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(7)]
        [JsonProperty("description_localkey", Order = 7)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonProperty("product_resource_id", Order = 8)]
        public string ProductResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(9)]
        [JsonProperty("buy_limit_type", Order = 9)]

        public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.None;

        [MemoryPackOrder(10)]
        [JsonProperty("is_limit", Order = 10)]
        public bool IsLimited { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("buy_limit_count", Order = 11)]
        public int BuyLimitCount { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("is_free", Order = 12)]
        public bool IsFree { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("midas_product_id", Order = 13)]
        public int MidasProductId { get; set; }
    }

    [MemoryPackable]
    public partial class CustomPackageSlotData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("custom_group_id", Order = 1)]
        public int CustomGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("slot_number", Order = 2)]
        public int SlotNumber { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("product_type", Order = 3)]

        public ProductType ProductType { get; set; } = ProductType.Unknown;

        [MemoryPackOrder(4)]
        [JsonProperty("product_id", Order = 4)]
        public int ProductId { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("product_value", Order = 5)]
        public int ProductValue { get; set; }
    }

    [MemoryPackable]
    public partial class MidasProductData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("product_type", Order = 1)]

        public MidasProductType ProductType { get; set; } = MidasProductType.CashShop;

        [MemoryPackOrder(2)]
        [JsonProperty("product_id", Order = 2)]
        public int ProductId { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("item_type", Order = 3)]

        public ProductItemType ItemType { get; set; } = ProductItemType.Currency;

        [MemoryPackOrder(4)]
        [JsonProperty("midas_product_id_proximabeta", Order = 4)]
        public string ProximaBetaProductId { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("midas_product_id_gamamobi", Order = 5)]
        public string GamamobiProductId { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("is_free", Order = 6)]
        public bool IsFree { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("cost", Order = 7)]
        public string Cost { get; set; } = "0";
    }

    [MemoryPackable]
    public partial class ConsumeItemData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("use_condition_type", Order = 1)]

        public UseConditionType UseConditionType { get; set; } = UseConditionType.Unknown;

        [MemoryPackOrder(2)]
        [JsonProperty("use_condition_value", Order = 2)]
        public int UseConditionValue { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("name_localkey", Order = 3)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("description_localkey", Order = 4)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonProperty("resource_id", Order = 5)]
        public string ResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonProperty("item_type", Order = 6)]

        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(7)]
        [JsonProperty("item_sub_type", Order = 7)]

        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(8)]
        [JsonProperty("item_rare", Order = 8)]

        public Rarity ItemRarity { get; set; } = Rarity.R;

        [MemoryPackOrder(9)]
        [JsonProperty("use_type", Order = 9)]

        public UseType UseType { get; set; } = UseType.Unknown;

        [MemoryPackOrder(10)]
        [JsonProperty("use_id", Order = 10)]
        public int UseId { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("percent_display_type", Order = 11)]

        public PercentDisplayType PercentDisplayType { get; set; } = PercentDisplayType.None;

        [MemoryPackOrder(12)]
        [JsonProperty("use_value", Order = 12)]
        public int UseValue { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("use_frag_cost", Order = 13)]
        public int UseFragCost { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("use_limit_count", Order = 14)]
        public bool UseLimitCount { get; set; }

        [MemoryPackOrder(15)]
        [JsonProperty("use_limit_count_value", Order = 15, DefaultValueHandling = DefaultValueHandling.Ignore)]
        public int UseLimitCountValue { get; set; } = 0;

        [MemoryPackOrder(16)]
        [JsonProperty("stack_max", Order = 16)]
        public int StackMax { get; set; }
    }

    [MemoryPackable]
    public partial class MaterialItemData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("resource_id", Order = 3)]
        public string ResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonProperty("item_type", Order = 4)]

        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(5)]
        [JsonProperty("item_sub_type", Order = 5)]

        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(6)]
        [JsonProperty("item_rare", Order = 6)]

        public Rarity ItemRarity { get; set; } = Rarity.R;

        [MemoryPackOrder(7)]
        [JsonProperty("item_value", Order = 7)]
        public int ItemValue { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("material_type", Order = 8)]

        public MaterialType MaterialType { get; set; } = MaterialType.Unknown;

        [MemoryPackOrder(9)]
        [JsonProperty("material_value", Order = 9)]
        public int MaterialValue { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("stack_max", Order = 10)]
        public int StackMax { get; set; }
    }

    [MemoryPackable]
    public partial class PieceItemData
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("name_localkey", Order = 1)]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonProperty("description_localkey", Order = 2)]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonProperty("resource_id", Order = 3)]
        public int ResourceId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("item_type", Order = 4)]

        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(5)]
        [JsonProperty("item_sub_type", Order = 5)]

        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(6)]
        [JsonProperty("item_rare", Order = 6)]

        public Rarity ItemRarity { get; set; } = Rarity.R;

        [MemoryPackOrder(7)]
        [JsonProperty("corporation", Order = 7)]

        public Corporation Corporation { get; set; } = Corporation.None;

        [MemoryPackOrder(8)]
        [JsonProperty("corporation_sub_type", Order = 8, DefaultValueHandling = DefaultValueHandling.Ignore)]

        public CorporationSubType CorporationSubType { get; set; } = CorporationSubType.NORMAL;

        [MemoryPackOrder(9)]
        [JsonProperty("class", Order = 9)]

        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;

        [MemoryPackOrder(10)]
        [JsonProperty("use_type", Order = 10)]

        public UseType UseType { get; set; } = UseType.Unknown;

        [MemoryPackOrder(11)]
        [JsonProperty("use_id", Order = 11)]
        public int UseId { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("use_value", Order = 12)]
        public int UseValue { get; set; }

        [MemoryPackOrder(13)]
        [JsonProperty("use_limit_count", Order = 13)]
        public bool UseLimitCount { get; set; }

        [MemoryPackOrder(14)]
        [JsonProperty("use_limit_count_value", Order = 14, DefaultValueHandling = DefaultValueHandling.Ignore)]
        public int UseLimitCountValue { get; set; } = 0;

        [MemoryPackOrder(15)]
        [JsonProperty("stack_max", Order = 15)]
        public int StackMax { get; set; }
    }
}