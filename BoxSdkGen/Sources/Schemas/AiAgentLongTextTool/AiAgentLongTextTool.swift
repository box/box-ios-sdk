import Foundation

/// AI agent processor used to to handle longer text.
public class AiAgentLongTextTool: AiAgentBasicTextTool {
    private enum CodingKeys: String, CodingKey {
        case embeddings
    }

    public let embeddings: AiAgentLongTextToolEmbeddingsField?

    /// Initializer for a AiAgentLongTextTool.
    ///
    /// - Parameters:
    ///   - model: The model used for the AI agent for basic text. For specific model values, see the [available models list](g://box-ai/supported-models).
    ///   - numTokensForCompletion: The number of tokens for completion.
    ///   - llmEndpointParams: The parameters for the LLM endpoint specific to OpenAI / Google models.
    ///   - systemMessage: System messages try to help the LLM "understand" its role and what it is supposed to do.
    ///   - promptTemplate: The prompt template contains contextual information of the request and the user prompt.
    ///     When passing `prompt_template` parameters, you **must include** inputs for `{user_question}` and `{content}`.
    ///     `{current_date}` is optional, depending on the use.
    ///   - embeddings: 
    public init(model: String? = nil, numTokensForCompletion: Int64? = nil, llmEndpointParams: AiLlmEndpointParamsAwsOrAiLlmEndpointParamsGoogleOrAiLlmEndpointParamsOpenAi? = nil, systemMessage: String? = nil, promptTemplate: String? = nil, embeddings: AiAgentLongTextToolEmbeddingsField? = nil) {
        self.embeddings = embeddings

        super.init(model: model, numTokensForCompletion: numTokensForCompletion, llmEndpointParams: llmEndpointParams, systemMessage: systemMessage, promptTemplate: promptTemplate)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embeddings = try container.decodeIfPresent(AiAgentLongTextToolEmbeddingsField.self, forKey: .embeddings)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(embeddings, forKey: .embeddings)
        try super.encode(to: encoder)
    }

}
