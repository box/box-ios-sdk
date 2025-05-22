import Foundation

public class FileFullPermissionsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case canDelete = "can_delete"
        case canDownload = "can_download"
        case canInviteCollaborator = "can_invite_collaborator"
        case canRename = "can_rename"
        case canSetShareAccess = "can_set_share_access"
        case canShare = "can_share"
        case canAnnotate = "can_annotate"
        case canComment = "can_comment"
        case canPreview = "can_preview"
        case canUpload = "can_upload"
        case canViewAnnotationsAll = "can_view_annotations_all"
        case canViewAnnotationsSelf = "can_view_annotations_self"
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

    /// Specifies if the user can place annotations on this file.
    public let canAnnotate: Bool

    /// Specifies if the user can place comments on this file.
    public let canComment: Bool

    /// Specifies if the user can preview this file.
    public let canPreview: Bool

    /// Specifies if the user can upload a new version of this file.
    public let canUpload: Bool

    /// Specifies if the user view all annotations placed on this file
    public let canViewAnnotationsAll: Bool

    /// Specifies if the user view annotations placed by themselves
    /// on this file
    public let canViewAnnotationsSelf: Bool

    /// Initializer for a FileFullPermissionsField.
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
    ///   - canAnnotate: Specifies if the user can place annotations on this file.
    ///   - canComment: Specifies if the user can place comments on this file.
    ///   - canPreview: Specifies if the user can preview this file.
    ///   - canUpload: Specifies if the user can upload a new version of this file.
    ///   - canViewAnnotationsAll: Specifies if the user view all annotations placed on this file
    ///   - canViewAnnotationsSelf: Specifies if the user view annotations placed by themselves
    ///     on this file
    public init(canDelete: Bool, canDownload: Bool, canInviteCollaborator: Bool, canRename: Bool, canSetShareAccess: Bool, canShare: Bool, canAnnotate: Bool, canComment: Bool, canPreview: Bool, canUpload: Bool, canViewAnnotationsAll: Bool, canViewAnnotationsSelf: Bool) {
        self.canDelete = canDelete
        self.canDownload = canDownload
        self.canInviteCollaborator = canInviteCollaborator
        self.canRename = canRename
        self.canSetShareAccess = canSetShareAccess
        self.canShare = canShare
        self.canAnnotate = canAnnotate
        self.canComment = canComment
        self.canPreview = canPreview
        self.canUpload = canUpload
        self.canViewAnnotationsAll = canViewAnnotationsAll
        self.canViewAnnotationsSelf = canViewAnnotationsSelf
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canDelete = try container.decode(Bool.self, forKey: .canDelete)
        canDownload = try container.decode(Bool.self, forKey: .canDownload)
        canInviteCollaborator = try container.decode(Bool.self, forKey: .canInviteCollaborator)
        canRename = try container.decode(Bool.self, forKey: .canRename)
        canSetShareAccess = try container.decode(Bool.self, forKey: .canSetShareAccess)
        canShare = try container.decode(Bool.self, forKey: .canShare)
        canAnnotate = try container.decode(Bool.self, forKey: .canAnnotate)
        canComment = try container.decode(Bool.self, forKey: .canComment)
        canPreview = try container.decode(Bool.self, forKey: .canPreview)
        canUpload = try container.decode(Bool.self, forKey: .canUpload)
        canViewAnnotationsAll = try container.decode(Bool.self, forKey: .canViewAnnotationsAll)
        canViewAnnotationsSelf = try container.decode(Bool.self, forKey: .canViewAnnotationsSelf)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(canDelete, forKey: .canDelete)
        try container.encode(canDownload, forKey: .canDownload)
        try container.encode(canInviteCollaborator, forKey: .canInviteCollaborator)
        try container.encode(canRename, forKey: .canRename)
        try container.encode(canSetShareAccess, forKey: .canSetShareAccess)
        try container.encode(canShare, forKey: .canShare)
        try container.encode(canAnnotate, forKey: .canAnnotate)
        try container.encode(canComment, forKey: .canComment)
        try container.encode(canPreview, forKey: .canPreview)
        try container.encode(canUpload, forKey: .canUpload)
        try container.encode(canViewAnnotationsAll, forKey: .canViewAnnotationsAll)
        try container.encode(canViewAnnotationsSelf, forKey: .canViewAnnotationsSelf)
    }

}
