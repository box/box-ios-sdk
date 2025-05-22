import Foundation

public class CreateCollaborationRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case item
        case accessibleBy = "accessible_by"
        case role
        case isAccessOnly = "is_access_only"
        case canViewPath = "can_view_path"
        case expiresAt = "expires_at"
    }

    /// The item to attach the comment to.
    public let item: CreateCollaborationRequestBodyItemField

    /// The user or group to give access to the item.
    public let accessibleBy: CreateCollaborationRequestBodyAccessibleByField

    /// The level of access granted.
    public let role: CreateCollaborationRequestBodyRoleField

    /// If set to `true`, collaborators have access to
    /// shared items, but such items won't be visible in the
    /// All Files list. Additionally, collaborators won't
    /// see the the path to the root folder for the
    /// shared item.
    public let isAccessOnly: Bool?

    /// Determines if the invited users can see the entire parent path to
    /// the associated folder. The user will not gain privileges in any
    /// parent folder and therefore can not see content the user is not
    /// collaborated on.
    /// 
    /// Be aware that this meaningfully increases the time required to load the
    /// invitee's **All Files** page. We recommend you limit the number of
    /// collaborations with `can_view_path` enabled to 1,000 per user.
    /// 
    /// Only owner or co-owners can invite collaborators with a `can_view_path` of
    /// `true`.
    /// 
    /// `can_view_path` can only be used for folder collaborations.
    public let canViewPath: Bool?

    /// Set the expiration date for the collaboration. At this date, the
    /// collaboration will be automatically removed from the item.
    /// 
    /// This feature will only work if the **Automatically remove invited
    /// collaborators: Allow folder owners to extend the expiry date**
    /// setting has been enabled in the **Enterprise Settings**
    /// of the **Admin Console**. When the setting is not enabled,
    /// collaborations can not have an expiry date and a value for this
    /// field will be result in an error.
    public let expiresAt: Date?

    /// Initializer for a CreateCollaborationRequestBody.
    ///
    /// - Parameters:
    ///   - item: The item to attach the comment to.
    ///   - accessibleBy: The user or group to give access to the item.
    ///   - role: The level of access granted.
    ///   - isAccessOnly: If set to `true`, collaborators have access to
    ///     shared items, but such items won't be visible in the
    ///     All Files list. Additionally, collaborators won't
    ///     see the the path to the root folder for the
    ///     shared item.
    ///   - canViewPath: Determines if the invited users can see the entire parent path to
    ///     the associated folder. The user will not gain privileges in any
    ///     parent folder and therefore can not see content the user is not
    ///     collaborated on.
    ///     
    ///     Be aware that this meaningfully increases the time required to load the
    ///     invitee's **All Files** page. We recommend you limit the number of
    ///     collaborations with `can_view_path` enabled to 1,000 per user.
    ///     
    ///     Only owner or co-owners can invite collaborators with a `can_view_path` of
    ///     `true`.
    ///     
    ///     `can_view_path` can only be used for folder collaborations.
    ///   - expiresAt: Set the expiration date for the collaboration. At this date, the
    ///     collaboration will be automatically removed from the item.
    ///     
    ///     This feature will only work if the **Automatically remove invited
    ///     collaborators: Allow folder owners to extend the expiry date**
    ///     setting has been enabled in the **Enterprise Settings**
    ///     of the **Admin Console**. When the setting is not enabled,
    ///     collaborations can not have an expiry date and a value for this
    ///     field will be result in an error.
    public init(item: CreateCollaborationRequestBodyItemField, accessibleBy: CreateCollaborationRequestBodyAccessibleByField, role: CreateCollaborationRequestBodyRoleField, isAccessOnly: Bool? = nil, canViewPath: Bool? = nil, expiresAt: Date? = nil) {
        self.item = item
        self.accessibleBy = accessibleBy
        self.role = role
        self.isAccessOnly = isAccessOnly
        self.canViewPath = canViewPath
        self.expiresAt = expiresAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        item = try container.decode(CreateCollaborationRequestBodyItemField.self, forKey: .item)
        accessibleBy = try container.decode(CreateCollaborationRequestBodyAccessibleByField.self, forKey: .accessibleBy)
        role = try container.decode(CreateCollaborationRequestBodyRoleField.self, forKey: .role)
        isAccessOnly = try container.decodeIfPresent(Bool.self, forKey: .isAccessOnly)
        canViewPath = try container.decodeIfPresent(Bool.self, forKey: .canViewPath)
        expiresAt = try container.decodeDateTimeIfPresent(forKey: .expiresAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(item, forKey: .item)
        try container.encode(accessibleBy, forKey: .accessibleBy)
        try container.encode(role, forKey: .role)
        try container.encodeIfPresent(isAccessOnly, forKey: .isAccessOnly)
        try container.encodeIfPresent(canViewPath, forKey: .canViewPath)
        try container.encodeDateTimeIfPresent(field: expiresAt, forKey: .expiresAt)
    }

}
