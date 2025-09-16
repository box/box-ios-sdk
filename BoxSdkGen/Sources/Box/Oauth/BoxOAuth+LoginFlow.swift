import Foundation
#if os(iOS) || os(macOS)
import AuthenticationServices
#endif


/// Extension for OAuth Authentication
public extension BoxOAuth {

#if os(iOS) || os(macOS)
    /// The complete authorization code flow which opens a secure web view,
    /// where users enter their login credentials to obtain an authorization code, which is then exchanged for an access token.
    ///
    /// This requires that the application using the SDK registers itself for a custom URL scheme of the
    /// format `boxsdk-<<CLIENT ID>>://boxsdkoauth2redirect`
    ///
    /// As the result of this method, an access token will be returned and the `AccessTokenRepresentation`
    /// will be stored in the current instance for future use.
    ///
    /// - Parameters:
    ///   - options: The parameters for the authorization URL.
    ///     If `options.redirectUri` is not set, then the field  will be automatically set according to the established format `boxsdk-<<CLIENT ID>>://boxsdkoauth2redirect`,
    ///     where `<<CLIENT_ID>>` will be replaced with the actual `clientId` from the config.
    ///   - context: A context to target where in an application's UI the authorization view should be shown.
    /// - Returns: The access token.
    /// - Throws: An error if for any reason the token cannot be fetched.
    @discardableResult
    func runLoginFlow(
        options: GetAuthorizeUrlOptions,
        context: ASWebAuthenticationPresentationContextProviding
    ) async throws -> AccessToken {
        let redirectUri = BoxOAuthWebAuthentication.getCallbackUrlScheme(
            redirectUri: options.redirectUri,
            clientId: self.config.clientId
        )
        let authorizeOptions = GetAuthorizeUrlOptions(
            clientId: options.clientId ?? self.config.clientId,
            redirectUri: options.redirectUri ?? redirectUri,
            responseType: options.responseType,
            state: options.state,
            scope: options.scope
        )

        let webAuthentication = BoxOAuthWebAuthentication(
            authorizeUrl: try getAuthorizeUrl(options: authorizeOptions)
        )

        let code = try await webAuthentication.obtainAuthorizationCode(
            options: authorizeOptions,
            context: context
        )

        return try await getTokensAuthorizationCodeGrant(authorizationCode: code)
    }
#endif
}
