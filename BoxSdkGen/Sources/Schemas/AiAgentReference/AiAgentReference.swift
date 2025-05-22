import Foundation

/// The AI agent used to handle queries.
public class AiAgentReference: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// The type of AI agent used to handle queries.
    public let type: AiAgentReferenceTypeField

    /// The ID of an Agent
    public let id: String?

    /// Initializer for a AiAgentReference.
    ///
    /// - Parameters:
    ///   - type: The type of AI agent used to handle queries.
    ///   - id: The ID of an Agent
    public init(type: AiAgentReferenceTypeField = AiAgentReferenceTypeField.aiAgentId, id: String? = nil) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(AiAgentReferenceTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
    }

}
