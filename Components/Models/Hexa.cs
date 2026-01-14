using MemoryPack;
using System.Text.Json.Serialization;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosRecord 
    {
    
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id {  get;  set; } 
        [JsonPropertyName("bios_group")]
        [MemoryPackOrder(1)]
        public int Bios_group {  get;  set; } 
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(2)]
        public string? Name_localkey {  get;  set; } 
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(3)]
        public string? Description_localkey {  get;  set; } 
        [JsonPropertyName("resource_id")]
        [MemoryPackOrder(4)]
        public string? Resource_id {  get;  set; } 
        [JsonPropertyName("bios_rare")]
        [MemoryPackOrder(5)]
        public int Bios_rare {  get;  set; } 
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("element")]
        [MemoryPackOrder(6)]
        public AttackType Element {  get;  set; } 
        [JsonPropertyName("main_option")]
        [MemoryPackOrder(7)]
        public int Main_option {  get;  set; } 
        [JsonPropertyName("sub_01_option")]
        [MemoryPackOrder(8)]
        public int Sub_01_option {  get;  set; } 
        [JsonPropertyName("sub_02_option")]
        [MemoryPackOrder(9)]
        public int Sub_02_option {  get;  set; } 
    }

    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRecord 
    {
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("order")]
        [MemoryPackOrder(1)]
        public int Order { get; set; } 
        [JsonPropertyName("option_rare")]
        [MemoryPackOrder(2)]
        public int Option_rare { get; set; } 
        [JsonPropertyName("state_effect_localkey")]
        [MemoryPackOrder(3)]
        public string? State_effect_localkey { get; set; } 
        [JsonPropertyName("function_id")]
        [MemoryPackOrder(4)]
        public int Function_id { get; set; } 
        [JsonPropertyName("HexaBiosOptionRandomData")]
        [MemoryPackOrder(5)]
        public List<HexaBiosOptionStateEffectStepData> HexaBiosOptionRandomData { get; set; } = []; 
    }
    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionStateEffectStepData 
    {
        
        [JsonPropertyName("need_point")]
        [MemoryPackOrder(0)]
        public int Need_point { get; set; } 
        [JsonPropertyName("state_effect_id")]
        [MemoryPackOrder(1)]
        public int State_effect_id { get; set; } 
    }

    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRandomData 
    {
        
        [JsonPropertyName("option_id")]
        [MemoryPackOrder(0)]
        public int Option_id { get; set; } 
        [JsonPropertyName("ratio")]
        [MemoryPackOrder(1)]
        public int Ratio { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRandomRecord 
    {
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("option_group")]
        [MemoryPackOrder(1)]
        public int Option_group { get; set; } 
        [JsonPropertyName("HexaBiosOptionRandomData")]
        [MemoryPackOrder(2)]
        public List<HexaBiosOptionRandomData> HexaBiosOptionRandomData { get; set; } = []; 
    }

    public enum HexaBlockDesignType 
    {
        Unknown = -1,
        None = 0,
        Type_C = 1,
        Type_I = 2,
        Type_A = 3
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBlockRecord 
    {
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("block_group")]
        [MemoryPackOrder(1)]
        public int Block_group { get; set; } 
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(2)]
        public string? Name_localkey { get; set; } 
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(3)]
        public string? Description_localkey { get; set; } 
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("block_type")]
        [MemoryPackOrder(4)]
        public HexaBlockDesignType Block_type { get; set; } 
        [JsonPropertyName("block_rare")]
        [MemoryPackOrder(5)]
        public int Block_rare { get; set; } 
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("element")]
        [MemoryPackOrder(6)]
        public AttackType Element { get; set; } 
        [JsonPropertyName("attak")]
        [MemoryPackOrder(7)]
        public int Attak { get; set; } 
        [JsonPropertyName("hp")]
        [MemoryPackOrder(8)]
        public int Hp { get; set; } 
        [JsonPropertyName("defence")]
        [MemoryPackOrder(9)]
        public int Defence { get; set; } 
        [JsonPropertyName("function_group")]
        [MemoryPackOrder(10)]
        public int Function_group { get; set; } 
    }

    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBlockUndefinedRecord : IMemoryPackable<HexaBlockUndefinedRecord> 
    {
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(1)]
        public string? Name_localkey { get; set; } 
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(2)]
        public string? Description_localkey { get; set; } 
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("block_type")]
        [MemoryPackOrder(3)]
        public HexaBlockDesignType Block_type { get; set; } 
        [JsonPropertyName("block_rare")]
        [MemoryPackOrder(4)]
        public int Block_rare { get; set; } 
        [JsonPropertyName("block_group")]
        [MemoryPackOrder(5)]
        public int Block_group { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosUndefinedRecord : IMemoryPackable<HexaBiosUndefinedRecord> 
    {
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("name_localkey")]
        [MemoryPackOrder(1)]
        public string? Name_localkey { get; set; } 
        [JsonPropertyName("description_localkey")]
        [MemoryPackOrder(2)]
        public string? Description_localkey { get; set; } 
        [JsonPropertyName("resource_id")]
        [MemoryPackOrder(3)]
        public string? Resource_id { get; set; } 
        [JsonPropertyName("bios_rare")]
        [MemoryPackOrder(4)]
        public int Bios_rare { get; set; } 
        [JsonPropertyName("bios_group")]
        [MemoryPackOrder(5)]
        public int Bios_group { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBoardSlotNumberData : IMemoryPackable<HexaBoardSlotNumberData> 
    {
        
        [JsonPropertyName("slot_no")]
        [MemoryPackOrder(0)]
        public int Slot_no { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBoardSlotRecord : IMemoryPackable<HexaBoardSlotRecord> 
    {
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("slot_lock")]
        [MemoryPackOrder(1)]
        public bool Slot_lock { get; set; } 
        [JsonPropertyName("lock_group")]
        [MemoryPackOrder(2)]
        public int Lock_group { get; set; } 
        [JsonPropertyName("currency_id")]
        [MemoryPackOrder(3)]
        public int Currency_id { get; set; } 
        [JsonPropertyName("currency_value")]
        [MemoryPackOrder(4)]
        public int Currency_value { get; set; } 
        [JsonPropertyName("HexaBoardSlotNumberData")]
        [MemoryPackOrder(5)]
        public List<HexaBoardSlotNumberData> HexaBoardSlotNumberData { get; set; } = []; 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionGroupRecord 
    {

        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("function_group")]
        [MemoryPackOrder(1)]
        public int Function_group { get; set; } 
        [JsonPropertyName("ratio")]
        [MemoryPackOrder(2)]
        public int Ratio { get; set; } 
        [JsonPropertyName("slot_1_function")]
        [MemoryPackOrder(3)]
        public int Slot_1_function { get; set; } 
        [JsonPropertyName("slot_2_function")]
        [MemoryPackOrder(4)]
        public int Slot_2_function { get; set; } 
        [JsonPropertyName("slot_3_function")]
        [MemoryPackOrder(5)]
        public int Slot_3_function { get; set; } 
        [JsonPropertyName("order")]
        [MemoryPackOrder(6)]
        public int Order { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionPointData 
    {
        
        [JsonPropertyName("point_rare")]
        [MemoryPackOrder(0)]
        public int Point_rare { get; set; } 
    }

    public enum HexaBiosFilterType 
    {
        Unknown = -1,
        None = 0,
        MAIN = 1,
        SUB_01 = 2,
        SUB_02 = 3
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionRecord 
    {
        
        [JsonPropertyName("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonPropertyName("resource_id")]
        [MemoryPackOrder(1)]
        public string? Resource_id { get; set; } 
        [JsonConverter(typeof(JsonStringEnumConverter))]
        [JsonPropertyName("bios_type")]
        [MemoryPackOrder(2)]
        public HexaBiosFilterType Bios_type { get; set; } 
        [JsonPropertyName("HexaFunctionPointData")]
        [MemoryPackOrder(3)]
        public List<HexaFunctionPointData> HexaFunctionPointData { get; set; } = []; 
    }
}