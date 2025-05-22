import Foundation

/// The AI Agent to be used for ask.
public class AiStudioAgentAskResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case accessState = "access_state"
        case description
        case type
        case customInstructions = "custom_instructions"
        case longText = "long_text"
        case basicText = "basic_text"
        case longTextMulti = "long_text_multi"
        case basicTextMulti = "basic_text_multi"
    }

    /// The state of the AI Agent capability. Possible values are: `enabled` and `disabled`.
    public let accessState: String

    /// The description of the AI Agent.
    public let description: String

    /// The type of AI agent used to handle queries.
    public let type: AiStudioAgentAskResponseTypeField

    /// Custom instructions for the agent.
    @CodableTriState public private(set) var customInstructions: String?

    public let longText: AiStudioAgentLongTextToolResponse?

    public let basicText: AiStudioAgentBasicTextToolResponse?

    public let longTextMulti: AiStudioAgentLongTextToolResponse?

    public let basicTextMulti: AiStudioAgentBasicTextToolResponse?

    /// Initializer for a AiStudioAgentAskResponse.
    ///
    /// - Parameters:
    ///   - accessState: The state of the AI Agent capability. Possible values are: `enabled` and `disabled`.
    ///   - description: The description of the AI Agent.
    ///   - type: The type of AI agent used to handle queries.
    ///   - customInstructions: Custom instructions for the agent.
    ///   - longText: 
    ///   - basicText: 
    ///   - longTextMulti: 
    ///   - basicTextMulti: 
    public init(accessState: String, description: String, type: AiStudioAgentAskResponseTypeField = AiStudioAgentAskResponseTypeField.aiAgentAsk, customInstructions: TriStateField<String> = nil, longText: AiStudioAgentLongTextToolResponse? = nil, basicText: AiStudioAgentBasicTextToolResponse? = nil, longTextMulti: AiStudioAgentLongTextToolResponse? = nil, basicTextMulti: AiStudioAgentBasicTextToolResponse? = nil) {
        self.accessState = accessState
        self.description = description
        self.type = type
        self._customInstructions = CodableTriState(state: customInstructions)
        self.longText = longText
        self.basicText = basicText
        self.longTextMulti = longTextMulti
        self.basicTextMulti = basicTextMulti
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessState = try container.decode(String.self, forKey: .accessState)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(AiStudioAgentAskResponseTypeField.self, forKey: .type)
        customInstructions = try container.decodeIfPresent(String.self, forKey: .customInstructions)
        longText = try container.decodeIfPresent(AiStudioAgentLongTextToolResponse.self, forKey: .longText)
        basicText = try container.decodeIfPresent(AiStudioAgentBasicTextToolResponse.self, forKey: .basicText)
        longTextMulti = try container.decodeIfPresent(AiStudioAgentLongTextToolResponse.self, forKey: .longTextMulti)
        basicTextMulti = try container.decodeIfPresent(AiStudioAgentBasicTextToolResponse.self, forKey: .basicTextMulti)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessState, forKey: .accessState)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encode(field: _customInstructions.state, forKey: .customInstructions)
        try container.encodeIfPresent(longText, forKey: .longText)
        try container.encodeIfPresent(basicText, forKey: .basicText)
        try container.encodeIfPresent(longTextMulti, forKey: .longTextMulti)
        try container.encodeIfPresent(basicTextMulti, forKey: .basicTextMulti)
    }

}
