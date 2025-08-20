import Foundation

/// AI LLM endpoint params Google object.
public class AiLlmEndpointParamsGoogle: Codable, RawJSONReadable {
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


    /// The type of the AI LLM endpoint params object for Google.
    /// This parameter is **required**.
    public let type: AiLlmEndpointParamsGoogleTypeField

    /// The temperature is used for sampling during response generation, which occurs when `top-P` and `top-K` are applied. Temperature controls the degree of randomness in the token selection.
    @CodableTriState public private(set) var temperature: Double?

    /// `Top-P` changes how the model selects tokens for output. Tokens are selected from the most (see `top-K`) to least probable until the sum of their probabilities equals the `top-P` value.
    @CodableTriState public private(set) var topP: Double?

    /// `Top-K` changes how the model selects tokens for output. A low `top-K` means the next selected token is
    /// the most probable among all tokens in the model's vocabulary (also called greedy decoding),
    /// while a high `top-K` means that the next token is selected from among the three most probable tokens by using temperature.
    @CodableTriState public private(set) var topK: Double?

    /// Initializer for a AiLlmEndpointParamsGoogle.
    ///
    /// - Parameters:
    ///   - type: The type of the AI LLM endpoint params object for Google.
    ///     This parameter is **required**.
    ///   - temperature: The temperature is used for sampling during response generation, which occurs when `top-P` and `top-K` are applied. Temperature controls the degree of randomness in the token selection.
    ///   - topP: `Top-P` changes how the model selects tokens for output. Tokens are selected from the most (see `top-K`) to least probable until the sum of their probabilities equals the `top-P` value.
    ///   - topK: `Top-K` changes how the model selects tokens for output. A low `top-K` means the next selected token is
    ///     the most probable among all tokens in the model's vocabulary (also called greedy decoding),
    ///     while a high `top-K` means that the next token is selected from among the three most probable tokens by using temperature.
    public init(type: AiLlmEndpointParamsGoogleTypeField = AiLlmEndpointParamsGoogleTypeField.googleParams, temperature: TriStateField<Double> = nil, topP: TriStateField<Double> = nil, topK: TriStateField<Double> = nil) {
        self.type = type
        self._temperature = CodableTriState(state: temperature)
        self._topP = CodableTriState(state: topP)
        self._topK = CodableTriState(state: topK)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiLlmEndpointParamsGoogleTypeField.self, forKey: .type)
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
