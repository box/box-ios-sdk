import Foundation

/// A standard representation of a file version
public class FileVersion: FileVersionMini {
    private enum CodingKeys: String, CodingKey {
        case name
        case size
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case modifiedBy = "modified_by"
        case trashedAt = "trashed_at"
        case trashedBy = "trashed_by"
        case restoredAt = "restored_at"
        case restoredBy = "restored_by"
        case purgedAt = "purged_at"
        case uploaderDisplayName = "uploader_display_name"
    }

    /// The name of the file version
    public let name: String?

    /// Size of the file version in bytes
    public let size: Int64?

    /// When the file version object was created
    public let createdAt: Date?

    /// When the file version object was last updated
    public let modifiedAt: Date?

    public let modifiedBy: UserMini?

    /// When the file version object was trashed.
    @CodableTriState public private(set) var trashedAt: Date?

    public let trashedBy: UserMini?

    /// When the file version was restored from the trash.
    @CodableTriState public private(set) var restoredAt: Date?

    public let restoredBy: UserMini?

    /// When the file version object will be permanently deleted.
    @CodableTriState public private(set) var purgedAt: Date?

    public let uploaderDisplayName: String?

    /// Initializer for a FileVersion.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a file version.
    ///   - type: `file_version`
    ///   - sha1: The SHA1 hash of this version of the file.
    ///   - name: The name of the file version
    ///   - size: Size of the file version in bytes
    ///   - createdAt: When the file version object was created
    ///   - modifiedAt: When the file version object was last updated
    ///   - modifiedBy: 
    ///   - trashedAt: When the file version object was trashed.
    ///   - trashedBy: 
    ///   - restoredAt: When the file version was restored from the trash.
    ///   - restoredBy: 
    ///   - purgedAt: When the file version object will be permanently deleted.
    ///   - uploaderDisplayName: 
    public init(id: String, type: FileVersionBaseTypeField = FileVersionBaseTypeField.fileVersion, sha1: String? = nil, name: String? = nil, size: Int64? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, modifiedBy: UserMini? = nil, trashedAt: TriStateField<Date> = nil, trashedBy: UserMini? = nil, restoredAt: TriStateField<Date> = nil, restoredBy: UserMini? = nil, purgedAt: TriStateField<Date> = nil, uploaderDisplayName: String? = nil) {
        self.name = name
        self.size = size
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.modifiedBy = modifiedBy
        self._trashedAt = CodableTriState(state: trashedAt)
        self.trashedBy = trashedBy
        self._restoredAt = CodableTriState(state: restoredAt)
        self.restoredBy = restoredBy
        self._purgedAt = CodableTriState(state: purgedAt)
        self.uploaderDisplayName = uploaderDisplayName

        super.init(id: id, type: type, sha1: sha1)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        size = try container.decodeIfPresent(Int64.self, forKey: .size)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        modifiedBy = try container.decodeIfPresent(UserMini.self, forKey: .modifiedBy)
        trashedAt = try container.decodeDateTimeIfPresent(forKey: .trashedAt)
        trashedBy = try container.decodeIfPresent(UserMini.self, forKey: .trashedBy)
        restoredAt = try container.decodeDateTimeIfPresent(forKey: .restoredAt)
        restoredBy = try container.decodeIfPresent(UserMini.self, forKey: .restoredBy)
        purgedAt = try container.decodeDateTimeIfPresent(forKey: .purgedAt)
        uploaderDisplayName = try container.decodeIfPresent(String.self, forKey: .uploaderDisplayName)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeIfPresent(modifiedBy, forKey: .modifiedBy)
        try container.encodeDateTime(field: _trashedAt.state, forKey: .trashedAt)
        try container.encodeIfPresent(trashedBy, forKey: .trashedBy)
        try container.encodeDateTime(field: _restoredAt.state, forKey: .restoredAt)
        try container.encodeIfPresent(restoredBy, forKey: .restoredBy)
        try container.encodeDateTime(field: _purgedAt.state, forKey: .purgedAt)
        try container.encodeIfPresent(uploaderDisplayName, forKey: .uploaderDisplayName)
        try super.encode(to: encoder)
    }

}
