import Foundation

public class CreateCommentRequestBodyItemField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of the item
    public let id: String

    /// The type of the item that this comment will be placed on.
    public let type: CreateCommentRequestBodyItemTypeField

    /// Initializer for a CreateCommentRequestBodyItemField.
    ///
    /// - Parameters:
    ///   - id: The ID of the item
    ///   - type: The type of the item that this comment will be placed on.
    public init(id: String, type: CreateCommentRequestBodyItemTypeField) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CreateCommentRequestBodyItemTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
