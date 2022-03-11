//
//  CCGAuthSession.swift
//  BoxSDK
//
//  Created by Artur Jankowski on 8/03/2022.
//  Copyright © 2022 Box. All rights reserved.
//

import Foundation

/// An authorization session using Client Credentials Grant
public class CCGAuthSession: SessionProtocol, ExpiredTokenHandling {
    var authModule: CCGAuthModule
    var configuration: BoxSDKConfiguration
    var tokenStore: TokenStore
    var tokenInfo: TokenInfo?

    let authDispatcher = AuthModuleDispatcher()

    init(
        authModule: CCGAuthModule,
        configuration: BoxSDKConfiguration,
        tokenInfo: TokenInfo?,
        tokenStore: TokenStore
    ) {
        self.authModule = authModule
        self.configuration = configuration
        self.tokenInfo = tokenInfo
        self.tokenStore = tokenStore
    }

    /// Revokes token
    ///
    /// - Parameter completion: Returns empty result in case of success and an error otherwise.
    public func revokeTokens(completion: @escaping Callback<Void>) {
        guard let accessToken = tokenInfo?.accessToken else {
            completion(.success(()))
            return
        }

        authModule.revokeToken(token: accessToken) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.tokenStore.clear { _ in }
                self.tokenInfo = nil
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// Retrieves valid access token
    ///
    /// - Parameter completion: AccessTokenClosure returning either valid access token string or an error.
    public func getAccessToken(completion: @escaping AccessTokenClosure) {
        // Check if the cached token info is valid, if so just return that access token

        if let unwrappedTokenInfo = tokenInfo {
            if isValidToken() {
                completion(.success(unwrappedTokenInfo.accessToken))
                return
            }
        }

        authDispatcher.start { [weak self] done in
            guard let self = self else {
                completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get Access Token - CCGAuthSession deallocated"))))
                done()
                return
            }

            if let unwrappedTokenInfo = self.tokenInfo {
                if self.isValidToken() {
                    completion(.success(unwrappedTokenInfo.accessToken))
                    done()
                    return
                }
            }

            self.authModule.getCCGToken { result in
                switch result {
                case let .success(tokenInfo):
                    if tokenInfo.expiresIn < self.configuration.tokenRefreshThreshold {
                        completion(.failure(BoxAPIAuthError(message: .expiredToken)))
                        done()
                        return
                    }

                    self.tokenInfo = tokenInfo
                    self.tokenStore.write(tokenInfo: tokenInfo, completion: { storeResult in
                        switch storeResult {
                        case .success:
                            completion(.success(tokenInfo.accessToken))
                        case let .failure(error):
                            completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
                        }
                        done()
                    })

                case let .failure(error):
                    completion(.failure(BoxAPIAuthError(message: .ccgAuthError, error: error)))
                    done()
                }
            }
        }
    }

    /// Handles token expiration.
    ///
    /// - Parameter completion: Returns either empty result representing success or error.
    public func handleExpiredToken(completion: @escaping Callback<Void>) {
        tokenStore.clear { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error)))
            }
        }
    }

    /// Downscope the token.
    ///
    /// - Parameters:
    ///   - scope: Scope or scopes that you want to apply to the resulting token.
    ///   - resource: Full url path to the file that the token should be generated for, eg: https://api.box.com/2.0/files/{file_id}
    ///   - sharedLink: Shared link to get a token for.
    ///   - completion: Returns the success or an error.
    public func downscopeToken(
        scope: Set<TokenScope>,
        resource: String? = nil,
        sharedLink: String? = nil,
        completion: @escaping TokenInfoClosure
    ) {
        getAccessToken { [weak self] result in
            guard let self = self else {
                completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to downscope Token - CCGAuthSession deallocated"))))
                return
            }

            switch result {
            case let .success(accessToken):
                self.authModule.downscopeToken(parentToken: accessToken, scope: scope, resource: resource, sharedLink: sharedLink, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private Helpers

private extension CCGAuthSession {
    func isValidToken() -> Bool {
        if let unwrappedTokenInfo = tokenInfo, unwrappedTokenInfo.expiresAt.timeIntervalSinceNow > configuration.tokenRefreshThreshold {
            return true
        }
        return false
    }
}
