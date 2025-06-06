//
//  BaseAsyncIntegrationTests.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 24/05/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import XCTest

@available(iOS 13.0, *)
class BaseAsyncIntegrationTests: XCTestCase {
    let sdk = BoxSDK(
        clientId: Configuration.shared.ccg.clientId,
        clientSecret: Configuration.shared.ccg.clientSecret
    )
    var client: BoxClient!
    var rootFolder: Folder!

    override func setUp() async throws {
        try await initializeClient()
        try await initalizeRootFolder()
    }

    override func tearDown() async throws {
        try await cleanupRootFolder()
    }

    // MARK: Initialize Methods

    func initializeClient() async throws {
        if let enterpriseId = Configuration.shared.ccg.enterpriseId, !enterpriseId.isEmpty {
            client = try await sdk.getCCGClientForAccountService(enterpriseId: enterpriseId)
        }
        else if let userId = Configuration.shared.ccg.userId, !userId.isEmpty {
            client = try await sdk.getCCGClientForUser(userId: userId)
        }
        else {
            throw BoxSDKError(message: "Could not initialze BoxClient")
        }
    }

    func initalizeRootFolder() async throws {
        rootFolder = try await client.folders.create(name: getRootFolderName(), parentId: "0")
    }

    // MARK: Cleanup Methods

    func cleanupRootFolder() async throws {
        try await client.folders.delete(folderId: rootFolder.id, recursive: true)
    }

    func getRootFolderName() -> String {
        NameGenerator.getUniqueFolderName()
    }
}
