import Foundation

/// Request body describing the filtering, grouping, and metrics for an insights
/// computation.
public class QueryInsightsRequestBodyV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case query
        case metrics
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The filtering and grouping definition. Filters are applied first, followed
    /// by grouping, before metrics are computed.
    public let query: QueryInsightsRequestBodyV2026R0QueryField

    /// A map of user-defined metric aliases to their definitions. A maximum of 10
    /// metrics may be defined. Each alias must be a unique, non-empty string of up
    /// to 256 characters, containing only letters, digits, `_`, `-`, or `.`, and
    /// must not start with a digit, `_`, `-`, or `.`. May be empty to request
    /// only a total count.
    public let metrics: [String: QueryInsightsMetricDefinitionV2026R0]

    /// Initializer for a QueryInsightsRequestBodyV2026R0.
    ///
    /// - Parameters:
    ///   - query: The filtering and grouping definition. Filters are applied first, followed
    ///     by grouping, before metrics are computed.
    ///   - metrics: A map of user-defined metric aliases to their definitions. A maximum of 10
    ///     metrics may be defined. Each alias must be a unique, non-empty string of up
    ///     to 256 characters, containing only letters, digits, `_`, `-`, or `.`, and
    ///     must not start with a digit, `_`, `-`, or `.`. May be empty to request
    ///     only a total count.
    public init(query: QueryInsightsRequestBodyV2026R0QueryField, metrics: [String: QueryInsightsMetricDefinitionV2026R0]) {
        self.query = query
        self.metrics = metrics
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        query = try container.decode(QueryInsightsRequestBodyV2026R0QueryField.self, forKey: .query)
        metrics = try container.decode([String: QueryInsightsMetricDefinitionV2026R0].self, forKey: .metrics)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        try container.encode(metrics, forKey: .metrics)
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
