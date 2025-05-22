//
//  FileVersionLegalHold.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/3/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// A file version legal hold object represents all holds on a file version
public class FileVersionLegalHold: BoxModel {

    // MARK: - BoxModel
    private static var resourceType: String = "legal_hold"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties
    /// The ID of the file version legal hold object.
    public let id: String
    /// The file version that is held
    public let fileVersion: FileVersion?
    /// The parent file of the file version that is held.
    public let file: File?
    /// List of assignments contributing to this hold.
    public let legalHoldPolicyAssignments: [LegalHoldPolicyAssignment]?
    /// Time that this file version legal hold was deleted.
    public let deletedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == FileVersionLegalHold.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [FileVersionLegalHold.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        fileVersion = try BoxJSONDecoder.optionalDecode(json: json, forKey: "file_version")
        file = try BoxJSONDecoder.optionalDecode(json: json, forKey: "file")
        legalHoldPolicyAssignments = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "legal_hold_policy_assignments")
        deletedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deleted_at")
    }
}
