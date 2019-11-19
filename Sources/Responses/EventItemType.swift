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
        /// Unknown type
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
        case "comment":
            let comment = try Comment(json: json)
            itemValue = .comment(comment)
        default:
            // Clients to use rawData directly
            itemValue = .unknown
        }
    }
}
