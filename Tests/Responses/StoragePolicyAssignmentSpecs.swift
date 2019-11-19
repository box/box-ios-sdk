//
//  StoragePolicyAssignmentSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/6/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import Quick

class StoragePolicyAssignmentSpecs: QuickSpec {

    override func spec() {
        describe("Storage Policy Assignment") {

            describe("init()") {

                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullStoragePolicyAssignment", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let assignment = try StoragePolicyAssignment(json: jsonDict)

                        expect(assignment.type).to(equal("storage_policy_assignment"))
                        expect(assignment.id).to(equal("enterprise_36907420"))
                        expect(assignment.storagePolicy?.type).to(equal("storage_policy"))
                        expect(assignment.storagePolicy?.id).to(equal("123"))
                        expect(assignment.assignedTo?.type).to(equal("enterprise"))
                        expect(assignment.assignedTo?.id).to(equal("12345"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
