//
//  FieldsQueryParamTest.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 5/14/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import Quick

class FieldsQueryParamTest: QuickSpec {

    public override func spec() {

        describe("FieldsQueryParam") {

            let param = FieldsQueryParam(["name", "description", "sha1"])

            describe("queryParamValue") {

                it("should encode fields as comma-separated values") {
                    expect(param.queryParamValue).to(equal("name,description,sha1"))
                }

                it("should encode as nil when fields array is nil") {
                    let nilParam = FieldsQueryParam(nil)
                    expect(nilParam.queryParamValue).to(beNil())
                }

                it("should encode as empty string when fields array is empty") {
                    let emptyParam = FieldsQueryParam([])
                    expect(emptyParam.queryParamValue).to(equal(""))
                }
            }
        }
    }
}
