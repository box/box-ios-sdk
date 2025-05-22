import Foundation

/// Represents a file restored from the trash.
public class TrashFileRestored: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case sequenceId = "sequence_id"
        case sha1
        case description
        case size
        case pathCollection = "path_collection"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case modifiedBy = "modified_by"
        case ownedBy = "owned_by"
        case itemStatus = "item_status"
        case etag
        case type
        case name
        case fileVersion = "file_version"
        case trashedAt = "trashed_at"
        case purgedAt = "purged_at"
        case contentCreatedAt = "content_created_at"
        case contentModifiedAt = "content_modified_at"
        case createdBy = "created_by"
        case sharedLink = "shared_link"
        case parent
    }

    /// The unique identifier that represent a file.
    /// 
    /// The ID for any file can be determined
    /// by visiting a file in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/files/123`
    /// the `file_id` is `123`.
    public let id: String

    public let sequenceId: String

    /// The SHA1 hash of the file. This can be used to compare the contents
    /// of a file on Box with a local file.
    public let sha1: String

    /// The optional description of this file
    public let description: String

    /// The file size in bytes. Be careful parsing this integer as it can
    /// get very large and cause an integer overflow.
    public let size: Int64

    public let pathCollection: TrashFileRestoredPathCollectionField

    /// The date and time when the file was created on Box.
    public let createdAt: Date

    /// The date and time when the file was last updated on Box.
    public let modifiedAt: Date

    public let modifiedBy: UserMini

    public let ownedBy: UserMini

    /// Defines if this item has been deleted or not.
    /// 
    /// * `active` when the item has is not in the trash
    /// * `trashed` when the item has been moved to the trash but not deleted
    /// * `deleted` when the item has been permanently deleted.
    public let itemStatus: TrashFileRestoredItemStatusField

    /// The HTTP `etag` of this file. This can be used within some API
    /// endpoints in the `If-Match` and `If-None-Match` headers to only
    /// perform changes on the file if (no) changes have happened.
    @CodableTriState public private(set) var etag: String?

    /// `file`
    public let type: TrashFileRestoredTypeField

    /// The name of the file
    public let name: String?

    public let fileVersion: FileVersionMini?

    /// The time at which this file was put in the
    /// trash - becomes `null` after restore.
    @CodableTriState public private(set) var trashedAt: String?

    /// The time at which this file is expected to be purged
    /// from the trash  - becomes `null` after restore.
    @CodableTriState public private(set) var purgedAt: String?

    /// The date and time at which this file was originally
    /// created, which might be before it was uploaded to Box.
    @CodableTriState public private(set) var contentCreatedAt: Date?

    /// The date and time at which this file was last updated,
    /// which might be before it was uploaded to Box.
    @CodableTriState public private(set) var contentModifiedAt: Date?

    public let createdBy: UserMini?

    /// The shared link for this file. This will
    /// be `null` if a file had been trashed, even though the original shared
    /// link does become active again.
    @CodableTriState public private(set) var sharedLink: String?

    public let parent: FolderMini?

    /// Initializer for a TrashFileRestored.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a file.
    ///     
    ///     The ID for any file can be determined
    ///     by visiting a file in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/files/123`
    ///     the `file_id` is `123`.
    ///   - sequenceId: 
    ///   - sha1: The SHA1 hash of the file. This can be used to compare the contents
    ///     of a file on Box with a local file.
    ///   - description: The optional description of this file
    ///   - size: The file size in bytes. Be careful parsing this integer as it can
    ///     get very large and cause an integer overflow.
    ///   - pathCollection: 
    ///   - createdAt: The date and time when the file was created on Box.
    ///   - modifiedAt: The date and time when the file was last updated on Box.
    ///   - modifiedBy: 
    ///   - ownedBy: 
    ///   - itemStatus: Defines if this item has been deleted or not.
    ///     
    ///     * `active` when the item has is not in the trash
    ///     * `trashed` when the item has been moved to the trash but not deleted
    ///     * `deleted` when the item has been permanently deleted.
    ///   - etag: The HTTP `etag` of this file. This can be used within some API
    ///     endpoints in the `If-Match` and `If-None-Match` headers to only
    ///     perform changes on the file if (no) changes have happened.
    ///   - type: `file`
    ///   - name: The name of the file
    ///   - fileVersion: 
    ///   - trashedAt: The time at which this file was put in the
    ///     trash - becomes `null` after restore.
    ///   - purgedAt: The time at which this file is expected to be purged
    ///     from the trash  - becomes `null` after restore.
    ///   - contentCreatedAt: The date and time at which this file was originally
    ///     created, which might be before it was uploaded to Box.
    ///   - contentModifiedAt: The date and time at which this file was last updated,
    ///     which might be before it was uploaded to Box.
    ///   - createdBy: 
    ///   - sharedLink: The shared link for this file. This will
    ///     be `null` if a file had been trashed, even though the original shared
    ///     link does become active again.
    ///   - parent: 
    public init(id: String, sequenceId: String, sha1: String, description: String, size: Int64, pathCollection: TrashFileRestoredPathCollectionField, createdAt: Date, modifiedAt: Date, modifiedBy: UserMini, ownedBy: UserMini, itemStatus: TrashFileRestoredItemStatusField, etag: TriStateField<String> = nil, type: TrashFileRestoredTypeField = TrashFileRestoredTypeField.file, name: String? = nil, fileVersion: FileVersionMini? = nil, trashedAt: TriStateField<String> = nil, purgedAt: TriStateField<String> = nil, contentCreatedAt: TriStateField<Date> = nil, contentModifiedAt: TriStateField<Date> = nil, createdBy: UserMini? = nil, sharedLink: TriStateField<String> = nil, parent: FolderMini? = nil) {
        self.id = id
        self.sequenceId = sequenceId
        self.sha1 = sha1
        self.description = description
        self.size = size
        self.pathCollection = pathCollection
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.modifiedBy = modifiedBy
        self.ownedBy = ownedBy
        self.itemStatus = itemStatus
        self._etag = CodableTriState(state: etag)
        self.type = type
        self.name = name
        self.fileVersion = fileVersion
        self._trashedAt = CodableTriState(state: trashedAt)
        self._purgedAt = CodableTriState(state: purgedAt)
        self._contentCreatedAt = CodableTriState(state: contentCreatedAt)
        self._contentModifiedAt = CodableTriState(state: contentModifiedAt)
        self.createdBy = createdBy
        self._sharedLink = CodableTriState(state: sharedLink)
        self.parent = parent
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        sequenceId = try container.decode(String.self, forKey: .sequenceId)
        sha1 = try container.decode(String.self, forKey: .sha1)
        description = try container.decode(String.self, forKey: .description)
        size = try container.decode(Int64.self, forKey: .size)
        pathCollection = try container.decode(TrashFileRestoredPathCollectionField.self, forKey: .pathCollection)
        createdAt = try container.decodeDateTime(forKey: .createdAt)
        modifiedAt = try container.decodeDateTime(forKey: .modifiedAt)
        modifiedBy = try container.decode(UserMini.self, forKey: .modifiedBy)
        ownedBy = try container.decode(UserMini.self, forKey: .ownedBy)
        itemStatus = try container.decode(TrashFileRestoredItemStatusField.self, forKey: .itemStatus)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
        type = try container.decode(TrashFileRestoredTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        fileVersion = try container.decodeIfPresent(FileVersionMini.self, forKey: .fileVersion)
        trashedAt = try container.decodeIfPresent(String.self, forKey: .trashedAt)
        purgedAt = try container.decodeIfPresent(String.self, forKey: .purgedAt)
        contentCreatedAt = try container.decodeDateTimeIfPresent(forKey: .contentCreatedAt)
        contentModifiedAt = try container.decodeDateTimeIfPresent(forKey: .contentModifiedAt)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        sharedLink = try container.decodeIfPresent(String.self, forKey: .sharedLink)
        parent = try container.decodeIfPresent(FolderMini.self, forKey: .parent)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(sequenceId, forKey: .sequenceId)
        try container.encode(sha1, forKey: .sha1)
        try container.encode(description, forKey: .description)
        try container.encode(size, forKey: .size)
        try container.encode(pathCollection, forKey: .pathCollection)
        try container.encodeDateTime(field: createdAt, forKey: .createdAt)
        try container.encodeDateTime(field: modifiedAt, forKey: .modifiedAt)
        try container.encode(modifiedBy, forKey: .modifiedBy)
        try container.encode(ownedBy, forKey: .ownedBy)
        try container.encode(itemStatus, forKey: .itemStatus)
        try container.encode(field: _etag.state, forKey: .etag)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(fileVersion, forKey: .fileVersion)
        try container.encode(field: _trashedAt.state, forKey: .trashedAt)
        try container.encode(field: _purgedAt.state, forKey: .purgedAt)
        try container.encodeDateTime(field: _contentCreatedAt.state, forKey: .contentCreatedAt)
        try container.encodeDateTime(field: _contentModifiedAt.state, forKey: .contentModifiedAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encode(field: _sharedLink.state, forKey: .sharedLink)
        try container.encodeIfPresent(parent, forKey: .parent)
    }

}
