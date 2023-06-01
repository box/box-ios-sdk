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

    override class func spec() {
        var sut: AccessibleBy!

        describe("Comments Module") {
            beforeEach {
                sut = AccessibleBy.group
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("BoxEnum comparisons") {

                it("it should match the enum and string representation") {
                    expect(sut == "group").to(equal(true))
                }
            }
        }
    }
}
