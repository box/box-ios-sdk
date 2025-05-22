import Foundation

/// A standard representation of a file, as returned from any
/// file API endpoints by default
public class File: FileMini {
    private enum CodingKeys: String, CodingKey {
        case description
        case size
        case pathCollection = "path_collection"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case trashedAt = "trashed_at"
        case purgedAt = "purged_at"
        case contentCreatedAt = "content_created_at"
        case contentModifiedAt = "content_modified_at"
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case ownedBy = "owned_by"
        case sharedLink = "shared_link"
        case parent
        case itemStatus = "item_status"
    }

    /// The optional description of this file.
    /// If the description exceeds 255 characters, the first 255 characters
    /// are set as a file description and the rest of it is ignored.
    public let description: String?

    /// The file size in bytes. Be careful parsing this integer as it can
    /// get very large and cause an integer overflow.
    public let size: Int64?

    public let pathCollection: FilePathCollectionField?

    /// The date and time when the file was created on Box.
    public let createdAt: Date?

    /// The date and time when the file was last updated on Box.
    public let modifiedAt: Date?

    /// The time at which this file was put in the trash.
    @CodableTriState public private(set) var trashedAt: Date?

    /// The time at which this file is expected to be purged
    /// from the trash.
    @CodableTriState public private(set) var purgedAt: Date?

    /// The date and time at which this file was originally
    /// created, which might be before it was uploaded to Box.
    @CodableTriState public private(set) var contentCreatedAt: Date?

    /// The date and time at which this file was last updated,
    /// which might be before it was uploaded to Box.
    @CodableTriState public private(set) var contentModifiedAt: Date?

    public let createdBy: UserMini?

    public let modifiedBy: UserMini?

    public let ownedBy: UserMini?

    public let sharedLink: FileSharedLinkField?

    @CodableTriState public private(set) var parent: FolderMini?

    /// Defines if this item has been deleted or not.
    /// 
    /// * `active` when the item has is not in the trash
    /// * `trashed` when the item has been moved to the trash but not deleted
    /// * `deleted` when the item has been permanently deleted.
    public let itemStatus: FileItemStatusField?

    /// Initializer for a File.
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
    public init(id: String, etag: TriStateField<String> = nil, type: FileBaseTypeField = FileBaseTypeField.file, sequenceId: String? = nil, name: String? = nil, sha1: String? = nil, fileVersion: FileVersionMini? = nil, description: String? = nil, size: Int64? = nil, pathCollection: FilePathCollectionField? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, trashedAt: TriStateField<Date> = nil, purgedAt: TriStateField<Date> = nil, contentCreatedAt: TriStateField<Date> = nil, contentModifiedAt: TriStateField<Date> = nil, createdBy: UserMini? = nil, modifiedBy: UserMini? = nil, ownedBy: UserMini? = nil, sharedLink: FileSharedLinkField? = nil, parent: TriStateField<FolderMini> = nil, itemStatus: FileItemStatusField? = nil) {
        self.description = description
        self.size = size
        self.pathCollection = pathCollection
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self._trashedAt = CodableTriState(state: trashedAt)
        self._purgedAt = CodableTriState(state: purgedAt)
        self._contentCreatedAt = CodableTriState(state: contentCreatedAt)
        self._contentModifiedAt = CodableTriState(state: contentModifiedAt)
        self.createdBy = createdBy
        self.modifiedBy = modifiedBy
        self.ownedBy = ownedBy
        self.sharedLink = sharedLink
        self._parent = CodableTriState(state: parent)
        self.itemStatus = itemStatus

        super.init(id: id, etag: etag, type: type, sequenceId: sequenceId, name: name, sha1: sha1, fileVersion: fileVersion)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        size = try container.decodeIfPresent(Int64.self, forKey: .size)
        pathCollection = try container.decodeIfPresent(FilePathCollectionField.self, forKey: .pathCollection)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        trashedAt = try container.decodeDateTimeIfPresent(forKey: .trashedAt)
        purgedAt = try container.decodeDateTimeIfPresent(forKey: .purgedAt)
        contentCreatedAt = try container.decodeDateTimeIfPresent(forKey: .contentCreatedAt)
        contentModifiedAt = try container.decodeDateTimeIfPresent(forKey: .contentModifiedAt)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        modifiedBy = try container.decodeIfPresent(UserMini.self, forKey: .modifiedBy)
        ownedBy = try container.decodeIfPresent(UserMini.self, forKey: .ownedBy)
        sharedLink = try container.decodeIfPresent(FileSharedLinkField.self, forKey: .sharedLink)
        parent = try container.decodeIfPresent(FolderMini.self, forKey: .parent)
        itemStatus = try container.decodeIfPresent(FileItemStatusField.self, forKey: .itemStatus)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(pathCollection, forKey: .pathCollection)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeDateTime(field: _trashedAt.state, forKey: .trashedAt)
        try container.encodeDateTime(field: _purgedAt.state, forKey: .purgedAt)
        try container.encodeDateTime(field: _contentCreatedAt.state, forKey: .contentCreatedAt)
        try container.encodeDateTime(field: _contentModifiedAt.state, forKey: .contentModifiedAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try container.encodeIfPresent(ownedBy, forKey: .ownedBy)
        try container.encodeIfPresent(sharedLink, forKey: .sharedLink)
        try container.encode(field: _parent.state, forKey: .parent)
        try container.encodeIfPresent(itemStatus, forKey: .itemStatus)
        try super.encode(to: encoder)
    }

}
