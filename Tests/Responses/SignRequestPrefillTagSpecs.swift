//
//  SignRequestPrefillTagSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 14/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestPrefillTagSpecs: QuickSpec {

    override class func spec() {
        describe("SignRequestPrefillTag") {

            describe("init()") {

                it("should correctly create an object using init with textValue parameter") {
                    let sut = SignRequestPrefillTag(documentTagId: "1", textValue: "text")
                    expect(sut.documentTagId).to(equal("1"))
                    expect(sut.textValue).to(equal("text"))
                    expect(sut.checkboxValue).to(beNil())
                    expect(sut.dateValue).to(beNil())
                }

                it("should correctly create an object using init with checkboxValue parameter") {
                    let sut = SignRequestPrefillTag(documentTagId: "1", checkboxValue: true)
                    expect(sut.documentTagId).to(equal("1"))
                    expect(sut.checkboxValue).to(equal(true))
                    expect(sut.textValue).to(beNil())
                    expect(sut.dateValue).to(beNil())
                }

                it("should correctly create an object using init with dateValue parameter") {
                    let sut = SignRequestPrefillTag(documentTagId: "1", dateValue: "2021-04-26".iso8601)
                    expect(sut.documentTagId).to(equal("1"))
                    expect(sut.dateValue).to(equal("2021-04-26".iso8601))
                    expect(sut.checkboxValue).to(beNil())
                    expect(sut.textValue).to(beNil())
                }
            }
        }
    }
}
