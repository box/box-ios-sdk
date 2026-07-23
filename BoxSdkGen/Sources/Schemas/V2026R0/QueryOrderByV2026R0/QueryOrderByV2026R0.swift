import Foundation

/// A single sorting criterion applied to the query result set. Multiple criteria
/// are applied sequentially in the order specified.
public class QueryOrderByV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case fieldKey = "field_key"
        case direction
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The fully qualified field key to sort by.
    public let fieldKey: String

    /// The direction in which results are ordered.
    public let direction: QueryOrderByV2026R0DirectionField

    /// Initializer for a QueryOrderByV2026R0.
    ///
    /// - Parameters:
    ///   - fieldKey: The fully qualified field key to sort by.
    ///   - direction: The direction in which results are ordered.
    public init(fieldKey: String, direction: QueryOrderByV2026R0DirectionField) {
        self.fieldKey = fieldKey
        self.direction = direction
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fieldKey = try container.decode(String.self, forKey: .fieldKey)
        direction = try container.decode(QueryOrderByV2026R0DirectionField.self, forKey: .direction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fieldKey, forKey: .fieldKey)
        try container.encode(direction, forKey: .direction)
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
