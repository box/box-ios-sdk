import Foundation

/// AI agent processor used to to handle longer text.
public class AiStudioAgentLongTextTool: AiAgentLongTextTool {
    private enum CodingKeys: String, CodingKey {
        case isCustomInstructionsIncluded = "is_custom_instructions_included"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// True if system message contains custom instructions placeholder, false otherwise.
    public let isCustomInstructionsIncluded: Bool?

    /// Initializer for a AiStudioAgentLongTextTool.
    ///
    /// - Parameters:
    ///   - model: The model used for the AI agent for basic text. For specific model values, see the [available models list](g://box-ai/supported-models).
    ///   - numTokensForCompletion: The number of tokens for completion.
    ///   - llmEndpointParams: 
    ///   - systemMessage: System messages try to help the LLM "understand" its role and what it is supposed to do.
    ///   - promptTemplate: The prompt template contains contextual information of the request and the user prompt.
    ///     When passing `prompt_template` parameters, you **must include** inputs for `{user_question}` and `{content}`.
    ///     `{current_date}` is optional, depending on the use.
    ///   - embeddings: 
    ///   - isCustomInstructionsIncluded: True if system message contains custom instructions placeholder, false otherwise.
    public init(model: String? = nil, numTokensForCompletion: Int64? = nil, llmEndpointParams: AiLlmEndpointParams? = nil, systemMessage: String? = nil, promptTemplate: String? = nil, embeddings: AiAgentLongTextToolEmbeddingsField? = nil, isCustomInstructionsIncluded: Bool? = nil) {
        self.isCustomInstructionsIncluded = isCustomInstructionsIncluded

        super.init(model: model, numTokensForCompletion: numTokensForCompletion, llmEndpointParams: llmEndpointParams, systemMessage: systemMessage, promptTemplate: promptTemplate, embeddings: embeddings)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isCustomInstructionsIncluded = try container.decodeIfPresent(Bool.self, forKey: .isCustomInstructionsIncluded)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isCustomInstructionsIncluded, forKey: .isCustomInstructionsIncluded)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
