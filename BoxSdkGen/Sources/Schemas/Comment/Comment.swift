import Foundation

/// Standard representation of a comment.
public class Comment: CommentBase {
    private enum CodingKeys: String, CodingKey {
        case isReplyComment = "is_reply_comment"
        case message
        case createdBy = "created_by"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case item
    }

    /// Whether or not this comment is a reply to another
    /// comment
    public let isReplyComment: Bool?

    /// The text of the comment, as provided by the user
    public let message: String?

    public let createdBy: UserMini?

    /// The time this comment was created
    public let createdAt: Date?

    /// The time this comment was last modified
    public let modifiedAt: Date?

    public let item: CommentItemField?

    /// Initializer for a Comment.
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
    public init(id: String? = nil, type: CommentBaseTypeField? = nil, isReplyComment: Bool? = nil, message: String? = nil, createdBy: UserMini? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, item: CommentItemField? = nil) {
        self.isReplyComment = isReplyComment
        self.message = message
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.item = item

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isReplyComment = try container.decodeIfPresent(Bool.self, forKey: .isReplyComment)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        item = try container.decodeIfPresent(CommentItemField.self, forKey: .item)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isReplyComment, forKey: .isReplyComment)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeIfPresent(item, forKey: .item)
        try super.encode(to: encoder)
    }

}
