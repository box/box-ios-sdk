import Foundation

/// A list of Hub Document Pages.
public class HubDocumentPagesV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case entries
        case type
        case limit
        case nextMarker = "next_marker"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Ordered list of pages.
    public let entries: [HubDocumentPageV2025R0]

    /// The value will always be `document_pages`.
    public let type: HubDocumentPagesV2025R0TypeField

    /// The limit that was used for these entries. This will be the same as the
    /// `limit` query parameter unless that value exceeded the maximum value
    /// allowed. The maximum value varies by API.
    public let limit: Int64?

    /// The marker for the start of the next page of results.
    @CodableTriState public private(set) var nextMarker: String?

    /// Initializer for a HubDocumentPagesV2025R0.
    ///
    /// - Parameters:
    ///   - entries: Ordered list of pages.
    ///   - type: The value will always be `document_pages`.
    ///   - limit: The limit that was used for these entries. This will be the same as the
    ///     `limit` query parameter unless that value exceeded the maximum value
    ///     allowed. The maximum value varies by API.
    ///   - nextMarker: The marker for the start of the next page of results.
    public init(entries: [HubDocumentPageV2025R0], type: HubDocumentPagesV2025R0TypeField = HubDocumentPagesV2025R0TypeField.documentPages, limit: Int64? = nil, nextMarker: TriStateField<String> = nil) {
        self.entries = entries
        self.type = type
        self.limit = limit
        self._nextMarker = CodableTriState(state: nextMarker)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decode([HubDocumentPageV2025R0].self, forKey: .entries)
        type = try container.decode(HubDocumentPagesV2025R0TypeField.self, forKey: .type)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entries, forKey: .entries)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encode(field: _nextMarker.state, forKey: .nextMarker)
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
