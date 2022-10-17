//
//  BaseIntegrationSpecs+RetentionPolicies.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 14/10/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

extension BaseIntegrationSpecs {

    func createRetention(
        name: String,
        type: RetentionPolicyType = .finite,
        length: Int? = 1,
        dispositionAction: DispositionAction = .permanentlyDelete,
        callback: @escaping (RetentionPolicy) -> Void
    ) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.retentionPolicy.create(
                name: name,
                type: type,
                length: length,
                dispositionAction: dispositionAction
            ) { result in
                switch result {
                case let .success(retention):
                    callback(retention)
                case let .failure(error):
                    fail("Expected create retention call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    func assignRetention(
        _ retention: RetentionPolicy?,
        assignedContentId: String?,
        assignContentType: RetentionPolicyAssignmentItemType = .folder,
        callback: @escaping (RetentionPolicyAssignment) -> Void
    ) {
        guard let retention = retention, let assignedContentId = assignedContentId else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.retentionPolicy.assign(
                policyId: retention.id,
                assignedContentId: assignedContentId,
                assignContentType: assignContentType
            ) { result in
                switch result {
                case let .success(retentionAssignment):
                    callback(retentionAssignment)
                case let .failure(error):
                    fail("Expected assign retention policy call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }

    func retireRetention(_ retention: RetentionPolicy?) {
        guard let retention = retention else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.retentionPolicy.update(policyId: retention.id, status: .retired) { result in
                if case let .failure(error) = result {
                    fail("Expected update retention call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }
}
