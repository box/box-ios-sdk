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

public class DevicePinsModuleSpecs: QuickSpec {
    var sut: BoxClient!

    public override func spec() {

        describe("Device Pins Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("delete()") {

                it("should make API call to delete the specified device pin") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/device_pinners/12345") && isMethodDELETE()) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.devicePins.delete(devicePinId: "12345") { response in
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
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("FullDevicePin.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.devicePins.get(devicePinId: "12345") { result in
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
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetDevicePins.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.devicePins.listForEnterprise(enterpriseId: "12345", direction: .ascending) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(devicePin):
                                        expect(devicePin).toNot(beNil())
                                        expect(devicePin.id).to(equal("12345"))
                                        expect(devicePin.type).to(equal("device_pinner"))
                                        expect(devicePin.productName).to(equal("Test"))

                                    case let .failure(error):
                                        fail("Unable to get Device Pins for an enterprise instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get Device Pins for an enterprise instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
