import Foundation

public class ClassificationTemplateFieldsOptionsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case key
        case staticConfig
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique ID of this classification.
    public let id: String

    /// The display name and key for this classification.
    public let key: String

    /// Additional information about the classification.
    public let staticConfig: ClassificationTemplateFieldsOptionsStaticConfigField?

    /// Initializer for a ClassificationTemplateFieldsOptionsField.
    ///
    /// - Parameters:
    ///   - id: The unique ID of this classification.
    ///   - key: The display name and key for this classification.
    ///   - staticConfig: Additional information about the classification.
    public init(id: String, key: String, staticConfig: ClassificationTemplateFieldsOptionsStaticConfigField? = nil) {
        self.id = id
        self.key = key
        self.staticConfig = staticConfig
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        key = try container.decode(String.self, forKey: .key)
        staticConfig = try container.decodeIfPresent(ClassificationTemplateFieldsOptionsStaticConfigField.self, forKey: .staticConfig)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(staticConfig, forKey: .staticConfig)
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
