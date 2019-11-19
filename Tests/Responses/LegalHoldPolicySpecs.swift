//
//  LegalHoldPolicySpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/4/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import Quick

class LegalHoldPolicySpecs: QuickSpec {

    override func spec() {
        describe("Legal Hold Policy") {

            describe("init()") {

                it("should correctly deserialize legal hold policy from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullLegalHoldPolicy", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let legalHoldPolicy = try LegalHoldPolicy(json: jsonDict)

                        expect(legalHoldPolicy.type).to(equal("legal_hold_policy"))
                        expect(legalHoldPolicy.id).to(equal("16657"))
                        expect(legalHoldPolicy.policyName).to(equal("Policy 4"))
                        expect(legalHoldPolicy.description).to(equal("Postman created policy"))
                        expect(legalHoldPolicy.status?.description).to(equal("active"))
                        expect(legalHoldPolicy.assignmentCounts?.user).to(equal(1))
                        expect(legalHoldPolicy.assignmentCounts?.folder).to(equal(0))
                        expect(legalHoldPolicy.assignmentCounts?.file).to(equal(0))
                        expect(legalHoldPolicy.assignmentCounts?.fileVersion).to(equal(0))
                        expect(legalHoldPolicy.createdBy?.type).to(equal("user"))
                        expect(legalHoldPolicy.createdBy?.id).to(equal("2030388321"))
                        expect(legalHoldPolicy.createdBy?.name).to(equal("Test User"))
                        expect(legalHoldPolicy.createdBy?.login).to(equal("testuser@example.com"))
                        expect(legalHoldPolicy.createdAt?.iso8601).to(equal("2016-05-18T17:28:45Z"))
                        expect(legalHoldPolicy.modifiedAt?.iso8601).to(equal("2016-05-18T18:25:59Z"))
                        expect(legalHoldPolicy.deletedAt).to(beNil())
                        expect(legalHoldPolicy.filterStartedAt?.iso8601).to(equal("2016-05-17T08:00:00Z"))
                        expect(legalHoldPolicy.filterEndedAt?.iso8601).to(equal("2016-05-21T08:00:00Z"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
