//
//  GroupMembership.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 9/3/19.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

/// Specifies role of the user within a Group.
public enum GroupRole: BoxEnum {
    /// Default permission for a user in a Group.
    case member
    /// The admin of the Group.
    case admin
    /// A custom object type for defining access that is not yet implemented
    case customValue(String)

    /// Creates a new value
    ///
    /// - Parameter value: String representation of an GroupRole rawValue
    public init(_ value: String) {
        switch value {
        case "member":
            self = .member
        case "admin":
            self = .admin
        default:
            self = .customValue(value)
        }
    }

    /// Returns string representation of type that can be used in a request.
    public var description: String {
        switch self {
        case .member:
            return "member"
        case .admin:
            return "admin"
        case let .customValue(userValue):
            return userValue
        }
    }
}

public class GroupMembership: BoxModel {

    public struct ConfigurablePermissions: BoxInnerModel {
        public let canRunReports: Bool
        public let canInstantLogin: Bool
        public let canCreateAccounts: Bool
        public let canEditAccounts: Bool
    }

    // MARK: - BoxModel

    private static var resourceType: String = "group_membership"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    /// The ID of the association between a user and a group.
    public let id: String
    /// A user object associated with the group.
    public let user: User?
    /// The group the user is associated with.
    public let group: Group?
    /// The role of the user within the group. The default is `member` with an option for `admin`.
    public let role: GroupRole?
    /// Permissions of an individual group member.
    public let configurablePermissions: ConfigurablePermissions?
    /// The date time this membership was created at.
    public let createdAt: Date?
    /// The date time this membership was modified at.
    public let modifiedAt: Date?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == GroupMembership.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [GroupMembership.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        user = try BoxJSONDecoder.optionalDecode(json: json, forKey: "user")
        group = try BoxJSONDecoder.optionalDecode(json: json, forKey: "group")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        role = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "role")
        configurablePermissions = try BoxJSONDecoder.optionalDecode(json: json, forKey: "configurable_permissions")
    }
}
