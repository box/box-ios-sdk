//
//  Lock.swift
//  BoxSDK
//
//  Created by Abel Osorio on 5/22/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Locks a file to prevent it from being modified
public class Lock: BoxModel {
    // MARK: - BoxModel

    private static var resourceType: String = "lock"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// Who created the lock.
    public let createdBy: User?
    /// When was lock created.
    public let createdAt: Date?
    /// When lock expires.
    public let expiresAt: Date?
    /// Whether or not the file can be downloaded while locked.
    public let isDownloadPrevented: Bool?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Lock.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Lock.resourceType]))
        }

        rawData = json
        type = itemType
        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        expiresAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "expires_at")
        isDownloadPrevented = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_download_prevented")
    }
}
