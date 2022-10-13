//
//  BaseIntegrationSpecs.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class BaseIntegrationSpecs: QuickSpec {
    let sdk = BoxSDK(clientId: Configuration.shared.ccg.clientId, clientSecret: Configuration.shared.ccg.clientSecret)
    var client: BoxClient!

    // MARK: BoxClient helper methods

    func initializeClient() {
        if let enterpriseId = Configuration.shared.ccg.enterpriseId, !enterpriseId.isEmpty {
            initializeCCGForAccountService(enterpriseId: enterpriseId)
        }
        else if let userId = Configuration.shared.ccg.userId, !userId.isEmpty {
            initializeCCGForUser(userId: userId)
        }
        else {
            fail("Can not create the CCG Client instance: either \"enterpriseId\" or \"userId\" is required")
        }
    }

    func initializeCCGForAccountService(enterpriseId: String) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { [weak self] done in
            self?.sdk.getCCGClientForAccountService(enterpriseId: enterpriseId) { result in
                switch result {
                case let .success(resultClient):
                    self?.client = resultClient
                case let .failure(error):
                    fail("Expected getCCGClientForAccountService call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    func initializeCCGForUser(userId: String) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { [weak self] done in
            self?.sdk.getCCGClientForUser(userId: userId) { result in
                switch result {
                case let .success(resultClient):
                    self?.client = resultClient
                case let .failure(error):
                    fail("Expected getCCGClientForUser call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }
}
