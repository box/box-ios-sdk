import Foundation

/// A representation of a file that is used to show.
public class FileConflict: FileMini {
    private enum CodingKeys: CodingKey {
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// Initializer for a FileConflict.
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
    ///   - type: The value will always be `file`.
    ///   - sequenceId: 
    ///   - name: The name of the file.
    ///   - sha1: The SHA1 hash of the file. This can be used to compare the contents
    ///     of a file on Box with a local file.
    ///   - fileVersion: 
    public override init(id: String, etag: TriStateField<String> = nil, type: FileBaseTypeField = FileBaseTypeField.file, sequenceId: String? = nil, name: String? = nil, sha1: String? = nil, fileVersion: FileVersionMini? = nil) {
        super.init(id: id, etag: etag, type: type, sequenceId: sequenceId, name: name, sha1: sha1, fileVersion: fileVersion)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
