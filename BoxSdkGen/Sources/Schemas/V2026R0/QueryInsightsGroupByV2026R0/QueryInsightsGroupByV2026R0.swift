import Foundation

/// Defines a single grouping criterion for an insights request. Currently only a
/// single grouping field is supported.
public class QueryInsightsGroupByV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case field
        case bucketLimit = "bucket_limit"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The fully qualified field name to group by. Supports metadata and item
    /// properties.
    public let field: String

    /// The maximum number of buckets to return for the grouping. Defaults to `5`.
    public let bucketLimit: Int?

    /// Initializer for a QueryInsightsGroupByV2026R0.
    ///
    /// - Parameters:
    ///   - field: The fully qualified field name to group by. Supports metadata and item
    ///     properties.
    ///   - bucketLimit: The maximum number of buckets to return for the grouping. Defaults to `5`.
    public init(field: String, bucketLimit: Int? = nil) {
        self.field = field
        self.bucketLimit = bucketLimit
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        field = try container.decode(String.self, forKey: .field)
        bucketLimit = try container.decodeIfPresent(Int.self, forKey: .bucketLimit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field, forKey: .field)
        try container.encodeIfPresent(bucketLimit, forKey: .bucketLimit)
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
