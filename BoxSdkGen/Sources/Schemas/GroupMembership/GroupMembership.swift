import Foundation

/// Membership is used to signify that a user is part of a
/// group.
public class GroupMembership: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case user
        case group
        case role
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

    /// The unique identifier for this group membership
    public let id: String?

    /// `group_membership`
    public let type: GroupMembershipTypeField?

    public let user: UserMini?

    public let group: GroupMini?

    /// The role of the user in the group.
    public let role: GroupMembershipRoleField?

    /// The time this membership was created.
    public let createdAt: Date?

    /// The time this membership was last modified.
    public let modifiedAt: Date?

    /// Initializer for a GroupMembership.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this group membership
    ///   - type: `group_membership`
    ///   - user: 
    ///   - group: 
    ///   - role: The role of the user in the group.
    ///   - createdAt: The time this membership was created.
    ///   - modifiedAt: The time this membership was last modified.
    public init(id: String? = nil, type: GroupMembershipTypeField? = nil, user: UserMini? = nil, group: GroupMini? = nil, role: GroupMembershipRoleField? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.id = id
        self.type = type
        self.user = user
        self.group = group
        self.role = role
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(GroupMembershipTypeField.self, forKey: .type)
        user = try container.decodeIfPresent(UserMini.self, forKey: .user)
        group = try container.decodeIfPresent(GroupMini.self, forKey: .group)
        role = try container.decodeIfPresent(GroupMembershipRoleField.self, forKey: .role)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(group, forKey: .group)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
    }

}
