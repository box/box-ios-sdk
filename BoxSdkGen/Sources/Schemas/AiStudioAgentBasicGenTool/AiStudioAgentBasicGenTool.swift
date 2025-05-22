import Foundation

/// AI agent basic tool used to generate text.
public class AiStudioAgentBasicGenTool: AiAgentBasicGenTool {
    private enum CodingKeys: String, CodingKey {
        case isCustomInstructionsIncluded = "is_custom_instructions_included"
    }

    /// True if system message contains custom instructions placeholder, false otherwise
    public let isCustomInstructionsIncluded: Bool?

    /// Initializer for a AiStudioAgentBasicGenTool.
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
    ///   - contentTemplate: How the content should be included in a request to the LLM.
    ///     Input for `{content}` is optional, depending on the use.
    ///   - isCustomInstructionsIncluded: True if system message contains custom instructions placeholder, false otherwise
    public init(model: String? = nil, numTokensForCompletion: Int64? = nil, llmEndpointParams: AiLlmEndpointParamsAwsOrAiLlmEndpointParamsGoogleOrAiLlmEndpointParamsOpenAi? = nil, systemMessage: String? = nil, promptTemplate: String? = nil, embeddings: AiAgentLongTextToolTextGenEmbeddingsField? = nil, contentTemplate: String? = nil, isCustomInstructionsIncluded: Bool? = nil) {
        self.isCustomInstructionsIncluded = isCustomInstructionsIncluded

        super.init(model: model, numTokensForCompletion: numTokensForCompletion, llmEndpointParams: llmEndpointParams, systemMessage: systemMessage, promptTemplate: promptTemplate, embeddings: embeddings, contentTemplate: contentTemplate)
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

}
