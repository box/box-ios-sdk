//
//  URLCreationTest.swift
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

    public override func spec() {

        let configuration: BoxSDKConfiguration = try! BoxSDKConfiguration(clientId: "", clientSecret: "")
        let customURLPart: String = "/testurl"

        describe("boxAPIEndpoint()") {
            it("should create an API Endpoint URL containing base url from configuration") {
                let url = URL.boxAPIEndpoint(customURLPart, configuration: configuration)
                expect(url.absoluteString).to(equal(configuration.apiBaseURL.absoluteString.appending(customURLPart)))
                expect(url.absoluteString).to(contain(configuration.apiBaseURL.absoluteString))
            }
        }

        describe("boxAPIEndpoint()") {
            it("should create an Upload Endpoint URL containing base url from configuration") {
                let url = URL.boxUploadEndpoint(customURLPart, configuration: configuration)
                expect(url.absoluteString).to(equal(configuration.uploadApiBaseURL.absoluteString.appending(customURLPart)))
                expect(url.absoluteString).to(contain(configuration.uploadApiBaseURL.absoluteString))
            }

            context("when providing full url string") {
                it("should create url only from url string without base url from configuration") {
                    let urlString = "http://fakeurl.com/test"
                    let url = URL.boxUploadEndpoint(urlString, configuration: configuration)
                    expect(url.absoluteString).to(equal(urlString))
                }
            }
        }
    }
}
