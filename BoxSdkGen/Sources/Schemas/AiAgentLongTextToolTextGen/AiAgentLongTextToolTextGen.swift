import Foundation

/// AI agent processor used to to handle longer text.
public class AiAgentLongTextToolTextGen: AiAgentBasicTextToolTextGen {
    private enum CodingKeys: String, CodingKey {
        case embeddings
    }

    public let embeddings: AiAgentLongTextToolTextGenEmbeddingsField?

    /// Initializer for a AiAgentLongTextToolTextGen.
    ///
    /// - Parameters:
    ///   - model: The model used for the AI agent for basic text. For specific model values, see the [available models list](g://box-ai/supported-models).
    ///   - numTokensForCompletion: The number of tokens for completion.
    ///   - llmEndpointParams: The parameters for the LLM endpoint specific to OpenAI / Google models.
    ///   - systemMessage: System messages aim at helping the LLM understand its role and what it is supposed to do.
    ///     The input for `{current_date}` is optional, depending on the use.
    ///   - promptTemplate: The prompt template contains contextual information of the request and the user prompt.
    ///     
    ///     When using the `prompt_template` parameter, you **must include** input for `{user_question}`.
    ///     Inputs for `{current_date}` and `{content}` are optional, depending on the use.
    ///   - embeddings: 
    public init(model: String? = nil, numTokensForCompletion: Int64? = nil, llmEndpointParams: AiLlmEndpointParamsAwsOrAiLlmEndpointParamsGoogleOrAiLlmEndpointParamsOpenAi? = nil, systemMessage: String? = nil, promptTemplate: String? = nil, embeddings: AiAgentLongTextToolTextGenEmbeddingsField? = nil) {
        self.embeddings = embeddings

        super.init(model: model, numTokensForCompletion: numTokensForCompletion, llmEndpointParams: llmEndpointParams, systemMessage: systemMessage, promptTemplate: promptTemplate)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embeddings = try container.decodeIfPresent(AiAgentLongTextToolTextGenEmbeddingsField.self, forKey: .embeddings)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(embeddings, forKey: .embeddings)
        try super.encode(to: encoder)
    }

}
