import Foundation

/// Represents a folder restored from the trash.
public class TrashFolderRestored: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case etag
        case type
        case sequenceId = "sequence_id"
        case name
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
    }

    /// The unique identifier that represent a folder.
    /// 
    /// The ID for any folder can be determined
    /// by visiting a folder in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/folders/123`
    /// the `folder_id` is `123`.
    public let id: String?

    /// The HTTP `etag` of this folder. This can be used within some API
    /// endpoints in the `If-Match` and `If-None-Match` headers to only
    /// perform changes on the folder if (no) changes have happened.
    @CodableTriState public private(set) var etag: String?

    /// `folder`
    public let type: TrashFolderRestoredTypeField?

    public let sequenceId: String?

    /// The name of the folder.
    public let name: String?

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

    public let pathCollection: TrashFolderRestoredPathCollectionField?

    public let createdBy: UserMini?

    public let modifiedBy: UserMini?

    /// The time at which this folder was put in the
    /// trash - becomes `null` after restore.
    @CodableTriState public private(set) var trashedAt: String?

    /// The time at which this folder is expected to be purged
    /// from the trash  - becomes `null` after restore.
    @CodableTriState public private(set) var purgedAt: String?

    /// The date and time at which this folder was originally
    /// created.
    @CodableTriState public private(set) var contentCreatedAt: Date?

    /// The date and time at which this folder was last updated.
    @CodableTriState public private(set) var contentModifiedAt: Date?

    public let ownedBy: UserMini?

    /// The shared link for this file. This will
    /// be `null` if a folder had been trashed, even though the original shared
    /// link does become active again.
    @CodableTriState public private(set) var sharedLink: String?

    /// The folder upload email for this folder. This will
    /// be `null` if a folder has been trashed, even though the original upload
    /// email does become active again.
    @CodableTriState public private(set) var folderUploadEmail: String?

    public let parent: FolderMini?

    /// Defines if this item has been deleted or not.
    /// 
    /// * `active` when the item has is not in the trash
    /// * `trashed` when the item has been moved to the trash but not deleted
    /// * `deleted` when the item has been permanently deleted.
    public let itemStatus: TrashFolderRestoredItemStatusField?

    /// Initializer for a TrashFolderRestored.
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
    ///   - trashedAt: The time at which this folder was put in the
    ///     trash - becomes `null` after restore.
    ///   - purgedAt: The time at which this folder is expected to be purged
    ///     from the trash  - becomes `null` after restore.
    ///   - contentCreatedAt: The date and time at which this folder was originally
    ///     created.
    ///   - contentModifiedAt: The date and time at which this folder was last updated.
    ///   - ownedBy: 
    ///   - sharedLink: The shared link for this file. This will
    ///     be `null` if a folder had been trashed, even though the original shared
    ///     link does become active again.
    ///   - folderUploadEmail: The folder upload email for this folder. This will
    ///     be `null` if a folder has been trashed, even though the original upload
    ///     email does become active again.
    ///   - parent: 
    ///   - itemStatus: Defines if this item has been deleted or not.
    ///     
    ///     * `active` when the item has is not in the trash
    ///     * `trashed` when the item has been moved to the trash but not deleted
    ///     * `deleted` when the item has been permanently deleted.
    public init(id: String? = nil, etag: TriStateField<String> = nil, type: TrashFolderRestoredTypeField? = nil, sequenceId: String? = nil, name: String? = nil, createdAt: TriStateField<Date> = nil, modifiedAt: TriStateField<Date> = nil, description: String? = nil, size: Int64? = nil, pathCollection: TrashFolderRestoredPathCollectionField? = nil, createdBy: UserMini? = nil, modifiedBy: UserMini? = nil, trashedAt: TriStateField<String> = nil, purgedAt: TriStateField<String> = nil, contentCreatedAt: TriStateField<Date> = nil, contentModifiedAt: TriStateField<Date> = nil, ownedBy: UserMini? = nil, sharedLink: TriStateField<String> = nil, folderUploadEmail: TriStateField<String> = nil, parent: FolderMini? = nil, itemStatus: TrashFolderRestoredItemStatusField? = nil) {
        self.id = id
        self._etag = CodableTriState(state: etag)
        self.type = type
        self.sequenceId = sequenceId
        self.name = name
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
        self.parent = parent
        self.itemStatus = itemStatus
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
        type = try container.decodeIfPresent(TrashFolderRestoredTypeField.self, forKey: .type)
        sequenceId = try container.decodeIfPresent(String.self, forKey: .sequenceId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        size = try container.decodeIfPresent(Int64.self, forKey: .size)
        pathCollection = try container.decodeIfPresent(TrashFolderRestoredPathCollectionField.self, forKey: .pathCollection)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        modifiedBy = try container.decodeIfPresent(UserMini.self, forKey: .modifiedBy)
        trashedAt = try container.decodeIfPresent(String.self, forKey: .trashedAt)
        purgedAt = try container.decodeIfPresent(String.self, forKey: .purgedAt)
        contentCreatedAt = try container.decodeDateTimeIfPresent(forKey: .contentCreatedAt)
        contentModifiedAt = try container.decodeDateTimeIfPresent(forKey: .contentModifiedAt)
        ownedBy = try container.decodeIfPresent(UserMini.self, forKey: .ownedBy)
        sharedLink = try container.decodeIfPresent(String.self, forKey: .sharedLink)
        folderUploadEmail = try container.decodeIfPresent(String.self, forKey: .folderUploadEmail)
        parent = try container.decodeIfPresent(FolderMini.self, forKey: .parent)
        itemStatus = try container.decodeIfPresent(TrashFolderRestoredItemStatusField.self, forKey: .itemStatus)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(field: _etag.state, forKey: .etag)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(sequenceId, forKey: .sequenceId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeDateTime(field: _createdAt.state, forKey: .createdAt)
        try container.encodeDateTime(field: _modifiedAt.state, forKey: .modifiedAt)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(pathCollection, forKey: .pathCollection)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try container.encode(field: _trashedAt.state, forKey: .trashedAt)
        try container.encode(field: _purgedAt.state, forKey: .purgedAt)
        try container.encodeDateTime(field: _contentCreatedAt.state, forKey: .contentCreatedAt)
        try container.encodeDateTime(field: _contentModifiedAt.state, forKey: .contentModifiedAt)
        try container.encodeIfPresent(ownedBy, forKey: .ownedBy)
        try container.encode(field: _sharedLink.state, forKey: .sharedLink)
        try container.encode(field: _folderUploadEmail.state, forKey: .folderUploadEmail)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(itemStatus, forKey: .itemStatus)
    }

}
