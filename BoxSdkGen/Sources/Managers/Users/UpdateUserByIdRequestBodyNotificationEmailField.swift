import Foundation

public class UpdateUserByIdRequestBodyNotificationEmailField: Codable {
    private enum CodingKeys: String, CodingKey {
        case email
    }

    /// The email address to send the notifications to.
    public let email: String?

    /// Initializer for a UpdateUserByIdRequestBodyNotificationEmailField.
    ///
    /// - Parameters:
    ///   - email: The email address to send the notifications to.
    public init(email: String? = nil) {
        self.email = email
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decodeIfPresent(String.self, forKey: .email)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
    }

}
