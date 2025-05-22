import Foundation

/// A standard representation of a folder, as returned from any
/// folder API endpoints by default
public class Folder: FolderMini {
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case description
        case size
        case pathCollection = "path_collection"
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case trashedAt = "trashed_at"
        case purgedAt = "purged_at"
        case contentCreatedAt = "content_created_at"
        case contentModifiedAt = "content_modified_at"
        case ownedBy = "owned_by"
        case sharedLink = "shared_link"
        case folderUploadEmail = "folder_upload_email"
        case parent
        case itemStatus = "item_status"
        case itemCollection = "item_collection"
    }

    /// The date and time when the folder was created. This value may
    /// be `null` for some folders such as the root folder or the trash
    /// folder.
    @CodableTriState public private(set) var createdAt: Date?

    /// The date and time when the folder was last updated. This value may
    /// be `null` for some folders such as the root folder or the trash
    /// folder.
    @CodableTriState public private(set) var modifiedAt: Date?

    public let description: String?

    /// The folder size in bytes.
    /// 
    /// Be careful parsing this integer as its
    /// value can get very large.
    public let size: Int64?

    public let pathCollection: FolderPathCollectionField?

    public let createdBy: UserMini?

    public let modifiedBy: UserMini?

    /// The time at which this folder was put in the trash.
    @CodableTriState public private(set) var trashedAt: Date?

    /// The time at which this folder is expected to be purged
    /// from the trash.
    @CodableTriState public private(set) var purgedAt: Date?

    /// The date and time at which this folder was originally
    /// created.
    @CodableTriState public private(set) var contentCreatedAt: Date?

    /// The date and time at which this folder was last updated.
    @CodableTriState public private(set) var contentModifiedAt: Date?

    public let ownedBy: UserMini?

    @CodableTriState public private(set) var sharedLink: FolderSharedLinkField?

    /// The `folder_upload_email` parameter is not `null` if one of the following options is **true**:
    /// 
    ///   * The **Allow uploads to this folder via email** and the **Only allow email uploads from collaborators in this folder** are [enabled for a folder in the Admin Console](https://support.box.com/hc/en-us/articles/360043697534-Upload-to-Box-Through-Email), and the user has at least **Upload** permissions granted.
    /// 
    ///   * The **Allow uploads to this folder via email** setting is enabled for a folder in the Admin Console, and the **Only allow email uploads from collaborators in this folder** setting is deactivated (unchecked).
    /// 
    /// If the conditions are not met, the parameter will have the following value: `folder_upload_email: null`
    @CodableTriState public private(set) var folderUploadEmail: FolderFolderUploadEmailField?

    @CodableTriState public private(set) var parent: FolderMini?

    /// Defines if this item has been deleted or not.
    /// 
    /// * `active` when the item has is not in the trash
    /// * `trashed` when the item has been moved to the trash but not deleted
    /// * `deleted` when the item has been permanently deleted.
    public let itemStatus: FolderItemStatusField?

    public let itemCollection: Items?

    /// Initializer for a Folder.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting a folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folders/123`
    ///     the `folder_id` is `123`.
    ///   - etag: The HTTP `etag` of this folder. This can be used within some API
    ///     endpoints in the `If-Match` and `If-None-Match` headers to only
    ///     perform changes on the folder if (no) changes have happened.
    ///   - type: `folder`
    ///   - sequenceId: 
    ///   - name: The name of the folder.
    ///   - createdAt: The date and time when the folder was created. This value may
    ///     be `null` for some folders such as the root folder or the trash
    ///     folder.
    ///   - modifiedAt: The date and time when the folder was last updated. This value may
    ///     be `null` for some folders such as the root folder or the trash
    ///     folder.
    ///   - description: 
    ///   - size: The folder size in bytes.
    ///     
    ///     Be careful parsing this integer as its
    ///     value can get very large.
    ///   - pathCollection: 
    ///   - createdBy: 
    ///   - modifiedBy: 
    ///   - trashedAt: The time at which this folder was put in the trash.
    ///   - purgedAt: The time at which this folder is expected to be purged
    ///     from the trash.
    ///   - contentCreatedAt: The date and time at which this folder was originally
    ///     created.
    ///   - contentModifiedAt: The date and time at which this folder was last updated.
    ///   - ownedBy: 
    ///   - sharedLink: 
    ///   - folderUploadEmail: The `folder_upload_email` parameter is not `null` if one of the following options is **true**:
    ///     
    ///       * The **Allow uploads to this folder via email** and the **Only allow email uploads from collaborators in this folder** are [enabled for a folder in the Admin Console](https://support.box.com/hc/en-us/articles/360043697534-Upload-to-Box-Through-Email), and the user has at least **Upload** permissions granted.
    ///     
    ///       * The **Allow uploads to this folder via email** setting is enabled for a folder in the Admin Console, and the **Only allow email uploads from collaborators in this folder** setting is deactivated (unchecked).
    ///     
    ///     If the conditions are not met, the parameter will have the following value: `folder_upload_email: null`
    ///   - parent: 
    ///   - itemStatus: Defines if this item has been deleted or not.
    ///     
    ///     * `active` when the item has is not in the trash
    ///     * `trashed` when the item has been moved to the trash but not deleted
    ///     * `deleted` when the item has been permanently deleted.
    ///   - itemCollection: 
    public init(id: String, etag: TriStateField<String> = nil, type: FolderBaseTypeField = FolderBaseTypeField.folder, sequenceId: String? = nil, name: String? = nil, createdAt: TriStateField<Date> = nil, modifiedAt: TriStateField<Date> = nil, description: String? = nil, size: Int64? = nil, pathCollection: FolderPathCollectionField? = nil, createdBy: UserMini? = nil, modifiedBy: UserMini? = nil, trashedAt: TriStateField<Date> = nil, purgedAt: TriStateField<Date> = nil, contentCreatedAt: TriStateField<Date> = nil, contentModifiedAt: TriStateField<Date> = nil, ownedBy: UserMini? = nil, sharedLink: TriStateField<FolderSharedLinkField> = nil, folderUploadEmail: TriStateField<FolderFolderUploadEmailField> = nil, parent: TriStateField<FolderMini> = nil, itemStatus: FolderItemStatusField? = nil, itemCollection: Items? = nil) {
        self._createdAt = CodableTriState(state: createdAt)
        self._modifiedAt = CodableTriState(state: modifiedAt)
        self.description = description
        self.size = size
        self.pathCollection = pathCollection
        self.createdBy = createdBy
        self.modifiedBy = modifiedBy
        self._trashedAt = CodableTriState(state: trashedAt)
        self._purgedAt = CodableTriState(state: purgedAt)
        self._contentCreatedAt = CodableTriState(state: contentCreatedAt)
        self._contentModifiedAt = CodableTriState(state: contentModifiedAt)
        self.ownedBy = ownedBy
        self._sharedLink = CodableTriState(state: sharedLink)
        self._folderUploadEmail = CodableTriState(state: folderUploadEmail)
        self._parent = CodableTriState(state: parent)
        self.itemStatus = itemStatus
        self.itemCollection = itemCollection

        super.init(id: id, etag: etag, type: type, sequenceId: sequenceId, name: name)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        size = try container.decodeIfPresent(Int64.self, forKey: .size)
        pathCollection = try container.decodeIfPresent(FolderPathCollectionField.self, forKey: .pathCollection)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        modifiedBy = try container.decodeIfPresent(UserMini.self, forKey: .modifiedBy)
        trashedAt = try container.decodeDateTimeIfPresent(forKey: .trashedAt)
        purgedAt = try container.decodeDateTimeIfPresent(forKey: .purgedAt)
        contentCreatedAt = try container.decodeDateTimeIfPresent(forKey: .contentCreatedAt)
        contentModifiedAt = try container.decodeDateTimeIfPresent(forKey: .contentModifiedAt)
        ownedBy = try container.decodeIfPresent(UserMini.self, forKey: .ownedBy)
        sharedLink = try container.decodeIfPresent(FolderSharedLinkField.self, forKey: .sharedLink)
        folderUploadEmail = try container.decodeIfPresent(FolderFolderUploadEmailField.self, forKey: .folderUploadEmail)
        parent = try container.decodeIfPresent(FolderMini.self, forKey: .parent)
        itemStatus = try container.decodeIfPresent(FolderItemStatusField.self, forKey: .itemStatus)
        itemCollection = try container.decodeIfPresent(Items.self, forKey: .itemCollection)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeDateTime(field: _createdAt.state, forKey: .createdAt)
        try container.encodeDateTime(field: _modifiedAt.state, forKey: .modifiedAt)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(pathCollection, forKey: .pathCollection)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try container.encodeDateTime(field: _trashedAt.state, forKey: .trashedAt)
        try container.encodeDateTime(field: _purgedAt.state, forKey: .purgedAt)
        try container.encodeDateTime(field: _contentCreatedAt.state, forKey: .contentCreatedAt)
        try container.encodeDateTime(field: _contentModifiedAt.state, forKey: .contentModifiedAt)
        try container.encodeIfPresent(ownedBy, forKey: .ownedBy)
        try container.encode(field: _sharedLink.state, forKey: .sharedLink)
        try container.encode(field: _folderUploadEmail.state, forKey: .folderUploadEmail)
        try container.encode(field: _parent.state, forKey: .parent)
        try container.encodeIfPresent(itemStatus, forKey: .itemStatus)
        try container.encodeIfPresent(itemCollection, forKey: .itemCollection)
        try super.encode(to: encoder)
    }

}
