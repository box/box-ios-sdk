import Foundation

public class RetentionPolicyAssignmentFilterFieldsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case field
        case value
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The metadata attribute key id.
    @CodableTriState public private(set) var field: String?

    /// The metadata attribute field id. For value, only
    /// enum and multiselect types are supported.
    @CodableTriState public private(set) var value: String?

    /// Initializer for a RetentionPolicyAssignmentFilterFieldsField.
    ///
    /// - Parameters:
    ///   - field: The metadata attribute key id.
    ///   - value: The metadata attribute field id. For value, only
    ///     enum and multiselect types are supported.
    public init(field: TriStateField<String> = nil, value: TriStateField<String> = nil) {
        self._field = CodableTriState(state: field)
        self._value = CodableTriState(state: value)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        field = try container.decodeIfPresent(String.self, forKey: .field)
        value = try container.decodeIfPresent(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _field.state, forKey: .field)
        try container.encode(field: _value.state, forKey: .value)
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
