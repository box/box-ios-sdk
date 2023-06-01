//
//  RetentionPoliciesModuleIntegrationSpecs.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Kamil Berdychowski on 09/09/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class RetentionPoliciesModuleIntegrationSpecs: QuickSpec {

    override class func spec() {
        var client: BoxClient!
        var rootFolder: Folder!

        beforeSuite {
            initializeClient { createdClient in client = createdClient }
            createFolder(client: client, name: NameGenerator.getUniqueFolderName(for: "RetentionPoliciesModule")) { createdFolder in rootFolder = createdFolder }
        }

        afterSuite {
            deleteFolder(client: client, folder: rootFolder, recursive: true)
        }

        describe("Retention Policy Assignment") {

            context("live cycle") {
                var retentionPolicy: RetentionPolicy?

                beforeEach {
                    createRetention(client: client, name: NameGenerator.getUniqueName(for: "Retention")) { createdRetention in retentionPolicy = createdRetention }
                }

                afterEach {
                    retireRetention(client: client, retention: retentionPolicy)
                }

                it("assign get list unassign retention policy in folder context") {
                    guard let retentionPolicy = retentionPolicy else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var retentionPolicyAssignment: RetentionPolicyAssignment?

                    // Assign
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.retentionPolicy.assign(
                            policyId: retentionPolicy.id,
                            assignedContentId: rootFolder.id,
                            assignContentType: .folder
                        ) { result in
                            switch result {
                            case let .success(assignment):
                                retentionPolicyAssignment = assignment
                                expect(retentionPolicyAssignment?.retentionPolicy?.id).to(equal(retentionPolicy.id))
                                expect(retentionPolicyAssignment?.assignedTo?.type).to(equal(.folder))
                                expect(retentionPolicyAssignment?.assignedTo?.id).to(equal(rootFolder.id))
                            case let .failure(error):
                                fail("Expected assign call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let retentionPolicyAssignment = retentionPolicyAssignment else { return }

                    // Get
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.retentionPolicy.getAssignment(assignmentId: retentionPolicyAssignment.id) { result in
                            switch result {
                            case let .success(assignment):
                                expect(assignment.retentionPolicy?.id).to(equal(retentionPolicy.id))
                                expect(assignment.assignedTo?.type).to(equal(.folder))
                                expect(assignment.assignedTo?.id).to(equal(rootFolder.id))
                            case let .failure(error):
                                fail("Expected get call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // List
                    let iterator = client.retentionPolicy.listAssignments(policyId: retentionPolicy.id, type: .folder, fields: ["assigned_to"])
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(1))
                                expect(page.entries[0].id).to(equal(retentionPolicyAssignment.id))
                                expect(page.entries[0].assignedTo?.type).to(equal(.folder))
                                expect(page.entries[0].assignedTo?.id).to(equal(rootFolder.id))
                            case let .failure(error):
                                fail("Expected listAssignments call to succeeded, but it instead got: \(error)")
                            }

                            done()
                        }
                    }

                    // Delete
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.retentionPolicy.deleteAssignment(assignmentId: retentionPolicyAssignment.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected delete call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("assign unassign retention policy in enterprise context") {
                    guard let retentionPolicy = retentionPolicy else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var retentionPolicyAssignment: RetentionPolicyAssignment?

                    // Assign
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.retentionPolicy.assign(
                            policyId: retentionPolicy.id,
                            assignedContentId: nil,
                            assignContentType: .enterprise
                        ) { result in
                            switch result {
                            case let .success(assignment):
                                retentionPolicyAssignment = assignment
                                expect(retentionPolicyAssignment?.retentionPolicy?.id).to(equal(retentionPolicy.id))
                                expect(retentionPolicyAssignment?.assignedTo?.type).to(equal(.enterprise))
                                expect(retentionPolicyAssignment?.assignedTo?.id).toNot(beNil())
                            case let .failure(error):
                                fail("Expected assign call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let retentionPolicyAssignment = retentionPolicyAssignment else { return }

                    // Delete
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        client.retentionPolicy.deleteAssignment(assignmentId: retentionPolicyAssignment.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected delete call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}
