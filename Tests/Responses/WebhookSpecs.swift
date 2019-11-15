//
//  WebhookSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/30/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class WebhookSpecs: QuickSpec {

    override func spec() {
        describe("Webhook") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullWebhook", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let webhook = try Webhook(json: jsonDict)

                        expect(webhook.type).to(equal("webhook"))
                        guard case let .file(file)? = webhook.target else {
                            fail("Failed: Expected file object as target")
                            return
                        }
                        expect(file.id).to(equal("5018848529"))
                        expect(file.type).to(equal("file"))
                        expect(webhook.createdBy?.type).to(equal("user"))
                        expect(webhook.createdBy?.id).to(equal("2030392653"))
                        expect(webhook.createdBy?.name).to(equal("John Q. Developer"))
                        expect(webhook.createdBy?.login).to(equal("johnq@example.net"))
                        expect(webhook.createdAt?.iso8601).to(equal("2016-05-05T01:51:45Z"))
                        expect(webhook.address).to(equal(URL(string: "https://example.net/actions/file_changed")))
                        expect(webhook.triggers?[0].description).to(equal("FILE.PREVIEWED"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
