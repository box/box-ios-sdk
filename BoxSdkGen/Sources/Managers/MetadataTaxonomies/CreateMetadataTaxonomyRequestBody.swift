import Foundation

public class CreateMetadataTaxonomyRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case displayName
        case namespace
        case key
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The display name of the taxonomy.
    public let displayName: String

    /// The namespace of the metadata taxonomy to create.
    public let namespace: String

    /// The taxonomy key. If it is not provided in the request body, it will be 
    /// generated from the `displayName`. The `displayName` would be converted 
    /// to lower case, and all spaces and non-alphanumeric characters replaced 
    /// with underscores.
    public let key: String?

    /// Initializer for a CreateMetadataTaxonomyRequestBody.
    ///
    /// - Parameters:
    ///   - displayName: The display name of the taxonomy.
    ///   - namespace: The namespace of the metadata taxonomy to create.
    ///   - key: The taxonomy key. If it is not provided in the request body, it will be 
    ///     generated from the `displayName`. The `displayName` would be converted 
    ///     to lower case, and all spaces and non-alphanumeric characters replaced 
    ///     with underscores.
    public init(displayName: String, namespace: String, key: String? = nil) {
        self.displayName = displayName
        self.namespace = namespace
        self.key = key
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decode(String.self, forKey: .displayName)
        namespace = try container.decode(String.self, forKey: .namespace)
        key = try container.decodeIfPresent(String.self, forKey: .key)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(namespace, forKey: .namespace)
        try container.encodeIfPresent(key, forKey: .key)
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
