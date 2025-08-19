import Foundation

/// Options of getAuthorizeUrl method
public class GetAuthorizeUrlOptions {
    /// Box API key used for identifying the application the user is authenticating with
    public let clientId: String?

    /// The URI to which Box redirects the browser after the user has granted or denied the application permission. This URI match one of the redirect URIs in the configuration of your application.
    public let redirectUri: String?

    /// The type of response we would like to receive.
    public let responseType: String?

    /// A custom string of your choice. Box will pass the same string to the redirect URL when authentication is complete. This parameter can be used to identify a user on redirect, as well as protect against hijacked sessions and other exploits.
    public let state: String?

    /// A space-separated list of application scopes you'd like to authenticate the user for. This defaults to all the scopes configured for the application in its configuration page.
    public let scope: String?

    /// Initializer for a GetAuthorizeUrlOptions.
    ///
    /// - Parameters:
    ///   - clientId: Box API key used for identifying the application the user is authenticating with
    ///   - redirectUri: The URI to which Box redirects the browser after the user has granted or denied the application permission. This URI match one of the redirect URIs in the configuration of your application.
    ///   - responseType: The type of response we would like to receive.
    ///   - state: A custom string of your choice. Box will pass the same string to the redirect URL when authentication is complete. This parameter can be used to identify a user on redirect, as well as protect against hijacked sessions and other exploits.
    ///   - scope: A space-separated list of application scopes you'd like to authenticate the user for. This defaults to all the scopes configured for the application in its configuration page.
    public init(clientId: String? = nil, redirectUri: String? = nil, responseType: String? = nil, state: String? = nil, scope: String? = nil) {
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.responseType = responseType
        self.state = state
        self.scope = scope
    }

}
