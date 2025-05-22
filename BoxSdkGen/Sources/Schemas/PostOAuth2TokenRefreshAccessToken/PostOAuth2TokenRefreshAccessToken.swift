import Foundation

/// A request to refresh an Access Token. Use this API to refresh an expired
/// Access Token using a valid Refresh Token.
public class PostOAuth2TokenRefreshAccessToken: Codable {
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case refreshToken = "refresh_token"
        case grantType = "grant_type"
    }

    /// The client ID of the application requesting to refresh the token.
    public let clientId: String

    /// The client secret of the application requesting to refresh the token.
    public let clientSecret: String

    /// The refresh token to refresh.
    public let refreshToken: String

    /// The type of request being made, in this case a refresh request.
    public let grantType: PostOAuth2TokenRefreshAccessTokenGrantTypeField

    /// Initializer for a PostOAuth2TokenRefreshAccessToken.
    ///
    /// - Parameters:
    ///   - clientId: The client ID of the application requesting to refresh the token.
    ///   - clientSecret: The client secret of the application requesting to refresh the token.
    ///   - refreshToken: The refresh token to refresh.
    ///   - grantType: The type of request being made, in this case a refresh request.
    public init(clientId: String, clientSecret: String, refreshToken: String, grantType: PostOAuth2TokenRefreshAccessTokenGrantTypeField = PostOAuth2TokenRefreshAccessTokenGrantTypeField.refreshToken) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.refreshToken = refreshToken
        self.grantType = grantType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        clientId = try container.decode(String.self, forKey: .clientId)
        clientSecret = try container.decode(String.self, forKey: .clientSecret)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        grantType = try container.decode(PostOAuth2TokenRefreshAccessTokenGrantTypeField.self, forKey: .grantType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clientId, forKey: .clientId)
        try container.encode(clientSecret, forKey: .clientSecret)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(grantType, forKey: .grantType)
    }

}
