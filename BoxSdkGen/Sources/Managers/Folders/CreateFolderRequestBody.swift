import Foundation

public class CreateFolderRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case parent
        case folderUploadEmail = "folder_upload_email"
        case syncState = "sync_state"
    }

    /// The name for the new folder.
    /// 
    /// There are some restrictions to the file name. Names containing
    /// non-printable ASCII characters, forward and backward slashes
    /// (`/`, `\`), as well as names with trailing spaces are
    /// prohibited.
    /// 
    /// Additionally, the names `.` and `..` are
    /// not allowed either.
    public let name: String

    /// The parent folder to create the new folder within.
    public let parent: CreateFolderRequestBodyParentField

    public let folderUploadEmail: CreateFolderRequestBodyFolderUploadEmailField?

    /// Specifies whether a folder should be synced to a
    /// user's device or not. This is used by Box Sync
    /// (discontinued) and is not used by Box Drive.
    public let syncState: CreateFolderRequestBodySyncStateField?

    /// Initializer for a CreateFolderRequestBody.
    ///
    /// - Parameters:
    ///   - name: The name for the new folder.
    ///     
    ///     There are some restrictions to the file name. Names containing
    ///     non-printable ASCII characters, forward and backward slashes
    ///     (`/`, `\`), as well as names with trailing spaces are
    ///     prohibited.
    ///     
    ///     Additionally, the names `.` and `..` are
    ///     not allowed either.
    ///   - parent: The parent folder to create the new folder within.
    ///   - folderUploadEmail: 
    ///   - syncState: Specifies whether a folder should be synced to a
    ///     user's device or not. This is used by Box Sync
    ///     (discontinued) and is not used by Box Drive.
    public init(name: String, parent: CreateFolderRequestBodyParentField, folderUploadEmail: CreateFolderRequestBodyFolderUploadEmailField? = nil, syncState: CreateFolderRequestBodySyncStateField? = nil) {
        self.name = name
        self.parent = parent
        self.folderUploadEmail = folderUploadEmail
        self.syncState = syncState
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        parent = try container.decode(CreateFolderRequestBodyParentField.self, forKey: .parent)
        folderUploadEmail = try container.decodeIfPresent(CreateFolderRequestBodyFolderUploadEmailField.self, forKey: .folderUploadEmail)
        syncState = try container.decodeIfPresent(CreateFolderRequestBodySyncStateField.self, forKey: .syncState)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(parent, forKey: .parent)
        try container.encodeIfPresent(folderUploadEmail, forKey: .folderUploadEmail)
        try container.encodeIfPresent(syncState, forKey: .syncState)
    }

}
