import Foundation

/// Base representation of a comment.
public class CommentBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this comment.
    public let id: String?

    /// `comment`
    public let type: CommentBaseTypeField?

    /// Initializer for a CommentBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this comment.
    ///   - type: `comment`
    public init(id: String? = nil, type: CommentBaseTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(CommentBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
