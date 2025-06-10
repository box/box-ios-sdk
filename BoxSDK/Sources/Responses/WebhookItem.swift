//
//  WebhookItem.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Files, folders, or web links associated with a webhook.
public enum WebhookItem: BoxModel {
    // MARK: - BoxModel

    public var rawData: [String: Any] {
        switch self {
        case let .folder(folder):
            return folder.rawData
        case let .file(file):
            return file.rawData
        }
    }

    /// Folder type
    case folder(Folder)
    /// File type
    case file(File)

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public init(json: [String: Any]) throws {

        guard let type = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }
        switch type {
        case "file":
            let file = try File(json: json)
            self = .file(file)
        case "folder":
            let folder = try Folder(json: json)
            self = .folder(folder)
        default:
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["file", "folder"]))
        }
    }
}

extension WebhookItem: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .folder(folder):
            return "folder \(String(describing: folder.name))"
        case let .file(file):
            return "file \(String(describing: file.name))"
        }
    }
}
