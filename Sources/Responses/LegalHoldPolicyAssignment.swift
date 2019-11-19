//
//  LegalHoldPolicyAssignment.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/3/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Legal hold policy assignment
public class LegalHoldPolicyAssignment: BoxModel {

    // MARK: - BoxModel
    private static var resourceType: String = "legal_hold_policy_assignment"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties
    /// Identifier
    public let id: String
    /// The policy that the legal hold policy assignment is part of.
    public let legalHoldPolicy: LegalHoldPolicy?
    /// The entity that the legal hold policy assignment is assigned to.
    public let assignedTo: LegalHoldPolicyAssignmentItem?
    /// The user who created the legal hold policy assignment.
    public let assignedBy: User?
    /// When the legal hold policy assignment object was created.
    public let assignedAt: Date?
    /// When the assignment release request was sent.
    public let deletedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == LegalHoldPolicyAssignment.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [LegalHoldPolicyAssignment.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        legalHoldPolicy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "legal_hold_policy")
        assignedTo = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assigned_to")
        assignedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assigned_by")
        assignedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "assigned_at")
        deletedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deleted_at")
    }
}
