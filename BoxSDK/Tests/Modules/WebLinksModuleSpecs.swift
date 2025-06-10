//
//  WebLinksModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/3/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class WebLinksModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("Web Links Module") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("create()") {

                it("should make an API call to create a new web link.") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/web_links")
                            && isMethodPOST()
                            && hasJsonBody([
                                "description": "A web link for testing",
                                "parent": [
                                    "id": "33333"
                                ],
                                "url": "http://example.com",
                                "name": "Example Web Link"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullWebLink.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.webLinks.create(url: "http://example.com", parentId: "33333", name: "Example Web Link", description: "A web link for testing") { result in
                            switch result {
                            case let .success(webLink):
                                expect(webLink).toNot(beNil())
                                expect(webLink.id).to(equal("11111"))
                                expect(webLink.url).to(equal(URL(string: "http://example.com")))
                                expect(webLink.parent?.id).to(equal("33333"))
                                expect(webLink.name).to(equal("Example Web Link"))
                                expect(webLink.description).to(equal("A web link for testing"))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get()") {

                it("should make an API call to retrieve a specified web link") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/web_links/12345") && isMethodGET()) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullWebLink.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.webLinks.get(webLinkId: "12345") { result in
                            switch result {
                            case let .success(webLink):
                                expect(webLink).toNot(beNil())
                                expect(webLink.id).to(equal("11111"))
                                expect(webLink.createdBy?.name).to(equal("Example User"))
                                expect(webLink.description).to(equal("A web link for testing"))
                                expect(webLink.name).to(equal("Example Web Link"))
                                expect(webLink.url).to(equal(URL(string: "http://example.com")))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {

                it("should delete the specified web link") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/web_links/12345") && isMethodDELETE()) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.webLinks.delete(webLinkId: "12345") { result in
                            if case let .failure(error) = result {
                                fail("Expected call to delete to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update()") {

                it("should make API call to update web link with new fields") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/web_links/12345")
                            && isMethodPUT()
                            && hasJsonBody([
                                "description": "Updated Test Description",
                                "name": "Updated Test",
                                "parent": [
                                    "id": "11111"
                                ],
                                "url": "https://updatedexample.com"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateWebLink.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.webLinks.update(webLinkId: "12345", url: "https://updatedexample.com", parentId: "11111", name: "Updated Test", description: "Updated Test Description") { result in
                            switch result {
                            case let .success(webLink):
                                expect(webLink).toNot(beNil())
                                expect(webLink).to(beAKindOf(WebLink.self))
                                expect(webLink.parent?.id).to(equal("11111"))
                                expect(webLink.description).to(equal("Updated Description"))
                                expect(webLink.url).to(equal(URL(string: "https://updatedexample.com")))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make API call to update web link and the shared link") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/web_links/12345")
                            && isMethodPUT()
                            && hasJsonBody([
                                "description": "Updated Test Description",
                                "name": "Updated Test",
                                "parent": [
                                    "id": "11111"
                                ],
                                "url": "https://updatedexample.com",
                                "shared_link": [
                                    "access": "open",
                                    "password": "password"
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateWebLink.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.webLinks.update(
                            webLinkId: "12345",
                            url: "https://updatedexample.com",
                            parentId: "11111",
                            name: "Updated Test",
                            description: "Updated Test Description",
                            sharedLink: .value(SharedLinkData(access: .open, password: .value("password")))
                        ) { result in
                            switch result {
                            case let .success(webLink):
                                expect(webLink).toNot(beNil())
                                expect(webLink).to(beAKindOf(WebLink.self))
                                expect(webLink.parent?.id).to(equal("11111"))
                                expect(webLink.description).to(equal("Updated Description"))
                                expect(webLink.url).to(equal(URL(string: "https://updatedexample.com")))
                                expect(webLink.sharedLink?.access).to(equal(.open))
                                expect(webLink.sharedLink?.url).to(equal(URL(string: "https://app.box.com/s/ioh1ue6n5htav8h3c0m3f1gj40pbxpnz")))
                                expect(webLink.sharedLink?.previewCount).to(equal(0))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getSharedLink()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/web_links/12345") &&
                            isMethodGET() &&
                            containsQueryParams(["fields": "shared_link"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetWebLinkSharedLink.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }

                it("should download a shared link for a web link", closure: {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.webLinks.getSharedLink(forWebLink: "12345") { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).toNot(beNil())
                                expect(sharedLink.url).to(equal(URL(string: "https://www.box.com/s/vspke7y05sb214wjokpk")))
                                expect(sharedLink.isPasswordEnabled).to(equal(true))
                                expect(sharedLink.previewCount).to(equal(0))
                                expect(sharedLink.downloadCount).to(equal(0))
                            case let .failure(error):
                                fail("Expected call to getSharedLink to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                })
            }

            describe("deleteSharedLink()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/web_links/12345") &&
                            isMethodPUT() &&
                            hasJsonBody(["shared_link": NSNull()])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "RemoveWebLinkSharedLink.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should delete a shared link for a web link", closure: {
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.webLinks.deleteSharedLink(forWebLink: "12345") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteSharedLink to suceeded, but instead got \(error)")
                            }
                            done()
                        }
                    }
                })
            }

            describe("setSharedLink()") {

                context("updating web link with new password value for shared link") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/web_links/12345") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "password": "test"]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetWebLinkSharedLink.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a web link", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.webLinks.setSharedLink(forWebLink: "12345", access: SharedLinkAccess.open, password: .value("test")) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(true))
                                case let .failure(error):
                                    fail("Expected call to setSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }

                context("updating web link without updating password") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/web_links/12345") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open"]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetWebLinkSharedLink.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a web link", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.webLinks.setSharedLink(forWebLink: "12345", access: SharedLinkAccess.open) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(true))
                                case let .failure(error):
                                    fail("Expected call to setSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }

                context("updating web link with password deletion") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/web_links/12345") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "password": NSNull()]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetWebLinkSharedLink_PasswordNotEnabled.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a web link", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.webLinks.setSharedLink(forWebLink: "12345", access: SharedLinkAccess.open, password: .null) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(false))
                                case let .failure(error):
                                    fail("Expected call to setSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }

                context("updating web link with vanity name value for shared link") {
                    beforeEach {
                        stub(
                            condition: isHost("api.box.com") &&
                                isPath("/2.0/web_links/12345") &&
                                isMethodPUT() &&
                                containsQueryParams(["fields": "shared_link"]) &&
                                hasJsonBody(["shared_link": ["access": "open", "vanity_name": "testVanityName"]])
                        ) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "GetWebLinkSharedLink_VanityNameEnabled.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }
                    }
                    it("should update a shared link on a web link", closure: {
                        waitUntil(timeout: .seconds(10)) { done in
                            sut.webLinks.setSharedLink(forWebLink: "12345", access: SharedLinkAccess.open, vanityName: .value("testVanityName")) { result in
                                switch result {
                                case let .success(sharedLink):
                                    expect(sharedLink.access).to(equal(.open))
                                    expect(sharedLink.previewCount).to(equal(0))
                                    expect(sharedLink.downloadCount).to(equal(0))
                                    expect(sharedLink.downloadURL).to(beNil())
                                    expect(sharedLink.isPasswordEnabled).to(equal(false))
                                    expect(sharedLink.url).to(equal(URL(string: "https://cloud.box.com/v/testVanityName")))
                                    expect(sharedLink.vanityName).to(equal("testVanityName"))
                                    expect(sharedLink.vanityURL).to(equal(URL(string: "https://cloud.box.com/v/testVanityName")))
                                case let .failure(error):
                                    fail("Expected call to setSharedLink to suceeded, but instead got \(error)")
                                }
                                done()
                            }
                        }
                    })
                }
            }
        }
    }
}
