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

class RetentionPoliciesModuleIntegrationSpecs: BaseIntegrationSpecs {
    var rootFolder: Folder!

    override func spec() {
        beforeSuite {
            self.initializeClient()
            self.createFolder(name: NameGenerator.getUniqueFolderName(for: "RetentionPoliciesModule")) { [weak self] createdFolder in self?.rootFolder = createdFolder }
        }

        afterSuite {
            self.deleteFolder(self.rootFolder, recursive: true)
        }

        describe("Retention Policy Assignment") {

            context("live cycle") {
                var retentionPolicy: RetentionPolicy?

                beforeEach {
                    self.createRetention(name: NameGenerator.getUniqueName(for: "Retention")) { createdRetention in retentionPolicy = createdRetention }
                }

                afterEach {
                    self.retireRetention(retentionPolicy)
                }

                it("assign then get and unassign retention policy") {
                    guard let retentionPolicy = retentionPolicy else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var retentionPolicyAssignment: RetentionPolicyAssignment?

                    // Assign
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.retentionPolicy.assign(
                            policyId: retentionPolicy.id,
                            assignedContentId: self.rootFolder.id,
                            assignContentType: RetentionPolicyAssignmentItemType.folder
                        ) { result in
                            switch result {
                            case let .success(assignment):
                                retentionPolicyAssignment = assignment
                                expect(retentionPolicyAssignment?.retentionPolicy?.id).to(equal(retentionPolicy.id))
                                expect(retentionPolicyAssignment?.assignedTo?.type).to(equal(RetentionPolicyAssignmentItemType.folder))
                                expect(retentionPolicyAssignment?.assignedTo?.id).to(equal(self.rootFolder.id))
                            case let .failure(error):
                                fail("Expected assign call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let retentionPolicyAssignment = retentionPolicyAssignment else { return }

                    // Get
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.retentionPolicy.getAssignment(assignmentId: retentionPolicyAssignment.id) { result in
                            switch result {
                            case let .success(assignment):
                                expect(assignment.retentionPolicy?.id).to(equal(retentionPolicy.id))
                                expect(assignment.assignedTo?.type).to(equal(RetentionPolicyAssignmentItemType.folder))
                                expect(assignment.assignedTo?.id).to(equal(self.rootFolder.id))
                            case let .failure(error):
                                fail("Expected get call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Delete
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.retentionPolicy.deleteAssignment(assignmentId: retentionPolicyAssignment.id) { result in
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
