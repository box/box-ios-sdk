import Foundation

/// Represents a trashed folder.
public class TrashFolder: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case size
        case pathCollection = "path_collection"
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case ownedBy = "owned_by"
        case itemStatus = "item_status"
        case etag
        case type
        case sequenceId = "sequence_id"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case trashedAt = "trashed_at"
        case purgedAt = "purged_at"
        case contentCreatedAt = "content_created_at"
        case contentModifiedAt = "content_modified_at"
        case sharedLink = "shared_link"
        case folderUploadEmail = "folder_upload_email"
        case parent
    }

    /// The unique identifier that represent a folder.
    /// 
    /// The ID for any folder can be determined
    /// by visiting a folder in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/folders/123`
    /// the `folder_id` is `123`.
    public let id: String

    /// The name of the folder.
    public let name: String

    public let description: String

    /// The folder size in bytes.
    /// 
    /// Be careful parsing this integer as its
    /// value can get very large.
    public let size: Int64

    public let pathCollection: TrashFolderPathCollectionField

    public let createdBy: UserMini

    public let modifiedBy: UserMini

    public let ownedBy: UserMini

    /// Defines if this item has been deleted or not.
    /// 
    /// * `active` when the item has is not in the trash
    /// * `trashed` when the item has been moved to the trash but not deleted
    /// * `deleted` when the item has been permanently deleted.
    public let itemStatus: TrashFolderItemStatusField

    /// The HTTP `etag` of this folder. This can be used within some API
    /// endpoints in the `If-Match` and `If-None-Match` headers to only
    /// perform changes on the folder if (no) changes have happened.
    @CodableTriState public private(set) var etag: String?

    /// `folder`
    public let type: TrashFolderTypeField

    public let sequenceId: String?

    /// The date and time when the folder was created. This value may
    /// be `null` for some folders such as the root folder or the trash
    /// folder.
    @CodableTriState public private(set) var createdAt: Date?

    /// The date and time when the folder was last updated. This value may
    /// be `null` for some folders such as the root folder or the trash
    /// folder.
    @CodableTriState public private(set) var modifiedAt: Date?

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

    /// The shared link for this folder. This will
    /// be `null` if a folder has been trashed, since the link will no longer
    /// be active.
    @CodableTriState public private(set) var sharedLink: String?

    /// The folder upload email for this folder. This will
    /// be `null` if a folder has been trashed, since the upload will no longer
    /// work.
    @CodableTriState public private(set) var folderUploadEmail: String?

    public let parent: FolderMini?

    /// Initializer for a TrashFolder.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting a folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folders/123`
    ///     the `folder_id` is `123`.
    ///   - name: The name of the folder.
    ///   - description: 
    ///   - size: The folder size in bytes.
    ///     
    ///     Be careful parsing this integer as its
    ///     value can get very large.
    ///   - pathCollection: 
    ///   - createdBy: 
    ///   - modifiedBy: 
    ///   - ownedBy: 
    ///   - itemStatus: Defines if this item has been deleted or not.
    ///     
    ///     * `active` when the item has is not in the trash
    ///     * `trashed` when the item has been moved to the trash but not deleted
    ///     * `deleted` when the item has been permanently deleted.
    ///   - etag: The HTTP `etag` of this folder. This can be used within some API
    ///     endpoints in the `If-Match` and `If-None-Match` headers to only
    ///     perform changes on the folder if (no) changes have happened.
    ///   - type: `folder`
    ///   - sequenceId: 
    ///   - createdAt: The date and time when the folder was created. This value may
    ///     be `null` for some folders such as the root folder or the trash
    ///     folder.
    ///   - modifiedAt: The date and time when the folder was last updated. This value may
    ///     be `null` for some folders such as the root folder or the trash
    ///     folder.
    ///   - trashedAt: The time at which this folder was put in the trash.
    ///   - purgedAt: The time at which this folder is expected to be purged
    ///     from the trash.
    ///   - contentCreatedAt: The date and time at which this folder was originally
    ///     created.
    ///   - contentModifiedAt: The date and time at which this folder was last updated.
    ///   - sharedLink: The shared link for this folder. This will
    ///     be `null` if a folder has been trashed, since the link will no longer
    ///     be active.
    ///   - folderUploadEmail: The folder upload email for this folder. This will
    ///     be `null` if a folder has been trashed, since the upload will no longer
    ///     work.
    ///   - parent: 
    public init(id: String, name: String, description: String, size: Int64, pathCollection: TrashFolderPathCollectionField, createdBy: UserMini, modifiedBy: UserMini, ownedBy: UserMini, itemStatus: TrashFolderItemStatusField, etag: TriStateField<String> = nil, type: TrashFolderTypeField = TrashFolderTypeField.folder, sequenceId: String? = nil, createdAt: TriStateField<Date> = nil, modifiedAt: TriStateField<Date> = nil, trashedAt: TriStateField<Date> = nil, purgedAt: TriStateField<Date> = nil, contentCreatedAt: TriStateField<Date> = nil, contentModifiedAt: TriStateField<Date> = nil, sharedLink: TriStateField<String> = nil, folderUploadEmail: TriStateField<String> = nil, parent: FolderMini? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.size = size
        self.pathCollection = pathCollection
        self.createdBy = createdBy
        self.modifiedBy = modifiedBy
        self.ownedBy = ownedBy
        self.itemStatus = itemStatus
        self._etag = CodableTriState(state: etag)
        self.type = type
        self.sequenceId = sequenceId
        self._createdAt = CodableTriState(state: createdAt)
        self._modifiedAt = CodableTriState(state: modifiedAt)
        self._trashedAt = CodableTriState(state: trashedAt)
        self._purgedAt = CodableTriState(state: purgedAt)
        self._contentCreatedAt = CodableTriState(state: contentCreatedAt)
        self._contentModifiedAt = CodableTriState(state: contentModifiedAt)
        self._sharedLink = CodableTriState(state: sharedLink)
        self._folderUploadEmail = CodableTriState(state: folderUploadEmail)
        self.parent = parent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        size = try container.decode(Int64.self, forKey: .size)
        pathCollection = try container.decode(TrashFolderPathCollectionField.self, forKey: .pathCollection)
        createdBy = try container.decode(UserMini.self, forKey: .createdBy)
        modifiedBy = try container.decode(UserMini.self, forKey: .modifiedBy)
        ownedBy = try container.decode(UserMini.self, forKey: .ownedBy)
        itemStatus = try container.decode(TrashFolderItemStatusField.self, forKey: .itemStatus)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
        type = try container.decode(TrashFolderTypeField.self, forKey: .type)
        sequenceId = try container.decodeIfPresent(String.self, forKey: .sequenceId)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        trashedAt = try container.decodeDateTimeIfPresent(forKey: .trashedAt)
        purgedAt = try container.decodeDateTimeIfPresent(forKey: .purgedAt)
        contentCreatedAt = try container.decodeDateTimeIfPresent(forKey: .contentCreatedAt)
        contentModifiedAt = try container.decodeDateTimeIfPresent(forKey: .contentModifiedAt)
        sharedLink = try container.decodeIfPresent(String.self, forKey: .sharedLink)
        folderUploadEmail = try container.decodeIfPresent(String.self, forKey: .folderUploadEmail)
        parent = try container.decodeIfPresent(FolderMini.self, forKey: .parent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(size, forKey: .size)
        try container.encode(pathCollection, forKey: .pathCollection)
        try container.encode(createdBy, forKey: .createdBy)
        try container.encode(modifiedBy, forKey: .modifiedBy)
        try container.encode(ownedBy, forKey: .ownedBy)
        try container.encode(itemStatus, forKey: .itemStatus)
        try container.encode(field: _etag.state, forKey: .etag)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(sequenceId, forKey: .sequenceId)
        try container.encodeDateTime(field: _createdAt.state, forKey: .createdAt)
        try container.encodeDateTime(field: _modifiedAt.state, forKey: .modifiedAt)
        try container.encodeDateTime(field: _trashedAt.state, forKey: .trashedAt)
        try container.encodeDateTime(field: _purgedAt.state, forKey: .purgedAt)
        try container.encodeDateTime(field: _contentCreatedAt.state, forKey: .contentCreatedAt)
        try container.encodeDateTime(field: _contentModifiedAt.state, forKey: .contentModifiedAt)
        try container.encode(field: _sharedLink.state, forKey: .sharedLink)
        try container.encode(field: _folderUploadEmail.state, forKey: .folderUploadEmail)
        try container.encodeIfPresent(parent, forKey: .parent)
    }

}
