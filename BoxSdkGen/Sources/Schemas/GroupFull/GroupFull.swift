import Foundation

/// Groups contain a set of users, and can be used in place of
/// users in some operations, such as collaborations.
public class GroupFull: Group {
    private enum CodingKeys: String, CodingKey {
        case provenance
        case externalSyncIdentifier = "external_sync_identifier"
        case description
        case invitabilityLevel = "invitability_level"
        case memberViewabilityLevel = "member_viewability_level"
        case permissions
    }

    /// Keeps track of which external source this group is
    /// coming from (e.g. "Active Directory", "Google Groups",
    /// "Facebook Groups").  Setting this will
    /// also prevent Box users from editing the group name
    /// and its members directly via the Box web application.
    /// This is desirable for one-way syncing of groups.
    public let provenance: String?

    /// An arbitrary identifier that can be used by
    /// external group sync tools to link this Box Group to
    /// an external group. Example values of this field
    /// could be an Active Directory Object ID or a Google
    /// Group ID.  We recommend you use of this field in
    /// order to avoid issues when group names are updated in
    /// either Box or external systems.
    public let externalSyncIdentifier: String?

    /// Human readable description of the group.
    public let description: String?

    /// Specifies who can invite the group to collaborate
    /// on items.
    /// 
    /// When set to `admins_only` the enterprise admin, co-admins,
    /// and the group's admin can invite the group.
    /// 
    /// When set to `admins_and_members` all the admins listed
    /// above and group members can invite the group.
    /// 
    /// When set to `all_managed_users` all managed users in the
    /// enterprise can invite the group.
    public let invitabilityLevel: GroupFullInvitabilityLevelField?

    /// Specifies who can view the members of the group
    /// (Get Memberships for Group).
    /// 
    /// * `admins_only` - the enterprise admin, co-admins, group's
    ///   group admin
    /// * `admins_and_members` - all admins and group members
    /// * `all_managed_users` - all managed users in the
    ///   enterprise
    public let memberViewabilityLevel: GroupFullMemberViewabilityLevelField?

    public let permissions: GroupFullPermissionsField?

    /// Initializer for a GroupFull.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this object
    ///   - type: `group`
    ///   - name: The name of the group
    ///   - groupType: The type of the group.
    ///   - createdAt: When the group object was created
    ///   - modifiedAt: When the group object was last modified
    ///   - provenance: Keeps track of which external source this group is
    ///     coming from (e.g. "Active Directory", "Google Groups",
    ///     "Facebook Groups").  Setting this will
    ///     also prevent Box users from editing the group name
    ///     and its members directly via the Box web application.
    ///     This is desirable for one-way syncing of groups.
    ///   - externalSyncIdentifier: An arbitrary identifier that can be used by
    ///     external group sync tools to link this Box Group to
    ///     an external group. Example values of this field
    ///     could be an Active Directory Object ID or a Google
    ///     Group ID.  We recommend you use of this field in
    ///     order to avoid issues when group names are updated in
    ///     either Box or external systems.
    ///   - description: Human readable description of the group.
    ///   - invitabilityLevel: Specifies who can invite the group to collaborate
    ///     on items.
    ///     
    ///     When set to `admins_only` the enterprise admin, co-admins,
    ///     and the group's admin can invite the group.
    ///     
    ///     When set to `admins_and_members` all the admins listed
    ///     above and group members can invite the group.
    ///     
    ///     When set to `all_managed_users` all managed users in the
    ///     enterprise can invite the group.
    ///   - memberViewabilityLevel: Specifies who can view the members of the group
    ///     (Get Memberships for Group).
    ///     
    ///     * `admins_only` - the enterprise admin, co-admins, group's
    ///       group admin
    ///     * `admins_and_members` - all admins and group members
    ///     * `all_managed_users` - all managed users in the
    ///       enterprise
    ///   - permissions: 
    public init(id: String, type: GroupBaseTypeField = GroupBaseTypeField.group, name: String? = nil, groupType: GroupMiniGroupTypeField? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, provenance: String? = nil, externalSyncIdentifier: String? = nil, description: String? = nil, invitabilityLevel: GroupFullInvitabilityLevelField? = nil, memberViewabilityLevel: GroupFullMemberViewabilityLevelField? = nil, permissions: GroupFullPermissionsField? = nil) {
        self.provenance = provenance
        self.externalSyncIdentifier = externalSyncIdentifier
        self.description = description
        self.invitabilityLevel = invitabilityLevel
        self.memberViewabilityLevel = memberViewabilityLevel
        self.permissions = permissions

        super.init(id: id, type: type, name: name, groupType: groupType, createdAt: createdAt, modifiedAt: modifiedAt)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        provenance = try container.decodeIfPresent(String.self, forKey: .provenance)
        externalSyncIdentifier = try container.decodeIfPresent(String.self, forKey: .externalSyncIdentifier)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        invitabilityLevel = try container.decodeIfPresent(GroupFullInvitabilityLevelField.self, forKey: .invitabilityLevel)
        memberViewabilityLevel = try container.decodeIfPresent(GroupFullMemberViewabilityLevelField.self, forKey: .memberViewabilityLevel)
        permissions = try container.decodeIfPresent(GroupFullPermissionsField.self, forKey: .permissions)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(provenance, forKey: .provenance)
        try container.encodeIfPresent(externalSyncIdentifier, forKey: .externalSyncIdentifier)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(invitabilityLevel, forKey: .invitabilityLevel)
        try container.encodeIfPresent(memberViewabilityLevel, forKey: .memberViewabilityLevel)
        try container.encodeIfPresent(permissions, forKey: .permissions)
        try super.encode(to: encoder)
    }

}
