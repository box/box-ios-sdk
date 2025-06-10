//
//  BoxNetworkAgentSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/3/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class BoxNetworkAgentSpy: BoxNetworkAgent {
    var responseIntervals = [TimeInterval]()

    override func retryRequest(_ retry: @escaping () -> Void, afterDelay delay: TimeInterval) {
        super.retryRequest(retry, afterDelay: delay)

        responseIntervals.append(delay)
    }
}

class BoxNetworkAgentSpecs: QuickSpec {

    override class func spec() {
        var networkAgent: BoxNetworkAgentSpy!

        beforeEach {
            networkAgent = BoxNetworkAgentSpy(configuration: BoxSDK.defaultConfiguration)
        }

        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("send()") {

            context("retry with exponential backoff") {
                beforeEach {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/me") && isMethodGET()) { _ in
                        HTTPStubsResponse(
                            data: Data(), statusCode: 500, headers: [:]
                        )
                    }
                }

                it("should fail and the intervals between retries should fit expected ranges when API returns transient error") {
                    waitUntil(timeout: .seconds(200)) { done in
                        let request = BoxRequest(httpMethod: .get, url: URL(string: "https://api.box.com/2.0/users/me")!)
                        networkAgent.send(request: request) { result in
                            switch result {
                            case .success:
                                fail("Expected call to fail, but it succeeded")
                            case .failure:
                                let bounds: [(min: TimeInterval, max: TimeInterval)] = [(0, 2), (1, 3), (2, 6), (4, 12), (8, 24), (16, 48), (32, 96)]

                                let responseIntervals = networkAgent.responseIntervals
                                expect(responseIntervals.count).to(equal(BoxSDK.defaultConfiguration.maxRetryAttempts))

                                for index in 0 ..< min(6, responseIntervals.count) {
                                    let delay = responseIntervals[index]
                                    let bound = bounds[index]

                                    expect(delay).to(beGreaterThanOrEqualTo(bound.min))
                                    expect(delay).to(beLessThanOrEqualTo(bound.max))
                                }
                            }
                            done()
                        }
                    }
                }
            }

            it("should send request with analytics header") {
                let analytics = AnalyticsHeaderGenerator()
                let analyticsHeader = "agent=box-swift-sdk/\(analytics.swiftSDKVersion); env=\(analytics.deviceName)/\(analytics.iOSVersion)"

                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/users/me")
                        && isMethodGET()
                        && hasHeaderNamed("X-Box-UA", value: analyticsHeader)
                ) { _ in
                    HTTPStubsResponse(
                        fileAtPath: TestAssets.path(forResource: "GetUserInfo.json")!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: .seconds(10)) { done in
                    let request = BoxRequest(httpMethod: .get, url: URL(string: "https://api.box.com/2.0/users/me")!)
                    networkAgent.send(request: request) { result in
                        if case let .failure(error) = result {
                            fail("Expected call to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }

            it("should send analytics header containing client analytics info when configuration includes client info") {
                let clientInfo = ClientAnalyticsInfo(appName: "testApp", appVersion: "1.2.3")
                let config = try! BoxSDKConfiguration(clientId: "", clientSecret: "", clientAnalyticsInfo: clientInfo)
                networkAgent = BoxNetworkAgentSpy(configuration: config)

                let analytics = AnalyticsHeaderGenerator()
                let analyticsHeader = "agent=box-swift-sdk/\(analytics.swiftSDKVersion); env=\(analytics.deviceName)/\(analytics.iOSVersion); client=testApp/1.2.3"

                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/users/me")
                        && isMethodGET()
                        && hasHeaderNamed("X-Box-UA", value: analyticsHeader)
                ) { _ in
                    HTTPStubsResponse(
                        fileAtPath: TestAssets.path(forResource: "GetUserInfo.json")!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: .seconds(10)) { done in
                    let request = BoxRequest(httpMethod: .get, url: URL(string: "https://api.box.com/2.0/users/me")!)
                    networkAgent.send(request: request) { result in
                        if case let .failure(error) = result {
                            fail("Expected call to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }

            it("should use custom Content-Type header if specified") {
                stub(
                    condition: isHost("api.box.com")
                        && isPath("/2.0/users/me")
                        && isMethodGET()
                        && hasHeaderNamed("Content-Type", value: "application/vnd.box+json")
                ) { _ in
                    HTTPStubsResponse(
                        fileAtPath: TestAssets.path(forResource: "GetUserInfo.json")!,
                        statusCode: 200, headers: ["Content-Type": "application/json"]
                    )
                }

                waitUntil(timeout: .seconds(10)) { done in
                    let request = BoxRequest(
                        httpMethod: .get,
                        url: URL(string: "https://api.box.com/2.0/users/me")!,
                        httpHeaders: ["Content-Type": "application/vnd.box+json"],
                        body: .jsonObject(["type": "user"])
                    )
                    networkAgent.send(request: request) { result in
                        if case let .failure(error) = result {
                            fail("Expected call to succeed, but instead got \(error)")
                        }
                        done()
                    }
                }
            }
        }
    }
}
