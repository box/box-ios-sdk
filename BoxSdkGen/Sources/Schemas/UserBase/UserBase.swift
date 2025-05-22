import Foundation

/// A mini representation of a user, used when
/// nested within another resource.
public class UserBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this user
    public let id: String

    /// `user`
    public let type: UserBaseTypeField

    /// Initializer for a UserBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this user
    ///   - type: `user`
    public init(id: String, type: UserBaseTypeField = UserBaseTypeField.user) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(UserBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
