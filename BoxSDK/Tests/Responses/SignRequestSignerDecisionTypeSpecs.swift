//
//  SignRequestSignerDecisionTypeSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 14/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestSignerDecisionTypeSpecs: QuickSpec {

    override class func spec() {
        describe("SignRequestSignerDecisionType") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(SignRequestSignerDecisionType.signed).to(equal(SignRequestSignerDecisionType(SignRequestSignerDecisionType.signed.description)))
                    expect(SignRequestSignerDecisionType.declined).to(equal(SignRequestSignerDecisionType(SignRequestSignerDecisionType.declined.description)))
                    expect(SignRequestSignerDecisionType.customValue("custom value")).to(equal(SignRequestSignerDecisionType("custom value")))
                }
            }
        }
    }
}
