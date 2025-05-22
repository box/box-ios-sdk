import Foundation

/// Comments are messages created on files. Comments
/// can be made independently or created as responses to other
/// comments
public class CommentFull: Comment {
    private enum CodingKeys: String, CodingKey {
        case taggedMessage = "tagged_message"
    }

    /// The string representing the comment text with
    /// @mentions included. @mention format is @[id:username]
    /// where `id` is user's Box ID and `username` is
    /// their display name.
    public let taggedMessage: String?

    /// Initializer for a CommentFull.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this comment.
    ///   - type: `comment`
    ///   - isReplyComment: Whether or not this comment is a reply to another
    ///     comment
    ///   - message: The text of the comment, as provided by the user
    ///   - createdBy: 
    ///   - createdAt: The time this comment was created
    ///   - modifiedAt: The time this comment was last modified
    ///   - item: 
    ///   - taggedMessage: The string representing the comment text with
    ///     @mentions included. @mention format is @[id:username]
    ///     where `id` is user's Box ID and `username` is
    ///     their display name.
    public init(id: String? = nil, type: CommentBaseTypeField? = nil, isReplyComment: Bool? = nil, message: String? = nil, createdBy: UserMini? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, item: CommentItemField? = nil, taggedMessage: String? = nil) {
        self.taggedMessage = taggedMessage

        super.init(id: id, type: type, isReplyComment: isReplyComment, message: message, createdBy: createdBy, createdAt: createdAt, modifiedAt: modifiedAt, item: item)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        taggedMessage = try container.decodeIfPresent(String.self, forKey: .taggedMessage)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(taggedMessage, forKey: .taggedMessage)
        try super.encode(to: encoder)
    }

}
