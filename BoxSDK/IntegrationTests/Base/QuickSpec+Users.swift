//
//  QuickSpec+Users.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 14/10/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

extension QuickSpec {

    static func createUser(client: BoxClient, name: String, callback: @escaping (User) -> Void) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            client.users.createAppUser(name: name) { result in
                switch result {
                case let .success(user):
                    callback(user)
                case let .failure(error):
                    fail("Expected create call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    static func deleteUser(client: BoxClient, user: User?) {
        guard let user = user else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
            client.users.delete(userId: user.id, force: true) { result in
                if case let .failure(error) = result {
                    fail("Expected delete call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }
}
