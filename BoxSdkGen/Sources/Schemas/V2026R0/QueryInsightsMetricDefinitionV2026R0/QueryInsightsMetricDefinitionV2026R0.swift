import Foundation

/// Defines a single metric to compute, including the aggregation function and the
/// field it is applied to.
public class QueryInsightsMetricDefinitionV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case field
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The aggregation function to apply.
    public let type: QueryInsightsMetricDefinitionV2026R0TypeField

    /// The fully qualified field name on which the metric is computed.
    public let field: String

    /// Initializer for a QueryInsightsMetricDefinitionV2026R0.
    ///
    /// - Parameters:
    ///   - type: The aggregation function to apply.
    ///   - field: The fully qualified field name on which the metric is computed.
    public init(type: QueryInsightsMetricDefinitionV2026R0TypeField, field: String) {
        self.type = type
        self.field = field
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(QueryInsightsMetricDefinitionV2026R0TypeField.self, forKey: .type)
        field = try container.decode(String.self, forKey: .field)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field, forKey: .field)
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
