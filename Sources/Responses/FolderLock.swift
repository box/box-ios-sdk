//
//  FolderLock.swift
//  BoxSDK-iOS
//
//  Created by Skye Free on 3/2/21.
//  Copyright © 2021 box. All rights reserved.
//

import Foundation

/// Folder Lock
public class FolderLock: BoxModel {

    /// Locked operations on the folder
    public struct LockedOperations: BoxInnerModel {
        /// Whether deleting the folder is restricted.
        public let delete: Bool?
        /// Whether moving the folder is restricted.
        public let move: Bool?
    }

    // MARK: - BoxModel

    private static var resourceType: String = "folder_lock"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// The user or group that created the lock.
    public let createdBy: User?
    /// When the folder lock object was created.
    public let createdAt: Date?
    /// The (mini) folder object that the lock applies to.
    public let folder: Folder?
    /// The lock type, value is always "freeze".
    public let lockType: String?
    /// The operations that have been locked.
    public let lockedOperations: LockedOperations?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == FolderLock.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [FolderLock.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        folder = try BoxJSONDecoder.optionalDecode(json: json, forKey: "folder")
        lockType = try BoxJSONDecoder.optionalDecode(json: json, forKey: "lock_type")
        lockedOperations = try BoxJSONDecoder.optionalDecode(json: json, forKey: "locked_operations")
    }
}
