//
//  RetentionPolicyAssignmentSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/27/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class RetentionPolicyAssignmentSpecs: QuickSpec {

    override func spec() {
        describe("Retention Policy Assignment") {

            describe("init()") {

                it("should correctly deserialize retention policy assignment from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullRetentionPolicyAssignment", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let retentionPolicyAssignment = try RetentionPolicyAssignment(json: jsonDict)

                        expect(retentionPolicyAssignment.type).to(equal("retention_policy_assignment"))
                        expect(retentionPolicyAssignment.id).to(equal("12345678"))
                        expect(retentionPolicyAssignment.retentionPolicy?.type).to(equal("retention_policy"))
                        expect(retentionPolicyAssignment.retentionPolicy?.id).to(equal("123"))
                        expect(retentionPolicyAssignment.retentionPolicy?.name).to(equal("Some Policy Name"))
                        expect(retentionPolicyAssignment.assignedTo?.type?.description).to(equal("metadata_template"))
                        expect(retentionPolicyAssignment.assignedTo?.id).to(equal("dbab3bd1-93ab-43d9-a31c-9540b0a72ff"))
                        expect(retentionPolicyAssignment.filterFields?[0].field).to(equal("c0753131-b592-4340-9c2d-ba67145fb784"))
                        expect(retentionPolicyAssignment.filterFields?[0].value).to(equal("fe6b46fd-a7e9-127f-b3d0-a0be0921372e"))
                        expect(retentionPolicyAssignment.assignedBy?.type).to(equal("user"))
                        expect(retentionPolicyAssignment.assignedBy?.id).to(equal("1234"))
                        expect(retentionPolicyAssignment.assignedBy?.name).to(equal("Test User"))
                        expect(retentionPolicyAssignment.assignedBy?.login).to(equal("testuser@example.com"))
                        expect(retentionPolicyAssignment.assignedAt?.iso8601).to(equal("2018-01-05T19:45:19Z"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
