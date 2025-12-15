import Foundation

public class PatchMetadataTaxonomiesIdIdLevelsIdRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case displayName
        case description
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The display name of the taxonomy level.
    public let displayName: String

    /// The description of the taxonomy level.
    public let description: String?

    /// Initializer for a PatchMetadataTaxonomiesIdIdLevelsIdRequestBody.
    ///
    /// - Parameters:
    ///   - displayName: The display name of the taxonomy level.
    ///   - description: The description of the taxonomy level.
    public init(displayName: String, description: String? = nil) {
        self.displayName = displayName
        self.description = description
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decode(String.self, forKey: .displayName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayName, forKey: .displayName)
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
