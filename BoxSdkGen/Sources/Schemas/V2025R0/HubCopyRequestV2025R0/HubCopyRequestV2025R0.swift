import Foundation

/// Request schema for copying a Box Hub.
public class HubCopyRequestV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case includeItems = "include_items"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Title of the Box Hub. It cannot be empty and should be less than 50 characters.
    public let title: String?

    /// Description of the Box Hub.
    public let description: String?

    /// If true, the items which the user has Editor or Owner access to in the original Box Hub will be copied to the new Box Hub.
    /// Defaults to false.
    public let includeItems: Bool?

    /// Initializer for a HubCopyRequestV2025R0.
    ///
    /// - Parameters:
    ///   - title: Title of the Box Hub. It cannot be empty and should be less than 50 characters.
    ///   - description: Description of the Box Hub.
    ///   - includeItems: If true, the items which the user has Editor or Owner access to in the original Box Hub will be copied to the new Box Hub.
    ///     Defaults to false.
    public init(title: String? = nil, description: String? = nil, includeItems: Bool? = nil) {
        self.title = title
        self.description = description
        self.includeItems = includeItems
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        includeItems = try container.decodeIfPresent(Bool.self, forKey: .includeItems)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(includeItems, forKey: .includeItems)
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
