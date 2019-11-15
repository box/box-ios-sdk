//
//  SharedItemsModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 6/10/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class SharedItemsModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        describe("Shared Items Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("get()") {

                it("should make API call to get shared item and produce shared item response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/shared_items")
                            && hasHeaderNamed("BoxApi", value: "shared_link=https://example.com&shared_link_password=test_password")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.sharedItems.get(sharedLinkURL: "https://example.com", sharedLinkPassword: "test_password") { result in
                            switch result {
                            case let .success(sharedItem):
                                guard case let .file(file) = sharedItem.itemValue else {
                                    fail("No Item Object Parsed.")
                                    done()
                                    return
                                }

                                expect(sharedItem).toNot(beNil())
                                expect(file.id).to(equal("5000948880"))
                            case let .failure(error):
                                fail("Expected call to get to succeed, but it failed with error: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make API call to get shared item with password and produce shared item response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/shared_items")
                            && hasHeaderNamed("BoxApi", value: "shared_link=https://example.com")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetFileInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.sharedItems.get(sharedLinkURL: "https://example.com") { result in
                            if case let .failure(error) = result {
                                fail("Expected call to get to succeed, but it failed with error: \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
