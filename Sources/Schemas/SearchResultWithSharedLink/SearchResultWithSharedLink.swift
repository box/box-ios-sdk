import Foundation

/// A single of files, folder or web link that matched the search query,
/// including the additional information about the shared link through
/// which the item has been shared with the user.
/// 
/// This response format is only returned when the
/// `include_recent_shared_links` query parameter has been set to `true`.
public class SearchResultWithSharedLink: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case accessibleViaSharedLink = "accessible_via_shared_link"
        case item
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The optional shared link through which the user has access to this
    /// item. This value is only returned for items for which the user has
    /// recently accessed the file through a shared link. For all other
    /// items this value will return `null`.
    public let accessibleViaSharedLink: String?

    public let item: FileFullOrFolderFullOrWebLink?

    /// The result type. The value is always `search_result`.
    public let type: String?

    /// Initializer for a SearchResultWithSharedLink.
    ///
    /// - Parameters:
    ///   - accessibleViaSharedLink: The optional shared link through which the user has access to this
    ///     item. This value is only returned for items for which the user has
    ///     recently accessed the file through a shared link. For all other
    ///     items this value will return `null`.
    ///   - item: 
    ///   - type: The result type. The value is always `search_result`.
    public init(accessibleViaSharedLink: String? = nil, item: FileFullOrFolderFullOrWebLink? = nil, type: String? = nil) {
        self.accessibleViaSharedLink = accessibleViaSharedLink
        self.item = item
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessibleViaSharedLink = try container.decodeIfPresent(String.self, forKey: .accessibleViaSharedLink)
        item = try container.decodeIfPresent(FileFullOrFolderFullOrWebLink.self, forKey: .item)
        type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(accessibleViaSharedLink, forKey: .accessibleViaSharedLink)
        try container.encodeIfPresent(item, forKey: .item)
        try container.encodeIfPresent(type, forKey: .type)
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
