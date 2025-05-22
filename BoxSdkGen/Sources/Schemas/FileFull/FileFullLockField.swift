import Foundation

public class FileFullLockField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case createdBy = "created_by"
        case createdAt = "created_at"
        case expiredAt = "expired_at"
        case isDownloadPrevented = "is_download_prevented"
        case appType = "app_type"
    }

    /// The unique identifier for this lock
    public let id: String?

    /// `lock`
    public let type: FileFullLockTypeField?

    public let createdBy: UserMini?

    /// The time this lock was created at.
    public let createdAt: Date?

    /// The time this lock is to expire at, which might be in the past.
    public let expiredAt: Date?

    /// Whether or not the file can be downloaded while locked.
    public let isDownloadPrevented: Bool?

    /// If the lock is managed by an application rather than a user, this
    /// field identifies the type of the application that holds the lock.
    /// This is an open enum and may be extended with additional values in
    /// the future.
    @CodableTriState public private(set) var appType: FileFullLockAppTypeField?

    /// Initializer for a FileFullLockField.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this lock
    ///   - type: `lock`
    ///   - createdBy: 
    ///   - createdAt: The time this lock was created at.
    ///   - expiredAt: The time this lock is to expire at, which might be in the past.
    ///   - isDownloadPrevented: Whether or not the file can be downloaded while locked.
    ///   - appType: If the lock is managed by an application rather than a user, this
    ///     field identifies the type of the application that holds the lock.
    ///     This is an open enum and may be extended with additional values in
    ///     the future.
    public init(id: String? = nil, type: FileFullLockTypeField? = nil, createdBy: UserMini? = nil, createdAt: Date? = nil, expiredAt: Date? = nil, isDownloadPrevented: Bool? = nil, appType: TriStateField<FileFullLockAppTypeField> = nil) {
        self.id = id
        self.type = type
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.expiredAt = expiredAt
        self.isDownloadPrevented = isDownloadPrevented
        self._appType = CodableTriState(state: appType)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(FileFullLockTypeField.self, forKey: .type)
        createdBy = try container.decodeIfPresent(UserMini.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        expiredAt = try container.decodeDateTimeIfPresent(forKey: .expiredAt)
        isDownloadPrevented = try container.decodeIfPresent(Bool.self, forKey: .isDownloadPrevented)
        appType = try container.decodeIfPresent(FileFullLockAppTypeField.self, forKey: .appType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: expiredAt, forKey: .expiredAt)
        try container.encodeIfPresent(isDownloadPrevented, forKey: .isDownloadPrevented)
        try container.encode(field: _appType.state, forKey: .appType)
    }

}
