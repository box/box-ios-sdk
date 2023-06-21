//
//  QuickSpec+BoxClient.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

extension QuickSpec {

    static let sdk = BoxSDK(clientId: Configuration.shared.ccg.clientId, clientSecret: Configuration.shared.ccg.clientSecret)
    // MARK: BoxClient helper methods

    static func initializeClient(callback: @escaping (BoxClient) -> Void) {
        if let enterpriseId = Configuration.shared.ccg.enterpriseId, !enterpriseId.isEmpty {
            initializeCCGForAccountService(enterpriseId: enterpriseId, callback: callback)
        }
        else if let userId = Configuration.shared.ccg.userId, !userId.isEmpty {
            initializeCCGForUser(userId: userId, callback: callback)
        }
        else {
            fail("Can not create the CCG Client instance: either \"enterpriseId\" or \"userId\" is required")
        }
    }

    static func initializeCCGForAccountService(enterpriseId: String, callback: @escaping (BoxClient) -> Void) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            sdk.getCCGClientForAccountService(enterpriseId: enterpriseId) { result in
                switch result {
                case let .success(resultClient):
                    callback(resultClient)
                case let .failure(error):
                    fail("Expected getCCGClientForAccountService call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    static func initializeCCGForUser(userId: String, callback: @escaping (BoxClient) -> Void) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            sdk.getCCGClientForUser(userId: userId) { result in
                switch result {
                case let .success(resultClient):
                    callback(resultClient)
                case let .failure(error):
                    fail("Expected getCCGClientForUser call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }
}
