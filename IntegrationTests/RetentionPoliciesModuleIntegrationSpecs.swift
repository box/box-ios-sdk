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
    var folder: Folder!
    var retentionPolicy: RetentionPolicy!

    override func spec() {
        beforeSuite {
            self.initializeClient()
            self.createRetention(name: self.randomizeName(name: "iOS One Day")) { [weak self] retention in self?.retentionPolicy = retention }
            self.createFolder(name: NameGenerator.getUniqueFolderName(for: "RetentionPoliciesModule")) { [weak self] createdFolder in self?.folder = createdFolder }
        }

        afterSuite {
            self.retireRetention(self.retentionPolicy)
            self.deleteFolder(self.folder, recursive: true)
        }

        describe("Retention Policy Assignment") {

            context("live cycle") {

                it("assign then get and unassign retention policy") {
                    var retentionPolicyAssignment: RetentionPolicyAssignment?

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.retentionPolicy.assign(
                            policyId: self.retentionPolicy.id,
                            assignedContentId: self.folder.id,
                            assignContentType: RetentionPolicyAssignmentItemType.folder
                        ) { result in
                            switch result {
                            case let .success(assignment):
                                retentionPolicyAssignment = assignment
                                expect(retentionPolicyAssignment?.retentionPolicy?.id).to(equal(self.retentionPolicy.id))
                                expect(retentionPolicyAssignment?.assignedTo?.type).to(equal(RetentionPolicyAssignmentItemType.folder))
                                expect(retentionPolicyAssignment?.assignedTo?.id).to(equal(self.folder.id))
                            case let .failure(error):
                                fail("Expected upload call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let retentionPolicyAssignment = retentionPolicyAssignment else { return }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.retentionPolicy.getAssignment(assignmentId: retentionPolicyAssignment.id) { result in
                            switch result {
                            case let .success(assignment):
                                expect(assignment.retentionPolicy?.id).to(equal(self.retentionPolicy.id))
                                expect(assignment.assignedTo?.type).to(equal(RetentionPolicyAssignmentItemType.folder))
                                expect(assignment.assignedTo?.id).to(equal(self.folder.id))
                            case let .failure(error):
                                fail("Expected upload call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

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
