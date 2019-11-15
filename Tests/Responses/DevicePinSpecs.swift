//
//  GroupSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/18/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class DevicePinSpecs: QuickSpec {

    override func spec() {
        describe("DevicePin") {
            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullDevicePin", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let devicePin = try DevicePin(json: jsonDict)

                        expect(devicePin.type).to(equal("device_pinner"))
                        expect(devicePin.id).to(equal("12345"))
                        expect(devicePin.ownedBy?.type).to(equal("user"))
                        expect(devicePin.ownedBy?.id).to(equal("54321"))
                        expect(devicePin.ownedBy?.login).to(equal("testuser@example.com"))
                        expect(devicePin.ownedBy?.name).to(equal("Test User"))
                        expect(devicePin.productName).to(equal("Test"))
                        expect(devicePin.createdAt?.iso8601).to(equal("2019-08-24T05:56:18Z"))
                        expect(devicePin.modifiedAt?.iso8601).to(equal("2019-08-24T05:56:18Z"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
