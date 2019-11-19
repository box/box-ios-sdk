//
//  RetentionPolicyAssignmentItem.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 31/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Item type with task assignment.
public enum RetentionPolicyAssignmentItemType: BoxEnum {
    /// Folder type of content with retention policy assignment.
    case folder
    /// Enterprise type of content with retention policy assignment.
    case enterprise
    /// Metadata template type of content with retention policy assignment.
    case metadataTemplate
    /// Custom value not yet implemented in this version of SDK.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "folder":
            self = .folder
        case "enterprise":
            self = .enterprise
        case "metadata_template":
            self = .metadataTemplate
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .folder:
            return "folder"
        case .enterprise:
            return "enterprise"
        case .metadataTemplate:
            return "metadata_template"
        case let .customValue(value):
            return value
        }
    }
}

/// The type and id of the content that is under retention.
public class RetentionPolicyAssignmentItem: BoxModel {

    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    /// ID of the content that is under retention.
    /// In case of enterprise type can be null.
    public let id: String?
    /// Type of the content that is under retention.
    public let type: RetentionPolicyAssignmentItemType?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        id = try BoxJSONDecoder.optionalDecode(json: json, forKey: "id")
        type = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "type")
    }
}
