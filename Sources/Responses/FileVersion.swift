//
//  FileVersion.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Specific version of a file.
public class FileVersion: BoxModel {
    // MARK: - BoxModel

    private static var resourceType: String = "file_version"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// The ID of the file version object
    public let id: String
    /// The SHA-1 hash of the file.
    public let sha1: String?
    /// The name of the file version
    public let name: String?
    /// Size of the file version in bytes
    public let size: Int64?
    /// When the file version object was created
    public let createdAt: Date?
    /// When the file version object was last updated
    public let modifiedAt: Date?
    /// The user who last updated the file version
    public let modifiedBy: User?
    /// When the file version object was trashed.
    public let trashedAt: Date?
    /// The user who trashed the file version.
    public let trashedBy: User?
    /// When the file version object was purged.
    public let purgedAt: Date?
    /// When the file version object was restored.
    public let restoredAt: Date?
    /// The user who restored the file version.
    public let restoredBy: User?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == FileVersion.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [FileVersion.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        sha1 = try BoxJSONDecoder.optionalDecode(json: json, forKey: "sha1")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        size = try BoxJSONDecoder.optionalDecode(json: json, forKey: "size")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        modifiedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "modified_by")
        trashedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "trashed_at")
        trashedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "trashed_by")
        purgedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "purged_at")
        restoredAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "restored_at")
        restoredBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "restored_by")
    }
}
