import Foundation

public class UpdateCollaborationByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case role
        case status
        case expiresAt = "expires_at"
        case canViewPath = "can_view_path"
    }

    /// The level of access granted.
    public let role: UpdateCollaborationByIdRequestBodyRoleField

    /// <!--alex ignore reject-->
    /// Set the status of a `pending` collaboration invitation,
    /// effectively accepting, or rejecting the invite.
    public let status: UpdateCollaborationByIdRequestBodyStatusField?

    /// Update the expiration date for the collaboration. At this date,
    /// the collaboration will be automatically removed from the item.
    /// 
    /// This feature will only work if the **Automatically remove invited
    /// collaborators: Allow folder owners to extend the expiry date**
    /// setting has been enabled in the **Enterprise Settings**
    /// of the **Admin Console**. When the setting is not enabled,
    /// collaborations can not have an expiry date and a value for this
    /// field will be result in an error.
    /// 
    /// Additionally, a collaboration can only be given an
    /// expiration if it was created after the **Automatically remove
    /// invited collaborator** setting was enabled.
    public let expiresAt: Date?

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

    /// Initializer for a UpdateCollaborationByIdRequestBody.
    ///
    /// - Parameters:
    ///   - role: The level of access granted.
    ///   - status: <!--alex ignore reject-->
    ///     Set the status of a `pending` collaboration invitation,
    ///     effectively accepting, or rejecting the invite.
    ///   - expiresAt: Update the expiration date for the collaboration. At this date,
    ///     the collaboration will be automatically removed from the item.
    ///     
    ///     This feature will only work if the **Automatically remove invited
    ///     collaborators: Allow folder owners to extend the expiry date**
    ///     setting has been enabled in the **Enterprise Settings**
    ///     of the **Admin Console**. When the setting is not enabled,
    ///     collaborations can not have an expiry date and a value for this
    ///     field will be result in an error.
    ///     
    ///     Additionally, a collaboration can only be given an
    ///     expiration if it was created after the **Automatically remove
    ///     invited collaborator** setting was enabled.
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
    public init(role: UpdateCollaborationByIdRequestBodyRoleField, status: UpdateCollaborationByIdRequestBodyStatusField? = nil, expiresAt: Date? = nil, canViewPath: Bool? = nil) {
        self.role = role
        self.status = status
        self.expiresAt = expiresAt
        self.canViewPath = canViewPath
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decode(UpdateCollaborationByIdRequestBodyRoleField.self, forKey: .role)
        status = try container.decodeIfPresent(UpdateCollaborationByIdRequestBodyStatusField.self, forKey: .status)
        expiresAt = try container.decodeDateTimeIfPresent(forKey: .expiresAt)
        canViewPath = try container.decodeIfPresent(Bool.self, forKey: .canViewPath)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeDateTimeIfPresent(field: expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(canViewPath, forKey: .canViewPath)
    }

}
