import Foundation

public class CreateCommentRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case message
        case item
        case taggedMessage = "tagged_message"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The text of the comment.
    /// 
    /// To mention a user, use the `tagged_message`
    /// parameter instead.
    public let message: String

    /// The item to attach the comment to.
    public let item: CreateCommentRequestBodyItemField

    /// The text of the comment, including `@[user_id:name]`
    /// somewhere in the message to mention another user, which
    /// will send them an email notification, letting them know
    /// they have been mentioned.
    /// 
    /// The `user_id` is the target user's ID, where the `name`
    /// can be any custom phrase. In the Box UI this name will
    /// link to the user's profile.
    /// 
    /// If you are not mentioning another user, use `message`
    /// instead.
    public let taggedMessage: String?

    /// Initializer for a CreateCommentRequestBody.
    ///
    /// - Parameters:
    ///   - message: The text of the comment.
    ///     
    ///     To mention a user, use the `tagged_message`
    ///     parameter instead.
    ///   - item: The item to attach the comment to.
    ///   - taggedMessage: The text of the comment, including `@[user_id:name]`
    ///     somewhere in the message to mention another user, which
    ///     will send them an email notification, letting them know
    ///     they have been mentioned.
    ///     
    ///     The `user_id` is the target user's ID, where the `name`
    ///     can be any custom phrase. In the Box UI this name will
    ///     link to the user's profile.
    ///     
    ///     If you are not mentioning another user, use `message`
    ///     instead.
    public init(message: String, item: CreateCommentRequestBodyItemField, taggedMessage: String? = nil) {
        self.message = message
        self.item = item
        self.taggedMessage = taggedMessage
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        item = try container.decode(CreateCommentRequestBodyItemField.self, forKey: .item)
        taggedMessage = try container.decodeIfPresent(String.self, forKey: .taggedMessage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(item, forKey: .item)
        try container.encodeIfPresent(taggedMessage, forKey: .taggedMessage)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
