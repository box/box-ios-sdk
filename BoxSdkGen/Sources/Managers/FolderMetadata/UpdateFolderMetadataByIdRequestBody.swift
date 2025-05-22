import Foundation

public class UpdateFolderMetadataByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case op
        case path
        case value
        case from
    }

    /// The type of change to perform on the template. Some
    /// of these are hazardous as they will change existing templates.
    public let op: UpdateFolderMetadataByIdRequestBodyOpField?

    /// The location in the metadata JSON object
    /// to apply the changes to, in the format of a
    /// [JSON-Pointer](https://tools.ietf.org/html/rfc6901).
    /// 
    /// The path must always be prefixed with a `/` to represent the root
    /// of the template. The characters `~` and `/` are reserved
    /// characters and must be escaped in the key.
    public let path: String?

    public let value: MetadataInstanceValue?

    /// The location in the metadata JSON object to move or copy a value
    /// from. Required for `move` or `copy` operations and must be in the
    /// format of a [JSON-Pointer](https://tools.ietf.org/html/rfc6901).
    public let from: String?

    /// Initializer for a UpdateFolderMetadataByIdRequestBody.
    ///
    /// - Parameters:
    ///   - op: The type of change to perform on the template. Some
    ///     of these are hazardous as they will change existing templates.
    ///   - path: The location in the metadata JSON object
    ///     to apply the changes to, in the format of a
    ///     [JSON-Pointer](https://tools.ietf.org/html/rfc6901).
    ///     
    ///     The path must always be prefixed with a `/` to represent the root
    ///     of the template. The characters `~` and `/` are reserved
    ///     characters and must be escaped in the key.
    ///   - value: 
    ///   - from: The location in the metadata JSON object to move or copy a value
    ///     from. Required for `move` or `copy` operations and must be in the
    ///     format of a [JSON-Pointer](https://tools.ietf.org/html/rfc6901).
    public init(op: UpdateFolderMetadataByIdRequestBodyOpField? = nil, path: String? = nil, value: MetadataInstanceValue? = nil, from: String? = nil) {
        self.op = op
        self.path = path
        self.value = value
        self.from = from
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        op = try container.decodeIfPresent(UpdateFolderMetadataByIdRequestBodyOpField.self, forKey: .op)
        path = try container.decodeIfPresent(String.self, forKey: .path)
        value = try container.decodeIfPresent(MetadataInstanceValue.self, forKey: .value)
        from = try container.decodeIfPresent(String.self, forKey: .from)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(op, forKey: .op)
        try container.encodeIfPresent(path, forKey: .path)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encodeIfPresent(from, forKey: .from)
    }

}
