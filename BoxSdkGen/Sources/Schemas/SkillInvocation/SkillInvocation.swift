import Foundation

/// The payload of a Box skill as sent to a skill's
/// `invocation_url`.
public class SkillInvocation: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case skill
        case token
        case status
        case createdAt = "created_at"
        case trigger
        case enterprise
        case source
        case event
    }

    /// `skill_invocation`
    public let type: SkillInvocationTypeField?

    /// Unique identifier for the invocation request.
    public let id: String?

    public let skill: SkillInvocationSkillField?

    /// The read-only and read-write access tokens for this item
    public let token: SkillInvocationTokenField?

    /// The details status of this event.
    public let status: SkillInvocationStatusField?

    /// The time this invocation was created.
    public let createdAt: Date?

    /// Action that triggered the invocation
    public let trigger: String?

    public let enterprise: SkillInvocationEnterpriseField?

    public let source: FileOrFolder?

    public let event: Event?

    /// Initializer for a SkillInvocation.
    ///
    /// - Parameters:
    ///   - type: `skill_invocation`
    ///   - id: Unique identifier for the invocation request.
    ///   - skill: 
    ///   - token: The read-only and read-write access tokens for this item
    ///   - status: The details status of this event.
    ///   - createdAt: The time this invocation was created.
    ///   - trigger: Action that triggered the invocation
    ///   - enterprise: 
    ///   - source: 
    ///   - event: 
    public init(type: SkillInvocationTypeField? = nil, id: String? = nil, skill: SkillInvocationSkillField? = nil, token: SkillInvocationTokenField? = nil, status: SkillInvocationStatusField? = nil, createdAt: Date? = nil, trigger: String? = nil, enterprise: SkillInvocationEnterpriseField? = nil, source: FileOrFolder? = nil, event: Event? = nil) {
        self.type = type
        self.id = id
        self.skill = skill
        self.token = token
        self.status = status
        self.createdAt = createdAt
        self.trigger = trigger
        self.enterprise = enterprise
        self.source = source
        self.event = event
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(SkillInvocationTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        skill = try container.decodeIfPresent(SkillInvocationSkillField.self, forKey: .skill)
        token = try container.decodeIfPresent(SkillInvocationTokenField.self, forKey: .token)
        status = try container.decodeIfPresent(SkillInvocationStatusField.self, forKey: .status)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        trigger = try container.decodeIfPresent(String.self, forKey: .trigger)
        enterprise = try container.decodeIfPresent(SkillInvocationEnterpriseField.self, forKey: .enterprise)
        source = try container.decodeIfPresent(FileOrFolder.self, forKey: .source)
        event = try container.decodeIfPresent(Event.self, forKey: .event)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(skill, forKey: .skill)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(trigger, forKey: .trigger)
        try container.encodeIfPresent(enterprise, forKey: .enterprise)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(event, forKey: .event)
    }

}
