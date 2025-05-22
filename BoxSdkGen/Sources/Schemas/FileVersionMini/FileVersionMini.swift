import Foundation

/// A mini representation of a file version, used when
/// nested within another resource.
public class FileVersionMini: FileVersionBase {
    private enum CodingKeys: String, CodingKey {
        case sha1
    }

    /// The SHA1 hash of this version of the file.
    public let sha1: String?

    /// Initializer for a FileVersionMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a file version.
    ///   - type: `file_version`
    ///   - sha1: The SHA1 hash of this version of the file.
    public init(id: String, type: FileVersionBaseTypeField = FileVersionBaseTypeField.fileVersion, sha1: String? = nil) {
        self.sha1 = sha1

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sha1, forKey: .sha1)
        try super.encode(to: encoder)
    }

}
