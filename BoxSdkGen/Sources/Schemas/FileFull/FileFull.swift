import Foundation

/// A full representation of a file, as can be returned from any
/// file API endpoints by default
public class FileFull: File {
    private enum CodingKeys: String, CodingKey {
        case versionNumber = "version_number"
        case commentCount = "comment_count"
        case permissions
        case tags
        case lock
        case extension_ = "extension"
        case isPackage = "is_package"
        case expiringEmbedLink = "expiring_embed_link"
        case watermarkInfo = "watermark_info"
        case isAccessibleViaSharedLink = "is_accessible_via_shared_link"
        case allowedInviteeRoles = "allowed_invitee_roles"
        case isExternallyOwned = "is_externally_owned"
        case hasCollaborations = "has_collaborations"
        case metadata
        case expiresAt = "expires_at"
        case representations
        case classification
        case uploaderDisplayName = "uploader_display_name"
        case dispositionAt = "disposition_at"
        case sharedLinkPermissionOptions = "shared_link_permission_options"
        case isAssociatedWithAppItem = "is_associated_with_app_item"
    }

    /// The version number of this file
    public let versionNumber: String?

    /// The number of comments on this file
    public let commentCount: Int64?

    public let permissions: FileFullPermissionsField?

    public let tags: [String]?

    @CodableTriState public private(set) var lock: FileFullLockField?

    /// Indicates the (optional) file extension for this file. By default,
    /// this is set to an empty string.
    public let extension_: String?

    /// Indicates if the file is a package. Packages are commonly used
    /// by Mac Applications and can include iWork files.
    public let isPackage: Bool?

    public let expiringEmbedLink: FileFullExpiringEmbedLinkField?

    public let watermarkInfo: FileFullWatermarkInfoField?

    /// Specifies if the file can be accessed
    /// via the direct shared link or a shared link
    /// to a parent folder.
    public let isAccessibleViaSharedLink: Bool?

    /// A list of the types of roles that user can be invited at
    /// when sharing this file.
    public let allowedInviteeRoles: [FileFullAllowedInviteeRolesField]?

    /// Specifies if this file is owned by a user outside of the
    /// authenticated enterprise.
    public let isExternallyOwned: Bool?

    /// Specifies if this file has any other collaborators.
    public let hasCollaborations: Bool?

    public let metadata: FileFullMetadataField?

    /// When the file will automatically be deleted
    @CodableTriState public private(set) var expiresAt: Date?

    public let representations: FileFullRepresentationsField?

    public let classification: FileFullClassificationField?

    public let uploaderDisplayName: String?

    /// The retention expiration timestamp for the given file
    @CodableTriState public private(set) var dispositionAt: Date?

    /// A list of the types of roles that user can be invited at
    /// when sharing this file.
    @CodableTriState public private(set) var sharedLinkPermissionOptions: [FileFullSharedLinkPermissionOptionsField]?

    /// This field will return true if the file or any ancestor of the file
    /// is associated with at least one app item. Note that this will return
    /// true even if the context user does not have access to the app item(s)
    /// associated with the file.
    public let isAssociatedWithAppItem: Bool?
    
    
    public internal(set) var rawData: [String: Any]? = nil

    /// Initializer for a FileFull.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///   - etag: The HTTP `etag` of this file. This can be used within some API
    ///     endpoints in the `If-Match` and `If-None-Match` headers to only
    ///     perform changes on the file if (no) changes have happened.
    ///   - type: `file`
    ///   - sequenceId: 
    ///   - name: The name of the file
    ///   - sha1: The SHA1 hash of the file. This can be used to compare the contents
    ///     of a file on Box with a local file.
    ///   - fileVersion: 
    ///   - description: The optional description of this file.
    ///     If the description exceeds 255 characters, the first 255 characters
    ///     are set as a file description and the rest of it is ignored.
    ///   - size: The file size in bytes. Be careful parsing this integer as it can
    ///     get very large and cause an integer overflow.
    ///   - pathCollection: 
    ///   - createdAt: The date and time when the file was created on Box.
    ///   - modifiedAt: The date and time when the file was last updated on Box.
    ///   - trashedAt: The time at which this file was put in the trash.
    ///   - purgedAt: The time at which this file is expected to be purged
    ///     from the trash.
    ///   - contentCreatedAt: The date and time at which this file was originally
    ///     created, which might be before it was uploaded to Box.
    ///   - contentModifiedAt: The date and time at which this file was last updated,
    ///     which might be before it was uploaded to Box.
    ///   - createdBy: 
    ///   - modifiedBy: 
    ///   - ownedBy: 
    ///   - sharedLink: 
    ///   - parent: 
    ///   - itemStatus: Defines if this item has been deleted or not.
    ///     
    ///     * `active` when the item has is not in the trash
    ///     * `trashed` when the item has been moved to the trash but not deleted
    ///     * `deleted` when the item has been permanently deleted.
    ///   - versionNumber: The version number of this file
    ///   - commentCount: The number of comments on this file
    ///   - permissions: 
    ///   - tags: 
    ///   - lock: 
    ///   - extension_: Indicates the (optional) file extension for this file. By default,
    ///     this is set to an empty string.
    ///   - isPackage: Indicates if the file is a package. Packages are commonly used
    ///     by Mac Applications and can include iWork files.
    ///   - expiringEmbedLink: 
    ///   - watermarkInfo: 
    ///   - isAccessibleViaSharedLink: Specifies if the file can be accessed
    ///     via the direct shared link or a shared link
    ///     to a parent folder.
    ///   - allowedInviteeRoles: A list of the types of roles that user can be invited at
    ///     when sharing this file.
    ///   - isExternallyOwned: Specifies if this file is owned by a user outside of the
    ///     authenticated enterprise.
    ///   - hasCollaborations: Specifies if this file has any other collaborators.
    ///   - metadata: 
    ///   - expiresAt: When the file will automatically be deleted
    ///   - representations: 
    ///   - classification: 
    ///   - uploaderDisplayName: 
    ///   - dispositionAt: The retention expiration timestamp for the given file
    ///   - sharedLinkPermissionOptions: A list of the types of roles that user can be invited at
    ///     when sharing this file.
    ///   - isAssociatedWithAppItem: This field will return true if the file or any ancestor of the file
    ///     is associated with at least one app item. Note that this will return
    ///     true even if the context user does not have access to the app item(s)
    ///     associated with the file.
    public init(id: String, etag: TriStateField<String> = nil, type: FileBaseTypeField = FileBaseTypeField.file, sequenceId: String? = nil, name: String? = nil, sha1: String? = nil, fileVersion: FileVersionMini? = nil, description: String? = nil, size: Int64? = nil, pathCollection: FilePathCollectionField? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, trashedAt: TriStateField<Date> = nil, purgedAt: TriStateField<Date> = nil, contentCreatedAt: TriStateField<Date> = nil, contentModifiedAt: TriStateField<Date> = nil, createdBy: UserMini? = nil, modifiedBy: UserMini? = nil, ownedBy: UserMini? = nil, sharedLink: FileSharedLinkField? = nil, parent: TriStateField<FolderMini> = nil, itemStatus: FileItemStatusField? = nil, versionNumber: String? = nil, commentCount: Int64? = nil, permissions: FileFullPermissionsField? = nil, tags: [String]? = nil, lock: TriStateField<FileFullLockField> = nil, extension_: String? = nil, isPackage: Bool? = nil, expiringEmbedLink: FileFullExpiringEmbedLinkField? = nil, watermarkInfo: FileFullWatermarkInfoField? = nil, isAccessibleViaSharedLink: Bool? = nil, allowedInviteeRoles: [FileFullAllowedInviteeRolesField]? = nil, isExternallyOwned: Bool? = nil, hasCollaborations: Bool? = nil, metadata: FileFullMetadataField? = nil, expiresAt: TriStateField<Date> = nil, representations: FileFullRepresentationsField? = nil, classification: FileFullClassificationField? = nil, uploaderDisplayName: String? = nil, dispositionAt: TriStateField<Date> = nil, sharedLinkPermissionOptions: TriStateField<[FileFullSharedLinkPermissionOptionsField]> = nil, isAssociatedWithAppItem: Bool? = nil) {
        self.versionNumber = versionNumber
        self.commentCount = commentCount
        self.permissions = permissions
        self.tags = tags
        self._lock = CodableTriState(state: lock)
        self.extension_ = extension_
        self.isPackage = isPackage
        self.expiringEmbedLink = expiringEmbedLink
        self.watermarkInfo = watermarkInfo
        self.isAccessibleViaSharedLink = isAccessibleViaSharedLink
        self.allowedInviteeRoles = allowedInviteeRoles
        self.isExternallyOwned = isExternallyOwned
        self.hasCollaborations = hasCollaborations
        self.metadata = metadata
        self._expiresAt = CodableTriState(state: expiresAt)
        self.representations = representations
        self.classification = classification
        self.uploaderDisplayName = uploaderDisplayName
        self._dispositionAt = CodableTriState(state: dispositionAt)
        self._sharedLinkPermissionOptions = CodableTriState(state: sharedLinkPermissionOptions)
        self.isAssociatedWithAppItem = isAssociatedWithAppItem

        super.init(id: id, etag: etag, type: type, sequenceId: sequenceId, name: name, sha1: sha1, fileVersion: fileVersion, description: description, size: size, pathCollection: pathCollection, createdAt: createdAt, modifiedAt: modifiedAt, trashedAt: trashedAt, purgedAt: purgedAt, contentCreatedAt: contentCreatedAt, contentModifiedAt: contentModifiedAt, createdBy: createdBy, modifiedBy: modifiedBy, ownedBy: ownedBy, sharedLink: sharedLink, parent: parent, itemStatus: itemStatus)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        versionNumber = try container.decodeIfPresent(String.self, forKey: .versionNumber)
        commentCount = try container.decodeIfPresent(Int64.self, forKey: .commentCount)
        permissions = try container.decodeIfPresent(FileFullPermissionsField.self, forKey: .permissions)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        lock = try container.decodeIfPresent(FileFullLockField.self, forKey: .lock)
        extension_ = try container.decodeIfPresent(String.self, forKey: .extension_)
        isPackage = try container.decodeIfPresent(Bool.self, forKey: .isPackage)
        expiringEmbedLink = try container.decodeIfPresent(FileFullExpiringEmbedLinkField.self, forKey: .expiringEmbedLink)
        watermarkInfo = try container.decodeIfPresent(FileFullWatermarkInfoField.self, forKey: .watermarkInfo)
        isAccessibleViaSharedLink = try container.decodeIfPresent(Bool.self, forKey: .isAccessibleViaSharedLink)
        allowedInviteeRoles = try container.decodeIfPresent([FileFullAllowedInviteeRolesField].self, forKey: .allowedInviteeRoles)
        isExternallyOwned = try container.decodeIfPresent(Bool.self, forKey: .isExternallyOwned)
        hasCollaborations = try container.decodeIfPresent(Bool.self, forKey: .hasCollaborations)
        metadata = try container.decodeIfPresent(FileFullMetadataField.self, forKey: .metadata)
        expiresAt = try container.decodeDateTimeIfPresent(forKey: .expiresAt)
        representations = try container.decodeIfPresent(FileFullRepresentationsField.self, forKey: .representations)
        classification = try container.decodeIfPresent(FileFullClassificationField.self, forKey: .classification)
        uploaderDisplayName = try container.decodeIfPresent(String.self, forKey: .uploaderDisplayName)
        dispositionAt = try container.decodeDateTimeIfPresent(forKey: .dispositionAt)
        sharedLinkPermissionOptions = try container.decodeIfPresent([FileFullSharedLinkPermissionOptionsField].self, forKey: .sharedLinkPermissionOptions)
        isAssociatedWithAppItem = try container.decodeIfPresent(Bool.self, forKey: .isAssociatedWithAppItem)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(versionNumber, forKey: .versionNumber)
        try container.encodeIfPresent(commentCount, forKey: .commentCount)
        try container.encodeIfPresent(permissions, forKey: .permissions)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encode(field: _lock.state, forKey: .lock)
        try container.encodeIfPresent(extension_, forKey: .extension_)
        try container.encodeIfPresent(isPackage, forKey: .isPackage)
        try container.encodeIfPresent(expiringEmbedLink, forKey: .expiringEmbedLink)
        try container.encodeIfPresent(watermarkInfo, forKey: .watermarkInfo)
        try container.encodeIfPresent(isAccessibleViaSharedLink, forKey: .isAccessibleViaSharedLink)
        try container.encodeIfPresent(allowedInviteeRoles, forKey: .allowedInviteeRoles)
        try container.encodeIfPresent(isExternallyOwned, forKey: .isExternallyOwned)
        try container.encodeIfPresent(hasCollaborations, forKey: .hasCollaborations)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeDateTime(field: _expiresAt.state, forKey: .expiresAt)
        try container.encodeIfPresent(representations, forKey: .representations)
        try container.encodeIfPresent(classification, forKey: .classification)
        try container.encodeIfPresent(uploaderDisplayName, forKey: .uploaderDisplayName)
        try container.encodeDateTime(field: _dispositionAt.state, forKey: .dispositionAt)
        try container.encode(field: _sharedLinkPermissionOptions.state, forKey: .sharedLinkPermissionOptions)
        try container.encodeIfPresent(isAssociatedWithAppItem, forKey: .isAssociatedWithAppItem)
        try super.encode(to: encoder)
    }
    
    func setRawData(_ rawData: [String: Any]?) {
        self.rawData = rawData
    }
}
