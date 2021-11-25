//
//  EventItemType.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 29/07/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// A metadata object associated with a file or a folder.
public class EventItem: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    /// Type of the object modified by the event
    public enum EventItemType {
        /// Folder type
        case folder(Folder)
        /// File type
        case file(File)
        /// Comment type
        case comment(Comment)
        /// User type
        case user(User)
        /// This case is used as a work around to bugs in the enterprise events API where some enterprise event sources
        /// don't correctly map to a specific types. In this case, you should use `rawData` to access the raw JSON
        /// directly.
        case unknown
    }

    /// Event item type
    public var itemValue: EventItemType

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        var updatedJson: [String: Any] = json

        if let entry = updatedJson.removeValue(forKey: "item_id") {
            updatedJson["id"] = entry
        }

        if let entry = updatedJson.removeValue(forKey: "item_type") {
            updatedJson["type"] = entry
        }

        if let entry = updatedJson.removeValue(forKey: "item_name") {
            updatedJson["name"] = entry
        }

        if let type = updatedJson["type"] as? String {
            switch type {
            case "file":
                let file = try File(json: updatedJson)
                itemValue = .file(file)
            case "folder":
                let folder = try Folder(json: updatedJson)
                itemValue = .folder(folder)
            case "comment":
                let comment = try Comment(json: updatedJson)
                itemValue = .comment(comment)
            case "user":
                let user = try User(json: updatedJson)
                itemValue = .user(user)
            default:
                // In the case where the event source JSON cannot be mapped to specific type, you can use the
                // `rawData` property to access the raw JSON representation of the event source.
                itemValue = .unknown
            }
        }
        else {
            // In the case where the event source JSON cannot be mapped to specific type, you can use the
            // `rawData` property to access the raw JSON representation of the event source.
            itemValue = .unknown
        }
    }
}
