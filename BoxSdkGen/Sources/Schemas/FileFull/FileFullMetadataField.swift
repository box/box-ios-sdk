import Foundation

public class FileFullMetadataField: Codable, RawJSONReadable {
    private struct CodingKeys: CodingKey {

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


    public let extraData: [String: [String: MetadataFull]]?

    public init(extraData: [String: [String: MetadataFull]]? = nil) {
        self.extraData = extraData
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let allKeys: [CodingKeys] = container.allKeys
        let definedKeys: [CodingKeys] = []
        let additionalKeys: [CodingKeys] = allKeys.filter({ (parent: CodingKeys) in !definedKeys.contains(where: { (child: CodingKeys) in child.stringValue == parent.stringValue }) })

        if !additionalKeys.isEmpty {
            var additionalProperties: [String: [String: MetadataFull]] = [:]
            for key in additionalKeys {
                if let value = try? container.decode([String: MetadataFull].self, forKey: key) {
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
