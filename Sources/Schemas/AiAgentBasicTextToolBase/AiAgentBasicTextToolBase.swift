import Foundation

/// AI agent processor used to handle basic text.
public class AiAgentBasicTextToolBase: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case model
        case numTokensForCompletion = "num_tokens_for_completion"
        case llmEndpointParams = "llm_endpoint_params"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The model used for the AI agent for basic text. For specific model values, see the [available models list](g://box-ai/supported-models).
    public let model: String?

    /// The number of tokens for completion.
    public let numTokensForCompletion: Int64?

    public let llmEndpointParams: AiLlmEndpointParams?

    /// Initializer for a AiAgentBasicTextToolBase.
    ///
    /// - Parameters:
    ///   - model: The model used for the AI agent for basic text. For specific model values, see the [available models list](g://box-ai/supported-models).
    ///   - numTokensForCompletion: The number of tokens for completion.
    ///   - llmEndpointParams: 
    public init(model: String? = nil, numTokensForCompletion: Int64? = nil, llmEndpointParams: AiLlmEndpointParams? = nil) {
        self.model = model
        self.numTokensForCompletion = numTokensForCompletion
        self.llmEndpointParams = llmEndpointParams
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        model = try container.decodeIfPresent(String.self, forKey: .model)
        numTokensForCompletion = try container.decodeIfPresent(Int64.self, forKey: .numTokensForCompletion)
        llmEndpointParams = try container.decodeIfPresent(AiLlmEndpointParams.self, forKey: .llmEndpointParams)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(numTokensForCompletion, forKey: .numTokensForCompletion)
        try container.encodeIfPresent(llmEndpointParams, forKey: .llmEndpointParams)
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
