//
//  SignRequestSignerRoleSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 14/10/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class SignRequestSignerRoleSpecs: QuickSpec {

    override class func spec() {
        describe("SignRequestSignerRole") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(SignRequestSignerRole.signer).to(equal(SignRequestSignerRole(SignRequestSignerRole.signer.description)))
                    expect(SignRequestSignerRole.approver).to(equal(SignRequestSignerRole(SignRequestSignerRole.approver.description)))
                    expect(SignRequestSignerRole.finalCopyReader).to(equal(SignRequestSignerRole(SignRequestSignerRole.finalCopyReader.description)))
                    expect(SignRequestSignerRole.customValue("custom value")).to(equal(SignRequestSignerRole("custom value")))
                }
            }
        }
    }
}
