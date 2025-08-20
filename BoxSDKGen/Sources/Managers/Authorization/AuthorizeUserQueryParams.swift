import Foundation

public class AuthorizeUserQueryParams {
    /// The type of response we'd like to receive.
    public let responseType: AuthorizeUserQueryParamsResponseTypeField

    /// The Client ID of the application that is requesting to authenticate
    /// the user. To get the Client ID for your application, log in to your
    /// Box developer console and click the **Edit Application** link for
    /// the application you're working with. In the OAuth 2.0 Parameters section
    /// of the configuration page, find the item labelled `client_id`. The
    /// text of that item is your application's Client ID.
    public let clientId: String

    /// The URI to which Box redirects the browser after the user has granted
    /// or denied the application permission. This URI match one of the redirect
    /// URIs in the configuration of your application. It must be a
    /// valid HTTPS URI and it needs to be able to handle the redirection to
    /// complete the next step in the OAuth 2.0 flow.
    /// Although this parameter is optional, it must be a part of the
    /// authorization URL if you configured multiple redirect URIs
    /// for the application in the developer console. A missing parameter causes
    /// a `redirect_uri_missing` error after the user grants application access.
    public let redirectUri: String?

    /// A custom string of your choice. Box will pass the same string to
    /// the redirect URL when authentication is complete. This parameter
    /// can be used to identify a user on redirect, as well as protect
    /// against hijacked sessions and other exploits.
    public let state: String?

    /// A space-separated list of application scopes you'd like to
    /// authenticate the user for. This defaults to all the scopes configured
    /// for the application in its configuration page.
    public let scope: String?

    /// Initializer for a AuthorizeUserQueryParams.
    ///
    /// - Parameters:
    ///   - responseType: The type of response we'd like to receive.
    ///   - clientId: The Client ID of the application that is requesting to authenticate
    ///     the user. To get the Client ID for your application, log in to your
    ///     Box developer console and click the **Edit Application** link for
    ///     the application you're working with. In the OAuth 2.0 Parameters section
    ///     of the configuration page, find the item labelled `client_id`. The
    ///     text of that item is your application's Client ID.
    ///   - redirectUri: The URI to which Box redirects the browser after the user has granted
    ///     or denied the application permission. This URI match one of the redirect
    ///     URIs in the configuration of your application. It must be a
    ///     valid HTTPS URI and it needs to be able to handle the redirection to
    ///     complete the next step in the OAuth 2.0 flow.
    ///     Although this parameter is optional, it must be a part of the
    ///     authorization URL if you configured multiple redirect URIs
    ///     for the application in the developer console. A missing parameter causes
    ///     a `redirect_uri_missing` error after the user grants application access.
    ///   - state: A custom string of your choice. Box will pass the same string to
    ///     the redirect URL when authentication is complete. This parameter
    ///     can be used to identify a user on redirect, as well as protect
    ///     against hijacked sessions and other exploits.
    ///   - scope: A space-separated list of application scopes you'd like to
    ///     authenticate the user for. This defaults to all the scopes configured
    ///     for the application in its configuration page.
    public init(responseType: AuthorizeUserQueryParamsResponseTypeField, clientId: String, redirectUri: String? = nil, state: String? = nil, scope: String? = nil) {
        self.responseType = responseType
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.state = state
        self.scope = scope
    }

}
