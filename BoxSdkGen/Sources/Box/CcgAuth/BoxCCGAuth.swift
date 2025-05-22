import Foundation

public class BoxCCGAuth: Authentication {
    /// Configuration object of Client Credentials Grant auth.
    public let config: CCGConfig

    /// An object responsible for storing token. If no custom implementation provided, the token will be stored in memory.
    public let tokenStorage: TokenStorage

    /// The ID of the user or enterprise to authenticate as. If not provided, defaults to the enterprise ID if set, otherwise defaults to the user ID.
    public let subjectId: String?

    /// The type of the subject ID provided. Must be either 'user' or 'enterprise'.
    public let subjectType: PostOAuth2TokenBoxSubjectTypeField?

    /// Initializer for a BoxCCGAuth.
    ///
    /// - Parameters:
    ///   - config: Configuration object of Client Credentials Grant auth.
    public init(config: CCGConfig) {
        self.config = config
        self.tokenStorage = self.config.tokenStorage
        self.subjectId = self.config.userId != nil ? self.config.userId : self.config.enterpriseId
        self.subjectType = self.config.userId != nil ? PostOAuth2TokenBoxSubjectTypeField.user : PostOAuth2TokenBoxSubjectTypeField.enterprise
    }

    /// Get a new access token using CCG auth
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func refreshToken(networkSession: NetworkSession? = nil) async throws -> AccessToken {
        let authManager: AuthorizationManager = AuthorizationManager(networkSession: networkSession != nil ? networkSession! : NetworkSession())
        let token: AccessToken = try await authManager.requestAccessToken(requestBody: PostOAuth2Token(grantType: PostOAuth2TokenGrantTypeField.clientCredentials, clientId: self.config.clientId, clientSecret: self.config.clientSecret, boxSubjectType: self.subjectType, boxSubjectId: self.subjectId))
        try await self.tokenStorage.store(token: token)
        return token
    }

    /// Return a current token or get a new one when not available.
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func retrieveToken(networkSession: NetworkSession? = nil) async throws -> AccessToken {
        let oldToken: AccessToken? = try await self.tokenStorage.get()
        if oldToken == nil {
            let newToken: AccessToken = try await self.refreshToken(networkSession: networkSession)
            return newToken
        }

        return oldToken!
    }

    public func retrieveAuthorizationHeader(networkSession: NetworkSession? = nil) async throws -> String {
        let token: AccessToken = try await self.retrieveToken(networkSession: networkSession)
        return "\("Bearer ")\(token.accessToken!)"
    }

    /// Create a new BoxCCGAuth instance that uses the provided user ID as the subject ID.
    /// May be one of this application's created App User. Depending on the configured User Access Level, may also be any other App User or Managed User in the enterprise.
    /// <https://developer.box.com/en/guides/applications/>
    /// <https://developer.box.com/en/guides/authentication/select/>
    ///
    /// - Parameters:
    ///   - userId: The id of the user to authenticate
    ///   - tokenStorage: Object responsible for storing token in newly created BoxCCGAuth. If no custom implementation provided, the token will be stored in memory.
    /// - Returns: The `BoxCCGAuth`.
    public func withUserSubject(userId: String, tokenStorage: TokenStorage = InMemoryTokenStorage()) -> BoxCCGAuth {
        let newConfig: CCGConfig = CCGConfig(clientId: self.config.clientId, clientSecret: self.config.clientSecret, enterpriseId: self.config.enterpriseId, userId: userId, tokenStorage: tokenStorage)
        return BoxCCGAuth(config: newConfig)
    }

    /// Create a new BoxCCGAuth instance that uses the provided enterprise ID as the subject ID.
    ///
    /// - Parameters:
    ///   - enterpriseId: The id of the enterprise to authenticate
    ///   - tokenStorage: Object responsible for storing token in newly created BoxCCGAuth. If no custom implementation provided, the token will be stored in memory.
    /// - Returns: The `BoxCCGAuth`.
    public func withEnterpriseSubject(enterpriseId: String, tokenStorage: TokenStorage = InMemoryTokenStorage()) -> BoxCCGAuth {
        let newConfig: CCGConfig = CCGConfig(clientId: self.config.clientId, clientSecret: self.config.clientSecret, enterpriseId: enterpriseId, userId: nil, tokenStorage: tokenStorage)
        return BoxCCGAuth(config: newConfig)
    }

    /// Downscope access token to the provided scopes. Returning a new access token with the provided scopes, with the original access token unchanged.
    ///
    /// - Parameters:
    ///   - scopes: The scope(s) to apply to the resulting token.
    ///   - resource: The file or folder to get a downscoped token for. If None and shared_link None, the resulting token will not be scoped down to just a single item. The resource should be a full URL to an item, e.g. https://api.box.com/2.0/files/123456.
    ///   - sharedLink: The shared link to get a downscoped token for. If None and item None, the resulting token will not be scoped down to just a single item.
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func downscopeToken(scopes: [String], resource: String? = nil, sharedLink: String? = nil, networkSession: NetworkSession? = nil) async throws -> AccessToken {
        let token: AccessToken? = try await self.tokenStorage.get()
        if token == nil {
            throw BoxSDKError(message: "No access token is available. Make an API call to retrieve a token before calling this method.")
        }

        let authManager: AuthorizationManager = AuthorizationManager(networkSession: networkSession != nil ? networkSession! : NetworkSession())
        let downscopedToken: AccessToken = try await authManager.requestAccessToken(requestBody: PostOAuth2Token(grantType: PostOAuth2TokenGrantTypeField.urnIetfParamsOauthGrantTypeTokenExchange, subjectToken: token!.accessToken, subjectTokenType: PostOAuth2TokenSubjectTokenTypeField.urnIetfParamsOauthTokenTypeAccessToken, scope: scopes.joined(separator: " "), resource: resource, boxSharedLink: sharedLink))
        return downscopedToken
    }

    /// Revoke the current access token and remove it from token storage.
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Throws: The `GeneralError`.
    public func revokeToken(networkSession: NetworkSession? = nil) async throws {
        let oldToken: AccessToken? = try await self.tokenStorage.get()
        if oldToken == nil {
            return
        }

        let authManager: AuthorizationManager = AuthorizationManager(networkSession: networkSession != nil ? networkSession! : NetworkSession())
        try await authManager.revokeAccessToken(requestBody: PostOAuth2Revoke(clientId: self.config.clientId, clientSecret: self.config.clientSecret, token: oldToken!.accessToken))
        try await self.tokenStorage.clear()
    }

}
