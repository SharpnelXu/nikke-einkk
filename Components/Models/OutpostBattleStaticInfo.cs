using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum PrepareRewardType
    {
        Unknown = -1,
        None = 0,
        Currency = 1,
        ItemRandom = 2,
    }

    [MemoryPackable]
    public partial class OutpostRewardItem
    {
        [MemoryPackOrder(0)]
        [JsonProperty("view_item_id", Order = 0)]
        public int ViewItemId { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("item_type", Order = 1)]
        public PrepareRewardType ItemType { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("item_id", Order = 2)]
        public int ItemId { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("item_value", Order = 3)]
        public int ItemValue { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("time_sec", Order = 4)]
        public int TimeSec { get; set; }
    }

    [MemoryPackable]
    public partial class OutpostBattleStaticInfo
    {
        [MemoryPackOrder(0)]
        [JsonProperty("id", Order = 0)]
        public int Id { get; set; }

        [MemoryPackOrder(1)]
        [JsonProperty("battle_box_level", Order = 1)]
        public int BattleBoxLevel { get; set; }

        [MemoryPackOrder(2)]
        [JsonProperty("main_stage_clear_count", Order = 2)]
        public int MainStageClearCount { get; set; }

        [MemoryPackOrder(3)]
        [JsonProperty("reward_id", Order = 3)]
        public int RewardId { get; set; }

        [MemoryPackOrder(4)]
        [JsonProperty("credit", Order = 4)]
        public int Credit { get; set; }

        [MemoryPackOrder(5)]
        [JsonProperty("time_credit", Order = 5)]
        public int TimeCredit { get; set; }

        [MemoryPackOrder(6)]
        [JsonProperty("character_exp1", Order = 6)]
        public int CharacterExp1 { get; set; }

        [MemoryPackOrder(7)]
        [JsonProperty("time_charexp1", Order = 7)]
        public int TimeCharExp1 { get; set; }

        [MemoryPackOrder(8)]
        [JsonProperty("user_exp", Order = 8)]
        public int UserExp { get; set; }

        [MemoryPackOrder(9)]
        [JsonProperty("time_user_exp", Order = 9)]
        public int TimeUserExp { get; set; }

        [MemoryPackOrder(10)]
        [JsonProperty("character_exp2", Order = 10)]
        public int CharacterExp2 { get; set; }

        [MemoryPackOrder(11)]
        [JsonProperty("time_charexp2", Order = 11)]
        public int TimeCharExp2 { get; set; }

        [MemoryPackOrder(12)]
        [JsonProperty("outpost_reward_list", Order = 12)]
        public OutpostRewardItem[] OutpostRewardList { get; set; } = [];
    }
}
