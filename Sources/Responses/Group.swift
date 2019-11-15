//
//  Group.swift
//  BoxSDK-iOS
//
//  Created by Matthew Willer on 6/18/19.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

/// Specifies who can invite the group to collaborate on folders.
public enum GroupInvitabilityLevel: BoxEnum {
    /// Master Admin, Co-admins, the group's Group Admin can invite
    case adminsOnly
    /// Admins and group members can invite
    case adminsAndMembers
    /// All managed users in the enterprise.
    case allManagedUsers
    /// Custom level that was not yet implemented in this version of SDK.
    case customValue(String)

    /// String representation of invitability level.
    public var description: String {
        switch self {
        case .adminsOnly:
            return "admins_only"
        case .adminsAndMembers:
            return "admins_and_members"
        case .allManagedUsers:
            return "all_managed_users"
        case let .customValue(value):
            return value
        }
    }

    /// Initializer.
    ///
    /// - Parameter value: String representation of invitability level.
    public init(_ value: String) {
        switch value {
        case "admins_only":
            self = .adminsOnly
        case "admins_and_members":
            self = .adminsAndMembers
        case "all_managed_users":
            self = .allManagedUsers
        default:
            self = .customValue(value)
        }
    }
}

/// Specifies who can view the members of the group.
public enum GroupMemberViewabilityLevel: BoxEnum {
    /// Master Admin, Coadmins and group's Group Admin can view the members of the group.
    case adminsOnly
    /// Admins and group members can view the members of the group.
    case adminsAndMembers
    /// All managed users in the enterprise can view the members of the group.
    case allManagedUsers
    /// Custom level that was not yet implemented in this version of SDK.
    case customValue(String)

    /// String representation of member viewability level
    public var description: String {
        switch self {
        case .adminsOnly:
            return "admins_only"
        case .adminsAndMembers:
            return "admins_and_members"
        case .allManagedUsers:
            return "all_managed_users"
        case let .customValue(value):
            return value
        }
    }

    /// Initializer.
    ///
    /// - Parameter value: String representation of member viewability level
    public init(_ value: String) {
        switch value {
        case "admins_only":
            self = .adminsOnly
        case "admins_and_members":
            self = .adminsAndMembers
        case "all_managed_users":
            self = .allManagedUsers
        default:
            self = .customValue(value)
        }
    }
}

/// Contain a set of users, and can be used in place of users in some operations, such as collaborations.
public class Group: BoxModel {

    /// The type of the group.
    public enum GroupType: BoxEnum {
        /// Group is managed by the Enterprise admin
        case managedGroup
        /// A Box-defined group that includes all users in an Enterprise
        case allUsersGroup
        /// Custom value not yet implemented in this SDK.
        case customValue(String)

        public init(_ value: String) {
            switch value {
            case "managed_group":
                self = .managedGroup
            case "all_users_group":
                self = .allUsersGroup
            default:
                self = .customValue(value)
            }
        }

        public var description: String {
            switch self {
            case .managedGroup:
                return "managed_group"
            case .allUsersGroup:
                return "all_users_group"
            case let .customValue(value):
                return value
            }
        }
    }

    // MARK: - BoxModel

    private static var resourceType: String = "group"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// The ID of the group object.
    public let id: String
    /// The name of the group
    public let name: String?
    /// The type of the group
    public let groupType: GroupType?
    /// When the group object was created.
    public let createdAt: Date?
    /// When the group object was last modified.
    public let modifiedAt: Date?
    /// Keeps track of which external source this group is coming.
    public let provenance: String?
    /// Human readable description of the group. This can be up to 255 characters long
    public let description: String?
    /// An arbitrary identifier that can be used by external group sync tools to link this Box Group to an external group.
    public let externalSyncIdentifier: String?
    /// Specifies who can invite the group to collaborate on folders.
    public let invitabilityLevel: GroupInvitabilityLevel?
    /// Specifies who can view the members of the group.
    public let memberViewabilityLevel: GroupMemberViewabilityLevel?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Group.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Group.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        groupType = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "group_type")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        provenance = try BoxJSONDecoder.optionalDecode(json: json, forKey: "provenance")
        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
        externalSyncIdentifier = try BoxJSONDecoder.optionalDecode(json: json, forKey: "external_sync_identifier")
        invitabilityLevel = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "invitability_level")
        memberViewabilityLevel = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "member_viewability_level")
    }
}
