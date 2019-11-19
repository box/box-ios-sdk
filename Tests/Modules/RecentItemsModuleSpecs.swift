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
    var sut: BoxClient!

    override func spec() {
        describe("Recent Items Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("list()") {

                it("should make API call to get recent items and produce recent items response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/recent_items")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetRecentItems.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: 10) { done in
                        self.sut.recentItems.list { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstItem):
                                        expect(firstItem.type).to(equal("recent_item"))
                                        expect(firstItem.interactionType.description).to(equal("item_preview"))
                                        expect(firstItem.item.id).to(equal("181937331928"))
                                    case let .failure(error):
                                        fail("Unable to get recent items instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get recent items instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
