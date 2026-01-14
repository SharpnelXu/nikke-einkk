using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum PrepareRewardType
    {
        Unknown = -1,
        None = 0,
        Currency = 1,
        ItemRandom = 2,
        // Add other item types as needed
    }

    [MemoryPackable]
    public partial class OutpostRewardItem
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("view_item_id")]
        public int ViewItemId { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("item_type")]
        public PrepareRewardType ItemType { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("item_id")]
        public int ItemId { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("item_value")]
        public int ItemValue { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("time_sec")]
        public int TimeSec { get; set; }
    }

    [MemoryPackable]
    public partial class OutpostBattleStaticInfo
    {
        [MemoryPackOrder(0)]
        [JsonPropertyOrder(0)]
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonPropertyOrder(1)]
        [JsonPropertyName("battle_box_level")]
        public int BattleBoxLevel { get; set; }

        [MemoryPackOrder(2)]
        [JsonPropertyOrder(2)]
        [JsonPropertyName("main_stage_clear_count")]
        public int MainStageClearCount { get; set; }

        [MemoryPackOrder(3)]
        [JsonPropertyOrder(3)]
        [JsonPropertyName("reward_id")]
        public int RewardId { get; set; }

        [MemoryPackOrder(4)]
        [JsonPropertyOrder(4)]
        [JsonPropertyName("credit")]
        public int Credit { get; set; }

        [MemoryPackOrder(5)]
        [JsonPropertyOrder(5)]
        [JsonPropertyName("time_credit")]
        public int TimeCredit { get; set; }

        [MemoryPackOrder(6)]
        [JsonPropertyOrder(6)]
        [JsonPropertyName("character_exp1")]
        public int CharacterExp1 { get; set; }

        [MemoryPackOrder(7)]
        [JsonPropertyOrder(7)]
        [JsonPropertyName("time_charexp1")]
        public int TimeCharExp1 { get; set; }

        [MemoryPackOrder(8)]
        [JsonPropertyOrder(8)]
        [JsonPropertyName("user_exp")]
        public int UserExp { get; set; }

        [MemoryPackOrder(9)]
        [JsonPropertyOrder(9)]
        [JsonPropertyName("time_user_exp")]
        public int TimeUserExp { get; set; }

        [MemoryPackOrder(10)]
        [JsonPropertyOrder(10)]
        [JsonPropertyName("character_exp2")]
        public int CharacterExp2 { get; set; }

        [MemoryPackOrder(11)]
        [JsonPropertyOrder(11)]
        [JsonPropertyName("time_charexp2")]
        public int TimeCharExp2 { get; set; }

        [MemoryPackOrder(12)]
        [JsonPropertyOrder(12)]
        [JsonPropertyName("outpost_reward_list")]
        public OutpostRewardItem[] OutpostRewardList { get; set; } = [];
    }
}