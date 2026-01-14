using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NikkeEinkk.Components.Models.Enums
{
    [JsonConverter(typeof(StringEnumConverter))]
    public enum BurstStep
    {
        Unknown = -1,
        None = 0,
        Step1 = 1,
        Step2 = 2,
        Step3 = 3,
        StepFull = 4,
        AllStep = 5,
        NextStep = 6,
        KeepStep = 7
    }
}
