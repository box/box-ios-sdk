import Foundation

/// A mini representation of a user, can be returned only when
/// the status is `pending`.
public class UserCollaborations: UserBase {
    private enum CodingKeys: String, CodingKey {
        case name
        case login
        case isActive = "is_active"
    }

    /// The display name of this user. If the collaboration status is `pending`, an empty string is returned.
    public let name: String?

    /// The primary email address of this user. If the collaboration status is `pending`, an empty string is returned.
    public let login: String?

    /// If set to `false`, the user is either deactivated or deleted.
    public let isActive: Bool?

    /// Initializer for a UserCollaborations.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this user
    ///   - type: `user`
    ///   - name: The display name of this user. If the collaboration status is `pending`, an empty string is returned.
    ///   - login: The primary email address of this user. If the collaboration status is `pending`, an empty string is returned.
    ///   - isActive: If set to `false`, the user is either deactivated or deleted.
    public init(id: String, type: UserBaseTypeField = UserBaseTypeField.user, name: String? = nil, login: String? = nil, isActive: Bool? = nil) {
        self.name = name
        self.login = login
        self.isActive = isActive

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        login = try container.decodeIfPresent(String.self, forKey: .login)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(login, forKey: .login)
        try container.encodeIfPresent(isActive, forKey: .isActive)
        try super.encode(to: encoder)
    }

}
