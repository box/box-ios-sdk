import Foundation

/// Full representation of an AI Agent instance.
public class AiSingleAgentResponseFull: AiSingleAgentResponse {
    private enum CodingKeys: String, CodingKey {
        case ask
        case textGen = "text_gen"
        case extract
    }

    public let ask: AiStudioAgentAskResponse?

    public let textGen: AiStudioAgentTextGenResponse?

    public let extract: AiStudioAgentExtractResponse?

    /// Initializer for a AiSingleAgentResponseFull.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the AI Agent.
    ///   - origin: The provider of the AI Agent.
    ///   - name: The name of the AI Agent.
    ///   - accessState: The state of the AI Agent. Possible values are: `enabled`, `disabled`, and `enabled_for_selected_users`.
    ///   - type: The type of agent used to handle queries.
    ///   - createdBy: The user who created this agent.
    ///   - createdAt: The ISO date-time formatted timestamp of when this AI agent was created.
    ///   - modifiedBy: The user who most recently modified this agent.
    ///   - modifiedAt: The ISO date-time formatted timestamp of when this AI agent was recently modified.
    ///   - iconReference: The icon reference of the AI Agent.
    ///   - allowedEntities: List of allowed users or groups.
    ///   - ask: 
    ///   - textGen: 
    ///   - extract: 
    public init(id: String, origin: String, name: String, accessState: String, type: AiSingleAgentResponseTypeField? = nil, createdBy: UserBase? = nil, createdAt: Date? = nil, modifiedBy: UserBase? = nil, modifiedAt: Date? = nil, iconReference: String? = nil, allowedEntities: [AiAgentAllowedEntity]? = nil, ask: AiStudioAgentAskResponse? = nil, textGen: AiStudioAgentTextGenResponse? = nil, extract: AiStudioAgentExtractResponse? = nil) {
        self.ask = ask
        self.textGen = textGen
        self.extract = extract

        super.init(id: id, origin: origin, name: name, accessState: accessState, type: type, createdBy: createdBy, createdAt: createdAt, modifiedBy: modifiedBy, modifiedAt: modifiedAt, iconReference: iconReference, allowedEntities: allowedEntities)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ask = try container.decodeIfPresent(AiStudioAgentAskResponse.self, forKey: .ask)
        textGen = try container.decodeIfPresent(AiStudioAgentTextGenResponse.self, forKey: .textGen)
        extract = try container.decodeIfPresent(AiStudioAgentExtractResponse.self, forKey: .extract)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(ask, forKey: .ask)
        try container.encodeIfPresent(textGen, forKey: .textGen)
        try container.encodeIfPresent(extract, forKey: .extract)
        try super.encode(to: encoder)
    }

}
