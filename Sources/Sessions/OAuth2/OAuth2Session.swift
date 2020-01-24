//
//  OAuth2Session.swift
//  BoxSDK
//
//  Created by Daniel Cech on 28/03/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

public class OAuth2Session: SessionProtocol, ExpiredTokenHandling {
    var authModule: AuthModule
    var configuration: BoxSDKConfiguration
    var tokenStore: TokenStore
    var tokenInfo: TokenInfo

    let authDispatcher = AuthModuleDispatcher()

    init(authModule: AuthModule, tokenInfo: TokenInfo, tokenStore: TokenStore, configuration: BoxSDKConfiguration) {
        self.authModule = authModule
        self.tokenInfo = tokenInfo
        self.configuration = configuration
        self.tokenStore = tokenStore
    }

    public func getAccessToken(completion: @escaping AccessTokenClosure) {

        // Check if the cached token info is valid, if so just return that access token
        if isValidToken() {
            completion(.success(tokenInfo.accessToken))
            return
        }

        authDispatcher.start { [weak self] done in
            guard let self = self else {
                return
            }

            if self.isValidToken() {
                completion(.success(self.tokenInfo.accessToken))
                done()
                return
            }

            // If the cached token info is expired, attempt refresh
            self.refreshToken { result in
                completion(result)
                done()
            }
        }
    }

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

    public func refreshToken(completion: @escaping AccessTokenClosure) {
        guard let refreshToken = tokenInfo.refreshToken else {
            completion(.failure(BoxAPIAuthError(message: .refreshTokenNotFound)))
            return
        }

        authModule.refresh(refreshToken: refreshToken) { result in

            switch result {
            case let .success(tokenInfo):
                self.tokenInfo = tokenInfo
                // If refresh succeeds, cache the new token info (and write to the store if present) and return the new access token
                self.tokenStore.write(tokenInfo: tokenInfo) { result in

                    switch result {
                    case .success:
                        DispatchQueue.main.async { completion(.success(tokenInfo.accessToken)) }
                    case let .failure(error):
                        DispatchQueue.main.async { completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error))) }
                    }
                }
            case .failure:
                // If refresh fails, try reading from the store
                self.tokenStore.read { [weak self] result in
                    guard let self = self else {
                        return
                    }

                    switch result {
                    case let .success(storedTokenInfo):
                        // If reading from store succeeds, check if the tokens in the store were the same as the cached tokens; if so, fail
                        guard storedTokenInfo != self.tokenInfo else {
                            DispatchQueue.main.async { completion(.failure(BoxAPIAuthError(message: .expiredToken))) }
                            return
                        }
                        self.tokenInfo = storedTokenInfo
                        DispatchQueue.main.async { completion(.success(self.tokenInfo.accessToken)) }
                    case let .failure(error):
                        // If reading from store fails, fail
                        DispatchQueue.main.async { completion(.failure(BoxAPIAuthError(message: .tokenStoreFailure, error: error))) }
                    }
                }
            }
        }
    }

    public func revokeTokens(completion: @escaping Callback<Void>) {
        authModule.revokeToken(token: tokenInfo.accessToken) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.tokenStore.clear { _ in }
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
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
        authModule.downscopeToken(parentToken: tokenInfo.accessToken, scope: scope, resource: resource, sharedLink: sharedLink, completion: completion)
    }
}

// MARK: - Private Helpers

private extension OAuth2Session {
    func isValidToken() -> Bool {
        return tokenInfo.expiresAt.timeIntervalSinceNow > configuration.tokenRefreshThreshold
    }
}
