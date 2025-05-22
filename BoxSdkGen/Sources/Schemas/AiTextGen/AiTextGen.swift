import Foundation

/// AI text gen request object
public class AiTextGen: Codable {
    private enum CodingKeys: String, CodingKey {
        case prompt
        case items
        case dialogueHistory = "dialogue_history"
        case aiAgent = "ai_agent"
    }

    /// The prompt provided by the client to be answered by the LLM. The prompt's length is limited to 10000 characters.
    public let prompt: String

    /// The items to be processed by the LLM, often files.
    /// The array can include **exactly one** element.
    /// 
    /// **Note**: Box AI handles documents with text representations up to 1MB in size.
    /// If the file size exceeds 1MB, the first 1MB of text representation will be processed.
    public let items: [AiTextGenItemsField]

    /// The history of prompts and answers previously passed to the LLM. This parameter provides the additional context to the LLM when generating the response.
    public let dialogueHistory: [AiDialogueHistory]?

    public let aiAgent: AiAgentReferenceOrAiAgentTextGen?

    /// Initializer for a AiTextGen.
    ///
    /// - Parameters:
    ///   - prompt: The prompt provided by the client to be answered by the LLM. The prompt's length is limited to 10000 characters.
    ///   - items: The items to be processed by the LLM, often files.
    ///     The array can include **exactly one** element.
    ///     
    ///     **Note**: Box AI handles documents with text representations up to 1MB in size.
    ///     If the file size exceeds 1MB, the first 1MB of text representation will be processed.
    ///   - dialogueHistory: The history of prompts and answers previously passed to the LLM. This parameter provides the additional context to the LLM when generating the response.
    ///   - aiAgent: 
    public init(prompt: String, items: [AiTextGenItemsField], dialogueHistory: [AiDialogueHistory]? = nil, aiAgent: AiAgentReferenceOrAiAgentTextGen? = nil) {
        self.prompt = prompt
        self.items = items
        self.dialogueHistory = dialogueHistory
        self.aiAgent = aiAgent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try container.decode(String.self, forKey: .prompt)
        items = try container.decode([AiTextGenItemsField].self, forKey: .items)
        dialogueHistory = try container.decodeIfPresent([AiDialogueHistory].self, forKey: .dialogueHistory)
        aiAgent = try container.decodeIfPresent(AiAgentReferenceOrAiAgentTextGen.self, forKey: .aiAgent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(dialogueHistory, forKey: .dialogueHistory)
        try container.encodeIfPresent(aiAgent, forKey: .aiAgent)
    }

}
