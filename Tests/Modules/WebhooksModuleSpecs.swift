//
//  WebhooksModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class WebhooksModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        describe("Webhooks Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("create()") {

                it("should make API call to create a webhook and produce webhook response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/webhooks")
                            && isMethodPOST()
                            && hasJsonBody([
                                "target": [
                                    "type": "file",
                                    "id": "5016243669"
                                ],
                                "triggers": ["FILE.DOWNLOADED", "FILE.UPLOADED"],
                                "address": "https://dev.name/actions/file_changed"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateWebhook.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10) { done in
                        self.sut.webhooks.create(targetType: "file", targetId: "5016243669", triggers: [.fileDownloaded, .fileUploaded], address: "https://dev.name/actions/file_changed") { result in
                            guard case let .success(webhook) = result else {
                                fail("Expected call to createWebhook to succeed, but it failed")
                                done()
                                return
                            }
                            expect(webhook).toNot(beNil())
                            expect(webhook).to(beAKindOf(Webhook.self))
                            expect(webhook.id).to(equal("4165"))
                            expect(webhook.address).to(equal(URL(string: "https://dev.name/actions/file_changed")))
                            done()
                        }
                    }
                }
            }

            describe("update()") {

                it("should make API call to update a webhook and produce webhook response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/webhooks/4133")
                            && isMethodPUT()
                            && hasJsonBody([
                                "target": [
                                    "type": "folder",
                                    "id": "1000605797"
                                ],
                                "address": "https://notification.example.net"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateWebhook.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10) { done in
                        self.sut.webhooks.update(webhookId: "4133", targetType: "folder", targetId: "1000605797", address: "https://notification.example.net") { result in
                            guard case let .success(webhook) = result else {
                                fail("Expected call to updateWebhook to succeed, but it failed")
                                done()
                                return
                            }
                            expect(webhook).toNot(beNil())
                            expect(webhook).to(beAKindOf(Webhook.self))
                            expect(webhook.id).to(equal("4133"))
                            expect(webhook.address).to(equal(URL(string: "https://notification.example.net")))
                            done()
                        }
                    }
                }
            }

            describe("get()") {

                it("should make API call to get webhook and produce webhook response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/webhooks/4137")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetWebhookInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.webhooks.get(webhookId: "4137") { result in
                            guard case let .success(webhook) = result else {
                                fail("Expected call to get to succeed, but it failed")
                                done()
                                return
                            }
                            expect(webhook).toNot(beNil())
                            expect(webhook).to(beAKindOf(Webhook.self))
                            expect(webhook.id).to(equal("4137"))
                            done()
                        }
                    }
                }
            }

            describe("list()") {

                it("should make API call to get webhooks in an enterprise and produce webhooks response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/webhooks")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetWebhooks.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.webhooks.list { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstItem):
                                        expect(firstItem.id).to(equal("4161"))
                                        expect(firstItem.type).to(equal("webhook"))

                                    case let .failure(error):
                                        fail("Unable to get webhooks instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get webhooks instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("delete()") {
                it("should make API call to delete webhook and produce webhook response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/webhooks/12345")
                            && isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.webhooks.delete(webhookId: "12345") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                print(error)
                                fail("Expected call to delete to suceed, but it failed")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
