import Foundation

/// The schema for AI agent create request.
public class CreateAiAgent: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case accessState = "access_state"
        case type
        case iconReference = "icon_reference"
        case allowedEntities = "allowed_entities"
        case ask
        case textGen = "text_gen"
        case extract
    }

    /// The name of the AI Agent.
    public let name: String

    /// The state of the AI Agent. Possible values are: `enabled`, `disabled`, and `enabled_for_selected_users`.
    public let accessState: String

    /// The type of agent used to handle queries.
    public let type: CreateAiAgentTypeField

    /// The icon reference of the AI Agent. It should have format of the URL `https://cdn01.boxcdn.net/app-assets/aistudio/avatars/<file_name>`
    /// where possible values of `file_name` are: `logo_boxAi.png`,`logo_stamp.png`,`logo_legal.png`,`logo_finance.png`,`logo_config.png`,`logo_handshake.png`,`logo_analytics.png`,`logo_classification.png`
    public let iconReference: String?

    /// List of allowed users or groups.
    public let allowedEntities: [AiAgentAllowedEntity]?

    public let ask: AiStudioAgentAsk?

    public let textGen: AiStudioAgentTextGen?

    public let extract: AiStudioAgentExtract?

    /// Initializer for a CreateAiAgent.
    ///
    /// - Parameters:
    ///   - name: The name of the AI Agent.
    ///   - accessState: The state of the AI Agent. Possible values are: `enabled`, `disabled`, and `enabled_for_selected_users`.
    ///   - type: The type of agent used to handle queries.
    ///   - iconReference: The icon reference of the AI Agent. It should have format of the URL `https://cdn01.boxcdn.net/app-assets/aistudio/avatars/<file_name>`
    ///     where possible values of `file_name` are: `logo_boxAi.png`,`logo_stamp.png`,`logo_legal.png`,`logo_finance.png`,`logo_config.png`,`logo_handshake.png`,`logo_analytics.png`,`logo_classification.png`
    ///   - allowedEntities: List of allowed users or groups.
    ///   - ask: 
    ///   - textGen: 
    ///   - extract: 
    public init(name: String, accessState: String, type: CreateAiAgentTypeField = CreateAiAgentTypeField.aiAgent, iconReference: String? = nil, allowedEntities: [AiAgentAllowedEntity]? = nil, ask: AiStudioAgentAsk? = nil, textGen: AiStudioAgentTextGen? = nil, extract: AiStudioAgentExtract? = nil) {
        self.name = name
        self.accessState = accessState
        self.type = type
        self.iconReference = iconReference
        self.allowedEntities = allowedEntities
        self.ask = ask
        self.textGen = textGen
        self.extract = extract
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        accessState = try container.decode(String.self, forKey: .accessState)
        type = try container.decode(CreateAiAgentTypeField.self, forKey: .type)
        iconReference = try container.decodeIfPresent(String.self, forKey: .iconReference)
        allowedEntities = try container.decodeIfPresent([AiAgentAllowedEntity].self, forKey: .allowedEntities)
        ask = try container.decodeIfPresent(AiStudioAgentAsk.self, forKey: .ask)
        textGen = try container.decodeIfPresent(AiStudioAgentTextGen.self, forKey: .textGen)
        extract = try container.decodeIfPresent(AiStudioAgentExtract.self, forKey: .extract)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(accessState, forKey: .accessState)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(iconReference, forKey: .iconReference)
        try container.encodeIfPresent(allowedEntities, forKey: .allowedEntities)
        try container.encodeIfPresent(ask, forKey: .ask)
        try container.encodeIfPresent(textGen, forKey: .textGen)
        try container.encodeIfPresent(extract, forKey: .extract)
    }

}
