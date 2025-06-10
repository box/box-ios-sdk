//
//  QuickSpec+WebLinks.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 14/10/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

extension QuickSpec {

    static func deleteWebLink(client: BoxClient, webLink: WebLink?) {
        guard let webLink = webLink else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            client.webLinks.delete(webLinkId: webLink.id) { result in
                if case let .failure(error) = result {
                    fail("Expected delete call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }
}
