//
//  BoxSDK+Async.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 19/05/2022.
//  Copyright © 2022 box. All rights reserved.
//

#if os(iOS)
    import AuthenticationServices
#endif
import Foundation

@available(iOS 13.0, macOS 10.15, *)
public extension BoxSDK {

    // MARK: - JWT Client

    /// Creates BoxClient using JWT token.
    ///
    /// - Parameters:
    ///   - tokenInfo: Information about token
    ///   - tokenStore: Custom token store. To use custom store, implement TokenStore protocol.
    ///   - authClosure: Requests new JWT token value when needed. Provide the token value from your token provider.
    ///   - uniqueID: Unique identifier provided for jwt token.
    /// - Returns: The BoxClient object
    /// - Throws: BoxSDKError
    func getDelegatedAuthClient(
        authClosure: @escaping DelegatedAuthClosure,
        uniqueID: String,
        tokenInfo: TokenInfo? = nil,
        tokenStore: TokenStore? = nil
    ) async throws -> BoxClient {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<BoxClient>) in
            self.getDelegatedAuthClient(
                authClosure: authClosure,
                uniqueID: uniqueID,
                tokenInfo: tokenInfo,
                tokenStore: tokenStore,
                completion: callback
            )
        }
    }

    // MARK: - CCG Client

    /// Creates BoxClient using Server Authentication with Client Credentials Grant for account service
    ///
    /// - Parameters:
    ///   - enterpriseId: The enterprise ID to use when getting the access token.
    ///   - tokenInfo: Information about token
    ///   - tokenStore: Custom token store. To use custom store, implement TokenStore protocol.
    /// - Returns: The BoxClient object
    /// - Throws: BoxSDKError
    func getCCGClientForAccountService(
        enterpriseId: String,
        tokenInfo: TokenInfo? = nil,
        tokenStore: TokenStore? = nil
    ) async throws -> BoxClient {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<BoxClient>) in
            self.getCCGClientForAccountService(
                enterpriseId: enterpriseId,
                tokenInfo: tokenInfo,
                tokenStore: tokenStore,
                completion: callback
            )
        }
    }

    /// Creates BoxClient using Server Authentication with Client Credentials Grant for user account
    ///
    /// - Parameters:
    ///   - userId: The user ID to use when getting the access token.
    ///   - tokenInfo: Information about token
    ///   - tokenStore: Custom token store. To use custom store, implement TokenStore protocol.
    /// - Returns: The BoxClient object
    /// - Throws: BoxSDKError
    func getCCGClientForUser(
        userId: String,
        tokenInfo: TokenInfo? = nil,
        tokenStore: TokenStore? = nil
    ) async throws -> BoxClient {
        return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<BoxClient>) in
            self.getCCGClientForUser(
                userId: userId,
                tokenInfo: tokenInfo,
                tokenStore: tokenStore,
                completion: callback
            )
        }
    }

    // MARK: - OAUTH2 Client

    #if os(iOS)
        /// Creates BoxClient in a completion with OAuth 2.0 type of authentication
        ///
        /// - Parameters:
        ///   - tokenInfo: Information about token
        ///   - tokenStore: Custom token store. To use custom store, implement TokenStore protocol.
        ///   - context: The ViewController that is         presenting the OAuth request
        /// - Returns: The BoxClient object
        /// - Throws: BoxSDKError
        func getOAuth2Client(
            tokenInfo: TokenInfo? = nil,
            tokenStore: TokenStore? = nil,
            context: ASWebAuthenticationPresentationContextProviding
        ) async throws -> BoxClient {
            return try await AsyncHelper.asyncifyCallback { (callback: @escaping Callback<BoxClient>) in
                self.getOAuth2Client(
                    tokenInfo: tokenInfo,
                    tokenStore: tokenStore,
                    context: context,
                    completion: callback
                )
            }
        }
    #endif
}
