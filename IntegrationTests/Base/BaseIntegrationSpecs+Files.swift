//
//  BaseIntegrationSpecs+Files.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 14/10/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

extension BaseIntegrationSpecs {

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
}
