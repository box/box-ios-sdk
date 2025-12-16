import Foundation

public class CreateMetadataTemplateRequestBodyFieldsOptionsRulesField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case multiSelect
        case selectableLevels
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether to allow users to select multiple values.
    public let multiSelect: Bool?

    /// An array of integers defining which levels of the taxonomy are
    /// selectable by users.
    public let selectableLevels: [Int64]?

    /// Initializer for a CreateMetadataTemplateRequestBodyFieldsOptionsRulesField.
    ///
    /// - Parameters:
    ///   - multiSelect: Whether to allow users to select multiple values.
    ///   - selectableLevels: An array of integers defining which levels of the taxonomy are
    ///     selectable by users.
    public init(multiSelect: Bool? = nil, selectableLevels: [Int64]? = nil) {
        self.multiSelect = multiSelect
        self.selectableLevels = selectableLevels
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        multiSelect = try container.decodeIfPresent(Bool.self, forKey: .multiSelect)
        selectableLevels = try container.decodeIfPresent([Int64].self, forKey: .selectableLevels)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(multiSelect, forKey: .multiSelect)
        try container.encodeIfPresent(selectableLevels, forKey: .selectableLevels)
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
