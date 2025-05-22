import Foundation

public class FolderFullPermissionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case canDelete = "can_delete"
        case canDownload = "can_download"
        case canInviteCollaborator = "can_invite_collaborator"
        case canRename = "can_rename"
        case canSetShareAccess = "can_set_share_access"
        case canShare = "can_share"
        case canUpload = "can_upload"
    }

    /// Specifies if the current user can delete this item.
    public let canDelete: Bool

    /// Specifies if the current user can download this item.
    public let canDownload: Bool

    /// Specifies if the current user can invite new
    /// users to collaborate on this item, and if the user can
    /// update the role of a user already collaborated on this
    /// item.
    public let canInviteCollaborator: Bool

    /// Specifies if the user can rename this item.
    public let canRename: Bool

    /// Specifies if the user can change the access level of an
    /// existing shared link on this item.
    public let canSetShareAccess: Bool

    /// Specifies if the user can create a shared link for this item.
    public let canShare: Bool

    /// Specifies if the user can upload into this folder.
    public let canUpload: Bool

    /// Initializer for a FolderFullPermissionsField.
    ///
    /// - Parameters:
    ///   - canDelete: Specifies if the current user can delete this item.
    ///   - canDownload: Specifies if the current user can download this item.
    ///   - canInviteCollaborator: Specifies if the current user can invite new
    ///     users to collaborate on this item, and if the user can
    ///     update the role of a user already collaborated on this
    ///     item.
    ///   - canRename: Specifies if the user can rename this item.
    ///   - canSetShareAccess: Specifies if the user can change the access level of an
    ///     existing shared link on this item.
    ///   - canShare: Specifies if the user can create a shared link for this item.
    ///   - canUpload: Specifies if the user can upload into this folder.
    public init(canDelete: Bool, canDownload: Bool, canInviteCollaborator: Bool, canRename: Bool, canSetShareAccess: Bool, canShare: Bool, canUpload: Bool) {
        self.canDelete = canDelete
        self.canDownload = canDownload
        self.canInviteCollaborator = canInviteCollaborator
        self.canRename = canRename
        self.canSetShareAccess = canSetShareAccess
        self.canShare = canShare
        self.canUpload = canUpload
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canDelete = try container.decode(Bool.self, forKey: .canDelete)
        canDownload = try container.decode(Bool.self, forKey: .canDownload)
        canInviteCollaborator = try container.decode(Bool.self, forKey: .canInviteCollaborator)
        canRename = try container.decode(Bool.self, forKey: .canRename)
        canSetShareAccess = try container.decode(Bool.self, forKey: .canSetShareAccess)
        canShare = try container.decode(Bool.self, forKey: .canShare)
        canUpload = try container.decode(Bool.self, forKey: .canUpload)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(canDelete, forKey: .canDelete)
        try container.encode(canDownload, forKey: .canDownload)
        try container.encode(canInviteCollaborator, forKey: .canInviteCollaborator)
        try container.encode(canRename, forKey: .canRename)
        try container.encode(canSetShareAccess, forKey: .canSetShareAccess)
        try container.encode(canShare, forKey: .canShare)
        try container.encode(canUpload, forKey: .canUpload)
    }

}
