//
//  PagingIteratorSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 31/03/2023.
//  Copyright © 2023 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class PagingIteratorSpecs: QuickSpec {

    override class func spec() {
        var sut: PagingIterator<FolderItem>!
        var client = BoxSDK.getClient(token: "")
        lazy var url = URL.boxAPIEndpoint("/2.0/list_items/", configuration: client.configuration)

        describe("PageIteratorSpecs") {
            beforeEach {}

            afterEach {
                sut = nil
                HTTPStubs.removeAllStubs()
            }

            describe("marker based paging") {

                it("should get second page if first returns valid marker in next_marker field") {
                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/list_items")
                        && isMethodGET() && containsQueryParams(["usemarker": "true"])) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "MarkerBasedPagingWithValidNext.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/list_items")
                        && isMethodGET() && containsQueryParams(["usemarker": "true", "marker": "next_marker_value_1"])) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "MarkerBasedPagingWithEmptyNext.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                    sut = PagingIterator<FolderItem>(client: client, url: url, queryParameters: ["usemarker": "true"])

                    // Get first page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.nextMarker).to(equal("next_marker_value_1"))
                                expect(page.entries.count).to(equal(2))
                            case let .failure(error):
                                fail("Unable to get items: \(error)")
                            }
                            done()
                        }
                    }

                    // Get second page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.nextMarker).to(equal(""))
                                expect(page.entries.count).to(equal(2))
                            case let .failure(error):
                                fail("Unable to get items: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should throw an endOfList Error when trying to get second page if first request had returned an empty value in next_marker") {
                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/list_items")
                        && isMethodGET() && containsQueryParams(["usemarker": "true"])) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "MarkerBasedPagingWithEmptyNext.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                    sut = PagingIterator<FolderItem>(client: client, url: url, queryParameters: ["usemarker": "true"])

                    // Get first page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.nextMarker).to(equal(""))
                                expect(page.entries.count).to(equal(2))
                            case let .failure(error):
                                fail("Unable to get items: \(error)")
                            }
                            done()
                        }
                    }

                    // Get second page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case .success:
                                fail("Expected method to throw, but it didn't")
                            case let .failure(error):
                                expect(error).to(matchError(BoxSDKError(message: .endOfList)))
                            }
                            done()
                        }
                    }
                }

                it("should throw an endOfList Error when trying to get second page if first request had returned an null value in next_marker") {
                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/list_items")
                        && isMethodGET() && containsQueryParams(["usemarker": "true"])) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "MarkerBasedPagingWithNullNext.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                    sut = PagingIterator<FolderItem>(client: client, url: url, queryParameters: ["usemarker": "true"])

                    // Get first page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.nextMarker).to(beNil())
                                expect(page.entries.count).to(equal(2))
                            case let .failure(error):
                                fail("Unable to get items: \(error)")
                            }
                            done()
                        }
                    }

                    // Get second page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case .success:
                                fail("Expected method to throw, but it didn't")
                            case let .failure(error):
                                expect(error).to(matchError(BoxSDKError(message: .endOfList)))
                            }
                            done()
                        }
                    }
                }
            }

            describe("offset based paging") {

                it("should get second page if first did not reach total_count") {
                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/list_items")
                        && isMethodGET() && containsQueryParams(["limit": "2"])) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "OffsetBasedPagingWithMoreItems.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/list_items")
                        && isMethodGET() && containsQueryParams(["offset": "2", "limit": "2"])) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "OffsetBasedPagingWithoutMoreItems.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                    sut = PagingIterator<FolderItem>(client: client, url: url, queryParameters: ["limit": "2"])

                    // Get first page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.offset).to(equal(0))
                                expect(page.limit).to(equal(2))
                                expect(page.entries.count).to(equal(2))
                                expect(page.totalCount).to(equal(4))
                            case let .failure(error):
                                fail("Unable to get items: \(error)")
                            }
                            done()
                        }
                    }

                    // Get second page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.offset).to(equal(2))
                                expect(page.limit).to(equal(2))
                                expect(page.entries.count).to(equal(2))
                                expect(page.totalCount).to(equal(4))
                            case let .failure(error):
                                fail("Unable to get items: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should throw an endOfList Error when trying to get second page if first page has reached already total_cout") {
                    stub(condition: isHost("api.box.com")
                        && isPath("/2.0/list_items")
                        && isMethodGET() && containsQueryParams(["offset": "2", "limit": "2"])) { _ in
                            HTTPStubsResponse(
                                fileAtPath: TestAssets.path(forResource: "OffsetBasedPagingWithoutMoreItems.json")!,
                                statusCode: 200, headers: ["Content-Type": "application/json"]
                            )
                        }

                    sut = PagingIterator<FolderItem>(client: client, url: url, queryParameters: ["offset": "2", "limit": "2"])

                    // Get first page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.offset).to(equal(2))
                                expect(page.limit).to(equal(2))
                                expect(page.entries.count).to(equal(2))
                                expect(page.totalCount).to(equal(4))
                            case let .failure(error):
                                fail("Unable to get items: \(error)")
                            }
                            done()
                        }
                    }

                    // Get second page
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.next { result in
                            switch result {
                            case .success:
                                fail("Expected method to throw, but it didn't")
                            case let .failure(error):
                                expect(error).to(matchError(BoxSDKError(message: .endOfList)))
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
