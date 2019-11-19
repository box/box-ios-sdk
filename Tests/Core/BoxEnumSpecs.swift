//
//  BoxEnumSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Daniel Cech on 19/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class BoxEnumSpecs: QuickSpec {
    var sut: AccessibleBy!

    override func spec() {
        describe("Comments Module") {
            beforeEach {
                self.sut = AccessibleBy.group
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("BoxEnum comparisons") {

                it("it should match the enum and string representation") {
                    expect(self.sut == "group").to(equal(true))
                }
            }
        }
    }
}
