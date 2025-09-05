import Foundation

/// A list of device pins.
public class DevicePinners: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case entries
        case limit
        case nextMarker = "next_marker"
        case order
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A list of device pins.
    public let entries: [DevicePinner]?

    /// The limit that was used for these entries. This will be the same as the
    /// `limit` query parameter unless that value exceeded the maximum value
    /// allowed.
    public let limit: Int64?

    /// The marker for the start of the next page of results.
    public let nextMarker: Int64?

    /// The order by which items are returned.
    public let order: [DevicePinnersOrderField]?

    /// Initializer for a DevicePinners.
    ///
    /// - Parameters:
    ///   - entries: A list of device pins.
    ///   - limit: The limit that was used for these entries. This will be the same as the
    ///     `limit` query parameter unless that value exceeded the maximum value
    ///     allowed.
    ///   - nextMarker: The marker for the start of the next page of results.
    ///   - order: The order by which items are returned.
    public init(entries: [DevicePinner]? = nil, limit: Int64? = nil, nextMarker: Int64? = nil, order: [DevicePinnersOrderField]? = nil) {
        self.entries = entries
        self.limit = limit
        self.nextMarker = nextMarker
        self.order = order
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decodeIfPresent([DevicePinner].self, forKey: .entries)
        limit = try container.decodeIfPresent(Int64.self, forKey: .limit)
        nextMarker = try container.decodeIfPresent(Int64.self, forKey: .nextMarker)
        order = try container.decodeIfPresent([DevicePinnersOrderField].self, forKey: .order)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entries, forKey: .entries)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(nextMarker, forKey: .nextMarker)
        try container.encodeIfPresent(order, forKey: .order)
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
