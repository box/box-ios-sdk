//
//  QueryParameterConvertibleSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 21/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class QueryParameterConvertibleSpecs: QuickSpec {

    override class func spec() {
        describe("QueryParameterConvertible") {

            describe("queryParamValue") {

                it("should create a valid query param value from a String type") {
                    let param: String = "stringValue"
                    expect(param.queryParamValue).to(equal("stringValue"))
                }

                it("should create a valid query param value from a Int type") {
                    let param: Int = 1
                    expect(param.queryParamValue).to(equal("1"))
                }

                it("should create a valid query param value from a Bool type") {
                    let paramTrueValue: Bool = true
                    expect(paramTrueValue.queryParamValue).to(equal("true"))

                    let paramFalseValue: Bool = false
                    expect(paramFalseValue.queryParamValue).to(equal("false"))
                }

                it("should create a valid query param value from a NSNumber type") {
                    let paramInt = NSNumber(value: 123)
                    expect(paramInt.queryParamValue).to(equal("123"))

                    let paramDouble = NSNumber(value: 123.45)
                    expect(paramDouble.queryParamValue).to(equal("123.45"))
                }

                it("should create a valid query param value from a NSString type") {
                    let param = NSString(string: "testValue")
                    expect(param.queryParamValue).to(equal("testValue"))
                }

                it("should create a valid query param value from an Array type") {
                    let param: [String] = ["a", "bc", "d_e_f", "g h i j"]
                    expect(param.queryParamValue).to(equal("a,bc,d_e_f,g h i j"))
                }

                it("should create a valid query param value form an optional type which conforms to QueryParameterConvertible") {
                    let string: String? = "stringValue"
                    expect(string.queryParamValue).to(equal("stringValue"))

                    let nilString: String? = nil
                    expect(nilString.queryParamValue).to(beNil())
                }
            }
        }
    }
}
