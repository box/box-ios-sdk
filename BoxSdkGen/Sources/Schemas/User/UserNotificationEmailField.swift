import Foundation

public class UserNotificationEmailField: Codable {
    private enum CodingKeys: String, CodingKey {
        case email
        case isConfirmed = "is_confirmed"
    }

    /// The email address to send the notifications to.
    public let email: String?

    /// Specifies if this email address has been confirmed.
    public let isConfirmed: Bool?

    /// Initializer for a UserNotificationEmailField.
    ///
    /// - Parameters:
    ///   - email: The email address to send the notifications to.
    ///   - isConfirmed: Specifies if this email address has been confirmed.
    public init(email: String? = nil, isConfirmed: Bool? = nil) {
        self.email = email
        self.isConfirmed = isConfirmed
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        isConfirmed = try container.decodeIfPresent(Bool.self, forKey: .isConfirmed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(isConfirmed, forKey: .isConfirmed)
    }

}
