//
//  LegalHoldPolicyAssignmentSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/5/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import Quick

class LegalHoldPolicyAssignmentSpecs: QuickSpec {

    override func spec() {
        describe("Legal Hold Policy Assignment") {

            describe("init()") {

                it("should correctly deserialize legal hold assignment from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullPolicyAssignment", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let policyAssignment = try LegalHoldPolicyAssignment(json: jsonDict)

                        expect(policyAssignment.type).to(equal("legal_hold_policy_assignment"))
                        expect(policyAssignment.id).to(equal("25543"))
                        expect(policyAssignment.legalHoldPolicy?.type).to(equal("legal_hold_policy"))
                        expect(policyAssignment.legalHoldPolicy?.id).to(equal("16657"))
                        expect(policyAssignment.legalHoldPolicy?.policyName).to(equal("Bug Bash 5-12 Policy 3 updated"))
                        guard case let .user(user)? = policyAssignment.assignedTo?.itemValue else {
                            fail("Failed: Expected user object as target")
                            return
                        }
                        expect(user.type).to(equal("user"))
                        expect(user.id).to(equal("203038321"))
                        expect(policyAssignment.assignedBy?.type).to(equal("user"))
                        expect(policyAssignment.assignedBy?.id).to(equal("203038321"))
                        expect(policyAssignment.assignedBy?.name).to(equal("Test User"))
                        expect(policyAssignment.assignedBy?.login).to(equal("testuser@example.com"))
                        expect(policyAssignment.assignedAt?.iso8601).to(equal("2016-05-18T17:32:19Z"))
                        expect(policyAssignment.deletedAt?.iso8601).to(beNil())
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
