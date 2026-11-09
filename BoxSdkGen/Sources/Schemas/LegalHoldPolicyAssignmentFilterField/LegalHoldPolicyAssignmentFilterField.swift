import Foundation

/// A metadata template field filter for a legal hold policy assignment.
public class LegalHoldPolicyAssignmentFilterField: Codable, RawJSONReadable {
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


    /// The ID of the metadata template field to filter on.
    public let field: String

    /// The value of the metadata template field to filter on.
    public let value: String

    /// Initializer for a LegalHoldPolicyAssignmentFilterField.
    ///
    /// - Parameters:
    ///   - field: The ID of the metadata template field to filter on.
    ///   - value: The value of the metadata template field to filter on.
    public init(field: String, value: String) {
        self.field = field
        self.value = value
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        field = try container.decode(String.self, forKey: .field)
        value = try container.decode(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field, forKey: .field)
        try container.encode(value, forKey: .value)
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
