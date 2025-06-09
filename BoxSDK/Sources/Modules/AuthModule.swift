//
//  AuthModule.swift
//  BoxSDK-iOS
//
//  Created by Daniel Cech on 29/03/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Closure returning either standard TokenInfo object or error.
/// Used for closures of token-related API calls.
public typealias TokenInfoClosure = (Result<TokenInfo, BoxSDKError>) -> Void

/// OAuth2 URL parameter key constants
enum BoxOAuth2ParamsKey {
    static let responseType = "response_type"
    static let clientId = "client_id"
    static let redirectURL = "redirect_uri"
    static let responseTypeValue = "code"
    static let state = "state"
}

/// Defines methods for [Token](../Structs/Token.html) refreshing.
public protocol TokenRefreshing {
    /// Refreshes a token.
    ///
    /// - Parameters:
    ///   - refreshToken: The token to refresh.
    ///   - completion: Returns the token data or an error.
    func refresh(refreshToken: String, completion: @escaping TokenInfoClosure)

    /// Exchange an authorization code for an access token
    ///
    /// - Parameters:
    ///   - code: Authorization code
    ///   - completion: Returns the token data or an error.
    func getToken(withCode: String, completion: @escaping TokenInfoClosure)
}

/// Provides [Token](../Structs/Token.html) management.
public class AuthModule: TokenRefreshing {
    /// Required for communicating with Box APIs.
    private(set) var networkAgent: NetworkAgentProtocol
    private(set) var configuration: BoxSDKConfiguration

    /// Initializer
    ///
    /// - Parameters:
    ///   - networkAgent: Provides network communication with the Box APIs.
    ///   - configuration: Provides parameters to makes API calls in order to tailor it to their application's specific needs
    init(networkAgent: NetworkAgentProtocol, configuration: BoxSDKConfiguration) {
        self.networkAgent = networkAgent
        self.configuration = configuration
    }

    /// Refresh the given token.
    ///
    /// - Parameters:
    ///   - refreshToken: The token to refresh.
    ///   - completion: Returns the token data or an error.
    public func refresh(refreshToken: String, completion: @escaping TokenInfoClosure) {

        let params = [
            "grant_type": "refresh_token",
            "client_id": configuration.clientId,
            "client_secret": configuration.clientSecret,
            "refresh_token": refreshToken
        ]

        networkAgent.send(
            request: BoxRequest(
                httpMethod: HTTPMethod.post,
                url: URL.boxAPIEndpoint("oauth2/token", configuration: configuration),
                body: .urlencodedForm(params)
            ),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Exchange an authorization code for an access token
    ///
    /// - Parameters:
    ///   - code: Authorization code
    ///   - completion: Returns the token data or an error.
    public func getToken(withCode code: String, completion: @escaping TokenInfoClosure) {

        let params = [
            "grant_type": "authorization_code",
            "client_id": configuration.clientId,
            "client_secret": configuration.clientSecret,
            "code": code
        ]

        networkAgent.send(
            request: BoxRequest(
                httpMethod: HTTPMethod.post,
                url: URL.boxAPIEndpoint("oauth2/token", configuration: configuration),
                body: .urlencodedForm(params)
            ),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Revokes an access or refresh token, rendering it invalid.
    ///
    /// - Parameters:
    ///   - token: The token to revoke.
    ///   - completion: Called after the revocation completes
    public func revokeToken(token: String, completion: @escaping Callback<Void>) {

        let params = [
            "client_id": configuration.clientId,
            "client_secret": configuration.clientSecret,
            "token": token
        ]

        networkAgent.send(
            request: BoxRequest(
                httpMethod: HTTPMethod.post,
                url: URL.boxAPIEndpoint("oauth2/revoke", configuration: configuration),
                body: .urlencodedForm(params)
            ),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }

    /// Downscope the token.
    ///
    /// - Parameters:
    ///   - parentToken: Fully-scoped access token. This can be an OAuth (Managed User), JWT (App User or Service Account) or an App Token (New Box View) token.
    ///   - scope: Scope or scopes that you want to apply to the resulting token.
    ///   - resource: Full url path to the file that the token should be generated for, eg: https://api.box.com/2.0/files/{file_id}
    ///   - sharedLink: Shared link to get a token for.
    ///   - completion: Returns the token data or an error.
    public func downscopeToken(parentToken: String, scope: Set<TokenScope>, resource: String? = nil, sharedLink: String? = nil, completion: @escaping TokenInfoClosure) {

        let scopeList = Array(scope).map { $0.description }.joined(separator: " ")

        var params = [
            "subject_token": parentToken,
            "subject_token_type": "urn:ietf:params:oauth:token-type:access_token",
            "scope": scopeList,
            "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange"
        ]

        if let unwrappedResource = resource {
            params["resource"] = unwrappedResource
        }

        if let unwrappedSharedLink = sharedLink {
            params["box_shared_link"] = unwrappedSharedLink
        }

        networkAgent.send(
            request: BoxRequest(
                httpMethod: HTTPMethod.post,
                url: URL.boxAPIEndpoint("oauth2/token", configuration: configuration),
                body: .urlencodedForm(params)
            ),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}

/// Provides management for Client Credentials Grant authentication.
public class CCGAuthModule: AuthModule {

    /// The type of CCG connection, either user with userId or application service with enterpriseId.
    public enum CCGConnectionType {
        /// User connection type with associated userId
        case user(String)
        /// Application service connection type with associated enterpriseId
        case applicationService(String)

        /// A`box_subject_type` used in requesting CCG access token
        var subjectType: String {
            switch self {
            case .user:
                return "user"
            case .applicationService:
                return "enterprise"
            }
        }

        /// A `box_subject_id` used in requesting CCG access token
        var subjectId: String {
            switch self {
            case let .user(id):
                return id
            case let .applicationService(id):
                return id
            }
        }
    }

    /// The type of CCG connection, either user with userId or application service with enterpriseId.
    private let connectionType: CCGConnectionType

    /// Initializer
    ///
    /// - Parameters:
    ///   - connectionType: The type of CCG connection, either user with userId or application service with enterpriseId.
    ///   - networkAgent: Provides network communication with the Box APIs.
    ///   - configuration: Provides parameters to makes API calls in order to tailor it to their application's specific needs
    init(connectionType: CCGConnectionType, networkAgent: NetworkAgentProtocol, configuration: BoxSDKConfiguration) {
        self.connectionType = connectionType
        super.init(networkAgent: networkAgent, configuration: configuration)
    }

    /// Get CCG access token
    ///
    /// - Parameters:
    ///   - completion: Returns the token data or an error.
    public func getCCGToken(completion: @escaping TokenInfoClosure) {

        let params = [
            "grant_type": "client_credentials",
            "client_id": configuration.clientId,
            "client_secret": configuration.clientSecret,
            "box_subject_id": connectionType.subjectId,
            "box_subject_type": connectionType.subjectType
        ]

        networkAgent.send(
            request: BoxRequest(
                httpMethod: HTTPMethod.post,
                url: URL.boxAPIEndpoint("oauth2/token", configuration: configuration),
                body: .urlencodedForm(params)
            ),
            completion: ResponseHandler.default(wrapping: completion)
        )
    }
}
