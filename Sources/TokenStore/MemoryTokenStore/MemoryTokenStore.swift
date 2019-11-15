//
//  MemoryTokenStore.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/15/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

class MemoryTokenStore: TokenStore {
    var tokenInfo: TokenInfo?

    func read(completion: @escaping (Result<TokenInfo, Error>) -> Void) {
        guard let token = tokenInfo else {
            completion(.failure(BoxAPIAuthError(message: .tokenRetrieval)))
            return
        }
        completion(.success(token))
    }

    func write(tokenInfo: TokenInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        self.tokenInfo = tokenInfo
        completion(.success(()))
    }

    func clear(completion: @escaping (Result<Void, Error>) -> Void) {
        tokenInfo = nil
        completion(.success(()))
    }
}
