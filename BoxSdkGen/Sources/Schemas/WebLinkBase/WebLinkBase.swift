import Foundation

/// Web links are objects that point to URLs. These objects
/// are also known as bookmarks within the Box web application.
/// 
/// Web link objects are treated similarly to file objects,
/// they will also support most actions that apply to regular files.
public class WebLinkBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case etag
    }

    /// The unique identifier for this web link
    public let id: String

    /// `web_link`
    public let type: WebLinkBaseTypeField

    /// The entity tag of this web link. Used with `If-Match`
    /// headers.
    public let etag: String?

    /// Initializer for a WebLinkBase.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this web link
    ///   - type: `web_link`
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

}
