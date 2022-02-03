//
//  BaseIntegrationSpecs.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class BaseIntegrationSpecs: QuickSpec {
    let client = BoxSDK.getClient(token: Configuration.shared.accessToken)

    // MARK: Folder helper methods

    func createFolder(name: String, parentId: String = "0", callback: @escaping (Folder) -> Void) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.folders.create(name: name, parentId: parentId) { result in
                switch result {
                case let .success(folder):
                    callback(folder)
                case let .failure(error):
                    fail("Expected create call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    func deleteFolder(_ folder: Folder?, recursive: Bool = false) {
        guard let folder = folder else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.folders.delete(folderId: folder.id, recursive: recursive) { result in
                if case let .failure(error) = result {
                    fail("Expected delete call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }

    // MARK: File helper methods

    func uploadFile(fileName: String, stringContent: String, toFolder folderId: String, callback: @escaping (File) -> Void) {
        uploadFile(fileName: fileName, dataContent: stringContent.data(using: .utf8)!, toFolder: folderId, callback: callback)
    }

    func uploadFile(fileName: String, toFolder folderId: String?, callback: @escaping (File) -> Void) {
        guard let folderId = folderId else {
            fail("folderId should not be nil")
            return
        }

        guard let dataContent = FileUtil.getFileContent(fileName: fileName) else {
            fail("Can not get content of file \(fileName)")
            return
        }

        uploadFile(fileName: fileName, dataContent: dataContent, toFolder: folderId, callback: callback)
    }

    func uploadFile(fileName: String, dataContent: Data, toFolder folderId: String, callback: @escaping (File) -> Void) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.files.upload(
                data: dataContent,
                name: fileName,
                parentId: folderId
            ) { result in
                switch result {
                case let .success(file):
                    callback(file)
                case let .failure(error):
                    fail("Expected upload call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    func deleteFile(_ file: File?) {
        guard let file = file else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.files.delete(fileId: file.id) { result in
                if case let .failure(error) = result {
                    fail("Expected delete call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }

    // MARK: Retention Policy helper methods

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
