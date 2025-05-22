import Foundation

/// An email alias for a user.
public class EmailAlias: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case email
        case isConfirmed = "is_confirmed"
    }

    /// The unique identifier for this object
    public let id: String?

    /// `email_alias`
    public let type: EmailAliasTypeField?

    /// The email address
    public let email: String?

    /// Whether the email address has been confirmed
    public let isConfirmed: Bool?

    /// Initializer for a EmailAlias.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this object
    ///   - type: `email_alias`
    ///   - email: The email address
    ///   - isConfirmed: Whether the email address has been confirmed
    public init(id: String? = nil, type: EmailAliasTypeField? = nil, email: String? = nil, isConfirmed: Bool? = nil) {
        self.id = id
        self.type = type
        self.email = email
        self.isConfirmed = isConfirmed
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(EmailAliasTypeField.self, forKey: .type)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        isConfirmed = try container.decodeIfPresent(Bool.self, forKey: .isConfirmed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(isConfirmed, forKey: .isConfirmed)
    }

}
