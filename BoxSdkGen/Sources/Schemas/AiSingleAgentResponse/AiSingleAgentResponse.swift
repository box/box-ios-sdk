import Foundation

/// Standard representation of an AI Agent instance.
public class AiSingleAgentResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case origin
        case name
        case accessState = "access_state"
        case type
        case createdBy = "created_by"
        case createdAt = "created_at"
        case modifiedBy = "modified_by"
        case modifiedAt = "modified_at"
        case iconReference = "icon_reference"
        case allowedEntities = "allowed_entities"
    }

    /// The unique identifier of the AI Agent.
    public let id: String

    /// The provider of the AI Agent.
    public let origin: String

    /// The name of the AI Agent.
    public let name: String

    /// The state of the AI Agent. Possible values are: `enabled`, `disabled`, and `enabled_for_selected_users`.
    public let accessState: String

    /// The type of agent used to handle queries.
    public let type: AiSingleAgentResponseTypeField?

    /// The user who created this agent.
    public let createdBy: UserBase?

    /// The ISO date-time formatted timestamp of when this AI agent was created.
    public let createdAt: Date?

    /// The user who most recently modified this agent.
    public let modifiedBy: UserBase?

    /// The ISO date-time formatted timestamp of when this AI agent was recently modified.
    public let modifiedAt: Date?

    /// The icon reference of the AI Agent.
    public let iconReference: String?

    /// List of allowed users or groups.
    public let allowedEntities: [AiAgentAllowedEntity]?

    /// Initializer for a AiSingleAgentResponse.
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
    public init(id: String, origin: String, name: String, accessState: String, type: AiSingleAgentResponseTypeField? = nil, createdBy: UserBase? = nil, createdAt: Date? = nil, modifiedBy: UserBase? = nil, modifiedAt: Date? = nil, iconReference: String? = nil, allowedEntities: [AiAgentAllowedEntity]? = nil) {
        self.id = id
        self.origin = origin
        self.name = name
        self.accessState = accessState
        self.type = type
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.modifiedBy = modifiedBy
        self.modifiedAt = modifiedAt
        self.iconReference = iconReference
        self.allowedEntities = allowedEntities
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        origin = try container.decode(String.self, forKey: .origin)
        name = try container.decode(String.self, forKey: .name)
        accessState = try container.decode(String.self, forKey: .accessState)
        type = try container.decodeIfPresent(AiSingleAgentResponseTypeField.self, forKey: .type)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedBy = try container.decodeIfPresent(UserBase.self, forKey: .modifiedBy)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        iconReference = try container.decodeIfPresent(String.self, forKey: .iconReference)
        allowedEntities = try container.decodeIfPresent([AiAgentAllowedEntity].self, forKey: .allowedEntities)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(origin, forKey: .origin)
        try container.encode(name, forKey: .name)
        try container.encode(accessState, forKey: .accessState)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeIfPresent(iconReference, forKey: .iconReference)
        try container.encodeIfPresent(allowedEntities, forKey: .allowedEntities)
    }

}
