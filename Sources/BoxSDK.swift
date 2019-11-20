//
//  BoxSDK.swift
//  BoxSDK
//
//  Created by Abel Osorio on 03/12/19.
//  Copyright © 2018 Box Inc. All rights reserved.
//

#if os(iOS)
    import AuthenticationServices
#endif
import Foundation

/// Closure to return any generic type or an BoxSDKError
/// Used to simplify interfaces
public typealias Callback<T> = (Result<T, BoxSDKError>) -> Void

/// Provides methods for creating BoxSDKClient
public class BoxSDK {

    /// Box-specific constants
    public enum Constants {
        /// Root folder identifier
        public static let rootFolder = "0"
        /// Current user identifier
        public static let currentUser = "me"
    }

    /// SDK configuration
    public private(set) var configuration: BoxSDKConfiguration
    /// Default configuration
    public static let defaultConfiguration = try! BoxSDKConfiguration()
    // swiftlint:disable:previous force_try
    #if os(iOS)
        private var webSession: AuthenticationSession?
    #endif
    private var networkAgent: BoxNetworkAgent

    /// Auth module providing authorization and token related requests.
    /// Is set upon BoxSDK initialisation
    public private(set) var auth: AuthModule

    /// Initializer
    ///
    /// - Parameters:
    ///   - clientId: The client ID of the application requesting authentication. To get the client ID for your application,
    ///     log in to your Box developer console click the Edit Application link for the application you're working with.
    ///     In the OAuth 2 Parameters section of the configuration page, find the item labeled "client_id". The text of that item
    ///     is your application's client ID.
    ///   - clientSecret: The client secret of the application requesting authentication. To get the client secret for your application,
    ///     log in to your Box developer console and click the Edit Application link for the application you're working with.
    ///     In the OAuth 2 Parameters section of the configuration page, find the item labeled "client_secret".
    ///     The text of that item is your application's client secret.
    public init(clientId: String, clientSecret: String) {
        // swiftlint:disable:next force_try
        configuration = try! BoxSDKConfiguration(clientId: clientId, clientSecret: clientSecret)
        networkAgent = BoxNetworkAgent(configuration: configuration)
        auth = AuthModule(networkAgent: networkAgent, configuration: configuration)
    }

    /// Creates BoxClient object based on developer token
    ///
    /// - Parameter token: Developer token
    /// - Returns: New BoxClient object
    public static func getClient(token: String) -> BoxClient {
        let networkAgent = BoxNetworkAgent(configuration: defaultConfiguration)
        return BoxClient(
            networkAgent: networkAgent,
            session: SingleTokenSession(
                token: token,
                authModule: AuthModule(networkAgent: networkAgent, configuration: defaultConfiguration)
            ),
            configuration: defaultConfiguration
        )
    }

    /// Creates BoxClient with developer token
    ///
    /// - Parameter token: Developer token
    /// - Returns: New BoxClient object
    public func getClient(token: String) -> BoxClient {
        return BoxClient(networkAgent: networkAgent, session: SingleTokenSession(token: token, authModule: auth), configuration: configuration)
    }

    /// Creates BoxClient using JWT token.
    ///
    /// - Parameters:
    ///   - tokenInfo: Information about token
    ///   - tokenStore: Custom token store. To use custom store, implement TokenStore protocol.
    ///   - authClosure: Requests new JWT token value when needed. Provide the token value from your token provider.
    ///   - uniqueID: Unique identifier provided for jwt token.
    ///   - completion: Returns standard BoxClient object or error.
    public func getDelegatedAuthClient(
        authClosure: @escaping DelegatedAuthClosure,
        uniqueID: String,
        tokenInfo: TokenInfo? = nil,
        tokenStore: TokenStore? = nil,
        completion: @escaping Callback<BoxClient>
    ) {
        var designatedTokenStore: TokenStore
        let networkAgent = BoxNetworkAgent(configuration: configuration)
        let authModule = AuthModule(networkAgent: networkAgent, configuration: configuration)

        if tokenInfo == nil, let unWrappedTokenStore = tokenStore {
            designatedTokenStore = unWrappedTokenStore
            designatedTokenStore.read { [weak self] result in
                guard let self = self else {
                    completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get delegated auth client - BoxSDK deallocated"))))
                    return
                }

                switch result {
                case let .success(tokenInfo):
                    let session = DelegatedAuthSession(
                        authModule: authModule,
                        configuration: self.configuration,
                        tokenInfo: tokenInfo,
                        tokenStore: designatedTokenStore,
                        authClosure: authClosure,
                        uniqueID: uniqueID
                    )

                    let client = BoxClient(networkAgent: networkAgent, session: session, configuration: self.configuration)

                    completion(.success(client))
                case let .failure(error):
                    completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
                }
            }
        }
        else if let tokenInfo = tokenInfo {
            designatedTokenStore = tokenStore ?? MemoryTokenStore()
            designatedTokenStore.write(tokenInfo: tokenInfo) { [weak self] result in
                guard let self = self else {
                    completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get delegated auth client - BoxSDK deallocated"))))
                    return
                }
                switch result {
                case .success:
                    let session = DelegatedAuthSession(
                        authModule: authModule,
                        configuration: self.configuration,
                        tokenInfo: tokenInfo,
                        tokenStore: designatedTokenStore,
                        authClosure: authClosure,
                        uniqueID: uniqueID
                    )
                    let client = BoxClient(networkAgent: networkAgent, session: session, configuration: self.configuration)
                    completion(.success(client))

                case let .failure(error):
                    completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
                }
            }
        }
        else {
            designatedTokenStore = MemoryTokenStore()

            let session = DelegatedAuthSession(
                authModule: authModule,
                configuration: configuration,
                tokenInfo: tokenInfo,
                tokenStore: designatedTokenStore,
                authClosure: authClosure,
                uniqueID: uniqueID
            )
            let client = BoxClient(networkAgent: networkAgent, session: session, configuration: configuration)
            completion(.success(client))
        }
    }

    /// Creates BoxClient in a completion with OAuth 2.0 type of authentication
    ///
    /// - Parameters:
    ///   - tokenInfo: Information about token
    ///   - tokenStore: Custom token store. To use custom store, implement TokenStore protocol.
    ///   - context: The ViewController that is presenting the OAuth request
    ///   - completion: Returns created standard BoxClient object or error
    #if os(iOS)
        @available(iOS 13.0, *)
        public func getOAuth2Client(
            tokenInfo: TokenInfo? = nil,
            tokenStore: TokenStore? = nil,
            context: ASWebAuthenticationPresentationContextProviding,
            completion: @escaping Callback<BoxClient>
        ) {
            var designatedTokenStore: TokenStore

            if tokenInfo == nil, let unWrappedTokenStore = tokenStore {
                designatedTokenStore = unWrappedTokenStore
                designatedTokenStore.read { [weak self] result in
                    guard let self = self else {
                        completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get OAuth 2 client - BoxSDK deallocated"))))
                        return
                    }

                    switch result {
                    case let .success(tokenInfo):
                        let session = OAuth2Session(authModule: self.auth, tokenInfo: tokenInfo, tokenStore: designatedTokenStore, configuration: self.configuration)
                        let client = BoxClient(networkAgent: self.networkAgent, session: session, configuration: self.configuration)

                        completion(.success(client))
                    case .failure:
                        self.startOAuth2WebSession(completion: completion, tokenStore: designatedTokenStore, context: context)
                    }
                }
            }
            else if let tokenInfo = tokenInfo {
                designatedTokenStore = tokenStore ?? MemoryTokenStore()
                designatedTokenStore.write(tokenInfo: tokenInfo) { [weak self] result in
                    guard let self = self else {
                        completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get OAuth 2 client - BoxSDK deallocated"))))
                        return
                    }
                    switch result {
                    case .success:
                        let session = OAuth2Session(authModule: self.auth, tokenInfo: tokenInfo, tokenStore: designatedTokenStore, configuration: self.configuration)
                        let client = BoxClient(networkAgent: self.networkAgent, session: session, configuration: self.configuration)
                        completion(.success(client))
                    case let .failure(error):
                        completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
                    }
                }
            }
            else {
                designatedTokenStore = MemoryTokenStore()
                startOAuth2WebSession(completion: completion, tokenStore: designatedTokenStore)
            }
        }
    #endif

    /// Creates BoxClient in a completion with OAuth 2.0 type of authentication
    ///
    /// - Parameters:
    ///   - tokenInfo: Information about token
    ///   - tokenStore: Custom token store. To use custom store, implement TokenStore protocol.
    ///   - completion: Returns created standard BoxClient object or error
    @available(iOS 11.0, *)
    public func getOAuth2Client(
        tokenInfo: TokenInfo? = nil,
        tokenStore: TokenStore? = nil,
        completion: @escaping Callback<BoxClient>
    ) {
        var designatedTokenStore: TokenStore

        if tokenInfo == nil, let unWrappedTokenStore = tokenStore {
            designatedTokenStore = unWrappedTokenStore
            designatedTokenStore.read { [weak self] result in
                guard let self = self else {
                    completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get OAuth 2 client - BoxSDK deallocated"))))
                    return
                }

                switch result {
                case let .success(tokenInfo):
                    let session = OAuth2Session(authModule: self.auth, tokenInfo: tokenInfo, tokenStore: designatedTokenStore, configuration: self.configuration)
                    let client = BoxClient(networkAgent: self.networkAgent, session: session, configuration: self.configuration)

                    completion(.success(client))
                case .failure:
                    self.startOAuth2WebSession(completion: completion, tokenStore: designatedTokenStore)
                }
            }
        }
        else if let tokenInfo = tokenInfo {
            designatedTokenStore = tokenStore ?? MemoryTokenStore()
            designatedTokenStore.write(tokenInfo: tokenInfo) { [weak self] result in
                guard let self = self else {
                    completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get OAuth 2 client - BoxSDK deallocated"))))
                    return
                }
                switch result {
                case .success:
                    let session = OAuth2Session(authModule: self.auth, tokenInfo: tokenInfo, tokenStore: designatedTokenStore, configuration: self.configuration)
                    let client = BoxClient(networkAgent: self.networkAgent, session: session, configuration: self.configuration)
                    completion(.success(client))
                case let .failure(error):
                    completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
                }
            }
        }
        else {
            designatedTokenStore = MemoryTokenStore()
            startOAuth2WebSession(completion: completion, tokenStore: designatedTokenStore)
        }
    }

    // swiftlint:enable cyclomatic_complexity

    // MARK: - OAuthWebAuthenticationable related
    #if os(iOS)
        @available(iOS 13.0, *)
        func startOAuth2WebSession(completion: @escaping Callback<BoxClient>, tokenStore: TokenStore, context: ASWebAuthenticationPresentationContextProviding) {
            obtainAuthorizationCodeFromWebSession(context: context) { result in
                switch result {
                case let .failure(error):
                    completion(.failure(error))
                case let .success(authorizationCode):
                    self.auth.getToken(withCode: authorizationCode) { [weak self] result in
                        guard let self = self else {
                            completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to start OAuth 2 web session - BoxSDK deallocated"))))
                            return
                        }
                        switch result {
                        case let .success(tokenInfo):
                            tokenStore.write(tokenInfo: tokenInfo) { result in
                                switch result {
                                case .success:
                                    let session = OAuth2Session(authModule: self.auth, tokenInfo: tokenInfo, tokenStore: tokenStore, configuration: self.configuration)
                                    let client = BoxClient(networkAgent: self.networkAgent, session: session, configuration: self.configuration)
                                    completion(.success(client))
                                case let .failure(error):
                                    completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
                                }
                            }
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    #endif

    func startOAuth2WebSession(completion: @escaping Callback<BoxClient>, tokenStore: TokenStore) {
        obtainAuthorizationCodeFromWebSession { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(authorizationCode):
                self.auth.getToken(withCode: authorizationCode) { [weak self] result in
                    guard let self = self else {
                        completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to start OAuth 2 web session - BoxSDK deallocated"))))
                        return
                    }
                    switch result {
                    case let .success(tokenInfo):
                        tokenStore.write(tokenInfo: tokenInfo) { result in
                            switch result {
                            case .success:
                                let session = OAuth2Session(authModule: self.auth, tokenInfo: tokenInfo, tokenStore: tokenStore, configuration: self.configuration)
                                let client = BoxClient(networkAgent: self.networkAgent, session: session, configuration: self.configuration)
                                completion(.success(client))
                            case let .failure(error):
                                completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
                            }
                        }
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    #if os(iOS)
        @available(iOS 13.0, *)
        func obtainAuthorizationCodeFromWebSession(context: ASWebAuthenticationPresentationContextProviding, completion: @escaping Callback<String>) {
            let authorizeURL = makeAuthorizeURL(state: nonce)
            webSession = AuthenticationSession(url: authorizeURL, callbackURLScheme: defaultCallbackURL, context: context) { resultURL, error in
                guard error == nil,
                    let successURL = resultURL else {
                    print(error.debugDescription)
                    completion(.failure(BoxAPIAuthError(message: .invalidOAuthRedirectConfiguration)))
                    return
                }

                let usedState = self.getURLComponentValueAt(key: "state", from: authorizeURL)

                if let authorizationCode = self.getURLComponentValueAt(key: "code", from: successURL),
                    let receivedState = self.getURLComponentValueAt(key: "state", from: successURL),
                    receivedState == usedState {
                    completion(.success(authorizationCode))
                    return
                }
                else {
                    completion(.failure(BoxAPIAuthError(message: .invalidOAuthState)))
                }
            }

            webSession?.start()
        }
    #endif

    func obtainAuthorizationCodeFromWebSession(completion: @escaping Callback<String>) {
        let authorizeURL = makeAuthorizeURL(state: nonce)
        #if os(iOS)
            webSession = AuthenticationSession(url: authorizeURL, callbackURLScheme: defaultCallbackURL) { resultURL, error in
                guard error == nil,
                    let successURL = resultURL else {
                    print(error.debugDescription)
                    completion(.failure(BoxAPIAuthError(message: .invalidOAuthRedirectConfiguration)))
                    return
                }

                let usedState = self.getURLComponentValueAt(key: "state", from: authorizeURL)

                if let authorizationCode = self.getURLComponentValueAt(key: "code", from: successURL),
                    let receivedState = self.getURLComponentValueAt(key: "state", from: successURL),
                    receivedState == usedState {
                    completion(.success(authorizationCode))
                    return
                }
                else {
                    completion(.failure(BoxAPIAuthError(message: .invalidOAuthState)))
                }
            }

            webSession?.start()
        #endif
    }
}

// MARK: - Configuration

/// Extension for configuration-related methods
public extension BoxSDK {

    /// Updates current SDK configuration
    ///
    /// - Parameters:
    ///   - apiBaseURL: Base URL for majority of the requests.
    ///   - uploadApiBaseURL: Base URL for upload requests. If not specified, default URL is used.
    ///   - maxRetryAttempts: Maximum number of request retries in case of error result. If not specified, default value 5 is used.
    ///   - tokenRefreshThreshold: Specifies how many seconds before token expires it shuld be refreshed.
    ///     If not specified, default value 60 seconds is used.
    ///   - consoleLogDestination: Custom destination of console log.
    ///   - fileLogDestination: Custom destination of file log.
    ///   - clientAnalyticsInfo: Custom analytics info that will be set to request header.
    func updateConfiguration(
        apiBaseURL: URL? = nil,
        uploadApiBaseURL: URL? = nil,
        maxRetryAttempts: Int? = nil,
        tokenRefreshThreshold: TimeInterval? = nil,
        consoleLogDestination: ConsoleLogDestination? = nil,
        fileLogDestination: FileLogDestination? = nil,
        clientAnalyticsInfo: ClientAnalyticsInfo? = nil
    ) throws {
        configuration = try BoxSDKConfiguration(
            clientId: configuration.clientId,
            clientSecret: configuration.clientSecret,
            apiBaseURL: apiBaseURL,
            uploadApiBaseURL: uploadApiBaseURL,
            maxRetryAttempts: maxRetryAttempts,
            tokenRefreshThreshold: tokenRefreshThreshold,
            consoleLogDestination: consoleLogDestination,
            fileLogDestination: fileLogDestination,
            clientAnalyticsInfo: clientAnalyticsInfo
        )

        // Refresh config-dependent objects
        networkAgent = BoxNetworkAgent(configuration: configuration)
        auth = AuthModule(networkAgent: networkAgent, configuration: configuration)
    }
}

// MARK: - AuthenticationSession

extension BoxSDK {

    /// Creates OAuth2 authorization URL you can use in browser to authorize.
    ///
    /// - Parameters:
    ///   - callbackURL: Custom callback URL string. The URL to which Box redirects the browser when authentication completes.
    ///     The user's actual interaction with your application begins when Box redirects to this URL.
    ///     If not specified, default URL is used in a format of `boxsdk-clientId://boxsdkoauth2redirect` with the real value of `clientId`.
    ///   - state: A text string that you choose. Box sends the same string to your redirect URL when authentication is complete.
    ///     This parameter is provided for your use in protecting against hijacked sessions and other attacks.
    /// - Returns: Standard URL object to be used for authorization in external browser.
    public func makeAuthorizeURL(callbackURL: String? = nil, state: String? = nil) -> URL {
        // swiftlint:disable:next line_length
        var urlString = "\(configuration.oauth2AuthorizeURL)?\(BoxOAuth2ParamsKey.responseType)=\(BoxOAuth2ParamsKey.responseTypeValue)&\(BoxOAuth2ParamsKey.clientId)=\(configuration.clientId)&\(BoxOAuth2ParamsKey.redirectURL)=\(callbackURL ?? defaultCallbackURL)"

        if let state = state {
            urlString.append("&\(BoxOAuth2ParamsKey.state)=\(state)")
        }

        // swiftlint:disable:next force_unwrapping
        return URL(string: urlString)!
    }

    private var nonce: String {
        let length = 16
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        // swiftlint:disable:next force_unwrapping
        let randomCharacters = (0 ..< length).map { _ in characters.randomElement()! }
        return String(randomCharacters)
    }

    private var defaultCallbackURL: String {
        return "boxsdk-\(configuration.clientId)://boxsdkoauth2redirect"
    }

    private func getURLComponentValueAt(key: String, from url: URL?) -> String? {
        guard let url = url, let urlComponent = NSURLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == key }),
            let value = urlComponent.value else {
            return nil
        }
        return value
    }
}
