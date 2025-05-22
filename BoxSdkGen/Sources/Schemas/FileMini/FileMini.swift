import Foundation

/// A mini representation of a file, used when
/// nested under another resource.
public class FileMini: FileBase {
    private enum CodingKeys: String, CodingKey {
        case sequenceId = "sequence_id"
        case name
        case sha1
        case fileVersion = "file_version"
    }

    public let sequenceId: String?

    /// The name of the file
    public let name: String?

    /// The SHA1 hash of the file. This can be used to compare the contents
    /// of a file on Box with a local file.
    public let sha1: String?

    public let fileVersion: FileVersionMini?

    /// Initializer for a FileMini.
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
    public init(id: String, etag: TriStateField<String> = nil, type: FileBaseTypeField = FileBaseTypeField.file, sequenceId: String? = nil, name: String? = nil, sha1: String? = nil, fileVersion: FileVersionMini? = nil) {
        self.sequenceId = sequenceId
        self.name = name
        self.sha1 = sha1
        self.fileVersion = fileVersion

        super.init(id: id, etag: etag, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sequenceId = try container.decodeIfPresent(String.self, forKey: .sequenceId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)
        fileVersion = try container.decodeIfPresent(FileVersionMini.self, forKey: .fileVersion)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sequenceId, forKey: .sequenceId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(sha1, forKey: .sha1)
        try container.encodeIfPresent(fileVersion, forKey: .fileVersion)
        try super.encode(to: encoder)
    }

}
