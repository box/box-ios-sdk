//
//  Configuration.swift
//  BoxSDKIntegrationTests-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Foundation

class Configuration {
    static let shared: Configuration = {
        do {
            return try Configuration()
        }
        catch {
            fatalError("Error during initialization Configuration: \(error)")
        }
    }()

    let accessToken: String
    let collaboratorId: String

    private init() throws {
        let content = FileUtil.getFileContent(fileName: "Configuration.json")
        let jsonObject = try JSONSerialization.jsonObject(with: content!)
        let json = jsonObject as! [String: Any]

        accessToken = try BoxJSONDecoder.decode(json: json, forKey: "accessToken")
        collaboratorId = try BoxJSONDecoder.decode(json: json, forKey: "collaboratorId")
    }
}
