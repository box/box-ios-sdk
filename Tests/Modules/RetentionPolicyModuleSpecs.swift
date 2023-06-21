//
//  RetentionPolicyModuleSpecs.swift
//  BoxSDK
//
//  Created by Martina Stremenova on 01/09/2019.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class RetentionPolicyModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        beforeEach {
            sut = BoxSDK.getClient(token: "asdads")
        }

        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("Retention policy") {
            describe("get()") {
                it("should get retention policy object with provided id") {
                    let id: String = "103"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policies/\(id)") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetRetentionPolicy.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.get(policyId: id) { result in
                            switch result {
                            case let .success(retentionPolicy):
                                expect(retentionPolicy.id).to(equal(id))
                                expect(retentionPolicy.name).to(equal("somePolicy"))
                                expect(retentionPolicy.policyType).to(equal(.finite))
                                expect(retentionPolicy.retentionLength).to(equal(10))
                                expect(retentionPolicy.dispositionAction).to(equal(.permanentlyDelete))
                                expect(retentionPolicy.status).to(equal(.active))
                                expect(retentionPolicy.canOwnerExtendRetention).to(equal(true))
                                expect(retentionPolicy.areOwnersNotified).to(equal(true))
                                expect(retentionPolicy.customNotificationRecipients?.count).to(equal(2))
                                expect(retentionPolicy.customNotificationRecipients?.first?.id).to(equal("960"))
                                expect(retentionPolicy.createdBy?.id).to(equal("958"))
                                expect(retentionPolicy.retentionType).to(equal(.nonModifiable))
                            case let .failure(error):
                                fail("Expected call to getRetentionPolicy to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("create()") {
                it("should create retention policy object with provided parameters") {
                    let user = try! User(json: [
                        "type": "user",
                        "id": "12345",
                        "name": "Example User",
                        "login": "user@example.com"
                    ])
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policies") &&
                            isMethodPOST()
                            &&
                            hasJsonBody([
                                "policy_name": "Tax Documents",
                                "policy_type": "finite",
                                "retention_length": 365,
                                "disposition_action": "remove_retention",
                                "can_owner_extend_retention": false,
                                "are_owners_notified": true,
                                "custom_notification_recipients": [user.rawData],
                                "retention_type": "modifiable"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateRetentionPolicy.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.create(
                            name: "Tax Documents",
                            type: .finite,
                            length: 365,
                            dispositionAction: .removeRetention,
                            canOwnerExtendRetention: false,
                            areOwnersNotified: true,
                            customNotificationRecipients: [user],
                            retentionType: .modifiable
                        ) { result in
                            switch result {
                            case let .success(retentionPolicy):
                                expect(retentionPolicy.id).to(equal("123456789"))
                                expect(retentionPolicy.name).to(equal("Tax Documents"))
                                expect(retentionPolicy.policyType).to(equal(.finite))
                                expect(retentionPolicy.retentionLength).to(equal(365))
                                expect(retentionPolicy.dispositionAction).to(equal(.removeRetention))
                                expect(retentionPolicy.status).to(equal(.active))
                                expect(retentionPolicy.canOwnerExtendRetention).to(equal(false))
                                expect(retentionPolicy.areOwnersNotified).to(equal(true))
                                expect(retentionPolicy.customNotificationRecipients?.count).to(equal(1))
                                expect(retentionPolicy.customNotificationRecipients?.first?.id).to(equal("22222"))
                                expect(retentionPolicy.createdBy?.id).to(equal("33333"))
                                expect(retentionPolicy.retentionType).to(equal(.modifiable))
                            case let .failure(error):
                                fail("Expected call to create to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update()") {
                it("should update existing retention policy object") {
                    let id = "123456789"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policies/\(id)") &&
                            isMethodPUT() &&
                            hasJsonBody([
                                "policy_name": "Tax Documents",
                                "disposition_action": "remove_retention",
                                "status": "active"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateRetentionPolicy.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.update(
                            policyId: id,
                            name: "Tax Documents",
                            dispositionAction: .removeRetention,
                            status: .active
                        ) { result in
                            switch result {
                            case let .success(retentionPolicy):
                                expect(retentionPolicy.id).to(equal(id))
                                expect(retentionPolicy.name).to(equal("Tax Documents"))
                                expect(retentionPolicy.policyType).to(equal(.finite))
                                expect(retentionPolicy.retentionLength).to(equal(365))
                                expect(retentionPolicy.dispositionAction).to(equal(.removeRetention))
                                expect(retentionPolicy.status).to(equal(.active))
                                expect(retentionPolicy.createdBy?.id).to(equal("22222"))
                                expect(retentionPolicy.retentionType).to(equal(.modifiable))
                            case let .failure(error):
                                fail("Expected call to updateto succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should update retention type to non_modifiable") {
                    let id = "123456789"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policies/\(id)") &&
                            isMethodPUT() &&
                            hasJsonBody([
                                "retention_type": "non_modifiable"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateRetentionPolicy.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.update(
                            policyId: id,
                            setRetentionTypeToNonModifiable: true
                        ) { result in
                            switch result {
                            case let .success(retentionPolicy):
                                expect(retentionPolicy.id).to(equal(id))
                            case let .failure(error):
                                fail("Expected call to updateto succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("list()") {
                it("should get all of the retention policies for given enterprise") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policies") &&
                            containsQueryParams(["policy_name": "name", "policy_type": "finite", "created_by_user_id": "1234"]) &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetRetentionPolicies.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.retentionPolicy.list(
                            name: "name",
                            type: .finite,
                            createdByUserId: "1234"
                        )
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let retentionPolicy = page.entries[0]
                                expect(retentionPolicy.name).to(equal("Tax Documents"))
                                expect(retentionPolicy.id).to(equal("123456789"))
                            case let .failure(error):
                                fail("Expected call to list to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }

        describe("Retention policy assignment") {
            describe("getAssignment()") {
                it("should get retention policy assignment") {
                    let id = "11446498"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policy_assignments/\(id)") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetRetentionPolicyAssignment.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.getAssignment(assignmentId: id) { result in
                            switch result {
                            case let .success(retentionPolicyAssignment):
                                expect(retentionPolicyAssignment.id).to(equal(id))
                                expect(retentionPolicyAssignment.retentionPolicy?.id).to(equal("11446498"))
                                expect(retentionPolicyAssignment.retentionPolicy?.name).to(equal("Some Policy Name"))
                                expect(retentionPolicyAssignment.assignedTo?.id).to(equal("11446498"))
                                expect(retentionPolicyAssignment.assignedBy?.id).to(equal("11111"))
                                expect(retentionPolicyAssignment.assignedBy?.name).to(equal("Test User"))
                                expect(retentionPolicyAssignment.assignedBy?.login).to(equal("testuser@example.com"))
                            case let .failure(error):
                                fail("Expected call to getAssignment to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("assign()") {
                it("should create new retention policy assignment for folder") {
                    let id = "11446498"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policy_assignments") &&
                            isMethodPOST() &&
                            hasJsonBody([
                                "policy_id": id,
                                "assign_to": [
                                    "id": id,
                                    "type": "folder"
                                ],
                                "filter_fields": [
                                    [
                                        "field": "test",
                                        "value": "test"
                                    ]
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateRetentionPolicyAssignment.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.assign(
                            policyId: id,
                            assignedContentId: id,
                            assignContentType: RetentionPolicyAssignmentItemType.folder,
                            filterFields: [MetadataFieldFilter(field: "test", value: "test")]
                        ) { result in
                            switch result {
                            case let .success(retentionPolicyAssignment):
                                expect(retentionPolicyAssignment.id).to(equal(id))
                                expect(retentionPolicyAssignment.retentionPolicy?.id).to(equal("11446498"))
                                expect(retentionPolicyAssignment.retentionPolicy?.name).to(equal("Some Policy Name"))
                                expect(retentionPolicyAssignment.assignedTo?.id).to(equal("11446498"))
                                expect(retentionPolicyAssignment.assignedBy?.id).to(equal("11111"))
                                expect(retentionPolicyAssignment.assignedBy?.name).to(equal("Test User"))
                                expect(retentionPolicyAssignment.assignedBy?.login).to(equal("testuser@example.com"))
                            case let .failure(error):
                                fail("Expected call to assign to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should create new retention policy assignment for enterprise") {
                    let id = "11446498"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policy_assignments") &&
                            isMethodPOST() &&
                            hasJsonBody([
                                "policy_id": id,
                                "assign_to": [
                                    "id": nil,
                                    "type": "enterprise"
                                ],
                                "filter_fields": [
                                    [
                                        "field": "test",
                                        "value": "test"
                                    ]
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateRetentionPolicyAssignment.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.assign(
                            policyId: id,
                            assignedContentId: nil,
                            assignContentType: RetentionPolicyAssignmentItemType.enterprise,
                            filterFields: [MetadataFieldFilter(field: "test", value: "test")]
                        ) { result in
                            switch result {
                            case let .success(retentionPolicyAssignment):
                                expect(retentionPolicyAssignment.id).to(equal(id))
                                expect(retentionPolicyAssignment.retentionPolicy?.id).to(equal("11446498"))
                                expect(retentionPolicyAssignment.retentionPolicy?.name).to(equal("Some Policy Name"))
                                expect(retentionPolicyAssignment.assignedBy?.id).to(equal("11111"))
                                expect(retentionPolicyAssignment.assignedBy?.name).to(equal("Test User"))
                                expect(retentionPolicyAssignment.assignedBy?.login).to(equal("testuser@example.com"))
                            case let .failure(error):
                                fail("Expected call to assign to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("deleteAssignment()") {
                it("should delete retention policy assignment") {
                    let id = "11446498"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policy_assignments/\(id)") &&
                            isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.retentionPolicy.deleteAssignment(assignmentId: id) { response in
                            switch response {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteAssignment to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listAssignments()") {
                it("should get a list of all retention policy assignments associated with a specified retention policy") {
                    let id = "123456"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policies/\(id)/assignments") &&
                            isMethodGET() &&
                            containsQueryParams(["fields": "retention_policy,assigned_to", "type": "folder"])

                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetRetentionPolicyAssignments.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.retentionPolicy.listAssignments(
                            policyId: id,
                            type: .folder,
                            fields: ["retention_policy", "assigned_to"]
                        )
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let retentionPolicy = page.entries[0]
                                expect(retentionPolicy.id).to(equal("12345678"))
                            case let .failure(error):
                                fail("Expected call to listAssignments to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }

        describe("Retention policy on file version") {

            describe("getFileVersionRetention()") {
                it("should get information about a file version retention policy.") {
                    let id = "1234"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/file_version_retentions/\(id)") &&
                            isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFileVersionRetention.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        sut.files.getVersionRetention(
                            retentionId: id
                        ) { result in
                            switch result {
                            case let .success(fileVersionRetention):
                                expect(fileVersionRetention.id).to(equal("112729"))
                                expect(fileVersionRetention.winningRetentionPolicy?.id).to(equal("41173"))
                                expect(fileVersionRetention.winningRetentionPolicy?.name).to(equal("Tax Documents"))
                                expect(fileVersionRetention.fileVersion?.id).to(equal("124887629"))
                                expect(fileVersionRetention.fileVersion?.sha1).to(equal("4262d6250b0e6f440dca43a2337bd4621bad9136"))
                                expect(fileVersionRetention.file?.id).to(equal("5011706273"))
                                expect(fileVersionRetention.file?.etag).to(equal("2"))
                            case let .failure(error):
                                fail("Expected call to getFileVersionRetention to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listVersionRetentions()") {
                it("should get all file version retentions for the given enterprise") {
                    let dispositionBefore = Date()
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/file_version_retentions") &&
                            isMethodGET() &&
                            containsQueryParams([
                                "file_id": "1234",
                                "file_version_id": "1234",
                                "policy_id": "1234",
                                "disposition_action": "permanently_delete",
                                "disposition_before": dispositionBefore.iso8601
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFileVersionRetentions.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.files.listVersionRetentions(
                            fileId: "1234",
                            fileVersionId: "1234",
                            policyId: "1234",
                            dispositionAction: .permanentlyDelete, dispositionBefore: dispositionBefore
                        )
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let retentionPolicy = page.entries[0]
                                expect(retentionPolicy.id).to(equal("112725"))
                            case let .failure(error):
                                fail("Expected call to getFileVersionRetentions to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listFilesUnderRetentionForAssignment()") {
                it("should get all file version retentions for the given enterprise") {
                    let retentionPolicyAssignmentId = "1234"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policy_assignments/\(retentionPolicyAssignmentId)/files_under_retention") &&
                            isMethodGET() &&
                            containsQueryParams([
                                "limit": "100"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFilesUnderRetentionForAssignment.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.retentionPolicy.listFilesUnderRetentionForAssignment(
                            retentionPolicyAssignmentId: retentionPolicyAssignmentId,
                            limit: 100
                        )
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let fileUnderRetention = page.entries[0]
                                expect(fileUnderRetention.id).to(equal("12345"))
                                expect(fileUnderRetention.name).to(equal("Contract.pdf"))
                                expect(fileUnderRetention.fileVersion?.id).to(equal("123456"))
                            case let .failure(error):
                                fail("Expected call to listFilesUnderRetentionForAssignment to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listFileVersionsUnderRetentionForAssignment()") {
                it("should get all file version retentions for the given enterprise") {
                    let retentionPolicyAssignmentId = "1234"
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/retention_policy_assignments/\(retentionPolicyAssignmentId)/file_versions_under_retention") &&
                            isMethodGET() &&
                            containsQueryParams([
                                "limit": "100"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetFileVersionsUnderRetentionForAssignment.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }
                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.retentionPolicy.listFileVersionsUnderRetentionForAssignment(
                            retentionPolicyAssignmentId: retentionPolicyAssignmentId,
                            limit: 100
                        )
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let fileUnderRetention = page.entries[0]
                                expect(fileUnderRetention.id).to(equal("123456"))
                                expect(fileUnderRetention.name).to(equal("Contract.pdf"))
                                expect(fileUnderRetention.fileVersion?.id).to(equal("1234567"))
                            case let .failure(error):
                                fail("Expected call to listFilesUnderRetentionForAssignment to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
