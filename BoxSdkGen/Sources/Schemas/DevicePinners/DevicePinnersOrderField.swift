import Foundation

public class DevicePinnersOrderField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case by
        case direction
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The field that is ordered by.
    public let by: DevicePinnersOrderByField?

    /// The direction to order by, either ascending or descending.
    public let direction: DevicePinnersOrderDirectionField?

    /// Initializer for a DevicePinnersOrderField.
    ///
    /// - Parameters:
    ///   - by: The field that is ordered by.
    ///   - direction: The direction to order by, either ascending or descending.
    public init(by: DevicePinnersOrderByField? = nil, direction: DevicePinnersOrderDirectionField? = nil) {
        self.by = by
        self.direction = direction
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        by = try container.decodeIfPresent(DevicePinnersOrderByField.self, forKey: .by)
        direction = try container.decodeIfPresent(DevicePinnersOrderDirectionField.self, forKey: .direction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(by, forKey: .by)
        try container.encodeIfPresent(direction, forKey: .direction)
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
