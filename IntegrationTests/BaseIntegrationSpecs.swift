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
    let sdk = BoxSDK(clientId: Configuration.shared.ccg.clientId, clientSecret: Configuration.shared.ccg.clientSecret)
    var client: BoxClient!

    // MARK: BoxClient helper methods

    func initializeClient() {
        if let enterpriseId = Configuration.shared.ccg.enterpriseId, !enterpriseId.isEmpty {
            initializeCCGForAccountService(enterpriseId: enterpriseId)
        }
        else if let userId = Configuration.shared.ccg.userId, !userId.isEmpty {
            initializeCCGForUser(userId: userId)
        }
        else {
            fail("Can not create the CCG Client instance: either \"enterpriseId\" or \"userId\" is required")
        }
    }

    func initializeCCGForAccountService(enterpriseId: String) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { [weak self] done in
            self?.sdk.getCCGClientForAccountService(enterpriseId: enterpriseId) { result in
                switch result {
                case let .success(resultClient):
                    self?.client = resultClient
                case let .failure(error):
                    fail("Expected getCCGClientForAccountService call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    func initializeCCGForUser(userId: String) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { [weak self] done in
            self?.sdk.getCCGClientForUser(userId: userId) { result in
                switch result {
                case let .success(resultClient):
                    self?.client = resultClient
                case let .failure(error):
                    fail("Expected getCCGClientForUser call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

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

    // MARK: WebLink helper methods

    func deleteWebLink(_ webLink: WebLink?) {
        guard let webLink = webLink else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.webLinks.delete(webLinkId: webLink.id) { result in
                if case let .failure(error) = result {
                    fail("Expected delete call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }

    // MARK: Users helper methods

    func createUser(name: String, callback: @escaping (User) -> Void) {
        waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
            self.client.users.createAppUser(name: name) { result in
                switch result {
                case let .success(user):
                    callback(user)
                case let .failure(error):
                    fail("Expected create call to suceeded, but instead got \(error)")
                }

                done()
            }
        }
    }

    func deleteUser(_ user: User?) {
        guard let user = user else {
            return
        }

        waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
            self.client.users.delete(userId: user.id, force: true) { result in
                if case let .failure(error) = result {
                    fail("Expected delete call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }

    func randomizeName(name: String) -> String {
        return "\(name)_\(UUID().uuidString)"
    }
}
