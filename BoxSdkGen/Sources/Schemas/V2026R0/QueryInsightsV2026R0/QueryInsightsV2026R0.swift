import Foundation

/// The computed results of an insights request, as a list of insight entries.
public class QueryInsightsV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case insights
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The list of computed insight entries. Each entry corresponds to a group,
    /// the overall dataset, or the aggregate of groups outside the top results.
    public let insights: [QueryInsightEntryV2026R0]

    /// Initializer for a QueryInsightsV2026R0.
    ///
    /// - Parameters:
    ///   - insights: The list of computed insight entries. Each entry corresponds to a group,
    ///     the overall dataset, or the aggregate of groups outside the top results.
    public init(insights: [QueryInsightEntryV2026R0]) {
        self.insights = insights
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        insights = try container.decode([QueryInsightEntryV2026R0].self, forKey: .insights)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(insights, forKey: .insights)
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
