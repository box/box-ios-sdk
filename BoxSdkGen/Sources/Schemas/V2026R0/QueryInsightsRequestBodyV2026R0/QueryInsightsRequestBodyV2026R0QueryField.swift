import Foundation

public class QueryInsightsRequestBodyV2026R0QueryField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case predicate
        case params
        case ancestors
        case groupBy = "group_by"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A logical expression used to filter the dataset prior to metric
    /// computation, similar to an SQL `WHERE` clause. May include
    /// named parameters referenced as `:placeholder`.
    public let predicate: String

    /// A map of placeholder names (without the `:` prefix) to their values.
    /// Required only when the predicate contains parameter placeholders. The
    /// type of each value must match the type of the field it is compared to.
    public let params: [String: AnyCodable]?

    /// Restricts results to items contained within any of the specified
    /// ancestors. The user must have access to every listed ancestor. When
    /// omitted, insights are computed across all accessible items.
    public let ancestors: [QueryAncestorReferenceV2026R0]?

    /// Defines how data is grouped for insights computation. Currently only a
    /// single grouping field is supported.
    public let groupBy: [QueryInsightsGroupByV2026R0]?

    /// Initializer for a QueryInsightsRequestBodyV2026R0QueryField.
    ///
    /// - Parameters:
    ///   - predicate: A logical expression used to filter the dataset prior to metric
    ///     computation, similar to an SQL `WHERE` clause. May include
    ///     named parameters referenced as `:placeholder`.
    ///   - params: A map of placeholder names (without the `:` prefix) to their values.
    ///     Required only when the predicate contains parameter placeholders. The
    ///     type of each value must match the type of the field it is compared to.
    ///   - ancestors: Restricts results to items contained within any of the specified
    ///     ancestors. The user must have access to every listed ancestor. When
    ///     omitted, insights are computed across all accessible items.
    ///   - groupBy: Defines how data is grouped for insights computation. Currently only a
    ///     single grouping field is supported.
    public init(predicate: String, params: [String: AnyCodable]? = nil, ancestors: [QueryAncestorReferenceV2026R0]? = nil, groupBy: [QueryInsightsGroupByV2026R0]? = nil) {
        self.predicate = predicate
        self.params = params
        self.ancestors = ancestors
        self.groupBy = groupBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        predicate = try container.decode(String.self, forKey: .predicate)
        params = try container.decodeIfPresent([String: AnyCodable].self, forKey: .params)
        ancestors = try container.decodeIfPresent([QueryAncestorReferenceV2026R0].self, forKey: .ancestors)
        groupBy = try container.decodeIfPresent([QueryInsightsGroupByV2026R0].self, forKey: .groupBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(predicate, forKey: .predicate)
        try container.encodeIfPresent(params, forKey: .params)
        try container.encodeIfPresent(ancestors, forKey: .ancestors)
        try container.encodeIfPresent(groupBy, forKey: .groupBy)
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
