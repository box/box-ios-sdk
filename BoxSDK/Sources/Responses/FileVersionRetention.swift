//
//  FileVersionRetention.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 01/09/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// File objects in Box, with attributes like who created the file, when it was last modified, and other information.
public class FileVersionRetention: BoxModel {

    // MARK: - Properties

    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "file_version_retention"
    /// Box item type
    public var type: String

    /// Identifier
    public let id: String
    /// The file version this file version retention was applied to.
    public let fileVersion: FileVersion?
    /// The file this file version retention was applied to.
    public let file: File?
    /// When this file version retention object was created.
    public let appliedAt: Date?
    /// When the retention period expires on this file version retention.
    public let dispositionAt: Date?
    /// The winning retention policy applied to this file version retention. A file version can have multiple retention policies applied.
    public let winningRetentionPolicy: RetentionPolicy?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == FileVersionRetention.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [FileVersionRetention.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        fileVersion = try BoxJSONDecoder.optionalDecode(json: json, forKey: "file_version")
        file = try BoxJSONDecoder.optionalDecode(json: json, forKey: "file")
        appliedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "applied_at")
        dispositionAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "disposition_at")
        winningRetentionPolicy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "winning_retention_policy")
    }
}
