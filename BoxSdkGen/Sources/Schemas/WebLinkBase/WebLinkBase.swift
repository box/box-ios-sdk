import Foundation

/// Web links are objects that point to URLs. These objects
/// are also known as bookmarks within the Box web application.
/// 
/// Web link objects are treated similarly to file objects,
/// they will also support most actions that apply to regular files.
public class WebLinkBase: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case etag
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this web link.
    public let id: String

    /// The value will always be `web_link`.
    public let type: WebLinkBaseTypeField

    /// The entity tag of this web link. Used with `If-Match`
    /// headers.
    public let etag: String?

    /// Initializer for a WebLinkBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this web link.
    ///   - type: The value will always be `web_link`.
    ///   - etag: The entity tag of this web link. Used with `If-Match`
    ///     headers.
    public init(id: String, type: WebLinkBaseTypeField = WebLinkBaseTypeField.webLink, etag: String? = nil) {
        self.id = id
        self.type = type
        self.etag = etag
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(WebLinkBaseTypeField.self, forKey: .type)
        etag = try container.decodeIfPresent(String.self, forKey: .etag)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(etag, forKey: .etag)
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
