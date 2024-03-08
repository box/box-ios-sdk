//
//  SignRequestSignatureColorSpecs.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 06/03/2024.
//  Copyright © 2024 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestSignatureColorSpecs: QuickSpec {

    override class func spec() {
        describe("SignRequestSignatureColor") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(SignRequestSignatureColor.black).to(equal(SignRequestSignatureColor(SignRequestSignatureColor.black.description)))
                    expect(SignRequestSignatureColor.blue).to(equal(SignRequestSignatureColor(SignRequestSignatureColor.blue.description)))
                    expect(SignRequestSignatureColor.red).to(equal(SignRequestSignatureColor(SignRequestSignatureColor.red.description)))
                    expect(SignRequestSignatureColor.customValue("custom value")).to(equal(SignRequestSignatureColor("custom value")))
                }
            }
        }
    }
}
