import Foundation

/// The bare basic representation of a folder, the minimal
/// amount of fields returned when using the `fields` query
/// parameter.
public class FolderBase: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case etag
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier that represent a folder.
    /// 
    /// The ID for any folder can be determined
    /// by visiting a folder in the web application
    /// and copying the ID from the URL. For example,
    /// for the URL `https://*.app.box.com/folders/123`
    /// the `folder_id` is `123`.
    public let id: String

    /// The HTTP `etag` of this folder. This can be used within some API
    /// endpoints in the `If-Match` and `If-None-Match` headers to only
    /// perform changes on the folder if (no) changes have happened.
    @CodableTriState public private(set) var etag: String?

    /// The value will always be `folder`.
    public let type: FolderBaseTypeField

    /// Initializer for a FolderBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a folder.
    ///     
    ///     The ID for any folder can be determined
    ///     by visiting a folder in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/folders/123`
    ///     the `folder_id` is `123`.
    ///   - etag: The HTTP `etag` of this folder. This can be used within some API
    ///     endpoints in the `If-Match` and `If-None-Match` headers to only
    ///     perform changes on the folder if (no) changes have happened.
    ///   - type: The value will always be `folder`.
    public init(id: String, etag: TriStateField<String> = nil, type: FolderBaseTypeField = FolderBaseTypeField.folder) {
        self.id = id
        self._etag = CodableTriState(state: etag)
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
        type = try container.decode(FolderBaseTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(field: _etag.state, forKey: .etag)
        try container.encode(type, forKey: .type)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
