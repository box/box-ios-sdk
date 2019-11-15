//
//  KeychainTokenStore.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/9/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

// key for storing the token info
private let tokenInfoKeychainKey = "TokenInfo"

public class KeychainTokenStore: TokenStore {
    let secureStore = KeychainService(secureStoreQueryable: GenericPasswordQueryable(service: "com.box.SwiftSDK"))

    public init() {}

    public func read(completion: @escaping (Result<TokenInfo, Error>) -> Void) {
        do {
            guard let tokenInfo: TokenInfo = try? secureStore.getValue(tokenInfoKeychainKey) else {
                completion(.failure(BoxSDKError(message: .keychainNoValue)))
                return
            }
            completion(.success(tokenInfo))
        }
    }

    public func write(tokenInfo: TokenInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try secureStore.set(tokenInfo, key: tokenInfoKeychainKey)
            completion(.success(()))
        }
        catch let error as BoxSDKError {
            completion(.failure(error))
        }
        catch {
            completion(.failure(BoxSDKError(message: .keychainUnhandledError("Cannot write to keychain"))))
        }
    }

    public func clear(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try secureStore.removeValue(for: tokenInfoKeychainKey)
            completion(.success(()))
        }
        catch let error as BoxSDKError {
            completion(.failure(error))
        }
        catch {
            completion(.failure(BoxSDKError(message: .keychainUnhandledError("Cannot clear keychain"))))
        }
    }
}
