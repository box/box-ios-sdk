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
    var client: BoxClient!

    override func spec() {
        beforeSuite {
            self.client = BoxSDK.getClient(token: Configuration.developerToken)
        }
    }

    // MARK: Section with helper methods used in tests

    func createFolder(name: String, parentId: String = "0", callback: @escaping (Folder) -> Void) {
        waitUntil(timeout: .seconds(Constants.defaultTimeout)) { done in
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

        waitUntil(timeout: .seconds(10)) { done in
            self.client.folders.delete(folderId: folder.id, recursive: recursive) { result in
                if case let .failure(error) = result {
                    fail("Expected delete call to succeed, but instead got \(error)")
                }

                done()
            }
        }
    }
}
