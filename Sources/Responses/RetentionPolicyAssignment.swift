//
//  RetentionPolicyAssignment.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 31/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// The retention policy assignment provides a way for admins to apply a retention policy on a per-folder basis,
// or place a blanket policy over the entire enterprise.
public class RetentionPolicyAssignment: BoxModel {

    private static var resourceType: String = "retention_policy_assignment"

    public private(set) var rawData: [String: Any]
    /// Box item type
    public var type: String

    /// Identifier
    public let id: String
    /// A mini retention policy object representing the retention policy that has been assigned to this content.
    public let retentionPolicy: RetentionPolicy?
    /// Content that is under retention. The type can either be `folder` or `enterprise`.
    public let assignedTo: RetentionPolicyAssignmentItem?
    /// A mini user object representing the user that created the retention policy assignment object.
    public let assignedBy: User?
    /// When the retention policy assignment object was created.
    public let assignedAt: Date?
    // The array of metadata field filters, if present
    public let filterFields: [MetadataFieldFilter]?

    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == RetentionPolicyAssignment.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [RetentionPolicyAssignment.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        retentionPolicy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "retention_policy")
        assignedTo = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assigned_to")
        assignedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assigned_by")
        assignedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "assigned_at")
        filterFields = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "filter_fields")
    }
}
