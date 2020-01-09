//
//  SessionProtocol.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 3/27/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Closure returning either access token string or error.
/// Used for closures of access token - related API calls.
public typealias AccessTokenClosure = (Result<String, BoxSDKError>) -> Void

/// Defines methods for managing session token.
public protocol SessionProtocol {
    /// Gets accesss token
    ///
    /// - Parameter completion: Completion for obtaining access token.
    /// - Returns: AccessTokenClosure containing either token string or error.
    func getAccessToken(completion: @escaping AccessTokenClosure)
    /// Revokes all the tokens
    ///
    /// - Parameter completion: Returns either empty result representing success or error.
    func revokeTokens(completion: @escaping Callback<Void>)
    /// Downscope the token.
    ///
    /// - Parameters:
    ///   - scope: Scope or scopes that you want to apply to the resulting token.
    ///   - resource: Full url path to the file that the token should be generated for, eg: https://api.box.com/2.0/files/{file_id}
    ///   - sharedLink: Shared link to get a token for.
    ///   - completion: Returns the success or an error.
    func downscopeToken(scope: Set<TokenScope>, resource: String?, sharedLink: String?, completion: @escaping TokenInfoClosure)
}

/// Defines handler for expired token.
public protocol ExpiredTokenHandling {
    /// Handles token expiration.
    ///
    /// - Parameter completion: Returns either empty result representing success or error.
    func handleExpiredToken(completion: @escaping Callback<Void>)
}
