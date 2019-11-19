//
//  LegalHoldPolicy.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 9/3/19.
//  Copyright © 2019 box. All rights reserved.
//
import Foundation

/// Legal hold policy
public class LegalHoldPolicy: BoxModel {

    /// Counts of the assignments to different entities of this policy
    public struct AssignmentCounts: BoxInnerModel {
        public let user: Int
        public let folder: Int
        public let file: Int
        public let fileVersion: Int
    }

    /// Status of legal hold policy
    public enum Status: BoxEnum {
        /// The policy is not in a transition state
        case active
        /// That the policy is in the process of being applied
        case applying
        /// That the process is in the process of being released
        case releasing
        /// The policy is no longer active
        case released
        /// Custom value for enum values not yet implemented in the SDK
        case customValue(String)

        public init(_ value: String) {
            switch value {
            case "active":
                self = .active
            case "applying":
                self = .applying
            case "releasing":
                self = .releasing
            case "released":
                self = .released
            default:
                self = .customValue(value)
            }
        }

        public var description: String {
            switch self {
            case .active:
                return "active"
            case .applying:
                return "applying"
            case .releasing:
                return "releasing"
            case .released:
                return "released"
            case let .customValue(value):
                return value
            }
        }
    }

    // MARK: - BoxModel
    private static var resourceType: String = "legal_hold_policy"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties
    /// Identifier
    public let id: String
    /// Name of the legal hold policy.
    public let policyName: String?
    /// Description of the legal hold policy.
    public let description: String?
    /// Status of the legal hold policy.
    public let status: Status?
    /// Counts of assignments within this policy by apply-to type.
    public let assignmentCounts: AssignmentCounts?
    /// The user who created the legal hold policy object.
    public let createdBy: User?
    /// When the legal hold policy object was created.
    public let createdAt: Date?
    /// When the legal hold policy object was modified.
    public let modifiedAt: Date?
    /// When the policy release request was sent.
    public let deletedAt: Date?
    /// User-specified, optional date filter applies to Custodian assignments only.
    public let filterStartedAt: Date?
    /// User-specified, optional date filter applies to Custodian assignments only.
    public let filterEndedAt: Date?
    /// Notes about why the policy was released.
    public let releaseNotes: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == LegalHoldPolicy.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [LegalHoldPolicy.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        policyName = try BoxJSONDecoder.optionalDecode(json: json, forKey: "policy_name")
        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        assignmentCounts = try BoxJSONDecoder.optionalDecode(json: json, forKey: "assignment_counts")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        deletedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deleted_at")
        filterStartedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "filter_started_at")
        filterEndedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "filter_ended_at")
        releaseNotes = try BoxJSONDecoder.optionalDecode(json: json, forKey: "release_notes")
    }
}
