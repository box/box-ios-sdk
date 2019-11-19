//
//  RetentionPolicy.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremeňová on 8/29/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// The type of the retention policy.
public enum RetentionPolicyType: BoxEnum {
    /// A specific amount of time to retain the content is known upfront.
    case finite
    /// The amount of time to retain the content is still unknown.
    case indefinite
    /// Custom value not yet implemented in this SDK version.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "finite":
            self = .finite
        case "indefinite":
            self = .indefinite
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .finite:
            return "finite"
        case .indefinite:
            return "indefinite"
        case let .customValue(value):
            return value
        }
    }
}

/// The disposition action of the retention policy specifying what will happen once the retention policy time period has passed.
public enum DispositionAction: BoxEnum {
    /// Content retained by the policy to be permanently deleted once the retention policy time period has passed.
    case permanentlyDelete
    /// Will lift the retention policy from the content, allowing it to be deleted by users, once the retention policy time period has passed.
    case removeRetention
    /// Custom value not yet implemented in the SDK.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "permanently_delete":
            self = .permanentlyDelete
        case "remove_retention":
            self = .removeRetention
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .permanentlyDelete:
            return "permanently_delete"
        case .removeRetention:
            return "remove_retention"
        case let .customValue(value):
            return value
        }
    }
}

/// The status of the retention policy.
public enum RetentionPolicyStatus: BoxEnum {
    /// Retention policy is active.
    case active
    /// Retention policy is retired. Can be only retired by administrator
    /// and once a policy has been retired, it cannot become active again.
    case retired
    /// Custom value that was not yet implemented in current SDK version.
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "active":
            self = .active
        case "retired":
            self = .retired
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .active:
            return "active"
        case .retired:
            return "retired"
        case let .customValue(value):
            return value
        }
    }
}

/// A retention policy blocks permanent deletion of content for a specified amount of time.
public class RetentionPolicy: BoxModel {

    private static var resourceType: String = "retention_policy"

    public private(set) var rawData: [String: Any]
    /// Box item type
    public var type: String

    /// Identifier
    public let id: String
    /// The name of the retention policy.
    public let name: String?
    /// The type of the retention policy based on whether the amount of time to retain content is known or unknown.
    public let policyType: RetentionPolicyType?
    /// The length of the retention policy. This length specifies the duration in days that the retention policy will be active
    /// for after being assigned to content.
    public let retentionLength: Int?
    /// The disposition action of the retention policy specifying what will happen once the retention policy time period has passed.
    public let dispositionAction: DispositionAction?
    /// The status of the retention policy. Can be either `active` or `retired`. Once a policy has been retired, it cannot become active again.
    public let status: RetentionPolicyStatus?
    /// A mini user object representing the user that created the retention policy.
    public let createdBy: User?
    /// When the retention policy object was created.
    public let createdAt: Date?
    /// When the retention policy object was last modified.
    public let modifiedAt: Date?
    /// Wheter owner can extend time of retention policy.
    public let canOwnerExtendRetention: Bool?
    /// Whether owners are notified about retention policy changes.
    public let areOwnersNotified: Bool?
    /// Other users notified about retention policy changes.
    public let customNotificationRecipients: [User]?

    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == RetentionPolicy.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [RetentionPolicy.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "policy_name")
        policyType = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "policy_type")
        retentionLength = try BoxJSONDecoder.optionalDecodeRetentionLength(json: json)
        dispositionAction = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "disposition_action")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        canOwnerExtendRetention = try BoxJSONDecoder.optionalDecode(json: json, forKey: "can_owner_extend_retention")
        areOwnersNotified = try BoxJSONDecoder.optionalDecode(json: json, forKey: "are_owners_notified")
        customNotificationRecipients = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "custom_notification_recipients")
    }
}
