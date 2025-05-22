import Foundation

public class UpdateFileByIdRequestBodyLockField: Codable {
    private enum CodingKeys: String, CodingKey {
        case access
        case expiresAt = "expires_at"
        case isDownloadPrevented = "is_download_prevented"
    }

    /// The type of this object.
    public let access: UpdateFileByIdRequestBodyLockAccessField?

    /// Defines the time at which the lock expires.
    public let expiresAt: Date?

    /// Defines if the file can be downloaded while it is locked.
    public let isDownloadPrevented: Bool?

    /// Initializer for a UpdateFileByIdRequestBodyLockField.
    ///
    /// - Parameters:
    ///   - access: The type of this object.
    ///   - expiresAt: Defines the time at which the lock expires.
    ///   - isDownloadPrevented: Defines if the file can be downloaded while it is locked.
    public init(access: UpdateFileByIdRequestBodyLockAccessField? = nil, expiresAt: Date? = nil, isDownloadPrevented: Bool? = nil) {
        self.access = access
        self.expiresAt = expiresAt
        self.isDownloadPrevented = isDownloadPrevented
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access = try container.decodeIfPresent(UpdateFileByIdRequestBodyLockAccessField.self, forKey: .access)
        expiresAt = try container.decodeDateTimeIfPresent(forKey: .expiresAt)
        isDownloadPrevented = try container.decodeIfPresent(Bool.self, forKey: .isDownloadPrevented)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(access, forKey: .access)
        try container.encodeDateTimeIfPresent(field: expiresAt, forKey: .expiresAt)
        try container.encodeIfPresent(isDownloadPrevented, forKey: .isDownloadPrevented)
    }

}
