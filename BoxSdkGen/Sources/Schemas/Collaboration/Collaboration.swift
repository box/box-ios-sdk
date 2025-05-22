import Foundation

/// Collaborations define access permissions for users and groups to files and
/// folders, similar to access control lists. A collaboration object grants a
/// user or group access to a file or folder with permissions defined by a
/// specific role.
public class Collaboration: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case item
        case appItem = "app_item"
        case accessibleBy = "accessible_by"
        case inviteEmail = "invite_email"
        case role
        case expiresAt = "expires_at"
        case isAccessOnly = "is_access_only"
        case status
        case acknowledgedAt = "acknowledged_at"
        case createdBy = "created_by"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case acceptanceRequirementsStatus = "acceptance_requirements_status"
    }

    /// The unique identifier for this collaboration.
    public let id: String

    /// `collaboration`
    public let type: CollaborationTypeField

    @CodableTriState public private(set) var item: FileOrFolderOrWebLink?

    @CodableTriState public private(set) var appItem: AppItem?

    public let accessibleBy: GroupMiniOrUserCollaborations?

    /// The email address used to invite an unregistered collaborator, if
    /// they are not a registered user.
    @CodableTriState public private(set) var inviteEmail: String?

    /// The level of access granted.
    public let role: CollaborationRoleField?

    /// When the collaboration will expire, or `null` if no expiration
    /// date is set.
    @CodableTriState public private(set) var expiresAt: Date?

    /// If set to `true`, collaborators have access to
    /// shared items, but such items won't be visible in the
    /// All Files list. Additionally, collaborators won't
    /// see the the path to the root folder for the
    /// shared item.
    public let isAccessOnly: Bool?

    /// The status of the collaboration invitation. If the status
    /// is `pending`, `login` and `name` return an empty string.
    public let status: CollaborationStatusField?

    /// When the `status` of the collaboration object changed to
    /// `accepted` or `rejected`.
    public let acknowledgedAt: Date?

    public let createdBy: UserCollaborations?

    /// When the collaboration object was created.
    public let createdAt: Date?

    /// When the collaboration object was last modified.
    public let modifiedAt: Date?

    public let acceptanceRequirementsStatus: CollaborationAcceptanceRequirementsStatusField?

    /// Initializer for a Collaboration.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this collaboration.
    ///   - type: `collaboration`
    ///   - item: 
    ///   - appItem: 
    ///   - accessibleBy: 
    ///   - inviteEmail: The email address used to invite an unregistered collaborator, if
    ///     they are not a registered user.
    ///   - role: The level of access granted.
    ///   - expiresAt: When the collaboration will expire, or `null` if no expiration
    ///     date is set.
    ///   - isAccessOnly: If set to `true`, collaborators have access to
    ///     shared items, but such items won't be visible in the
    ///     All Files list. Additionally, collaborators won't
    ///     see the the path to the root folder for the
    ///     shared item.
    ///   - status: The status of the collaboration invitation. If the status
    ///     is `pending`, `login` and `name` return an empty string.
    ///   - acknowledgedAt: When the `status` of the collaboration object changed to
    ///     `accepted` or `rejected`.
    ///   - createdBy: 
    ///   - createdAt: When the collaboration object was created.
    ///   - modifiedAt: When the collaboration object was last modified.
    ///   - acceptanceRequirementsStatus: 
    public init(id: String, type: CollaborationTypeField = CollaborationTypeField.collaboration, item: TriStateField<FileOrFolderOrWebLink> = nil, appItem: TriStateField<AppItem> = nil, accessibleBy: GroupMiniOrUserCollaborations? = nil, inviteEmail: TriStateField<String> = nil, role: CollaborationRoleField? = nil, expiresAt: TriStateField<Date> = nil, isAccessOnly: Bool? = nil, status: CollaborationStatusField? = nil, acknowledgedAt: Date? = nil, createdBy: UserCollaborations? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, acceptanceRequirementsStatus: CollaborationAcceptanceRequirementsStatusField? = nil) {
        self.id = id
        self.type = type
        self._item = CodableTriState(state: item)
        self._appItem = CodableTriState(state: appItem)
        self.accessibleBy = accessibleBy
        self._inviteEmail = CodableTriState(state: inviteEmail)
        self.role = role
        self._expiresAt = CodableTriState(state: expiresAt)
        self.isAccessOnly = isAccessOnly
        self.status = status
        self.acknowledgedAt = acknowledgedAt
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.acceptanceRequirementsStatus = acceptanceRequirementsStatus
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CollaborationTypeField.self, forKey: .type)
        item = try container.decodeIfPresent(FileOrFolderOrWebLink.self, forKey: .item)
        appItem = try container.decodeIfPresent(AppItem.self, forKey: .appItem)
        accessibleBy = try container.decodeIfPresent(GroupMiniOrUserCollaborations.self, forKey: .accessibleBy)
        inviteEmail = try container.decodeIfPresent(String.self, forKey: .inviteEmail)
        role = try container.decodeIfPresent(CollaborationRoleField.self, forKey: .role)
        expiresAt = try container.decodeDateTimeIfPresent(forKey: .expiresAt)
        isAccessOnly = try container.decodeIfPresent(Bool.self, forKey: .isAccessOnly)
        status = try container.decodeIfPresent(CollaborationStatusField.self, forKey: .status)
        acknowledgedAt = try container.decodeDateTimeIfPresent(forKey: .acknowledgedAt)
        createdBy = try container.decodeIfPresent(UserCollaborations.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        acceptanceRequirementsStatus = try container.decodeIfPresent(CollaborationAcceptanceRequirementsStatusField.self, forKey: .acceptanceRequirementsStatus)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(field: _item.state, forKey: .item)
        try container.encode(field: _appItem.state, forKey: .appItem)
        try container.encodeIfPresent(accessibleBy, forKey: .accessibleBy)
        try container.encode(field: _inviteEmail.state, forKey: .inviteEmail)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeDateTime(field: _expiresAt.state, forKey: .expiresAt)
        try container.encodeIfPresent(isAccessOnly, forKey: .isAccessOnly)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeDateTimeIfPresent(field: acknowledgedAt, forKey: .acknowledgedAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeIfPresent(acceptanceRequirementsStatus, forKey: .acceptanceRequirementsStatus)
    }

}
