import Foundation

public class UpdateMetadataTaxonomyRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case displayName
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The display name of the taxonomy.
    public let displayName: String

    /// Initializer for a UpdateMetadataTaxonomyRequestBody.
    ///
    /// - Parameters:
    ///   - displayName: The display name of the taxonomy.
    public init(displayName: String) {
        self.displayName = displayName
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decode(String.self, forKey: .displayName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayName, forKey: .displayName)
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
