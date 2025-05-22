import Foundation

public class CommentItemField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this object
    public let id: String?

    /// The type for this object
    public let type: String?

    /// Initializer for a CommentItemField.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this object
    ///   - type: The type for this object
    public init(id: String? = nil, type: String? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
