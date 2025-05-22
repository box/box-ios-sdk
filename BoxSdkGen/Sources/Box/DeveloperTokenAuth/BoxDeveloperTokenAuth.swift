import Foundation

public class BoxDeveloperTokenAuth: Authentication {
    public let token: String

    /// Configuration object of DeveloperTokenAuth.
    public let config: DeveloperTokenConfig

    /// An object responsible for storing token. If no custom implementation provided, the token will be stored in memory.
    public let tokenStorage: TokenStorage

    /// Initializer for a BoxDeveloperTokenAuth.
    ///
    /// - Parameters:
    ///   - token: 
    ///   - config: Configuration object of DeveloperTokenAuth.
    public init(token: String, config: DeveloperTokenConfig = DeveloperTokenConfig()) {
        self.token = token
        self.config = config
        self.tokenStorage = InMemoryTokenStorage(token: AccessToken(accessToken: self.token))
    }

    /// Retrieves stored developer token
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func retrieveToken(networkSession: NetworkSession? = nil) async throws -> AccessToken {
        let token: AccessToken? = try await self.tokenStorage.get()
        if token == nil {
            throw BoxSDKError(message: "No access token is available.")
        }

        return token!
    }

    /// Developer token cannot be refreshed
    ///
    /// - Parameters:
    ///   - networkSession: An object to keep network session state
    /// - Returns: The `AccessToken`.
    /// - Throws: The `GeneralError`.
    public func refreshToken(networkSession: NetworkSession? = nil) async throws -> AccessToken {
        throw BoxSDKError(message: "Developer token has expired. Please provide a new one.")
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
        try await self.tokenStorage.clear()
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
