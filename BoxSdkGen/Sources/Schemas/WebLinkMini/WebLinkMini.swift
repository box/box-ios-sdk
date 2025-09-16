import Foundation

/// Web links are objects that point to URLs. These objects
/// are also known as bookmarks within the Box web application.
/// 
/// Web link objects are treated similarly to file objects,
/// they will also support most actions that apply to regular files.
public class WebLinkMini: WebLinkBase {
    private enum CodingKeys: String, CodingKey {
        case url
        case sequenceId = "sequence_id"
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The URL this web link points to.
    public let url: String?

    public let sequenceId: String?

    /// The name of the web link.
    public let name: String?

    /// Initializer for a WebLinkMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this web link.
    ///   - type: The value will always be `web_link`.
    ///   - etag: The entity tag of this web link. Used with `If-Match`
    ///     headers.
    ///   - url: The URL this web link points to.
    ///   - sequenceId: 
    ///   - name: The name of the web link.
    public init(id: String, type: WebLinkBaseTypeField = WebLinkBaseTypeField.webLink, etag: String? = nil, url: String? = nil, sequenceId: String? = nil, name: String? = nil) {
        self.url = url
        self.sequenceId = sequenceId
        self.name = name

        super.init(id: id, type: type, etag: etag)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        sequenceId = try container.decodeIfPresent(String.self, forKey: .sequenceId)
        name = try container.decodeIfPresent(String.self, forKey: .name)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(sequenceId, forKey: .sequenceId)
        try container.encodeIfPresent(name, forKey: .name)
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
