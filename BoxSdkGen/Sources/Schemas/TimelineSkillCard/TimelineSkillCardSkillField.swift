import Foundation

public class TimelineSkillCardSkillField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// A custom identifier that represent the service that
    /// applied this metadata.
    public let id: String

    /// `service`
    public let type: TimelineSkillCardSkillTypeField

    /// Initializer for a TimelineSkillCardSkillField.
    ///
    /// - Parameters:
    ///   - id: A custom identifier that represent the service that
    ///     applied this metadata.
    ///   - type: `service`
    public init(id: String, type: TimelineSkillCardSkillTypeField = TimelineSkillCardSkillTypeField.service) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(TimelineSkillCardSkillTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
