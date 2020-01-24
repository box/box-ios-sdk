//
//  SingleTokenSession.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 3/27/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

public class SingleTokenSession: SessionProtocol {
    var token: String
    var authModule: AuthModule

    init(token: String, authModule: AuthModule) {
        self.token = token
        self.authModule = authModule
    }

    public func getAccessToken(completion: @escaping AccessTokenClosure) {
        completion(.success(token))
    }

    public func revokeTokens(completion: @escaping Callback<Void>) {
        authModule.revokeToken(token: token, completion: completion)
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
        authModule.downscopeToken(parentToken: token, scope: scope, resource: resource, sharedLink: sharedLink, completion: completion)
    }
}
