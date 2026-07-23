import Foundation

/// The computed result for a single metric, including the metric type and its
/// computed value(s).
public class QueryInsightMetricResultV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case values
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The metric type that was computed.
    public let type: String

    /// The computed metric result(s), keyed by the metric function (for example
    /// `sum`, `avg`, `min`, `max`, or `count`).
    public let values: [String: Double]

    /// Initializer for a QueryInsightMetricResultV2026R0.
    ///
    /// - Parameters:
    ///   - type: The metric type that was computed.
    ///   - values: The computed metric result(s), keyed by the metric function (for example
    ///     `sum`, `avg`, `min`, `max`, or `count`).
    public init(type: String, values: [String: Double]) {
        self.type = type
        self.values = values
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        values = try container.decode([String: Double].self, forKey: .values)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(values, forKey: .values)
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
