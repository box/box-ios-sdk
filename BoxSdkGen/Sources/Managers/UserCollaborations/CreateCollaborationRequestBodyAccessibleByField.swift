import Foundation

public class CreateCollaborationRequestBodyAccessibleByField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case login
    }

    /// The type of collaborator to invite.
    public let type: CreateCollaborationRequestBodyAccessibleByTypeField

    /// The ID of the user or group.
    /// 
    /// Alternatively, use `login` to specify a user by email
    /// address.
    public let id: String?

    /// The email address of the user to grant access to the item.
    /// 
    /// Alternatively, use `id` to specify a user by user ID.
    public let login: String?

    /// Initializer for a CreateCollaborationRequestBodyAccessibleByField.
    ///
    /// - Parameters:
    ///   - type: The type of collaborator to invite.
    ///   - id: The ID of the user or group.
    ///     
    ///     Alternatively, use `login` to specify a user by email
    ///     address.
    ///   - login: The email address of the user to grant access to the item.
    ///     
    ///     Alternatively, use `id` to specify a user by user ID.
    public init(type: CreateCollaborationRequestBodyAccessibleByTypeField, id: String? = nil, login: String? = nil) {
        self.type = type
        self.id = id
        self.login = login
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(CreateCollaborationRequestBodyAccessibleByTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        login = try container.decodeIfPresent(String.self, forKey: .login)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(login, forKey: .login)
    }

}
