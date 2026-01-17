using Newtonsoft.Json;
using System.Globalization;

namespace NikkeEinkk.Components.Models.Locale;

public class Translation
{
    [JsonProperty("key")]
    public string Key { get; set; } = string.Empty;

    [JsonProperty("ko")]
    public string ko { get; set; } = string.Empty;

    [JsonProperty("en")]
    public string en { get; set; } = string.Empty;

    [JsonProperty("ja")]
    public string ja { get; set; } = string.Empty;

    [JsonProperty("zh-TW")]
    public string zhTW { get; set; } = string.Empty;

    [JsonProperty("zh-CN")]
    public string zhCN { get; set; } = string.Empty;

    [JsonProperty("th")]
    public string th { get; set; } = string.Empty;

    [JsonProperty("de")]
    public string de { get; set; } = string.Empty;

    [JsonProperty("fr")]
    public string fr { get; set; } = string.Empty;

    [JsonProperty("IsSmart")]
    public bool IsSmart { get; set; } = false;

    public string GetTranslation(string locale)
    {
        return locale switch
        {
            "ko" => ko,
            "en" => en,
            "ja" => ja,
            "zh-TW" => zhTW,
            "zh-CN" => zhCN,
            "th" => th,
            "de" => de,
            "fr" => fr,
            "debug" => Key,
            _ => en,
        };
    }

    public String GetTranslation()
    {
        var currentLocale = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
        return currentLocale switch
        {
            "zh" => GetTranslation("zh-CN"),
            _ => GetTranslation("en"),
        };
    }
}
