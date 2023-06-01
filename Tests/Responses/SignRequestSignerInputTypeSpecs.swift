//
//  SignRequestSignerInputTypeSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 14/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestSignerInputTypeSpecs: QuickSpec {

    override class func spec() {
        describe("SignRequestSignerInputType") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(SignRequestSignerInputType.signature).to(equal(SignRequestSignerInputType(SignRequestSignerInputType.signature.description)))
                    expect(SignRequestSignerInputType.date).to(equal(SignRequestSignerInputType(SignRequestSignerInputType.date.description)))
                    expect(SignRequestSignerInputType.text).to(equal(SignRequestSignerInputType(SignRequestSignerInputType.text.description)))
                    expect(SignRequestSignerInputType.checkbox).to(equal(SignRequestSignerInputType(SignRequestSignerInputType.checkbox.description)))
                    expect(SignRequestSignerInputType.customValue("custom value")).to(equal(SignRequestSignerInputType("custom value")))
                }
            }
        }
    }
}
