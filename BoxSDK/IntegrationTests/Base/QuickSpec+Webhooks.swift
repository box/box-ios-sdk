//
//  QuickSpec+Webhooks.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 14/10/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

extension QuickSpec {

    static func createWebhook(
        client: BoxClient,
        targetType: String,
        targetId: String,
        triggers: [Webhook.EventTriggers],
        address: String,
        callback: @escaping (Webhook) -> Void
    ) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            client.webhooks.create(targetType: targetType, targetId: targetId, triggers: triggers, address: address) { result in
                switch result {
                case let .success(webhook):
                    callback(webhook)
                case let .failure(error):
                    fail("Expected create call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }
}
