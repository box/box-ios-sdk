import Foundation

/// AI LLM endpoint params AWS object.
public class AiLlmEndpointParamsAws: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case temperature
        case topP = "top_p"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of the AI LLM endpoint params object for AWS.
    /// This parameter is **required**.
    public let type: AiLlmEndpointParamsAwsTypeField

    /// What sampling temperature to use, between 0 and 1. Higher values like 0.8 will make the output more random, 
    /// while lower values like 0.2 will make it more focused and deterministic. 
    /// We generally recommend altering this or `top_p` but not both.
    @CodableTriState public private(set) var temperature: Double?

    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results 
    /// of the tokens with `top_p` probability mass. So 0.1 means only the tokens comprising the top 10% probability 
    /// mass are considered. We generally recommend altering this or temperature but not both.
    @CodableTriState public private(set) var topP: Double?

    /// Initializer for a AiLlmEndpointParamsAws.
    ///
    /// - Parameters:
    ///   - type: The type of the AI LLM endpoint params object for AWS.
    ///     This parameter is **required**.
    ///   - temperature: What sampling temperature to use, between 0 and 1. Higher values like 0.8 will make the output more random, 
    ///     while lower values like 0.2 will make it more focused and deterministic. 
    ///     We generally recommend altering this or `top_p` but not both.
    ///   - topP: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results 
    ///     of the tokens with `top_p` probability mass. So 0.1 means only the tokens comprising the top 10% probability 
    ///     mass are considered. We generally recommend altering this or temperature but not both.
    public init(type: AiLlmEndpointParamsAwsTypeField = AiLlmEndpointParamsAwsTypeField.awsParams, temperature: TriStateField<Double> = nil, topP: TriStateField<Double> = nil) {
        self.type = type
        self._temperature = CodableTriState(state: temperature)
        self._topP = CodableTriState(state: topP)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiLlmEndpointParamsAwsTypeField.self, forKey: .type)
        temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
        topP = try container.decodeIfPresent(Double.self, forKey: .topP)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _temperature.state, forKey: .temperature)
        try container.encode(field: _topP.state, forKey: .topP)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
