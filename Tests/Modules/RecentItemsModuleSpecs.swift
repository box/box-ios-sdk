//
//  RecentItemsModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/26/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class RecentItemsModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("Recent Items Module") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("list()") {

                it("should make API call to get recent items and produce recent items response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/recent_items")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetRecentItems.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.recentItems.list()
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let firstItem = page.entries[0]
                                expect(firstItem.type).to(equal("recent_item"))
                                expect(firstItem.interactionType.description).to(equal("item_preview"))
                                expect(firstItem.item.id).to(equal("181937331928"))
                            case let .failure(error):
                                fail("Unable to get recent items instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
