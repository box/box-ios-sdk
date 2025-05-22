import Foundation

public class BoxOAuth: Authentication {
    /// Configuration object of OAuth.
    public let config: OAuthConfig

    /// An object responsible for storing token. If no custom implementation provided, the token will be stored in memory.
    public let tokenStorage: TokenStorage

    /// Initializer for a BoxOAuth.
    ///
    /// - Parameters:
    ///   - config: Configuration object of OAuth.
    public init(config: OAuthConfig) {
        self.config = config
        self.tokenStorage = self.config.tokenStorage
    }

    /// Get the authorization URL for the app user.
    ///
    /// - Parameters:
    ///   - options: 
    /// - Returns: The `String`.
    /// - Throws: The `GeneralError`.
    public func getAuthorizeUrl(options: GetAuthorizeUrlOptions = GetAuthorizeUrlOptions()) throws -> String {
        let paramsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["client_id": options.clientId != nil ? options.clientId : self.config.clientId, "response_type": options.responseType != nil ? options.responseType : "code", "redirect_uri": options.redirectUri, "state": options.state, "scope": options.scope])
        return "\("https://account.box.com/api/oauth2/authorize?")\(try JsonUtils.sdToUrlParams(data: try paramsMap.serialize()))"
    }

    /// Acquires token info using an authorization code.
    ///
    /// - Parameters:
    ///   - authorizationCode: The authorization code to use to get tokens.
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func getTokensAuthorizationCodeGrant(authorizationCode: String, networkSession: NetworkSession? = nil) async throws -> AccessToken {
        let authManager: AuthorizationManager = AuthorizationManager(networkSession: networkSession != nil ? networkSession! : NetworkSession())
        let token: AccessToken = try await authManager.requestAccessToken(requestBody: PostOAuth2Token(grantType: PostOAuth2TokenGrantTypeField.authorizationCode, clientId: self.config.clientId, clientSecret: self.config.clientSecret, code: authorizationCode))
        try await self.tokenStorage.store(token: token)
        return token
    }

    /// Get the current access token. If the current access token is expired or not found, this method will attempt to refresh the token.
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func retrieveToken(networkSession: NetworkSession? = nil) async throws -> AccessToken {
        let token: AccessToken? = try await self.tokenStorage.get()
        if token == nil {
            throw BoxSDKError(message: "Access and refresh tokens not available. Authenticate before making any API call first.")
        }

        return token!
    }

    /// Get a new access token for the platform app user.
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func refreshToken(networkSession: NetworkSession? = nil) async throws -> AccessToken {
        let oldToken: AccessToken? = try await self.tokenStorage.get()
        let tokenUsedForRefresh: String? = oldToken != nil ? oldToken!.refreshToken : nil
        let authManager: AuthorizationManager = AuthorizationManager(networkSession: networkSession != nil ? networkSession! : NetworkSession())
        let token: AccessToken = try await authManager.requestAccessToken(requestBody: PostOAuth2Token(grantType: PostOAuth2TokenGrantTypeField.refreshToken, clientId: self.config.clientId, clientSecret: self.config.clientSecret, refreshToken: tokenUsedForRefresh))
        try await self.tokenStorage.store(token: token)
        return token
    }

    public func retrieveAuthorizationHeader(networkSession: NetworkSession? = nil) async throws -> String {
        let token: AccessToken = try await self.retrieveToken(networkSession: networkSession)
        return "\("Bearer ")\(token.accessToken!)"
    }

    /// Revoke an active Access Token, effectively logging a user out that has been previously authenticated.
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Throws: The `GeneralError`.
    public func revokeToken(networkSession: NetworkSession? = nil) async throws {
        let token: AccessToken? = try await self.tokenStorage.get()
        if token == nil {
            return
        }

        let authManager: AuthorizationManager = AuthorizationManager(networkSession: networkSession != nil ? networkSession! : NetworkSession())
        try await authManager.revokeAccessToken(requestBody: PostOAuth2Revoke(clientId: self.config.clientId, clientSecret: self.config.clientSecret, token: token!.accessToken))
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
        if token == nil || token!.accessToken == nil {
            throw BoxSDKError(message: "No access token is available.")
        }

        let authManager: AuthorizationManager = AuthorizationManager(networkSession: networkSession != nil ? networkSession! : NetworkSession())
        let downscopedToken: AccessToken = try await authManager.requestAccessToken(requestBody: PostOAuth2Token(grantType: PostOAuth2TokenGrantTypeField.urnIetfParamsOauthGrantTypeTokenExchange, subjectToken: token!.accessToken, subjectTokenType: PostOAuth2TokenSubjectTokenTypeField.urnIetfParamsOauthTokenTypeAccessToken, scope: scopes.joined(separator: " "), resource: resource, boxSharedLink: sharedLink))
        return downscopedToken
    }

}
