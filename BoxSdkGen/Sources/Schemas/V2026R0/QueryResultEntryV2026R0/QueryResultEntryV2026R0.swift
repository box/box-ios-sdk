import Foundation

/// A single item matching the query. Always includes the item `type` and `id`.
/// If a `fields` parameter was specified in the request, then additional item
/// and/or metadata fields will be provided.
public class QueryResultEntryV2026R0: Codable, RawJSONReadable {
    private struct CodingKeys: CodingKey {
        static let id = CodingKeys(stringValue: "id")
        static let type = CodingKeys(stringValue: "type")

        var intValue: Int?

        var stringValue: String

        init?(intValue: Int) {
            return nil
        }

        init(stringValue: String) {
            self.stringValue = stringValue
        }

    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier of the matching item.
    public let id: String

    /// The type of the matching item.
    public let type: String

    public let extraData: [String: AnyCodable]?

    /// Initializer for a QueryResultEntryV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the matching item.
    ///   - type: The type of the matching item.
    ///   - extraData: 
    public init(id: String, type: String, extraData: [String: AnyCodable]? = nil) {
        self.id = id
        self.type = type
        self.extraData = extraData
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)

        let allKeys: [CodingKeys] = container.allKeys
        let definedKeys: [CodingKeys] = [.id, .type]
        let additionalKeys: [CodingKeys] = allKeys.filter({ (parent: CodingKeys) in !definedKeys.contains(where: { (child: CodingKeys) in child.stringValue == parent.stringValue }) })

        if !additionalKeys.isEmpty {
            var additionalProperties: [String: AnyCodable] = [:]
            for key in additionalKeys {
                if let value = try? container.decode(AnyCodable.self, forKey: key) {
                    additionalProperties[key.stringValue] = value
                }

            }

            extraData = additionalProperties
        } else {
            extraData = nil
        }

    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)

        if let extraData = extraData {
            for (key,value) in extraData {
                try container.encodeIfPresent(value, forKey: CodingKeys(stringValue: key))
            }

        }

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
