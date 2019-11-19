//
//  SharedItem.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 6/10/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Item shared by shared link.
public class SharedItem: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    public enum SharedItemType {
        case file(File)
        case folder(Folder)
        case webLink(WebLink)
    }

    public var itemValue: SharedItemType

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        guard let type = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }
        switch type {
        case "file":
            let file = try File(json: json)
            itemValue = .file(file)
        case "folder":
            let folder = try Folder(json: json)
            itemValue = .folder(folder)
        case "web_link":
            let webLink = try WebLink(json: json)
            itemValue = .webLink(webLink)
        default:
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["file", "folder", "web_link"]))
        }
    }
}
