import Foundation

/// AI metadata freeform extraction request object
public class AiExtract: Codable {
    private enum CodingKeys: String, CodingKey {
        case prompt
        case items
        case aiAgent = "ai_agent"
    }

    /// The prompt provided to a Large Language Model (LLM) in the request. The prompt can be up to 10000 characters long and it can be an XML or a JSON schema.
    public let prompt: String

    /// The items that LLM will process. Currently, you can use files only.
    public let items: [AiItemBase]

    public let aiAgent: AiAgentExtractOrAiAgentReference?

    /// Initializer for a AiExtract.
    ///
    /// - Parameters:
    ///   - prompt: The prompt provided to a Large Language Model (LLM) in the request. The prompt can be up to 10000 characters long and it can be an XML or a JSON schema.
    ///   - items: The items that LLM will process. Currently, you can use files only.
    ///   - aiAgent: 
    public init(prompt: String, items: [AiItemBase], aiAgent: AiAgentExtractOrAiAgentReference? = nil) {
        self.prompt = prompt
        self.items = items
        self.aiAgent = aiAgent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try container.decode(String.self, forKey: .prompt)
        items = try container.decode([AiItemBase].self, forKey: .items)
        aiAgent = try container.decodeIfPresent(AiAgentExtractOrAiAgentReference.self, forKey: .aiAgent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(aiAgent, forKey: .aiAgent)
    }

}
