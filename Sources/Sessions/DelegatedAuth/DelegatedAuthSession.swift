//
//  DelegatedAuthSession.swift
//  BoxSDK
//
//  Created by Daniel Cech on 23/05/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

typealias AuthActionClosure = (@escaping () -> Void) -> Void
typealias AuthActionTuple = (id: Int, action: AuthActionClosure)

/// Contains access token and its expiration date.
public typealias AccessTokenTuple = (accessToken: String, expiresIn: TimeInterval)

// DelegatedAuthClosure uses Error instead of BoxSDKError because this closure is called externally.
// This error is then mapped to BoxSDKError.jwtAuthError in the getAccessToken method.
/// Contains unique ID as an identifier for JWT token provider and completion returning either valid access token information or an error.
public typealias DelegatedAuthClosure = (_ uniqueID: String, _ completion: @escaping (Result<AccessTokenTuple, Error>) -> Void) -> Void

/// An authorization session using JWT token
public class DelegatedAuthSession: SessionProtocol {

    var authModule: AuthModule
    var configuration: BoxSDKConfiguration

    var authClosure: DelegatedAuthClosure
    var uniqueID: String

    var tokenStore: TokenStore
    var tokenInfo: TokenInfo?

    let authDispatcher = AuthModuleDispatcher()

    init(
        authModule: AuthModule,
        configuration: BoxSDKConfiguration,
        tokenInfo: TokenInfo?,
        tokenStore: TokenStore,
        authClosure: @escaping DelegatedAuthClosure,
        uniqueID: String
    ) {
        self.authModule = authModule
        self.configuration = configuration
        self.tokenInfo = tokenInfo
        self.tokenStore = tokenStore
        self.authClosure = authClosure
        self.uniqueID = uniqueID
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

        if let unwrappedTokenInfo = self.tokenInfo {
            if isValidToken() {
                completion(.success(unwrappedTokenInfo.accessToken))
                return
            }
        }

        authDispatcher.start { [weak self] done in
            guard let self = self else {
                completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to get Access Token - DelegatedAuthSession deallocated"))))
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

            self.authClosure(self.uniqueID) { result in
                switch result {
                case let .success(accessToken, expiresIn):
                    if expiresIn < self.configuration.tokenRefreshThreshold {
                        completion(.failure(BoxAPIAuthError(message: .expiredToken)))
                        done()
                        return
                    }

                    let tokenInfo = TokenInfo(accessToken: accessToken, expiresIn: expiresIn)
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
                    completion(.failure(BoxAPIAuthError(message: .jwtAuthError, error: error)))
                    done()
                }
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
                completion(.failure(BoxAPIAuthError(message: .instanceDeallocated("Unable to downscope Token - DelegatedAuthSession deallocated"))))
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

private extension DelegatedAuthSession {
    func isValidToken() -> Bool {
        if let unwrappedTokenInfo = tokenInfo, unwrappedTokenInfo.expiresAt.timeIntervalSinceNow > configuration.tokenRefreshThreshold {
            return true
        }
        return false
    }
}
