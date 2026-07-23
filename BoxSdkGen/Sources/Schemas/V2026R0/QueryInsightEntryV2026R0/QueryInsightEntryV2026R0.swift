import Foundation

/// A single computed insight entry, containing its grouping keys (if applicable)
/// and the computed metrics.
public class QueryInsightEntryV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case key
        case type
        case metrics
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The grouping key values associated with the entry. Contains one value per
    /// `group_by` field for `group` entries, and is empty for `overall` and
    /// `other` entries.
    public let key: [String]

    /// The type of insight entry, indicating how the associated metrics are
    /// aggregated.
    public let type: QueryInsightEntryV2026R0TypeField

    /// A map of metric aliases to their computed results. For `other` entries, the
    /// count is reported under the `totalCountBeyondTopGroups` key.
    public let metrics: [String: QueryInsightMetricResultV2026R0]

    /// Initializer for a QueryInsightEntryV2026R0.
    ///
    /// - Parameters:
    ///   - key: The grouping key values associated with the entry. Contains one value per
    ///     `group_by` field for `group` entries, and is empty for `overall` and
    ///     `other` entries.
    ///   - type: The type of insight entry, indicating how the associated metrics are
    ///     aggregated.
    ///   - metrics: A map of metric aliases to their computed results. For `other` entries, the
    ///     count is reported under the `totalCountBeyondTopGroups` key.
    public init(key: [String], type: QueryInsightEntryV2026R0TypeField, metrics: [String: QueryInsightMetricResultV2026R0]) {
        self.key = key
        self.type = type
        self.metrics = metrics
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode([String].self, forKey: .key)
        type = try container.decode(QueryInsightEntryV2026R0TypeField.self, forKey: .type)
        metrics = try container.decode([String: QueryInsightMetricResultV2026R0].self, forKey: .metrics)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(type, forKey: .type)
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
