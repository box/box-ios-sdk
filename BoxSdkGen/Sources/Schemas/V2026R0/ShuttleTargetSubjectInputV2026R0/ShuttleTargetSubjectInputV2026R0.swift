import Foundation

/// A Box user or group to map a source subject to.
public class ShuttleTargetSubjectInputV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether the Box target is a user or a group.
    public let type: ShuttleTargetSubjectInputV2026R0TypeField

    /// The identifier of the target Box subject.
    public let id: String

    /// Initializer for a ShuttleTargetSubjectInputV2026R0.
    ///
    /// - Parameters:
    ///   - type: Whether the Box target is a user or a group.
    ///   - id: The identifier of the target Box subject.
    public init(type: ShuttleTargetSubjectInputV2026R0TypeField, id: String) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ShuttleTargetSubjectInputV2026R0TypeField.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
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
