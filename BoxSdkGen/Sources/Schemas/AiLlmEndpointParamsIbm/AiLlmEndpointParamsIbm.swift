import Foundation

/// AI LLM endpoint params IBM object.
public class AiLlmEndpointParamsIbm: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case temperature
        case topP = "top_p"
        case topK = "top_k"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of the AI LLM endpoint params object for IBM.
    /// This parameter is **required**.
    public let type: AiLlmEndpointParamsIbmTypeField

    /// What sampling temperature to use, between 0 and 1. Higher values like 0.8 will make the output more random, 
    /// while lower values like 0.2 will make it more focused and deterministic. 
    /// We generally recommend altering this or `top_p` but not both.
    @CodableTriState public private(set) var temperature: Double?

    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results 
    /// of the tokens with `top_p` probability mass. So 0.1 means only the tokens comprising the top 10% probability 
    /// mass are considered. We generally recommend altering this or temperature but not both.
    @CodableTriState public private(set) var topP: Double?

    /// `Top-K` changes how the model selects tokens for output. A low `top-K` means the next selected token is
    /// the most probable among all tokens in the model's vocabulary (also called greedy decoding),
    /// while a high `top-K` means that the next token is selected from among the three most probable tokens by using temperature.
    @CodableTriState public private(set) var topK: Double?

    /// Initializer for a AiLlmEndpointParamsIbm.
    ///
    /// - Parameters:
    ///   - type: The type of the AI LLM endpoint params object for IBM.
    ///     This parameter is **required**.
    ///   - temperature: What sampling temperature to use, between 0 and 1. Higher values like 0.8 will make the output more random, 
    ///     while lower values like 0.2 will make it more focused and deterministic. 
    ///     We generally recommend altering this or `top_p` but not both.
    ///   - topP: An alternative to sampling with temperature, called nucleus sampling, where the model considers the results 
    ///     of the tokens with `top_p` probability mass. So 0.1 means only the tokens comprising the top 10% probability 
    ///     mass are considered. We generally recommend altering this or temperature but not both.
    ///   - topK: `Top-K` changes how the model selects tokens for output. A low `top-K` means the next selected token is
    ///     the most probable among all tokens in the model's vocabulary (also called greedy decoding),
    ///     while a high `top-K` means that the next token is selected from among the three most probable tokens by using temperature.
    public init(type: AiLlmEndpointParamsIbmTypeField = AiLlmEndpointParamsIbmTypeField.ibmParams, temperature: TriStateField<Double> = nil, topP: TriStateField<Double> = nil, topK: TriStateField<Double> = nil) {
        self.type = type
        self._temperature = CodableTriState(state: temperature)
        self._topP = CodableTriState(state: topP)
        self._topK = CodableTriState(state: topK)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiLlmEndpointParamsIbmTypeField.self, forKey: .type)
        temperature = try container.decodeIfPresent(Double.self, forKey: .temperature)
        topP = try container.decodeIfPresent(Double.self, forKey: .topP)
        topK = try container.decodeIfPresent(Double.self, forKey: .topK)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _temperature.state, forKey: .temperature)
        try container.encode(field: _topP.state, forKey: .topP)
        try container.encode(field: _topK.state, forKey: .topK)
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
