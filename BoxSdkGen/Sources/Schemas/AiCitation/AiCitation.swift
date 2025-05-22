import Foundation

/// The citation of the LLM's answer reference.
public class AiCitation: Codable {
    private enum CodingKeys: String, CodingKey {
        case content
        case id
        case type
        case name
    }

    /// The specific content from where the answer was referenced.
    public let content: String?

    /// The id of the item.
    public let id: String?

    /// The type of the item.
    public let type: AiCitationTypeField?

    /// The name of the item.
    public let name: String?

    /// Initializer for a AiCitation.
    ///
    /// - Parameters:
    ///   - content: The specific content from where the answer was referenced.
    ///   - id: The id of the item.
    ///   - type: The type of the item.
    ///   - name: The name of the item.
    public init(content: String? = nil, id: String? = nil, type: AiCitationTypeField? = nil, name: String? = nil) {
        self.content = content
        self.id = id
        self.type = type
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(AiCitationTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
    }

}
