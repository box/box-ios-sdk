//
//  TokenStore.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/9/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Defines an interface for managing token.
public protocol TokenStore {
    /// Retrieves current token information
    ///
    /// - Parameter completion: Returns either valid token information or an error
    func read(completion: @escaping (Result<TokenInfo, Error>) -> Void)
    /// Sets new token data
    ///
    /// - Parameters:
    ///   - tokenInfo: Token with it's additional information.
    ///   - completion: Returns either empty result in case of success or an error.
    func write(tokenInfo: TokenInfo, completion: @escaping (Result<Void, Error>) -> Void)
    /// Removes a token
    ///
    /// - Parameter completion: Returns either empty result in case of success or an error.
    func clear(completion: @escaping (Result<Void, Error>) -> Void)
}
