using Newtonsoft.Json;

namespace NikkeEinkk.Components.Models.Enums.Converters;

/// <summary>
/// Converts double arrays to JSON, serializing whole numbers without decimal points.
/// For example: [0.0, 0.0, 0.0] becomes [0, 0, 0]
/// </summary>
public class DoubleArrayConverter : JsonConverter<double[]>
{
    public override void WriteJson(JsonWriter writer, double[]? value, JsonSerializer serializer)
    {
        if (value == null)
        {
            writer.WriteNull();
            return;
        }

        writer.WriteStartArray();
        foreach (var item in value)
        {
            // If the value is a whole number, write it as an integer
            if (item % 1 == 0)
            {
                writer.WriteValue((long)item);
            }
            else
            {
                writer.WriteValue(item);
            }
        }
        writer.WriteEndArray();
    }

    public override double[]? ReadJson(JsonReader reader, Type objectType, double[]? existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        if (reader.TokenType == JsonToken.Null)
        {
            return null;
        }

        if (reader.TokenType != JsonToken.StartArray)
        {
            throw new JsonSerializationException($"Expected StartArray token but got {reader.TokenType}");
        }

        var values = new List<double>();
        while (reader.Read())
        {
            if (reader.TokenType == JsonToken.EndArray)
            {
                break;
            }

            if (reader.Value != null)
            {
                values.Add(Convert.ToDouble(reader.Value));
            }
        }

        return values.ToArray();
    }
}

