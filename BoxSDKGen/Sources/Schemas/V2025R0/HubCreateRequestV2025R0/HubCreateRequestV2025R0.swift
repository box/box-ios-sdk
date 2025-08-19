import Foundation

/// Request schema for creating a new Hub.
public class HubCreateRequestV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Title of the Hub. It cannot be empty and should be less than 50 characters.
    public let title: String

    /// Description of the Hub.
    public let description: String?

    /// Initializer for a HubCreateRequestV2025R0.
    ///
    /// - Parameters:
    ///   - title: Title of the Hub. It cannot be empty and should be less than 50 characters.
    ///   - description: Description of the Hub.
    public init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
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
