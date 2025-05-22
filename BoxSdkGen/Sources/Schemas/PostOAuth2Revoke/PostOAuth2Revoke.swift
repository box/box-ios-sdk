import Foundation

/// A request to revoke an OAuth 2.0 token
public class PostOAuth2Revoke: Codable {
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case token
    }

    /// The Client ID of the application requesting to revoke the
    /// access token.
    public let clientId: String?

    /// The client secret of the application requesting to revoke
    /// an access token.
    public let clientSecret: String?

    /// The access token to revoke.
    public let token: String?

    /// Initializer for a PostOAuth2Revoke.
    ///
    /// - Parameters:
    ///   - clientId: The Client ID of the application requesting to revoke the
    ///     access token.
    ///   - clientSecret: The client secret of the application requesting to revoke
    ///     an access token.
    ///   - token: The access token to revoke.
    public init(clientId: String? = nil, clientSecret: String? = nil, token: String? = nil) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.token = token
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clientId = try container.decodeIfPresent(String.self, forKey: .clientId)
        clientSecret = try container.decodeIfPresent(String.self, forKey: .clientSecret)
        token = try container.decodeIfPresent(String.self, forKey: .token)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(clientId, forKey: .clientId)
        try container.encodeIfPresent(clientSecret, forKey: .clientSecret)
        try container.encodeIfPresent(token, forKey: .token)
    }

}
