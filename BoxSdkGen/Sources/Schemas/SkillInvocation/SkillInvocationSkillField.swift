import Foundation

public class SkillInvocationSkillField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case apiKey = "api_key"
    }

    /// The unique identifier for this skill
    public let id: String?

    /// `skill`
    public let type: SkillInvocationSkillTypeField?

    /// The name of the skill
    public let name: String?

    /// The client ID of the application
    public let apiKey: String?

    /// Initializer for a SkillInvocationSkillField.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this skill
    ///   - type: `skill`
    ///   - name: The name of the skill
    ///   - apiKey: The client ID of the application
    public init(id: String? = nil, type: SkillInvocationSkillTypeField? = nil, name: String? = nil, apiKey: String? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.apiKey = apiKey
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(SkillInvocationSkillTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        apiKey = try container.decodeIfPresent(String.self, forKey: .apiKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(apiKey, forKey: .apiKey)
    }

}
