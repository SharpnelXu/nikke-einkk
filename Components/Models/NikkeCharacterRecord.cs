using MemoryPack;
using Newtonsoft.Json;
using NikkeEinkk.Components.Models.Enums;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable]
    public partial class NikkeCharacterRecord
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
        public int ResourceId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("additional_skins", Order = 4)]
        public string[] AdditionalSkins { get; set; } = [];

        [MemoryPackOrder(5)]
        [JsonProperty("name_code", Order = 5)]
        public int NameCode { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("order", Order = 6)]
        public int Order { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("original_rare", Order = 7)]
        public Rarity OriginalRare { get; set; } = Rarity.R;

        [MemoryPackOrder(8)]
        [JsonProperty("grade_core_id", Order = 8)]
        public int GradeCoreId { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("grow_grade", Order = 9)]
        public int GrowGrade { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("stat_enhance_id", Order = 10)]
        public int StatEnhanceId { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("corporation", Order = 32)]
        public Corporation Corporation { get; set; } = Corporation.None;

        [MemoryPackOrder(12)]
        [JsonProperty("corporation_sub_type", Order = 33, DefaultValueHandling = DefaultValueHandling.Ignore)]
        public CorporationSubType CorporationSubType { get; set; } = CorporationSubType.NORMAL;

        [MemoryPackOrder(13)]
        [JsonProperty("class", Order = 11)]
        public NikkeCharacterClass NikkeCharacterClass { get; set; } = NikkeCharacterClass.None;

        [MemoryPackOrder(15)]
        [JsonProperty("element_id", Order = 12)]
        public int[] ElementId { get; set; } = [];

        [MemoryPackOrder(16)]
        [JsonProperty("critical_ratio", Order = 13)]
        public int CriticalRatio { get; set; }

        [MemoryPackOrder(17)]
        [JsonProperty("critical_damage", Order = 14)]
        public int CriticalDamage { get; set; }

        [MemoryPackOrder(18)]
        [JsonProperty("shot_id", Order = 15)]
        public int ShotId { get; set; }

        [MemoryPackOrder(19)]
        [JsonProperty("bonusrange_min", Order = 16)]
        public int BonusRangeMin { get; set; }

        [MemoryPackOrder(20)]
        [JsonProperty("bonusrange_max", Order = 17)]
        public int BonusRangeMax { get; set; }

        [MemoryPackOrder(21)]
        [JsonProperty("use_burst_skill", Order = 18)]
        public BurstStep UseBurstSkill { get; set; } = BurstStep.None;

        [MemoryPackOrder(22)]
        [JsonProperty("change_burst_step", Order = 19)]
        public BurstStep ChangeBurstStep { get; set; } = BurstStep.None;

        [MemoryPackOrder(23)]
        [JsonProperty("burst_apply_delay", Order = 20)]
        public int BurstApplyDelay { get; set; }

        [MemoryPackOrder(24)]
        [JsonProperty("burst_duration", Order = 21)]
        public int BurstDuration { get; set; }

        [MemoryPackOrder(25)]
        [JsonProperty("ulti_skill_id", Order = 22)]
        public int UltiSkillId { get; set; }

        [MemoryPackOrder(26)]
        [JsonProperty("skill1_id", Order = 23)]
        public int Skill1Id { get; set; }

        [MemoryPackOrder(27)]
        [JsonProperty("skill1_table", Order = 24)]
        public SkillTableType Skill1Table { get; set; } = SkillTableType.None;

        [MemoryPackOrder(28)]
        [JsonProperty("skill2_id", Order = 25)]
        public int Skill2Id { get; set; }

        [MemoryPackOrder(29)]
        [JsonProperty("skill2_table", Order = 26)]
        public SkillTableType Skill2Table { get; set; } = SkillTableType.None;

        [MemoryPackOrder(30)]
        [JsonProperty("eff_category_type", Order = 27)]
        public EffCategoryType EffCategoryType { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(31)]
        [JsonProperty("eff_category_value", Order = 28)]
        public int EffCategoryValue { get; set; }

        [MemoryPackOrder(32)]
        [JsonProperty("category_type_1", Order = 29)]
        public EffCategoryType CategoryType1 { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(33)]
        [JsonProperty("category_type_2", Order = 30)]
        public EffCategoryType CategoryType2 { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(34)]
        [JsonProperty("category_type_3", Order = 31)]
        public EffCategoryType CategoryType3 { get; set; } = EffCategoryType.None;

        [MemoryPackOrder(35)]
        [JsonProperty("cv_localkey", Order = 34)]
        public string CvLocalkey { get; set; } = string.Empty;

        [MemoryPackOrder(36)]
        [JsonProperty("squad", Order = 35)]
        public Squad Squad { get; set; } = Squad.None;

        [MemoryPackOrder(37)]
        [JsonProperty("piece_id", Order = 36)]
        public int PieceId { get; set; }

        [MemoryPackOrder(38)]
        [JsonProperty("is_visible", Order = 37)]
        public bool IsVisible { get; set; }

        [MemoryPackOrder(39)]
        [JsonProperty("prism_is_active", Order = 38)]
        public bool PrismIsActive { get; set; }

        [MemoryPackOrder(40)]
        [JsonProperty("is_detail_close", Order = 39)]
        public bool IsDetailClose { get; set; }
    }
}
