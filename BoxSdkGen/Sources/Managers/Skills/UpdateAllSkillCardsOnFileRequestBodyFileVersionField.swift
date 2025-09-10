import Foundation

public class UpdateAllSkillCardsOnFileRequestBodyFileVersionField: Codable, RawJSONReadable {
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


    /// The value will always be `file_version`.
    public let type: UpdateAllSkillCardsOnFileRequestBodyFileVersionTypeField?

    /// The ID of the file version.
    public let id: String?

    /// Initializer for a UpdateAllSkillCardsOnFileRequestBodyFileVersionField.
    ///
    /// - Parameters:
    ///   - type: The value will always be `file_version`.
    ///   - id: The ID of the file version.
    public init(type: UpdateAllSkillCardsOnFileRequestBodyFileVersionTypeField? = nil, id: String? = nil) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(UpdateAllSkillCardsOnFileRequestBodyFileVersionTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
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
