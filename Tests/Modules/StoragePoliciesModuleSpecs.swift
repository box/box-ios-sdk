//
//  StoragePoliciesModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/6/19.
//  Copyright © 2019 box. All rights reserved.
//
@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class StoragePoliciesModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        describe("Storage Policies Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "asdads")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("get)") {

                it("should make API call to get storage policy info and produce storage policy info response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policies/12345")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetStoragePolicyInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.get(storagePolicyId: "12345") { result in
                            guard case let .success(policy) = result else {
                                fail("Expected call to get to succeed, but it failed")
                                done()
                                return
                            }
                            expect(policy).toNot(beNil())
                            expect(policy).to(beAKindOf(StoragePolicy.self))
                            expect(policy.id).to(equal("10"))
                            expect(policy.name).to(equal("Tokyo & Singapore"))
                            done()
                        }
                    }
                }
            }

            describe("listForEnterprise()") {

                it("should make API call to get storage policies and produce storage policy response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policies")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetStoragePolicies.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.listForEnterprise { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(firstItem):
                                        expect(firstItem.type).to(equal("storage_policy"))
                                        expect(firstItem.id).to(equal("12"))
                                        expect(firstItem.name).to(equal("Montreal / Dublin"))

                                    case let .failure(error):
                                        fail("Unable to get storage policies instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Unable to get storage policies instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }

            describe("getPolicyAssignment()") {

                it("should make API call to get storage policy assignment info and produce storage policy assignment info response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments/enterprise_36907420")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetStoragePolicyAssignmentInfo.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.getAssignment(storagePolicyAssignmentId: "enterprise_36907420") { result in
                            guard case let .success(assignment) = result else {
                                fail("Expected call to getPolicyAssignment to succeed, but it failed")
                                done()
                                return
                            }
                            expect(assignment).toNot(beNil())
                            expect(assignment).to(beAKindOf(StoragePolicyAssignment.self))
                            expect(assignment.id).to(equal("enterprise_36907420"))
                            expect(assignment.storagePolicy?.id).to(equal("168"))
                            done()
                        }
                    }
                }
            }

            describe("listAssignments()") {

                it("should make API call to get storage policy assignments and produce storage policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments")
                            && containsQueryParams(["resolved_for_type": "enterprise", "resolved_for_id": "36690620"])
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetStoragePolicyAssignments.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.listAssignments(resolvedForType: "enterprise", resolvedForId: "36690620") { result in
                            guard case let .success(assignment) = result else {
                                fail("Expected call to listAssignments to succeed, but it failed")
                                done()
                                return
                            }
                            expect(assignment).toNot(beNil())
                            expect(assignment).to(beAKindOf(StoragePolicyAssignment.self))
                            expect(assignment.id).to(equal("user_1234"))
                            expect(assignment.storagePolicy?.id).to(equal("123"))
                            done()
                        }
                    }
                }
            }

            describe("assign()") {

                it("should make API call to create a policy assignment and produce storage policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments")
                            && isMethodPOST()
                            && hasJsonBody([
                                "storage_policy": [
                                    "type": "storage_policy",
                                    "id": "12"
                                ],
                                "assigned_to": [
                                    "type": "user",
                                    "id": "3093450887"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateStoragePolicyAssignment.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.assign(storagePolicyId: "12", assignedToType: "user", assignedToId: "3093450887") { result in
                            guard case let .success(assignment) = result else {
                                fail("Expected call to assign to succeed, but it failed")
                                done()
                                return
                            }
                            expect(assignment).toNot(beNil())
                            expect(assignment).to(beAKindOf(StoragePolicyAssignment.self))
                            expect(assignment.id).to(equal("user_309387087"))
                            expect(assignment.storagePolicy?.id).to(equal("12"))
                            done()
                        }
                    }
                }
            }

            describe("forceAssign()") {

                it("should make API call to assign a policy and produce storage policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments")
                            && isMethodPOST()
                            && hasJsonBody([
                                "storage_policy": [
                                    "type": "storage_policy",
                                    "id": "192"
                                ],
                                "assigned_to": [
                                    "type": "user",
                                    "id": "3093450887"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 409, headers: [:])
                    }

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments")
                            && containsQueryParams(["resolved_for_type": "user", "resolved_for_id": "3093450887"])
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetStoragePolicyAssignments.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments/user_1234")
                            && isMethodPUT()
                            && hasJsonBody([
                                "storage_policy": [
                                    "type": "storage_policy",
                                    "id": "192"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateStoragePolicyAssignment.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.forceAssign(storagePolicyId: "192", assignedToType: "user", assignedToId: "3093450887") { result in
                            guard case let .success(assignment) = result else {
                                fail("Expected call to assignPolicy to succeed, but it failed")
                                done()
                                return
                            }

                            expect(assignment).toNot(beNil())
                            expect(assignment).to(beAKindOf(StoragePolicyAssignment.self))
                            expect(assignment.id).to(equal("user_7993870887"))
                            expect(assignment.storagePolicy?.id).to(equal("192"))
                            done()
                        }
                    }
                }
            }

            describe("updateAssignment()") {

                it("should make API call to update storage policy assignment and storage policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments/user_7993870887")
                            && isMethodPUT()
                            && hasJsonBody([
                                "storage_policy": [
                                    "type": "storage_policy",
                                    "id": "192"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateStoragePolicyAssignment.json", type(of: self))!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.updateAssignment(storagePolicyAssignmentId: "user_7993870887", storagePolicyId: "192") { result in
                            guard case let .success(assignment) = result else {
                                fail("Expected call to updateAssignment to succeed, but it failed")
                                done()
                                return
                            }
                            expect(assignment).toNot(beNil())
                            expect(assignment).to(beAKindOf(StoragePolicyAssignment.self))
                            expect(assignment.id).to(equal("user_7993870887"))
                            expect(assignment.storagePolicy?.id).to(equal("192"))
                            done()
                        }
                    }
                }
            }

            describe("deleteAssignment") {
                it("should make API call to delete storage policy assignment and produce storage policy assignment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/storage_policy_assignments/user_3093870887")
                            && isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.storagePolicies.deleteAssignment(storagePolicyAssignmentId: "user_3093870887") { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                print(error)
                                fail("Expected call to deleteAssignment to suceed, but it failed")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
