import Foundation

/// The schema for Shield List update request.
public class ShieldListsUpdateV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case name
        case content
        case description
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The name of the shield list.
    public let name: String

    public let content: ShieldListContentRequestV2025R0

    /// Optional description of Shield List.
    public let description: String?

    /// Initializer for a ShieldListsUpdateV2025R0.
    ///
    /// - Parameters:
    ///   - name: The name of the shield list.
    ///   - content: 
    ///   - description: Optional description of Shield List.
    public init(name: String, content: ShieldListContentRequestV2025R0, description: String? = nil) {
        self.name = name
        self.content = content
        self.description = description
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        content = try container.decode(ShieldListContentRequestV2025R0.self, forKey: .content)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(content, forKey: .content)
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
