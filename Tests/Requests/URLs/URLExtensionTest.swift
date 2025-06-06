//
//  URLExtensionTest.swift
//  BoxSDKTests-iOS
//
//  Created by Martina Stremenova on 10/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Foundation
import Nimble
import Quick

class URLExtensionTest: QuickSpec {

    override class func spec() {

        let configuration: BoxSDKConfiguration = try! BoxSDKConfiguration(clientId: "", clientSecret: "")
        let customURLPart: String = "/testurl"
        let invalidURLPart: String = "/test/../"
        let invalidURLPart2: String = "/test/.."

        describe("boxAPIEndpoint()") {
            it("should create an API Endpoint URL containing base url from configuration") {
                let url = URL.boxAPIEndpoint(customURLPart, configuration: configuration)
                expect(url.absoluteString).to(equal(configuration.apiBaseURL.absoluteString.appending(customURLPart)))
                expect(url.absoluteString).to(contain(configuration.apiBaseURL.absoluteString))
            }

            it("should fail to create an API Endpoint URL") {
                expect { _ = URL.boxAPIEndpoint(invalidURLPart, configuration: configuration) }.to(throwAssertion())
                expect { _ = URL.boxAPIEndpoint(invalidURLPart2, configuration: configuration) }.to(throwAssertion())
            }
        }

        describe("boxUploadEndpoint()") {
            it("should create an Upload Endpoint URL containing base url from configuration") {
                let url = URL.boxUploadEndpoint(customURLPart, configuration: configuration)
                expect(url.absoluteString).to(equal(configuration.uploadApiBaseURL.absoluteString.appending(customURLPart)))
                expect(url.absoluteString).to(contain(configuration.uploadApiBaseURL.absoluteString))
            }

            it("should fail to create an Upload Endpoint URL") {
                expect { _ = URL.boxUploadEndpoint(invalidURLPart, configuration: configuration) }.to(throwAssertion())
                expect { _ = URL.boxUploadEndpoint(invalidURLPart2, configuration: configuration) }.to(throwAssertion())
            }

            context("when providing full url string") {
                it("should create url only from url string without base url from configuration") {
                    let urlString = "http://fakeurl.com/test"
                    let url = URL.boxUploadEndpoint(urlString, configuration: configuration)
                    expect(url.absoluteString).to(equal(urlString))
                }

                it("should fail") {
                    let urlString = "http://fakeurl.com/test/../"
                    expect { _ = URL.boxUploadEndpoint(urlString, configuration: configuration) }.to(throwAssertion())
                }
            }
        }
    }
}
