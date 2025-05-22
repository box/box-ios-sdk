import Foundation

/// A token that can be used to make authenticated API calls.
public class AccessToken: Codable {
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case restrictedTo = "restricted_to"
        case refreshToken = "refresh_token"
        case issuedTokenType = "issued_token_type"
    }

    /// The requested access token.
    public let accessToken: String?

    /// The time in seconds by which this token will expire.
    public let expiresIn: Int64?

    /// The type of access token returned.
    public let tokenType: AccessTokenTokenTypeField?

    /// The permissions that this access token permits,
    /// providing a list of resources (files, folders, etc)
    /// and the scopes permitted for each of those resources.
    public let restrictedTo: [FileOrFolderScope]?

    /// The refresh token for this access token, which can be used
    /// to request a new access token when the current one expires.
    public let refreshToken: String?

    /// The type of downscoped access token returned. This is only
    /// returned if an access token has been downscoped.
    public let issuedTokenType: AccessTokenIssuedTokenTypeField?

    /// Initializer for a AccessToken.
    ///
    /// - Parameters:
    ///   - accessToken: The requested access token.
    ///   - expiresIn: The time in seconds by which this token will expire.
    ///   - tokenType: The type of access token returned.
    ///   - restrictedTo: The permissions that this access token permits,
    ///     providing a list of resources (files, folders, etc)
    ///     and the scopes permitted for each of those resources.
    ///   - refreshToken: The refresh token for this access token, which can be used
    ///     to request a new access token when the current one expires.
    ///   - issuedTokenType: The type of downscoped access token returned. This is only
    ///     returned if an access token has been downscoped.
    public init(accessToken: String? = nil, expiresIn: Int64? = nil, tokenType: AccessTokenTokenTypeField? = nil, restrictedTo: [FileOrFolderScope]? = nil, refreshToken: String? = nil, issuedTokenType: AccessTokenIssuedTokenTypeField? = nil) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.restrictedTo = restrictedTo
        self.refreshToken = refreshToken
        self.issuedTokenType = issuedTokenType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        expiresIn = try container.decodeIfPresent(Int64.self, forKey: .expiresIn)
        tokenType = try container.decodeIfPresent(AccessTokenTokenTypeField.self, forKey: .tokenType)
        restrictedTo = try container.decodeIfPresent([FileOrFolderScope].self, forKey: .restrictedTo)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        issuedTokenType = try container.decodeIfPresent(AccessTokenIssuedTokenTypeField.self, forKey: .issuedTokenType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(accessToken, forKey: .accessToken)
        try container.encodeIfPresent(expiresIn, forKey: .expiresIn)
        try container.encodeIfPresent(tokenType, forKey: .tokenType)
        try container.encodeIfPresent(restrictedTo, forKey: .restrictedTo)
        try container.encodeIfPresent(refreshToken, forKey: .refreshToken)
        try container.encodeIfPresent(issuedTokenType, forKey: .issuedTokenType)
    }

}
