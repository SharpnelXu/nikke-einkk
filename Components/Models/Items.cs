using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
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

    public enum FavoriteItemType
    {
        Unknown = -1,
        None = 0,
        Collection = 1,
        Favorite = 2
    }

    public enum UseConditionType
    {
        Unknown = -1,
        None = 0,
        MissionClear = 1,
        StageClear = 2,
        Time = 3
    }

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

    public enum PercentDisplayType
    {
        None = 0,
        Percent = 1,
        Random = 2,
        Unknown = -1
    }

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
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("resource_id")]
        public string ResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("item_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("item_sub_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("class")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("item_rare")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public EquipItemRarity EquipItemRarity { get; set; } = EquipItemRarity.Unknown;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("grade_core_id")]
        public int GradeCoreId { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("grow_grade")]
        public int GrowGrade { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("stat")]
        public EquipmentStat[] Stat { get; set; } = [];

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("option_slot")]
        public OptionSlot[] OptionSlots { get; set; } = [];

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("option_cost")]
        public int OptionCost { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("option_change_cost")]
        public int OptionChangeCost { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("option_lock_cost")]
        public int OptionLockCost { get; set; }
    }

    [MemoryPackable]
    public partial class EquipmentStat
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("stat_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StatType StatType { get; set; } = StatType.None;

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("stat_value")]
        public int StatValue { get; set; }
    }

    [MemoryPackable]
    public partial class OptionSlot
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("option_slot")]
        public int OptionSlotValue { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("option_slot_success_ratio")]
        public int OptionSlotSuccessRatio { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeSkillGroup
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("skill_group_id")]
        public int SkillGroupId { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("location_id")]
        public int LocationId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("location_localkey")]
        public string LocationLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("order")]
        public int Order { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("resource_id")]
        public int ResourceId { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("bg")]
        public string Bg { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("bg_color")]
        public string BgColor { get; set; } = string.Empty;

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("item_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("item_sub_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("item_rare")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Rarity ItemRare { get; set; } = Rarity.R;

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("class")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("level_enhance_id")]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("harmonycube_skill_group")]
        public HarmonyCubeSkillGroup[] HarmonyCubeSkillGroups { get; set; } = [];
    }

    [MemoryPackable]
    public partial class HarmonyCubeSkillLevel
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("skill_level")]
        public int Level { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeStat
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("stat_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StatType StatType { get; set; } = StatType.None;

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("stat_rate")]
        public int Rate { get; set; }
    }

    [MemoryPackable]
    public partial class HarmonyCubeLevelData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("level_enhance_id")]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("level")]
        public int Level { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("skill_levels")]
        public HarmonyCubeSkillLevel[] SkillLevels { get; set; } = [];

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("material_id")]
        public int MaterialId { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("material_value")]
        public int MaterialValue { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("gold_value")]
        public int GoldValue { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("slot")]
        public int Slot { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("harmonycube_stats")]
        public HarmonyCubeStat[] Stats { get; set; } = [];
    }

    [MemoryPackable]
    public partial class CollectionItemSkillGroup
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("collection_skill_id")]
        public int SkillGroupId { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemSkillGroup
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("favorite_skill_id")]
        public int SkillId { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("skill_table")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public SkillType SkillTable { get; set; } = SkillType.None;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("skill_change_slot")]
        public int SkillChangeSlot { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string NameLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("icon_resource_id")]
        public string IconResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("img_resource_id")]
        public string ImgResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("prop_resource_id")]
        public string PropResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("order")]
        public int Order { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("favorite_rare")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Rarity FavoriteRare { get; set; } = Rarity.R;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("favorite_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public FavoriteItemType FavoriteType { get; set; } = FavoriteItemType.Unknown;

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("weapon_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public WeaponType WeaponType { get; set; } = WeaponType.None;

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("name_code")]
        public int NameCode { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("max_level")]
        public int MaxLevel { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("level_enhance_id")]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("probability_group")]
        public int ProbabilityGroup { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("collection_skill_group_data")]
        public CollectionItemSkillGroup[] CollectionSkills { get; set; } = [];

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("favoriteitem_skill_group_data")]
        public FavoriteItemSkillGroup[] FavoriteItemSkills { get; set; } = [];

        [MemoryPackOrder(16)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("albumcategory_id")]
        public int AlbumCategoryId { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemStat
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("stat_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public StatType StatType { get; set; } = StatType.None;

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("stat_value")]
        public int Value { get; set; }
    }

    [MemoryPackable]
    public partial class CollectionItemSkillLevel
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("collection_skill_level")]
        public int Level { get; set; }
    }

    [MemoryPackable]
    public partial class FavoriteItemLevelData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("level_enhance_id")]
        public int LevelEnhanceId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("grade")]
        public int Grade { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("level")]
        public int Level { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("favoriteitem_stat_data")]
        public FavoriteItemStat[] Stats { get; set; } = [];

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("collection_skill_level_data")]
        public CollectionItemSkillLevel[] SkillLevels { get; set; } = [];
    }

    [MemoryPackable]
    public partial class PackageListData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("package_shop_id")]
        public int PackageShopId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("package_order")]
        public int PackageOrder { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("product_id")]
        public int ProductId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("product_resource_id")]
        public string ProductResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("buy_limit_type")]
        public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.Account;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("is_limit")]
        public bool IsLimited { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("buy_limit_count")]
        public int BuyLimitCount { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("is_active")]
        public bool IsActive { get; set; }
    }

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

    public enum ProductItemType
    {
        Unknown = -1,
        Currency = 0,
        Item = 1
    }
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

    [JsonConverter(typeof(JsonStringEnumConverter))]
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

    public enum ShopType
    {
        Unknown = -1,
        InAppShop = 0,
    }

    [MemoryPackable]
    public partial class InAppShopData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("main_category_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public MainCategoryType MainCategoryType { get; set; } = MainCategoryType.Unknown;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("order_group_id")]
        public int OrderGroupId { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("main_category_icon_name")]
        public string IconName { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("sub_category_id")]
        public int SubCategoryId { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("sub_category_name_localkey")]
        public string? SubCategoryNameKey { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("package_shop_id")]
        public int PackageShopId { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("is_hide_if_not_valid")]
        public bool HideIfNotValid { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("renew_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public RenewType RenewType { get; set; } = RenewType.NoRenew;

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("start_date")]
        public DateTime StartDate { get; set; } = new DateTime(2000, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("end_date")]
        public DateTime EndDate { get; set; } = new DateTime(2099, 12, 31, 0, 0, 0, DateTimeKind.Utc);

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("date_ui_control")]
        public bool DateUiControl { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("shop_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ShopType ShopType { get; set; } = ShopType.InAppShop;

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("shop_category")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ShopCategory ShopCategory { get; set; } = ShopCategory.Unknown;

        [MemoryPackOrder(16)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("shop_prefab_name")]
        public string ShopPrefabName { get; set; } = string.Empty;
    }

    [MemoryPackable]
    public partial class PackageProductData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("package_group_id")]
        public int PackageGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("product_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ProductType ProductType { get; set; } = ProductType.Item;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("product_id")]
        public int ProductId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("product_value")]
        public int ProductValue { get; set; }
    }

    [MemoryPackable]
    public partial class CurrencyData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("resource_id")]
        public int ResourceId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("is_visible_to_inventory")]
        public bool IsVisibleInInventory { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("max_value")]
        public long MaxValue { get; set; }
    }

    [MemoryPackable]
    public partial class StepUpPackageData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("stepup_group_id")]
        public int StepUpGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("package_group_id")]
        public int PackageGroupId { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("step")]
        public int Step { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("previous_package_id")]
        public int PreviousPackageId { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("is_last_step")]
        public bool IsLastStep { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("product_effieciency")]
        public int ProductEfficiency { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("buy_limit_type")]
        public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.Account;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("is_limit")]
        public bool IsLimited { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("buy_limit_count")]
        public int BuyLimitCount { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("is_free")]
        public bool IsFree { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("midas_product_id")]
        public int MidasProductId { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("product_resource_id")]
        public string ProductResourceId { get; set; } = string.Empty;
    }

    [MemoryPackable]
    public partial class CustomPackageShopData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("custom_shop_id")]
        public int CustomShopId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("custom_order")]
        public int CustomOrder { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("package_group_id")]
        public int PackageGroupId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("custom_group_id")]
        public int CustomGroupId { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("custom_group_count")]
        public int CustomGroupCount { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("product_resource_id")]
        public string ProductResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("buy_limit_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public BuyLimitType BuyLimitType { get; set; } = BuyLimitType.None;

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("is_limit")]
        public bool IsLimited { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("buy_limit_count")]
        public int BuyLimitCount { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("is_free")]
        public bool IsFree { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("midas_product_id")]
        public int MidasProductId { get; set; }
    }

    [MemoryPackable]
    public partial class CustomPackageSlotData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("custom_group_id")]
        public int CustomGroupId { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("slot_number")]
        public int SlotNumber { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("product_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ProductType ProductType { get; set; } = ProductType.Unknown;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("product_id")]
        public int ProductId { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("product_value")]
        public int ProductValue { get; set; }
    }

    [MemoryPackable]
    public partial class MidasProductData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("product_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public MidasProductType ProductType { get; set; } = MidasProductType.CashShop;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("product_id")]
        public int ProductId { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("item_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ProductItemType ItemType { get; set; } = ProductItemType.Currency;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("midas_product_id_proximabeta")]
        public string ProximaBetaProductId { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("midas_product_id_gamamobi")]
        public string GamamobiProductId { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("is_free")]
        public bool IsFree { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("cost")]
        public string Cost { get; set; } = "0";
    }

    [MemoryPackable]
    public partial class ConsumeItemData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("use_condition_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public UseConditionType UseConditionType { get; set; } = UseConditionType.Unknown;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("use_condition_value")]
        public int UseConditionValue { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("resource_id")]
        public string ResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("item_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("item_sub_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("item_rare")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Rarity ItemRarity { get; set; } = Rarity.R;

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("use_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public UseType UseType { get; set; } = UseType.Unknown;

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("use_id")]
        public int UseId { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("percent_display_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public PercentDisplayType PercentDisplayType { get; set; } = PercentDisplayType.None;

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("use_value")]
        public int UseValue { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("use_frag_cost")]
        public int UseFragCost { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("use_limit_count")]
        public bool UseLimitCount { get; set; }

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("use_limit_count_value")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int UseLimitCountValue { get; set; } = 0;

        [MemoryPackOrder(16)]
        [JsonPropertyOrder(16)]
        [JsonPropertyName("stack_max")]
        public int StackMax { get; set; }
    }

    [MemoryPackable]
    public partial class MaterialItemData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("resource_id")]
        public string ResourceId { get; set; } = string.Empty;

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("item_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("item_sub_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("item_rare")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Rarity ItemRarity { get; set; } = Rarity.R;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("item_value")]
        public int ItemValue { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("material_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public MaterialType MaterialType { get; set; } = MaterialType.Unknown;

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("material_value")]
        public int MaterialValue { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("stack_max")]
        public int StackMax { get; set; }
    }

    [MemoryPackable]
    public partial class PieceItemData
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("name_localkey")]
        public string NameKey { get; set; } = string.Empty;

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("description_localkey")]
        public string DescriptionKey { get; set; } = string.Empty;

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("resource_id")]
        public int ResourceId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("item_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemType ItemType { get; set; } = ItemType.Unknown;

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("item_sub_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public ItemSubType ItemSubType { get; set; } = ItemSubType.Unknown;

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("item_rare")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Rarity ItemRarity { get; set; } = Rarity.R;

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("corporation")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public Corporation Corporation { get; set; } = Corporation.None;

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("corporation_sub_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public CorporationSubType CorporationSubType { get; set; } = CorporationSubType.NORMAL;

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("class")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public NikkeClass CharacterClass { get; set; } = NikkeClass.None;

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("use_type")]
        [JsonConverter(typeof(JsonStringEnumConverter))]
        public UseType UseType { get; set; } = UseType.Unknown;

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("use_id")]
        public int UseId { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("use_value")]
        public int UseValue { get; set; }

        [MemoryPackOrder(13)]
        [JsonPropertyOrder(13)]
        [JsonPropertyName("use_limit_count")]
        public bool UseLimitCount { get; set; }

        [MemoryPackOrder(14)]
        [JsonPropertyOrder(14)]
        [JsonPropertyName("use_limit_count_value")]
        [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
        public int UseLimitCountValue { get; set; } = 0;

        [MemoryPackOrder(15)]
        [JsonPropertyOrder(15)]
        [JsonPropertyName("stack_max")]
        public int StackMax { get; set; }
    }
}