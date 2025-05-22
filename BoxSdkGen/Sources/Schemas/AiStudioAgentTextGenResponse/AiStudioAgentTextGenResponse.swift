import Foundation

/// The AI agent used for generating text.
public class AiStudioAgentTextGenResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case accessState = "access_state"
        case description
        case type
        case customInstructions = "custom_instructions"
        case basicGen = "basic_gen"
    }

    /// The state of the AI Agent capability. Possible values are: `enabled` and `disabled`.
    public let accessState: String

    /// The description of the AI Agent.
    public let description: String

    /// The type of AI agent used for generating text.
    public let type: AiStudioAgentTextGenResponseTypeField

    /// Custom instructions for the agent.
    @CodableTriState public private(set) var customInstructions: String?

    public let basicGen: AiStudioAgentBasicGenToolResponse?

    /// Initializer for a AiStudioAgentTextGenResponse.
    ///
    /// - Parameters:
    ///   - accessState: The state of the AI Agent capability. Possible values are: `enabled` and `disabled`.
    ///   - description: The description of the AI Agent.
    ///   - type: The type of AI agent used for generating text.
    ///   - customInstructions: Custom instructions for the agent.
    ///   - basicGen: 
    public init(accessState: String, description: String, type: AiStudioAgentTextGenResponseTypeField = AiStudioAgentTextGenResponseTypeField.aiAgentTextGen, customInstructions: TriStateField<String> = nil, basicGen: AiStudioAgentBasicGenToolResponse? = nil) {
        self.accessState = accessState
        self.description = description
        self.type = type
        self._customInstructions = CodableTriState(state: customInstructions)
        self.basicGen = basicGen
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessState = try container.decode(String.self, forKey: .accessState)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(AiStudioAgentTextGenResponseTypeField.self, forKey: .type)
        customInstructions = try container.decodeIfPresent(String.self, forKey: .customInstructions)
        basicGen = try container.decodeIfPresent(AiStudioAgentBasicGenToolResponse.self, forKey: .basicGen)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessState, forKey: .accessState)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encode(field: _customInstructions.state, forKey: .customInstructions)
        try container.encodeIfPresent(basicGen, forKey: .basicGen)
    }

}
