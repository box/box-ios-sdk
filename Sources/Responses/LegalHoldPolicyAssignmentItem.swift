//
//  LegalHoldPolicyAssignmentItem.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/3/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Item a legal hold policy was assigned to
public class LegalHoldPolicyAssignmentItem: BoxModel {
    // MARK: - BoxModel
    public private(set) var rawData: [String: Any]

    public enum AssignmentItemType {
        case file(File)
        case fileVersion(FileVersion)
        case folder(Folder)
        case user(User)
    }

    public var itemValue: AssignmentItemType

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
        case "file_version":
            let fileVersion = try FileVersion(json: json)
            itemValue = .fileVersion(fileVersion)
        case "folder":
            let folder = try Folder(json: json)
            itemValue = .folder(folder)
        case "user":
            let user = try User(json: json)
            itemValue = .user(user)
        default:
            throw BoxCodingError(message: .valueMismatch(key: "type", value: type, acceptedValues: ["file", "file_version", "folder", "user"]))
        }
    }
}
