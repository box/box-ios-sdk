import Foundation

/// Defines whether folder will be synced by the Box sync clients or not.
public enum SyncState: BoxEnum {
    /// Initializer.
    ///
    /// - Parameter value: String representation of sync state.
    public init(_ value: String) {
        switch value {
        case "synced":
            self = .synced
        case "not_synced":
            self = .notSynced
        case "partially_synced":
            self = .partiallySynced
        default:
            self = .customValue(value)
        }
    }

    /// String representation of sync state.
    public var description: String {
        switch self {
        case .synced:
            return "synced"
        case .notSynced:
            return "not_synced"
        case .partiallySynced:
            return "partially_synced"
        case let .customValue(value):
            return value
        }
    }

    /// Folder will be synced by the Box sync clients
    case synced
    ///  Folder will not be synced by the Box sync clients
    case notSynced
    /// Folder is partially synced by the Box sync clients
    case partiallySynced
    /// Custom sync option, that is not yet implemented in this SDK version.
    case customValue(String)
}

/// File objects in Box, with attributes like who created the file, when it was last modified, and other information.
public class Folder: BoxModel {

    /// An object containing the permissions that the current user has on this file.
    public struct Permissions: BoxInnerModel {
        /// Download permission
        public let canDownload: Bool?
        /// Upload permission
        public let canUpload: Bool?
        /// Rename permission
        public let canRename: Bool?
        /// Delete permission
        public let canDelete: Bool?
        /// Share permission
        public let canShare: Bool?
        /// Permission to add collaborators
        public let canInviteCollaborator: Bool?
        /// Permission to set shared link access level for the folder
        public let canSetShareAccess: Bool?
    }

    // MARK: - BoxModel

    private static var resourceType: String = "folder"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// A unique ID for use with the events.
    public let sequenceId: String?
    /// The name of the folder. May be nil for some folders, such as root or trash.
    public let etag: String?
    /// The name of the folder.
    public let name: String?
    /// The time the folder was created.
    public let createdAt: Date?
    /// When this folder was last updated on the Box servers.
    public let modifiedAt: Date?
    /// The description of the folder. The limit is 256 characters.
    public let description: String?
    /// Whether future collaborations should be restricted to within the enterprise only
    public let isCollaborationRestrictedToEnterprise: Bool?
    /// The folder size in bytes.
    public let size: Int?
    /// The path of folders to this folder, starting at the root.
    public let pathCollection: PathCollection?
    /// The user who created this folder.
    public let createdBy: User?
    /// The user who last modified this folder.
    public let modifiedBy: User?
    /// The user who owns this folder.
    public let ownedBy: User?
    /// The shared link object for this file. Is nil if no shared link has been created.
    public let sharedLink: SharedLink?
    /// The upload email address for this folder.
    public let folderUploadEmail: FolderUploadEmail?
    /// The folder that contains this folder. May be nil for folders such as root, trash and child folders whose parent is inaccessible.
    public let parent: Folder?
    /// Whether this item is deleted or not.
    public let itemStatus: ItemStatus?
    /// The time the folder or its contents were originally created (according to the uploader). May be nil for some folders such as root or trash.
    public let contentCreatedAt: Date?
    /// The time the folder or its contents were last modified (according to the uploader). May be nil for some folders such as root or trash.
    public let contentModifiedAt: Date?
    /// Whether non-owners can invite collaborators to this folder.
    public let canNonOwnersInvite: Bool?
    /// The time the folder or its contents were put in the trash.
    public let trashedAt: Date?
    /// The time the folder or its contents will be purged from the trash.
    public let purgedAt: Date?
    /// Whether this folder will be synced by the Box sync clients or not.
    public let syncState: SyncState?
    /// Whether this folder has any collaborators.
    public let hasCollaborations: Bool?
    /// An object containing the permissions that the current user has on this folder.
    public let permissions: Permissions?
    /// All tags applied to this folder.
    public let tags: [String]?
    /// Access level settings for shared links set by administrator.
    public let allowedSharedLinkAccessLevels: [SharedLinkAccess]?
    /// Folder collaboration roles allowed by the enterprise administrator.
    public let allowedInviteeRoles: [String]?
    /// Whether this folder is owned by a user outside of the enterprise.
    public let isExternallyOwned: Bool?
    /// The collections the folder belongs to
    public let collections: [[String: String]]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {

        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == Folder.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [Folder.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        sequenceId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "sequence_id")
        etag = try BoxJSONDecoder.optionalDecode(json: json, forKey: "etag")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
        isCollaborationRestrictedToEnterprise = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_collaboration_restricted_to_enterprise")
        size = try BoxJSONDecoder.optionalDecode(json: json, forKey: "size")
        pathCollection = try BoxJSONDecoder.optionalDecode(json: json, forKey: "path_collection")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        modifiedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "modified_by")
        ownedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "owned_by")
        sharedLink = try BoxJSONDecoder.optionalDecode(json: json, forKey: "shared_link")
        parent = try BoxJSONDecoder.optionalDecode(json: json, forKey: "parent")
        folderUploadEmail = try BoxJSONDecoder.optionalDecode(json: json, forKey: "folder_upload_email")
        itemStatus = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "item_status")

        contentCreatedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "content_created_at")
        contentModifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "content_modified_at")
        canNonOwnersInvite = try BoxJSONDecoder.optionalDecode(json: json, forKey: "can_non_owners_invite")
        trashedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "trashed_at")
        purgedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "purged_at")
        syncState = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "sync_state")
        hasCollaborations = try BoxJSONDecoder.optionalDecode(json: json, forKey: "has_collaborations")
        permissions = try BoxJSONDecoder.optionalDecode(json: json, forKey: "permissions")
        tags = try BoxJSONDecoder.optionalDecode(json: json, forKey: "tags")
        allowedSharedLinkAccessLevels = try BoxJSONDecoder.optionalDecodeEnumCollection(json: json, forKey: "allowed_shared_link_access_levels")
        allowedInviteeRoles = try BoxJSONDecoder.optionalDecode(json: json, forKey: "allowed_invitee_roles")
        isExternallyOwned = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_externally_owned")
        collections = json["collections"] as? [[String: String]]
    }
}
