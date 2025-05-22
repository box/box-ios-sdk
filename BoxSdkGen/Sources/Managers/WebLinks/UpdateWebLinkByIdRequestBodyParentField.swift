import Foundation

public class UpdateWebLinkByIdRequestBodyParentField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
    }

    /// The ID of parent item
    public let id: String?

    /// The input for `user_id` is optional. Moving to non-root folder is not allowed when `user_id` is present. Parent folder id should be zero when `user_id` is provided.
    public let userId: String?

    /// Initializer for a UpdateWebLinkByIdRequestBodyParentField.
    ///
    /// - Parameters:
    ///   - id: The ID of parent item
    ///   - userId: The input for `user_id` is optional. Moving to non-root folder is not allowed when `user_id` is present. Parent folder id should be zero when `user_id` is provided.
    public init(id: String? = nil, userId: String? = nil) {
        self.id = id
        self.userId = userId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(userId, forKey: .userId)
    }

}
