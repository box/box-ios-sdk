#if os(iOS) || os(macOS)
import AuthenticationServices
import Foundation

/// A class used to authenticate a user with a web service
class BoxOAuthWebAuthentication {

    /// The placeholder of a `clientId` used in  `defaultCallbackUrlSchemeFormat`.
    private static let clientIdPlaceholder = "<<CLIENT ID>>"
    /// The default URL scheme format used to create the custom URL scheme that the platform app expects in the callback URL
    private static let defaultCallbackUrlSchemeFormat = "boxsdk-\(clientIdPlaceholder)://boxsdkoauth2redirect"

    /// The initial URL pointing to the authentication webpage
    private let authorizeUrl: String

    ///  Initializer
    ///
    /// - Parameters:
    ///   - authorizeUrl: The initial URL pointing to the authentication webpage.
    init(authorizeUrl: String){
        self.authorizeUrl = authorizeUrl
    }

    /// This methods uses ASWebAuthenticationSession to obtain a authorization code from the authentication webpage.
    /// The page will be loaded in a secure view controller. From the webpage, the user can authenticate herself and grant access to the platform app.
    /// On completion, the service will send the authorization code.
    ///
    /// - Parameters:
    ///   - options: The parameters for the authorization URL.
    ///   - context: Context to target where in an application's UI the authorization view should be shown.
    ///   - completion: The completion handler which is called when the session is completed successfully or canceled by user.
    func obtainAuthorizationCode(
        options: GetAuthorizeUrlOptions,
        context: ASWebAuthenticationPresentationContextProviding,
        completion: @escaping (Result<String, Error>) -> Void) {
            let authorizeURL = URL.init(string:authorizeUrl)!

            let authenticationSession = ASWebAuthenticationSession(
                url: authorizeURL,
                callbackURLScheme: URL(string: options.redirectUri!)?.scheme,
                completionHandler: { url, error in
                    if let error = error {
                        completion(.failure(BoxSDKError(message: error.localizedDescription, error: error)))
                    } else if let url = url {
                        guard let authorizationCode =  BoxOAuthWebAuthentication.getURLComponentValueAt(key: "code", from: url) else {
                            completion(.failure(BoxSDKError(message: "Couldn't obtain authorization code from OAuth web session result.")))
                            return
                        }
                        if let sentState = options.state {
                            guard let receivedState =  BoxOAuthWebAuthentication.getURLComponentValueAt(key: "state", from: url), sentState == receivedState else {
                                completion(.failure(BoxSDKError(message: "The sent OAuth state does not match the received one.")))
                                return
                            }
                        }

                        completion(.success(authorizationCode))
                        return
                    }
                })

            DispatchQueue.main.async {
                authenticationSession.presentationContextProvider = context
                authenticationSession.start()
            }
        }

    /// This methods uses ASWebAuthenticationSession to obtain a authorization code from the authentication webpage.
    /// The page will be loaded in a secure view controller. From the webpage, the user can authenticate herself and grant access to the platform app.
    ///
    /// - Parameters:
    ///   - options: The parameters for the authorization URL.
    ///   - context: Context to target where in an application's UI the authorization view should be shown.
    /// - Returns: The authorization code.
    /// - Throws: An error if for any reason the authorization code cannot be fetched.
    func obtainAuthorizationCode(
        options: GetAuthorizeUrlOptions,
        context: ASWebAuthenticationPresentationContextProviding
    ) async throws ->String {
        return try await withCheckedThrowingContinuation {continuation in
            obtainAuthorizationCode(options: options, context: context) { result in
                switch result {
                case .success(let authorizationCode):
                    continuation.resume(returning: authorizationCode)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Retrieves a query Item with specific keys from the provided URL and returns its value
    ///
    /// - Parameters:
    ///   - key: The key of a query item to search.
    ///   - from: The URL in which the key will be searched.
    /// - Returns: The value with query item if found, otherwise nil.
    static func getURLComponentValueAt(key: String, from url: URL?) -> String? {
        guard let url = url, let urlComponent = NSURLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == key }),
              let value = urlComponent.value
        else {
            return nil
        }
        return value
    }

    /// Returns a `redirectUri` if exists, otherwise creates a new one using `defaultCallbackUrlSchemeFormat`.
    ///
    /// - Parameters:
    ///   - redirectUri: The optional redirectUri.
    ///   - clientId: The Id of the client, which will be used to create fallback callbackUrlScheme
    /// - Returns: The callback url scheme.
    static func getCallbackUrlScheme(redirectUri: String?, clientId: String) -> String? {
        if let redirectUri = redirectUri {
            return URL(string: redirectUri)?.scheme
        }

        return defaultCallbackUrlSchemeFormat.replacingOccurrences(of: clientIdPlaceholder, with: clientId)
    }
}
#endif
