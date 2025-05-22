import Foundation

public class CreateInviteRequestBodyActionableByField: Codable {
    private enum CodingKeys: String, CodingKey {
        case login
    }

    /// The login of the invited user
    public let login: String?

    /// Initializer for a CreateInviteRequestBodyActionableByField.
    ///
    /// - Parameters:
    ///   - login: The login of the invited user
    public init(login: String? = nil) {
        self.login = login
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decodeIfPresent(String.self, forKey: .login)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(login, forKey: .login)
    }

}
