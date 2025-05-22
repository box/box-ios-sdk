import Foundation

/// The item to be processed by the LLM.
public class AiItemBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case content
    }

    /// The ID of the file.
    public let id: String

    /// The type of the item. Currently the value can be `file` only.
    public let type: AiItemBaseTypeField

    /// The content of the item, often the text representation.
    public let content: String?

    /// Initializer for a AiItemBase.
    ///
    /// - Parameters:
    ///   - id: The ID of the file.
    ///   - type: The type of the item. Currently the value can be `file` only.
    ///   - content: The content of the item, often the text representation.
    public init(id: String, type: AiItemBaseTypeField = AiItemBaseTypeField.file, content: String? = nil) {
        self.id = id
        self.type = type
        self.content = content
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(AiItemBaseTypeField.self, forKey: .type)
        content = try container.decodeIfPresent(String.self, forKey: .content)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(content, forKey: .content)
    }

}
