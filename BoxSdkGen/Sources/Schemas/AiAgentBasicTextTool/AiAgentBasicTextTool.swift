import Foundation

/// AI agent processor used to handle basic text.
public class AiAgentBasicTextTool: AiAgentBasicTextToolBase {
    private enum CodingKeys: String, CodingKey {
        case systemMessage = "system_message"
        case promptTemplate = "prompt_template"
    }

    /// System messages try to help the LLM "understand" its role and what it is supposed to do.
    public let systemMessage: String?

    /// The prompt template contains contextual information of the request and the user prompt.
    /// When passing `prompt_template` parameters, you **must include** inputs for `{user_question}` and `{content}`.
    /// `{current_date}` is optional, depending on the use.
    public let promptTemplate: String?

    /// Initializer for a AiAgentBasicTextTool.
    ///
    /// - Parameters:
    ///   - model: The model used for the AI agent for basic text. For specific model values, see the [available models list](g://box-ai/supported-models).
    ///   - numTokensForCompletion: The number of tokens for completion.
    ///   - llmEndpointParams: The parameters for the LLM endpoint specific to OpenAI / Google models.
    ///   - systemMessage: System messages try to help the LLM "understand" its role and what it is supposed to do.
    ///   - promptTemplate: The prompt template contains contextual information of the request and the user prompt.
    ///     When passing `prompt_template` parameters, you **must include** inputs for `{user_question}` and `{content}`.
    ///     `{current_date}` is optional, depending on the use.
    public init(model: String? = nil, numTokensForCompletion: Int64? = nil, llmEndpointParams: AiLlmEndpointParamsAwsOrAiLlmEndpointParamsGoogleOrAiLlmEndpointParamsOpenAi? = nil, systemMessage: String? = nil, promptTemplate: String? = nil) {
        self.systemMessage = systemMessage
        self.promptTemplate = promptTemplate

        super.init(model: model, numTokensForCompletion: numTokensForCompletion, llmEndpointParams: llmEndpointParams)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        systemMessage = try container.decodeIfPresent(String.self, forKey: .systemMessage)
        promptTemplate = try container.decodeIfPresent(String.self, forKey: .promptTemplate)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(systemMessage, forKey: .systemMessage)
        try container.encodeIfPresent(promptTemplate, forKey: .promptTemplate)
        try super.encode(to: encoder)
    }

}
