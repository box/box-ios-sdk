//
//  StoragePolicySpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/6/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import Quick

class StoragePolicySpecs: QuickSpec {

    override func spec() {
        describe("Storage Policy") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullStoragePolicy", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let storagePolicy = try StoragePolicy(json: jsonDict)

                        expect(storagePolicy.type).to(equal("storage_policy"))
                        expect(storagePolicy.id).to(equal("10"))
                        expect(storagePolicy.name).to(equal("Tokyo & Singapore"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
