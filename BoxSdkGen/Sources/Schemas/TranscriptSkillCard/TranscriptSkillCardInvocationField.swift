import Foundation

public class TranscriptSkillCardInvocationField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// A custom identifier that represent the instance of
    /// the service that applied this metadata. For example,
    /// if your `image-recognition-service` runs on multiple
    /// nodes, this field can be used to identify the ID of
    /// the node that was used to apply the metadata.
    public let id: String

    /// `skill_invocation`
    public let type: TranscriptSkillCardInvocationTypeField

    /// Initializer for a TranscriptSkillCardInvocationField.
    ///
    /// - Parameters:
    ///   - id: A custom identifier that represent the instance of
    ///     the service that applied this metadata. For example,
    ///     if your `image-recognition-service` runs on multiple
    ///     nodes, this field can be used to identify the ID of
    ///     the node that was used to apply the metadata.
    ///   - type: `skill_invocation`
    public init(id: String, type: TranscriptSkillCardInvocationTypeField = TranscriptSkillCardInvocationTypeField.skillInvocation) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(TranscriptSkillCardInvocationTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
