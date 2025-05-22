import Foundation

/// The bare basic representation of a file, the minimal
/// amount of fields returned when using the `fields` query
/// parameter.
public class FileBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case etag
        case type
    }

    /// The unique identifier that represent a file.
    /// 
    /// The ID for any file can be determined
    /// by visiting a file in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/files/123`
    /// the `file_id` is `123`.
    public let id: String

    /// The HTTP `etag` of this file. This can be used within some API
    /// endpoints in the `If-Match` and `If-None-Match` headers to only
    /// perform changes on the file if (no) changes have happened.
    @CodableTriState public private(set) var etag: String?

    /// `file`
    public let type: FileBaseTypeField

    /// Initializer for a FileBase.
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
    public init(id: String, etag: TriStateField<String> = nil, type: FileBaseTypeField = FileBaseTypeField.file) {
        self.id = id
        self._etag = CodableTriState(state: etag)
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
        type = try container.decode(FileBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(field: _etag.state, forKey: .etag)
        try container.encode(type, forKey: .type)
    }

}
