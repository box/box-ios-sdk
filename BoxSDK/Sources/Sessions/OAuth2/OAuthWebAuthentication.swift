//
//  OAuthWebAuthtentication.swift
//  BoxSDK
//
//  Created by Abel Osorio on 4/23/19.
//  Copyright © 2019 Box. All rights reserved.
//

#if os(iOS)
    import AuthenticationServices
    import SafariServices
#endif
import Foundation

protocol OAuthWebAuthenticationable {

    init(
        url: URL,
        callbackURLScheme: String?,
        completionHandler: @escaping (URL?, Error?) -> Void
    )

    func start() -> Bool
    func cancel()
}

#if os(iOS)
    class AuthenticationSession: OAuthWebAuthenticationable {

        private let authSession: OAuthWebAuthenticationable

        @available(iOS 11.0, *)
        required init(
            url: URL,
            callbackURLScheme: String?,
            completionHandler: @escaping (URL?, Error?) -> Void
        ) {
            if #available(iOS 12, *) {
                authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler)
            }
            else {
                authSession = SFAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler)
            }
        }

        @available(iOS 13.0, *)
        required init(
            url: URL,
            callbackURLScheme: String?,
            context: ASWebAuthenticationPresentationContextProviding,
            completionHandler: @escaping (URL?, Error?) -> Void
        ) {
            let webAuthSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler)
            webAuthSession.presentationContextProvider = context
            authSession = webAuthSession
        }

        @discardableResult
        func start() -> Bool {
            return authSession.start()
        }

        func cancel() {
            authSession.cancel()
        }
    }
#endif

// MARK: - OAuthWebAuthenticationable

#if os(iOS)
    extension SFAuthenticationSession: OAuthWebAuthenticationable {}
    @available(iOS 12.0, *)
    extension ASWebAuthenticationSession: OAuthWebAuthenticationable {}
#endif
