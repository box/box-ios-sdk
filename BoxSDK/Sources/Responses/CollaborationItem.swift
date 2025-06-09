//
//  CollaborationItem.swift
//  BoxSDK
//
//  Created by Abel Osorio on 6/7/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// The file or folder that access is granted to by collaboration.
public enum CollaborationItem: BoxModel {
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
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["folder", "file"]))
        }
    }
}

extension CollaborationItem: CustomDebugStringConvertible {
    /// Debug description of an object
    public var debugDescription: String {
        switch self {
        case let .folder(folder):
            return "folder \(String(describing: folder.name))"
        case let .file(file):
            return "file \(String(describing: file.name))"
        }
    }
}
