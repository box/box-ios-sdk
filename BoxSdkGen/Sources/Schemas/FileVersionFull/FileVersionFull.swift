import Foundation

/// A full representation of a file version, as can be returned from any
/// file version API endpoints by default
public class FileVersionFull: FileVersion {
    private enum CodingKeys: String, CodingKey {
        case versionNumber = "version_number"
    }

    /// The version number of this file version
    public let versionNumber: String?

    /// Initializer for a FileVersionFull.
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
    ///   - versionNumber: The version number of this file version
    public init(id: String, type: FileVersionBaseTypeField = FileVersionBaseTypeField.fileVersion, sha1: String? = nil, name: String? = nil, size: Int64? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, modifiedBy: UserMini? = nil, trashedAt: TriStateField<Date> = nil, trashedBy: UserMini? = nil, restoredAt: TriStateField<Date> = nil, restoredBy: UserMini? = nil, purgedAt: TriStateField<Date> = nil, uploaderDisplayName: String? = nil, versionNumber: String? = nil) {
        self.versionNumber = versionNumber

        super.init(id: id, type: type, sha1: sha1, name: name, size: size, createdAt: createdAt, modifiedAt: modifiedAt, modifiedBy: modifiedBy, trashedAt: trashedAt, trashedBy: trashedBy, restoredAt: restoredAt, restoredBy: restoredBy, purgedAt: purgedAt, uploaderDisplayName: uploaderDisplayName)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        versionNumber = try container.decodeIfPresent(String.self, forKey: .versionNumber)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(versionNumber, forKey: .versionNumber)
        try super.encode(to: encoder)
    }

}
