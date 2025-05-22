import Foundation

public class AiTextGenItemsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case content
    }

    /// The ID of the item.
    public let id: String

    /// The type of the item.
    public let type: AiTextGenItemsTypeField

    /// The content to use as context for generating new text or editing existing text.
    public let content: String?

    /// Initializer for a AiTextGenItemsField.
    ///
    /// - Parameters:
    ///   - id: The ID of the item.
    ///   - type: The type of the item.
    ///   - content: The content to use as context for generating new text or editing existing text.
    public init(id: String, type: AiTextGenItemsTypeField = AiTextGenItemsTypeField.file, content: String? = nil) {
        self.id = id
        self.type = type
        self.content = content
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(AiTextGenItemsTypeField.self, forKey: .type)
        content = try container.decodeIfPresent(String.self, forKey: .content)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(content, forKey: .content)
    }

}
