//
//  LegalHoldsModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/4/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class LegalHoldsModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("Legal Holds Module") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("create()") {

                it("should make API call to create legal hold policy and produce legal hold policy response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policies")
                            && isMethodPOST()
                            && hasJsonBody([
                                "policy_name": "Policy",
                                "is_ongoing": true
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateLegalHoldPolicy.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.create(policyName: "Policy", isOngoing: true) { result in
                            switch result {
                            case let .success(legalHoldPolicy):
                                expect(legalHoldPolicy).toNot(beNil())
                                expect(legalHoldPolicy).to(beAKindOf(LegalHoldPolicy.self))
                                expect(legalHoldPolicy.id).to(equal("28115"))
                                expect(legalHoldPolicy.description).to(equal("postman created policy"))
                            case let .failure(error):
                                fail("Expected call to create to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get()") {

                it("should make API call to get legal hold policy and produce legal hold policy response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policies/166757")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetLegalHoldPolicyInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.get(policyId: "166757") { result in
                            switch result {
                            case let .success(legalHoldPolicy):
                                expect(legalHoldPolicy).toNot(beNil())
                                expect(legalHoldPolicy).to(beAKindOf(LegalHoldPolicy.self))
                                expect(legalHoldPolicy.id).to(equal("16675"))
                                expect(legalHoldPolicy.policyName).to(equal("Policy 4"))
                            case let .failure(error):
                                fail("Expected call to get to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update()") {

                it("should make API call to update legal hold policy and produce legal hold policy response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policies/166921")
                            && isMethodPUT()
                            && hasJsonBody([
                                "policy_name": "New Policy 3",
                                "description": "Policy 3 New Description"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateLegalHoldPolicy.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.update(policyId: "166921", policyName: "New Policy 3", description: "Policy 3 New Description") { result in
                            switch result {
                            case let .success(legalHoldPolicy):
                                expect(legalHoldPolicy).toNot(beNil())
                                expect(legalHoldPolicy).to(beAKindOf(LegalHoldPolicy.self))
                                expect(legalHoldPolicy.id).to(equal("16692"))
                                expect(legalHoldPolicy.policyName).to(equal("New Policy 3"))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should make API call to delete legal hold policy and produce legal hold policy response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policies/16692")
                            && isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.delete(policyId: "16692") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete to suceed, but it failed because \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listForEnterprise()") {

                it("should make API call to get legal hold policies and produce legal hold policy response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policies")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetLegalHoldPolicies.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.legalHolds.listForEnterprise()
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let policy = page.entries[0]
                                expect(policy.type).to(equal("legal_hold_policy"))
                                expect(policy.id).to(equal("16687"))
                                expect(policy.policyName).to(equal("Policy 1"))
                            case let .failure(error):
                                fail("Unable to get legal hold policies instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("assignPolicy()") {

                it("should make API call to assign legal hold policy and produce legal hold policy response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policy_assignments")
                            && isMethodPOST()
                            && hasJsonBody([
                                "policy_id": "166757",
                                "assign_to": [
                                    "id": "5025127885",
                                    "type": "file"
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "AssignPolicy.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.assignPolicy(policyId: "166757", assignToId: "5025127885", assignToType: "file") { result in
                            switch result {
                            case let .success(assignment):
                                expect(assignment).toNot(beNil())
                                expect(assignment).to(beAKindOf(LegalHoldPolicyAssignment.self))
                                expect(assignment.id).to(equal("2553"))
                                expect(assignment.assignedBy?.id).to(equal("22222"))
                            case let .failure(error):
                                fail("Expected call to assignPolicy to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getPolicyAssignment()") {

                it("should make API call to get legal hold policy assignment info and produce legal hold policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policy_assignments/255473")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetPolicyAssignmentInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.getPolicyAssignment(assignmentId: "255473") { result in
                            switch result {
                            case let .success(assignment):
                                expect(assignment).toNot(beNil())
                                expect(assignment).to(beAKindOf(LegalHoldPolicyAssignment.self))
                                expect(assignment.id).to(equal("1234"))
                                expect(assignment.legalHoldPolicy?.policyName).to(equal("Bug Bash 5-12 Policy 3 updated"))
                            case let .failure(error):
                                fail("Expected call to getPolicyAssignment to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("deletePolicyAssignment()") {
                it("should make API call to delete legal hold policy assignment and produce legal hold policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policy_assignments/166921")
                            && isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.deletePolicyAssignment(assignmentId: "166921") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deletePolicyAssignment to suceed, but it failed because \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listPolicyAssignments()") {

                it("should make API call to get legal hold policy assignments and produce legal hold policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/legal_hold_policy_assignments")
                            && isMethodGET()
                            && containsQueryParams(["policy_id": "255473"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetPolicyAssignments.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.legalHolds.listPolicyAssignments(policyId: "255473")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let assignment = page.entries[0]
                                expect(assignment.type).to(equal("legal_hold_policy_assignment"))
                                expect(assignment.id).to(equal("25573"))
                            case let .failure(error):
                                fail("Unable to get legal hold policy assignments instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getFileVersionPolicy()") {

                it("should make API call to get file version legal hold info and produce file version legal hold response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/file_version_legal_holds/166757")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFileVersionLegalHoldInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.legalHolds.getFileVersionPolicy(legalHoldId: "166757") { result in
                            switch result {
                            case let .success(legalHold):
                                expect(legalHold).toNot(beNil())
                                expect(legalHold).to(beAKindOf(FileVersionLegalHold.self))
                                expect(legalHold.id).to(equal("24097"))
                                expect(legalHold.fileVersion?.id).to(equal("14164417"))
                            case let .failure(error):
                                fail("Expected call to getFileVersionPolicy to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listFileVersionPolicies()") {

                it("should make API call to get file version legal holds and produce file version legal hold response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/file_version_legal_holds")
                            && isMethodGET()
                            && containsQueryParams(["policy_id": "240997"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFileVersionLegalHolds.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.legalHolds.listFileVersionPolicies(policyId: "240997")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let legalHold = page.entries[0]
                                expect(legalHold.type).to(equal("legal_hold"))
                                expect(legalHold.id).to(equal("24101"))
                            case let .failure(error):
                                fail("Unable to get file version legal holds instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
