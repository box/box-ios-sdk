import Foundation

/// AI ask request object
public class AiAsk: Codable {
    private enum CodingKeys: String, CodingKey {
        case mode
        case prompt
        case items
        case dialogueHistory = "dialogue_history"
        case includeCitations = "include_citations"
        case aiAgent = "ai_agent"
    }

    /// Box AI handles text documents with text representations up to 1MB in size, or a maximum of 25 files, whichever comes first. If the text file size exceeds 1MB, the first 1MB of text representation will be processed. Box AI handles image documents with a resolution of 1024 x 1024 pixels, with a maximum of 5 images or 5 pages for multi-page images. If the number of image or image pages exceeds 5, the first 5 images or pages will be processed. If you set mode parameter to `single_item_qa`, the items array can have one element only. Currently Box AI does not support multi-modal requests. If both images and text are sent Box AI will only process the text.
    public let mode: AiAskModeField

    /// The prompt provided by the client to be answered by the LLM. The prompt's length is limited to 10000 characters.
    public let prompt: String

    /// The items to be processed by the LLM, often files.
    public let items: [AiItemAsk]

    /// The history of prompts and answers previously passed to the LLM. This provides additional context to the LLM in generating the response.
    public let dialogueHistory: [AiDialogueHistory]?

    /// A flag to indicate whether citations should be returned.
    public let includeCitations: Bool?

    public let aiAgent: AiAgentAskOrAiAgentReference?

    /// Initializer for a AiAsk.
    ///
    /// - Parameters:
    ///   - mode: Box AI handles text documents with text representations up to 1MB in size, or a maximum of 25 files, whichever comes first. If the text file size exceeds 1MB, the first 1MB of text representation will be processed. Box AI handles image documents with a resolution of 1024 x 1024 pixels, with a maximum of 5 images or 5 pages for multi-page images. If the number of image or image pages exceeds 5, the first 5 images or pages will be processed. If you set mode parameter to `single_item_qa`, the items array can have one element only. Currently Box AI does not support multi-modal requests. If both images and text are sent Box AI will only process the text.
    ///   - prompt: The prompt provided by the client to be answered by the LLM. The prompt's length is limited to 10000 characters.
    ///   - items: The items to be processed by the LLM, often files.
    ///   - dialogueHistory: The history of prompts and answers previously passed to the LLM. This provides additional context to the LLM in generating the response.
    ///   - includeCitations: A flag to indicate whether citations should be returned.
    ///   - aiAgent: 
    public init(mode: AiAskModeField, prompt: String, items: [AiItemAsk], dialogueHistory: [AiDialogueHistory]? = nil, includeCitations: Bool? = nil, aiAgent: AiAgentAskOrAiAgentReference? = nil) {
        self.mode = mode
        self.prompt = prompt
        self.items = items
        self.dialogueHistory = dialogueHistory
        self.includeCitations = includeCitations
        self.aiAgent = aiAgent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(AiAskModeField.self, forKey: .mode)
        prompt = try container.decode(String.self, forKey: .prompt)
        items = try container.decode([AiItemAsk].self, forKey: .items)
        dialogueHistory = try container.decodeIfPresent([AiDialogueHistory].self, forKey: .dialogueHistory)
        includeCitations = try container.decodeIfPresent(Bool.self, forKey: .includeCitations)
        aiAgent = try container.decodeIfPresent(AiAgentAskOrAiAgentReference.self, forKey: .aiAgent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mode, forKey: .mode)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(dialogueHistory, forKey: .dialogueHistory)
        try container.encodeIfPresent(includeCitations, forKey: .includeCitations)
        try container.encodeIfPresent(aiAgent, forKey: .aiAgent)
    }

}
