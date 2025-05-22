import Foundation

public class CreateFolderLockRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case folder
        case lockedOperations = "locked_operations"
    }

    /// The folder to apply the lock to.
    public let folder: CreateFolderLockRequestBodyFolderField

    /// The operations to lock for the folder. If `locked_operations` is
    /// included in the request, both `move` and `delete` must also be
    /// included and both set to `true`.
    public let lockedOperations: CreateFolderLockRequestBodyLockedOperationsField?

    /// Initializer for a CreateFolderLockRequestBody.
    ///
    /// - Parameters:
    ///   - folder: The folder to apply the lock to.
    ///   - lockedOperations: The operations to lock for the folder. If `locked_operations` is
    ///     included in the request, both `move` and `delete` must also be
    ///     included and both set to `true`.
    public init(folder: CreateFolderLockRequestBodyFolderField, lockedOperations: CreateFolderLockRequestBodyLockedOperationsField? = nil) {
        self.folder = folder
        self.lockedOperations = lockedOperations
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folder = try container.decode(CreateFolderLockRequestBodyFolderField.self, forKey: .folder)
        lockedOperations = try container.decodeIfPresent(CreateFolderLockRequestBodyLockedOperationsField.self, forKey: .lockedOperations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folder, forKey: .folder)
        try container.encodeIfPresent(lockedOperations, forKey: .lockedOperations)
    }

}
