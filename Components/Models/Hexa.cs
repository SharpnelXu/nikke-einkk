using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Model
{
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosRecord // TypeDefIndex: 37831
    {
    
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id {  get;  set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("bios_group")]
        [MemoryPackOrder(1)]
        public int Bios_group {  get;  set; } // 0x00000001808A8B90-0x00000001808A8BA0 0x00000001808A8BB0-0x00000001808A8BC0
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(2)]
        public string? Name_localkey {  get;  set; } // 0x0000000180809D20-0x0000000180809D30 0x000000018085C270-0x000000018085C280
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(3)]
        public string? Description_localkey {  get;  set; } // 0x000000018082E3C0-0x000000018082E3D0 0x0000000180868490-0x00000001808684A0
        [JsonPropertyName("resource_id")]
        [MemoryPackOrder(4)]
        public string? Resource_id {  get;  set; } // 0x0000000180809160-0x0000000180809170 0x0000000180809230-0x0000000180809240
        [JsonPropertyName("bios_rare")]
        [MemoryPackOrder(5)]
        public int Bios_rare {  get;  set; } // 0x0000000180869A70-0x0000000180869A80 0x0000000180869AA0-0x0000000180869AB0
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("element")]
        [MemoryPackOrder(6)]
        public AttackType Element {  get;  set; } // 0x0000000180908FB0-0x0000000180908FC0 0x00000001809090B0-0x00000001809090C0
        [JsonPropertyName("main_option")]
        [MemoryPackOrder(7)]
        public int Main_option {  get;  set; } // 0x000000018147E6C0-0x000000018147E6D0 0x00000001827DCDC0-0x00000001827DCDD0
        [JsonPropertyName("sub_01_option")]
        [MemoryPackOrder(8)]
        public int Sub_01_option {  get;  set; } // 0x00000001814D7680-0x00000001814D7690 0x00000001827DCD80-0x00000001827DCD90
        [JsonPropertyName("sub_02_option")]
        [MemoryPackOrder(9)]
        public int Sub_02_option {  get;  set; } // 0x0000000180830920-0x0000000180830930 0x0000000180830930-0x0000000180830940
    }

    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRecord // TypeDefIndex: 37827
    {
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("order")]
        [MemoryPackOrder(1)]
        public int Order { get; set; } // 0x00000001808A8B90-0x00000001808A8BA0 0x00000001808A8BB0-0x00000001808A8BC0
        [JsonPropertyName("option_rare")]
        [MemoryPackOrder(2)]
        public int Option_rare { get; set; } // 0x000000018084E140-0x000000018084E150 0x00000001808A8BD0-0x00000001808A8BE0
        [JsonPropertyName("state_effect_localkey")]
        [MemoryPackOrder(3)]
        public string? State_effect_localkey { get; set; } // 0x000000018082E3C0-0x000000018082E3D0 0x0000000180868490-0x00000001808684A0
        [JsonPropertyName("function_id")]
        [MemoryPackOrder(4)]
        public int Function_id { get; set; } // 0x00000001808A7B10-0x00000001808A7B20 0x00000001809090C0-0x00000001809090D0
        [JsonPropertyName("HexaBiosOptionRandomData")]
        [MemoryPackOrder(5)]
        public List<HexaBiosOptionStateEffectStepData> HexaBiosOptionRandomData { get; set; } = []; // 0x000000018084ED30-0x000000018084ED40 0x000000018084E1A0-0x000000018084E1B0
    }
    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionStateEffectStepData // TypeDefIndex: 37829
    {
        // Properties
        [JsonPropertyName("need_point")]
        [MemoryPackOrder(0)]
        public int Need_point { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("state_effect_id")]
        [MemoryPackOrder(1)]
        public int State_effect_id { get; set; } // 0x00000001808A8B90-0x00000001808A8BA0 0x00000001808A8BB0-0x00000001808A8BC0
    }

    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRandomData // TypeDefIndex: 37825
    {
        // Properties
        [JsonPropertyName("option_id")]
        [MemoryPackOrder(0)]
        public int Option_id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("ratio")]
        [MemoryPackOrder(1)]
        public int Ratio { get; set; } // 0x00000001808A8B90-0x00000001808A8BA0 0x00000001808A8BB0-0x00000001808A8BC0
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRandomRecord // TypeDefIndex: 37823
    {
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("option_group")]
        [MemoryPackOrder(1)]
        public int Option_group { get; set; } // 0x00000001808A8B90-0x00000001808A8BA0 0x00000001808A8BB0-0x00000001808A8BC0
        [JsonPropertyName("HexaBiosOptionRandomData")]
        [MemoryPackOrder(2)]
        public List<HexaBiosOptionRandomData> HexaBiosOptionRandomData { get; set; } = []; // 0x0000000180809D20-0x0000000180809D30 0x000000018085C270-0x000000018085C280
    }

    public enum HexaBlockDesignType // TypeDefIndex: 37836
    {
        Unknown = -1,
        None = 0,
        Type_C = 1,
        Type_I = 2,
        Type_A = 3
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBlockRecord // TypeDefIndex: 37835
    {
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("block_group")]
        [MemoryPackOrder(1)]
        public int Block_group { get; set; } // 0x00000001808A8B90-0x00000001808A8BA0 0x00000001808A8BB0-0x00000001808A8BC0
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(2)]
        public string? Name_localkey { get; set; } // 0x0000000180809D20-0x0000000180809D30 0x000000018085C270-0x000000018085C280
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(3)]
        public string? Description_localkey { get; set; } // 0x000000018082E3C0-0x000000018082E3D0 0x0000000180868490-0x00000001808684A0
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("block_type")]
        [MemoryPackOrder(4)]
        public HexaBlockDesignType Block_type { get; set; } // 0x00000001808A7B10-0x00000001808A7B20 0x00000001809090C0-0x00000001809090D0
        [JsonPropertyName("block_rare")]
        [MemoryPackOrder(5)]
        public int Block_rare { get; set; } // 0x00000001808A7B00-0x00000001808A7B10 0x00000001826384F0-0x0000000182638500
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("element")]
        [MemoryPackOrder(6)]
        public AttackType Element { get; set; } // 0x0000000180869A70-0x0000000180869A80 0x0000000180869AA0-0x0000000180869AB0
        [JsonPropertyName("attak")]
        [MemoryPackOrder(7)]
        public int Attak { get; set; } // 0x0000000180908FB0-0x0000000180908FC0 0x00000001809090B0-0x00000001809090C0
        [JsonPropertyName("hp")]
        [MemoryPackOrder(8)]
        public int Hp { get; set; } // 0x000000018147E6C0-0x000000018147E6D0 0x00000001827DCDC0-0x00000001827DCDD0
        [JsonPropertyName("defence")]
        [MemoryPackOrder(9)]
        public int Defence { get; set; } // 0x00000001814D7680-0x00000001814D7690 0x00000001827DCD80-0x00000001827DCD90
        [JsonPropertyName("function_group")]
        [MemoryPackOrder(10)]
        public int Function_group { get; set; } // 0x0000000180830920-0x0000000180830930 0x0000000180830930-0x0000000180830940
    }

    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBlockUndefinedRecord : IMemoryPackable<HexaBlockUndefinedRecord> // TypeDefIndex: 37838
    {
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(1)]
        public string? Name_localkey { get; set; } // 0x0000000180809D20-0x0000000180809D30 0x000000018085C270-0x000000018085C280
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(2)]
        public string? Description_localkey { get; set; } // 0x000000018082E3C0-0x000000018082E3D0 0x0000000180868490-0x00000001808684A0
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("block_type")]
        [MemoryPackOrder(3)]
        public HexaBlockDesignType Block_type { get; set; } // 0x00000001808A7B10-0x00000001808A7B20 0x00000001809090C0-0x00000001809090D0
        [JsonPropertyName("block_rare")]
        [MemoryPackOrder(4)]
        public int Block_rare { get; set; } // 0x00000001808A7B00-0x00000001808A7B10 0x00000001826384F0-0x0000000182638500
        [JsonPropertyName("block_group")]
        [MemoryPackOrder(5)]
        public int Block_group { get; set; } // 0x0000000180869A70-0x0000000180869A80 0x0000000180869AA0-0x0000000180869AB0
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosUndefinedRecord : IMemoryPackable<HexaBiosUndefinedRecord> // TypeDefIndex: 37833
    {
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(1)]
        public string? Name_localkey { get; set; } // 0x0000000180809D20-0x0000000180809D30 0x000000018085C270-0x000000018085C280
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(2)]
        public string? Description_localkey { get; set; } // 0x000000018082E3C0-0x000000018082E3D0 0x0000000180868490-0x00000001808684A0
        [JsonPropertyName("resource_id")]
        [MemoryPackOrder(3)]
        public string? Resource_id { get; set; } // 0x0000000180809160-0x0000000180809170 0x0000000180809230-0x0000000180809240
        [JsonPropertyName("bios_rare")]
        [MemoryPackOrder(4)]
        public int Bios_rare { get; set; } // 0x0000000180869A70-0x0000000180869A80 0x0000000180869AA0-0x0000000180869AB0
        [JsonPropertyName("bios_group")]
        [MemoryPackOrder(5)]
        public int Bios_group { get; set; } // 0x0000000180908FB0-0x0000000180908FC0 0x00000001809090B0-0x00000001809090C0
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBoardSlotNumberData : IMemoryPackable<HexaBoardSlotNumberData> // TypeDefIndex: 37842
    {
        // Properties
        [JsonPropertyName("slot_no")]
        [MemoryPackOrder(0)]
        public int Slot_no { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBoardSlotRecord : IMemoryPackable<HexaBoardSlotRecord> // TypeDefIndex: 37840
    {
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("slot_lock")]
        [MemoryPackOrder(1)]
        public bool Slot_lock { get; set; } // 0x0000000181463760-0x0000000181463770 0x0000000183B7F180-0x0000000183B7F190
        [JsonPropertyName("lock_group")]
        [MemoryPackOrder(2)]
        public int Lock_group { get; set; } // 0x000000018084E140-0x000000018084E150 0x00000001808A8BD0-0x00000001808A8BE0
        [JsonPropertyName("currency_id")]
        [MemoryPackOrder(3)]
        public int Currency_id { get; set; } // 0x00000001808A8B80-0x00000001808A8B90 0x00000001808A8BA0-0x00000001808A8BB0
        [JsonPropertyName("currency_value")]
        [MemoryPackOrder(4)]
        public int Currency_value { get; set; } // 0x0000000180829AD0-0x0000000180829FA0 0x000000018084E180-0x000000018084E190
        [JsonPropertyName("HexaBoardSlotNumberData")]
        [MemoryPackOrder(5)]
        public List<HexaBoardSlotNumberData> HexaBoardSlotNumberData { get; set; } = []; // 0x0000000180809160-0x0000000180809170 0x0000000180809230-0x0000000180809240
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionGroupRecord // TypeDefIndex: 37844
    {

        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("function_group")]
        [MemoryPackOrder(1)]
        public int Function_group { get; set; } // 0x00000001808A8B90-0x00000001808A8BA0 0x00000001808A8BB0-0x00000001808A8BC0
        [JsonPropertyName("ratio")]
        [MemoryPackOrder(2)]
        public int Ratio { get; set; } // 0x000000018084E140-0x000000018084E150 0x00000001808A8BD0-0x00000001808A8BE0
        [JsonPropertyName("slot_1_function")]
        [MemoryPackOrder(3)]
        public int Slot_1_function { get; set; } // 0x00000001808A8B80-0x00000001808A8B90 0x00000001808A8BA0-0x00000001808A8BB0
        [JsonPropertyName("slot_2_function")]
        [MemoryPackOrder(4)]
        public int Slot_2_function { get; set; } // 0x0000000180829AD0-0x0000000180829FA0 0x000000018084E180-0x000000018084E190
        [JsonPropertyName("slot_3_function")]
        [MemoryPackOrder(5)]
        public int Slot_3_function { get; set; } // 0x000000018084DE80-0x000000018084DE90 0x000000018084E190-0x000000018084E1A0
        [JsonPropertyName("order")]
        [MemoryPackOrder(6)]
        public int Order { get; set; } // 0x00000001808A7B10-0x00000001808A7B20 0x00000001809090C0-0x00000001809090D0
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionPointData // TypeDefIndex: 37849
    {
        // Properties
        [JsonPropertyName("point_rare")]
        [MemoryPackOrder(0)]
        public int Point_rare { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
    }

    public enum HexaBiosFilterType // TypeDefIndex: 37847
    {
        Unknown = -1,
        None = 0,
        MAIN = 1,
        SUB_01 = 2,
        SUB_02 = 3
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionRecord // TypeDefIndex: 37846
    {
        // Properties
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } // 0x0000000180807250-0x0000000180807260 0x00000001808A8BC0-0x00000001808A8BD0
        [JsonPropertyName("resource_id")]
        [MemoryPackOrder(1)]
        public string? Resource_id { get; set; } // 0x0000000180809D20-0x0000000180809D30 0x000000018085C270-0x000000018085C280
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("bios_type")]
        [MemoryPackOrder(2)]
        public HexaBiosFilterType Bios_type { get; set; } // 0x0000000180829AD0-0x0000000180829FA0 0x000000018084E180-0x000000018084E190
        [JsonPropertyName("HexaFunctionPointData")]
        [MemoryPackOrder(3)]
        public List<HexaFunctionPointData> HexaFunctionPointData { get; set; } = []; // 0x0000000180809160-0x0000000180809170 0x0000000180809230-0x0000000180809240
    }
}