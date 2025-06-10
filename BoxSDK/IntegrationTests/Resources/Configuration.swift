//
//  Configuration.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Foundation

/// Defines all data needed to run the tests
class Configuration: BoxInnerModel {

    /// The CCG data that will be used to authenticate BoxClient
    class CCG: BoxInnerModel {
        ///  The client ID of the application requesting authentication.
        let clientId: String
        /// The client secret of the application requesting authentication.
        let clientSecret: String
        /// The user ID to use when getting the access token for CCG.
        let userId: String?
        /// The enterprise ID to use when getting the access token for CCG.
        let enterpriseId: String?
    }

    /// Additional data that will be used in tests, e.g. collaboratorId
    class Data: BoxInnerModel {
        /// The Identifier of a collaborator
        let collaboratorId: String
    }

    /// Shared instance (singleton) of Configuration class which will be used in tests.
    static let shared: Configuration = {
        do {
            return try Configuration()
        }
        catch {
            fatalError("Error during initialization Configuration: \(error)")
        }
    }()

    // MARK: - Properties

    /// The CCG data that will be used to authenticate BoxClient
    let ccg: CCG
    /// Additional data that will be used in tests, e.g. collaboratorId
    let data: Data

    /// Initializer.
    private init() throws {
        let content = FileUtil.getFileContent(fileName: "Configuration.json")
        let jsonObject = try JSONSerialization.jsonObject(with: content!)
        let json = jsonObject as! [String: Any]

        ccg = try BoxJSONDecoder.decode(json: json, forKey: "ccg")
        data = try BoxJSONDecoder.decode(json: json, forKey: "data")
    }
}
