using MemoryPack;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models
{
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosRecord 
    {
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id {  get;  set; } 
        
        [JsonProperty("bios_group")]
        [MemoryPackOrder(1)]
        public int Bios_group {  get;  set; } 
        
        [JsonProperty("name_localkey")]
        [MemoryPackOrder(2)]
        public string? Name_localkey {  get;  set; } 
        
        [JsonProperty("description_localkey")]
        [MemoryPackOrder(3)]
        public string? Description_localkey {  get;  set; } 
        
        [JsonProperty("resource_id")]
        [MemoryPackOrder(4)]
        public string? Resource_id {  get;  set; } 
        
        [JsonProperty("bios_rare")]
        [MemoryPackOrder(5)]
        public int Bios_rare {  get;  set; } 
        
        [JsonProperty("element")]
        [MemoryPackOrder(6)]
        public AttackType Element {  get;  set; } 
        
        [JsonProperty("main_option")]
        [MemoryPackOrder(7)]
        public int Main_option {  get;  set; } 
        
        [JsonProperty("sub_01_option")]
        [MemoryPackOrder(8)]
        public int Sub_01_option {  get;  set; } 
        
        
        [JsonProperty("sub_02_option")]
        [MemoryPackOrder(9)]
        public int Sub_02_option {  get;  set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRecord 
    {
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        
        [JsonProperty("order")]
        [MemoryPackOrder(1)]
        public int Order { get; set; } 
        
        [JsonProperty("option_rare")]
        [MemoryPackOrder(2)]
        public int Option_rare { get; set; } 
        
        [JsonProperty("state_effect_localkey")]
        [MemoryPackOrder(3)]
        public string? State_effect_localkey { get; set; } 
        
        [JsonProperty("function_id")]
        [MemoryPackOrder(4)]
        public int Function_id { get; set; } 
        
        [JsonProperty("HexaBiosOptionRandomData")]
        [MemoryPackOrder(5)]
        public List<HexaBiosOptionStateEffectStepData> HexaBiosOptionRandomData { get; set; } = []; 
    }
    
    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionStateEffectStepData 
    {
        
        [JsonProperty("need_point")]
        [MemoryPackOrder(0)]
        public int Need_point { get; set; } 
        
        [JsonProperty("state_effect_id")]
        [MemoryPackOrder(1)]
        public int State_effect_id { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRandomData 
    {
        
        [JsonProperty("option_id")]
        [MemoryPackOrder(0)]
        public int Option_id { get; set; } 
        
        [JsonProperty("ratio")]
        [MemoryPackOrder(1)]
        public int Ratio { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosOptionRandomRecord 
    {
        
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        
        [JsonProperty("option_group")]
        [MemoryPackOrder(1)]
        public int Option_group { get; set; } 
        
        [JsonProperty("HexaBiosOptionRandomData")]
        [MemoryPackOrder(2)]
        public List<HexaBiosOptionRandomData> HexaBiosOptionRandomData { get; set; } = []; 
    }

    [JsonConverter(typeof(StringEnumConverter))]
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
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        
        [JsonProperty("block_group")]
        [MemoryPackOrder(1)]
        public int Block_group { get; set; } 
        
        [JsonProperty("name_localkey")]
        [MemoryPackOrder(2)]
        public string? Name_localkey { get; set; } 
        
        [JsonProperty("description_localkey")]
        [MemoryPackOrder(3)]
        public string? Description_localkey { get; set; } 
        
        [JsonProperty("block_type")]
        [MemoryPackOrder(4)]
        public HexaBlockDesignType Block_type { get; set; } 
        
        [JsonProperty("block_rare")]
        [MemoryPackOrder(5)]
        public int Block_rare { get; set; } 
        
        [JsonProperty("element")]
        [MemoryPackOrder(6)]
        public AttackType Element { get; set; } 
        
        [JsonProperty("attak")]
        [MemoryPackOrder(7)]
        public int Attak { get; set; } 
        
        [JsonProperty("hp")]
        [MemoryPackOrder(8)]
        public int Hp { get; set; } 
        
        [JsonProperty("defence")]
        [MemoryPackOrder(9)]
        public int Defence { get; set; } 
        
        [JsonProperty("function_group")]
        [MemoryPackOrder(10)]
        public int Function_group { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBlockUndefinedRecord : IMemoryPackable<HexaBlockUndefinedRecord> 
    {
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        
        [JsonProperty("name_localkey")]
        [MemoryPackOrder(1)]
        public string? Name_localkey { get; set; } 
        
        [JsonProperty("description_localkey")]
        [MemoryPackOrder(2)]
        public string? Description_localkey { get; set; } 
        
        [JsonProperty("block_type")]
        [MemoryPackOrder(3)]
        public HexaBlockDesignType Block_type { get; set; } 
        
        [JsonProperty("block_rare")]
        [MemoryPackOrder(4)]
        public int Block_rare { get; set; } 
        
        [JsonProperty("block_group")]
        [MemoryPackOrder(5)]
        public int Block_group { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBiosUndefinedRecord : IMemoryPackable<HexaBiosUndefinedRecord> 
    {
        
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonProperty("name_localkey")]
        [MemoryPackOrder(1)]
        public string? Name_localkey { get; set; } 
        [JsonProperty("description_localkey")]
        [MemoryPackOrder(2)]
        public string? Description_localkey { get; set; } 
        [JsonProperty("resource_id")]
        [MemoryPackOrder(3)]
        public string? Resource_id { get; set; } 
        [JsonProperty("bios_rare")]
        [MemoryPackOrder(4)]
        public int Bios_rare { get; set; } 
        [JsonProperty("bios_group")]
        [MemoryPackOrder(5)]
        public int Bios_group { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBoardSlotNumberData : IMemoryPackable<HexaBoardSlotNumberData> 
    {
        
        [JsonProperty("slot_no")]
        [MemoryPackOrder(0)]
        public int Slot_no { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaBoardSlotRecord : IMemoryPackable<HexaBoardSlotRecord> 
    {
        
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonProperty("slot_lock")]
        [MemoryPackOrder(1)]
        public bool Slot_lock { get; set; } 
        [JsonProperty("lock_group")]
        [MemoryPackOrder(2)]
        public int Lock_group { get; set; } 
        [JsonProperty("currency_id")]
        [MemoryPackOrder(3)]
        public int Currency_id { get; set; } 
        [JsonProperty("currency_value")]
        [MemoryPackOrder(4)]
        public int Currency_value { get; set; } 
        [JsonProperty("HexaBoardSlotNumberData")]
        [MemoryPackOrder(5)]
        public List<HexaBoardSlotNumberData> HexaBoardSlotNumberData { get; set; } = []; 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionGroupRecord 
    {

        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonProperty("function_group")]
        [MemoryPackOrder(1)]
        public int Function_group { get; set; } 
        [JsonProperty("ratio")]
        [MemoryPackOrder(2)]
        public int Ratio { get; set; } 
        [JsonProperty("slot_1_function")]
        [MemoryPackOrder(3)]
        public int Slot_1_function { get; set; } 
        [JsonProperty("slot_2_function")]
        [MemoryPackOrder(4)]
        public int Slot_2_function { get; set; } 
        [JsonProperty("slot_3_function")]
        [MemoryPackOrder(5)]
        public int Slot_3_function { get; set; } 
        [JsonProperty("order")]
        [MemoryPackOrder(6)]
        public int Order { get; set; } 
    }

    [MemoryPackable(SerializeLayout.Explicit)]
    public partial class HexaFunctionPointData 
    {
        
        [JsonProperty("point_rare")]
        [MemoryPackOrder(0)]
        public int Point_rare { get; set; } 
    }

    [JsonConverter(typeof(StringEnumConverter))]
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
        
        [JsonProperty("id")]
        [MemoryPackOrder(0)]
        public int Id { get; set; } 
        [JsonProperty("resource_id")]
        [MemoryPackOrder(1)]
        public string? Resource_id { get; set; } 
        [JsonProperty("bios_type")]
        [MemoryPackOrder(2)]
        public HexaBiosFilterType Bios_type { get; set; } 
        [JsonProperty("HexaFunctionPointData")]
        [MemoryPackOrder(3)]
        public List<HexaFunctionPointData> HexaFunctionPointData { get; set; } = []; 
    }
}