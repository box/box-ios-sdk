import Foundation

/// Folder locks define access restrictions placed by folder owners
/// to prevent specific folders from being moved or deleted.
public class FolderLock: Codable {
    private enum CodingKeys: String, CodingKey {
        case folder
        case id
        case type
        case createdBy = "created_by"
        case createdAt = "created_at"
        case lockedOperations = "locked_operations"
        case lockType = "lock_type"
    }

    public let folder: FolderMini?

    /// The unique identifier for this folder lock.
    public let id: String?

    /// The object type, always `folder_lock`.
    public let type: String?

    public let createdBy: UserBase?

    /// When the folder lock object was created.
    public let createdAt: Date?

    /// The operations that have been locked. Currently the `move`
    /// and `delete` operations cannot be locked separately, and both need to be
    /// set to `true`.
    /// 
    public let lockedOperations: FolderLockLockedOperationsField?

    /// The lock type, always `freeze`.
    public let lockType: String?

    /// Initializer for a FolderLock.
    ///
    /// - Parameters:
    ///   - folder: 
    ///   - id: The unique identifier for this folder lock.
    ///   - type: The object type, always `folder_lock`.
    ///   - createdBy: 
    ///   - createdAt: When the folder lock object was created.
    ///   - lockedOperations: The operations that have been locked. Currently the `move`
    ///     and `delete` operations cannot be locked separately, and both need to be
    ///     set to `true`.
    ///     
    ///   - lockType: The lock type, always `freeze`.
    public init(folder: FolderMini? = nil, id: String? = nil, type: String? = nil, createdBy: UserBase? = nil, createdAt: Date? = nil, lockedOperations: FolderLockLockedOperationsField? = nil, lockType: String? = nil) {
        self.folder = folder
        self.id = id
        self.type = type
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.lockedOperations = lockedOperations
        self.lockType = lockType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folder = try container.decodeIfPresent(FolderMini.self, forKey: .folder)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        lockedOperations = try container.decodeIfPresent(FolderLockLockedOperationsField.self, forKey: .lockedOperations)
        lockType = try container.decodeIfPresent(String.self, forKey: .lockType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(folder, forKey: .folder)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(lockedOperations, forKey: .lockedOperations)
        try container.encodeIfPresent(lockType, forKey: .lockType)
    }

}
