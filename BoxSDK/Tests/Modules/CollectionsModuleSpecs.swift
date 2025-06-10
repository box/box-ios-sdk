//
//  CollectionsModuleSpecs.swift
//  BoxSDK
//
//  Created by Daniel Cech on 06/04/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class CollectionsModulesSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        beforeEach {
            sut = BoxSDK.getClient(token: "asdads")
        }

        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("CollectionsModuleSpecs") {
            describe("list()") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collections")
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollections.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }

                it("should be able to get a list of collections") {
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.collections.list()
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let firstCollection = page.entries[0]
                                expect(firstCollection).to(beAKindOf(BoxCollection.self))
                                expect(firstCollection.collectionType).to(equal("favorites"))
                                expect(firstCollection.id).to(equal("405151"))
                                expect(firstCollection.name).to(equal("Favorites"))

                            case let .failure(error):
                                fail("Expected call to list to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getFavorites()") {

                it("should retrieve the favorites collection") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collections")
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollections.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collections.getFavorites { result in
                            switch result {
                            case let .success(favoritesCollection):
                                expect(favoritesCollection).to(beAKindOf(BoxCollection.self))
                                expect(favoritesCollection.collectionType).to(equal("favorites"))
                                expect(favoritesCollection.id).to(equal("405151"))
                                expect(favoritesCollection.name).to(equal("Favorites"))
                            case let .failure(error):
                                fail("Expected call to getFavorites to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should produce error when no favorites collection is available") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collections")
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollectionsEmpty.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.collections.getFavorites { result in
                            switch result {
                            case .success:
                                fail("Expected method to produce an error, but it succeeded")
                            case let .failure(error):
                                expect(error).to(matchError(BoxSDKError(message: .notFound("Collections does not have the favorites collection type"))))
                            }

                            done()
                        }
                    }
                }
            }

            context("retrieving list of items of particular collection") {
                beforeEach {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/collections/123/items") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCollectionItems.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                }
                it("should be able to get list of collection items") {
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.collections.listItems(collectionId: "123")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let item = page.entries[0]
                                if case let .folder(folder) = item {
                                    expect(folder).toNot(beNil())
                                    expect(folder.id).to(equal("192429928"))
                                    expect(folder.name).to(equal("Test Folder"))
                                    expect(folder.sequenceId).to(equal("1"))
                                    expect(folder.etag).to(equal("1"))
                                }
                                else {
                                    fail("Expected test item to be a folder")
                                }

                            case let .failure(error):
                                fail("Expected getCollectionItems request to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
