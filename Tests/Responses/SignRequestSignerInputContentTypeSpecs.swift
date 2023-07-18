//
//  SignRequestSignerInputContentTypeSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Minh Nguyen Cong on 30/08/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestSignerInputContentTypeSpecs: QuickSpec {

    override class func spec() {
        describe("SignRequestSignerInputContentType") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(SignRequestSignerInputContentType.initial).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.initial.description)))
                    expect(SignRequestSignerInputContentType.stamp).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.stamp.description)))
                    expect(SignRequestSignerInputContentType.signature).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.signature.description)))
                    expect(SignRequestSignerInputContentType.company).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.company.description)))
                    expect(SignRequestSignerInputContentType.title).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.title.description)))
                    expect(SignRequestSignerInputContentType.email).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.email.description)))
                    expect(SignRequestSignerInputContentType.fullName).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.fullName.description)))
                    expect(SignRequestSignerInputContentType.firstName).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.firstName.description)))
                    expect(SignRequestSignerInputContentType.lastName).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.lastName.description)))
                    expect(SignRequestSignerInputContentType.text).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.text.description)))
                    expect(SignRequestSignerInputContentType.date).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.date.description)))
                    expect(SignRequestSignerInputContentType.checkbox).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.checkbox.description)))
                    expect(SignRequestSignerInputContentType.attachment).to(equal(SignRequestSignerInputContentType(SignRequestSignerInputContentType.attachment.description)))
                    expect(SignRequestSignerInputContentType.customValue("custom value")).to(equal(SignRequestSignerInputContentType("custom value")))
                }
            }
        }
    }
}
