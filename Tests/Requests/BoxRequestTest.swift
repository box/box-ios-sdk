//
//  BoxRequestTest.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 5/6/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import Quick

class BoxRequestUnitTests: QuickSpec {

    public override func spec() {

        describe("BoxRequest") {

            describe("endpoint()") {

                it("should not encode query parameters when they have nil value") {

                    let request = BoxRequest(
                        httpMethod: .get,
                        url: URL(string: "http://example.com/test")!,
                        queryParams: [
                            "foo": "bar",
                            "baz": nil
                        ],
                        body: .empty
                    )

                    let endpoint = request.endpoint()

                    expect(endpoint.absoluteString).to(equal("http://example.com/test?foo=bar"))
                }
            }
        }
    }
}
