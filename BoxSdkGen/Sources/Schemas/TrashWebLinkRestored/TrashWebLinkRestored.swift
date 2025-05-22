import Foundation

/// Represents a web link restored from the trash.
public class TrashWebLinkRestored: Codable {
    private enum CodingKeys: String, CodingKey {
        case sequenceId = "sequence_id"
        case pathCollection = "path_collection"
        case type
        case id
        case etag
        case name
        case url
        case parent
        case description
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case trashedAt = "trashed_at"
        case purgedAt = "purged_at"
        case createdBy = "created_by"
        case modifiedBy = "modified_by"
        case ownedBy = "owned_by"
        case sharedLink = "shared_link"
        case itemStatus = "item_status"
    }

    public let sequenceId: String

    public let pathCollection: TrashWebLinkRestoredPathCollectionField

    /// `web_link`
    public let type: TrashWebLinkRestoredTypeField?

    /// The unique identifier for this web link
    public let id: String?

    /// The entity tag of this web link. Used with `If-Match`
    /// headers.
    public let etag: String?

    /// The name of the web link
    public let name: String?

    /// The URL this web link points to
    public let url: String?

    public let parent: FolderMini?

    /// The description accompanying the web link. This is
    /// visible within the Box web application.
    public let description: String?

    /// When this file was created on Box’s servers.
    public let createdAt: Date?

    /// When this file was last updated on the Box
    /// servers.
    public let modifiedAt: Date?

    /// The time at which this bookmark was put in the
    /// trash - becomes `null` after restore.
    @CodableTriState public private(set) var trashedAt: String?

    /// The time at which this bookmark will be permanently
    /// deleted - becomes `null` after restore.
    @CodableTriState public private(set) var purgedAt: String?

    public let createdBy: UserMini?

    public let modifiedBy: UserMini?

    public let ownedBy: UserMini?

    /// The shared link for this bookmark. This will
    /// be `null` if a bookmark had been trashed, even though the original shared
    /// link does become active again.
    @CodableTriState public private(set) var sharedLink: String?

    /// Whether this item is deleted or not. Values include `active`,
    /// `trashed` if the file has been moved to the trash, and `deleted` if
    /// the file has been permanently deleted
    public let itemStatus: TrashWebLinkRestoredItemStatusField?

    /// Initializer for a TrashWebLinkRestored.
    ///
    /// - Parameters:
    ///   - sequenceId: 
    ///   - pathCollection: 
    ///   - type: `web_link`
    ///   - id: The unique identifier for this web link
    ///   - etag: The entity tag of this web link. Used with `If-Match`
    ///     headers.
    ///   - name: The name of the web link
    ///   - url: The URL this web link points to
    ///   - parent: 
    ///   - description: The description accompanying the web link. This is
    ///     visible within the Box web application.
    ///   - createdAt: When this file was created on Box’s servers.
    ///   - modifiedAt: When this file was last updated on the Box
    ///     servers.
    ///   - trashedAt: The time at which this bookmark was put in the
    ///     trash - becomes `null` after restore.
    ///   - purgedAt: The time at which this bookmark will be permanently
    ///     deleted - becomes `null` after restore.
    ///   - createdBy: 
    ///   - modifiedBy: 
    ///   - ownedBy: 
    ///   - sharedLink: The shared link for this bookmark. This will
    ///     be `null` if a bookmark had been trashed, even though the original shared
    ///     link does become active again.
    ///   - itemStatus: Whether this item is deleted or not. Values include `active`,
    ///     `trashed` if the file has been moved to the trash, and `deleted` if
    ///     the file has been permanently deleted
    public init(sequenceId: String, pathCollection: TrashWebLinkRestoredPathCollectionField, type: TrashWebLinkRestoredTypeField? = nil, id: String? = nil, etag: String? = nil, name: String? = nil, url: String? = nil, parent: FolderMini? = nil, description: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, trashedAt: TriStateField<String> = nil, purgedAt: TriStateField<String> = nil, createdBy: UserMini? = nil, modifiedBy: UserMini? = nil, ownedBy: UserMini? = nil, sharedLink: TriStateField<String> = nil, itemStatus: TrashWebLinkRestoredItemStatusField? = nil) {
        self.sequenceId = sequenceId
        self.pathCollection = pathCollection
        self.type = type
        self.id = id
        self.etag = etag
        self.name = name
        self.url = url
        self.parent = parent
        self.description = description
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self._trashedAt = CodableTriState(state: trashedAt)
        self._purgedAt = CodableTriState(state: purgedAt)
        self.createdBy = createdBy
        self.modifiedBy = modifiedBy
        self.ownedBy = ownedBy
        self._sharedLink = CodableTriState(state: sharedLink)
        self.itemStatus = itemStatus
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sequenceId = try container.decode(String.self, forKey: .sequenceId)
        pathCollection = try container.decode(TrashWebLinkRestoredPathCollectionField.self, forKey: .pathCollection)
        type = try container.decodeIfPresent(TrashWebLinkRestoredTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        parent = try container.decodeIfPresent(FolderMini.self, forKey: .parent)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        trashedAt = try container.decodeIfPresent(String.self, forKey: .trashedAt)
        purgedAt = try container.decodeIfPresent(String.self, forKey: .purgedAt)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        modifiedBy = try container.decodeIfPresent(UserMini.self, forKey: .modifiedBy)
        ownedBy = try container.decodeIfPresent(UserMini.self, forKey: .ownedBy)
        sharedLink = try container.decodeIfPresent(String.self, forKey: .sharedLink)
        itemStatus = try container.decodeIfPresent(TrashWebLinkRestoredItemStatusField.self, forKey: .itemStatus)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sequenceId, forKey: .sequenceId)
        try container.encode(pathCollection, forKey: .pathCollection)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(etag, forKey: .etag)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encode(field: _trashedAt.state, forKey: .trashedAt)
        try container.encode(field: _purgedAt.state, forKey: .purgedAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try container.encodeIfPresent(ownedBy, forKey: .ownedBy)
        try container.encode(field: _sharedLink.state, forKey: .sharedLink)
        try container.encodeIfPresent(itemStatus, forKey: .itemStatus)
    }

}
