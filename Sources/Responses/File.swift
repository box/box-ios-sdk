import Foundation

/// File objects in Box, with attributes like who created the file, when it was last modified, and other information.
public class File: BoxModel {

    /// Permissions that the current user has on this file.
    public struct Permissions: BoxInnerModel {
        /// Permission for download
        public let canDownload: Bool?
        /// Permission for preview
        public let canPreview: Bool?
        /// Permission for upload
        public let canUpload: Bool?
        /// Permission to comment
        public let canComment: Bool?
        /// Permission to rename
        public let canRename: Bool?
        /// Permission to delete
        public let canDelete: Bool?
        /// Permission to share
        public let canShare: Bool?
        /// Permission to share access
        public let canSetShareAccess: Bool?
        /// Permission to invite collaborators
        public let canInviteCollaborator: Bool?
        /// Permission to annotate
        public let canAnnotate: Bool?
        /// Permission to view all annotations
        public let canViewAnnotationsAll: Bool?
        /// Permission to view signed in user annotations
        public let canViewAnnotationsSelf: Bool?
    }

    // MARK: - Properties

    public private(set) var rawData: [String: Any]
    private static var resourceType: String = "file"
    /// Box item type
    public var type: String

    /// Identifier
    public let id: String
    /// The version information of the file.
    public let fileVersion: FileVersion?
    /// A unique ID for use with the events.
    public let sequenceId: String?
    /// The entity tag of this file object.
    public let etag: String?
    /// The SHA-1 hash of this file.
    public let sha1: String?
    /// The name of this file.
    public let name: String?
    /// Indicates the suffix, when available, on the file. By default, set to an empty string.
    /// The suffix usually indicates the encoding (file format) of the file contents or usage.
    public let `extension`: String?
    /// The description of this file.
    public let description: String?
    /// Size of this file in bytes.
    public let size: Int?
    /// The path of folders to this item, starting at the root.
    public let pathCollection: PathCollection?
    /// Description
    public let commentCount: Int?
    /// The number of comments on this file.
    public let createdAt: Date?
    /// When this file was last updated on the Box servers.
    public let modifiedAt: Date?
    /// When this file was moved to the trash.
    public let trashedAt: Date?
    /// When this file will be permanently deleted.
    public let purgedAt: Date?
    /// When the content of this file was created.
    public let contentCreatedAt: Date?
    /// When the content of this file was last modified.
    public let contentModifiedAt: Date?
    /// Whether the file is a package. Used for Mac Packages used by iWorks.
    public let isPackage: Bool?
    /// The user who first created this file.
    public let createdBy: User?
    /// The user who last updated this file.
    public let modifiedBy: User?
    /// The user who owns this file.
    public let ownedBy: User?
    /// The shared link object for this file.
    public let sharedLink: SharedLink?
    /// The folder containing this file.
    public let parent: Folder?
    /// Whether this item is deleted or not. Values include active, trashed if the file has been moved to the trash,
    /// and deleted if the file has been permanently deleted.
    public let itemStatus: ItemStatus?
    /// The version number of this file.
    public let versionNumber: String?
    /// When the file will automatically be deleted, i.e. expired.
    public let expiresAt: Date?
    /// Permissions that the current user has on this file.
    public let permissions: Permissions?
    /// An expiring URL for an embedded preview session in an iframe. This URL will expire after 60 seconds and the session will expire after 60 minutes.
    public let expiringEmbedLink: ExpiringEmbedLink?
    /// The collections that the file belongs to
    public let collections: [[String: String]]?
    /// The lock held on this file. If there is no lock, this can either be null or have a timestamp in the past.
    public let lock: Lock?
    /// All tags applied to this file
    public let tags: [String]?
    /// Whether this file has any collaborators.
    public let hasCollaborations: Bool?
    /// Whether this file is owned by a user outside of the enterprise.
    public let isExternallyOwned: Bool?
    /// File collaboration roles allowed by the enterprise administrator.
    public let allowedInviteeRoles: [CollaborationRole]?
    /// Digital assets created for this file.
    public let representations: EntryContainerInnerModel<FileRepresentation>?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == File.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [File.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        fileVersion = try BoxJSONDecoder.optionalDecode(json: json, forKey: "file_version")
        sequenceId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "sequence_id")
        etag = try BoxJSONDecoder.optionalDecode(json: json, forKey: "etag")
        sha1 = try BoxJSONDecoder.optionalDecode(json: json, forKey: "sha1")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        `extension` = try BoxJSONDecoder.optionalDecode(json: json, forKey: "extension")
        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
        size = try BoxJSONDecoder.optionalDecode(json: json, forKey: "size")
        pathCollection = try BoxJSONDecoder.optionalDecode(json: json, forKey: "path_collection")
        commentCount = try BoxJSONDecoder.optionalDecode(json: json, forKey: "comment_count")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        trashedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "trashed_at")
        purgedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "purged_at")
        contentCreatedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "content_created_at")
        contentModifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "content_modified_at")
        isPackage = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_package")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        modifiedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "modified_by")
        ownedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "owned_by")
        sharedLink = try BoxJSONDecoder.optionalDecode(json: json, forKey: "shared_link")
        parent = try BoxJSONDecoder.optionalDecode(json: json, forKey: "parent")
        itemStatus = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "item_status")
        expiringEmbedLink = try BoxJSONDecoder.optionalDecode(json: json, forKey: "expiring_embed_link")
        lock = try BoxJSONDecoder.optionalDecode(json: json, forKey: "lock")
        versionNumber = try BoxJSONDecoder.optionalDecode(json: json, forKey: "version_number")
        expiresAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "expires_at")
        permissions = try BoxJSONDecoder.optionalDecode(json: json, forKey: "permissions")
//        isHideCollaboratorsEnabled = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_hide_collaborators_enabled")
        tags = try BoxJSONDecoder.optionalDecode(json: json, forKey: "tags")
        hasCollaborations = try BoxJSONDecoder.optionalDecode(json: json, forKey: "has_collaborations")
        isExternallyOwned = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_externally_owned")
        allowedInviteeRoles = try BoxJSONDecoder.optionalDecodeEnumCollection(json: json, forKey: "allowed_invitee_roles")
        representations = try BoxJSONDecoder.optionalDecode(json: json, forKey: "representations")
        collections = json["collections"] as? [[String: String]]
    }
}
