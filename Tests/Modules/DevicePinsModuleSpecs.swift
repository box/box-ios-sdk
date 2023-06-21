//
//  DevicePinsModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 8/27/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class DevicePinsModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("Device Pins Module") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("delete()") {

                it("should make API call to delete the specified device pin") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/device_pinners/12345") && isMethodDELETE()) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.devicePins.delete(devicePinId: "12345") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteDevicePin to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get()") {

                it("should make an API call to retrieve a specified Device Pin") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/device_pinners/12345") && isMethodGET()) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "FullDevicePin.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.devicePins.get(devicePinId: "12345") { result in
                            switch result {
                            case let .success(devicePin):
                                expect(devicePin).toNot(beNil())
                                expect(devicePin).to(beAKindOf(DevicePin.self))
                                expect(devicePin.id).to(equal("12345"))
                                expect(devicePin.type).to(equal("device_pinner"))
                                expect(devicePin.productName).to(equal("Test"))
                            case let .failure(error):
                                fail("Expected call to get to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listForEnterprise()") {
                it("should be able to get Device Pins for an enterprise") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/enterprises/12345/device_pinners")
                            && isMethodGET()
                            && containsQueryParams(["direction": "ASC"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetDevicePins.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.devicePins.listForEnterprise(enterpriseId: "12345", direction: .ascending)
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let devicePin = page.entries[0]
                                expect(devicePin).toNot(beNil())
                                expect(devicePin.id).to(equal("12345"))
                                expect(devicePin.type).to(equal("device_pinner"))
                                expect(devicePin.productName).to(equal("Test"))

                            case let .failure(error):
                                fail("Unable to get Device Pins for an enterprise instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
