import Foundation

public class AddClassificationRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case data
        case op
        case fieldKey
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The details of the classification to add.
    public let data: AddClassificationRequestBodyDataField

    /// The type of change to perform on the classification
    /// object.
    public let op: AddClassificationRequestBodyOpField

    /// Defines classifications 
    /// available in the enterprise.
    public let fieldKey: AddClassificationRequestBodyFieldKeyField

    /// Initializer for a AddClassificationRequestBody.
    ///
    /// - Parameters:
    ///   - data: The details of the classification to add.
    ///   - op: The type of change to perform on the classification
    ///     object.
    ///   - fieldKey: Defines classifications 
    ///     available in the enterprise.
    public init(data: AddClassificationRequestBodyDataField, op: AddClassificationRequestBodyOpField = AddClassificationRequestBodyOpField.addEnumOption, fieldKey: AddClassificationRequestBodyFieldKeyField = AddClassificationRequestBodyFieldKeyField.boxSecurityClassificationKey) {
        self.data = data
        self.op = op
        self.fieldKey = fieldKey
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(AddClassificationRequestBodyDataField.self, forKey: .data)
        op = try container.decode(AddClassificationRequestBodyOpField.self, forKey: .op)
        fieldKey = try container.decode(AddClassificationRequestBodyFieldKeyField.self, forKey: .fieldKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(op, forKey: .op)
        try container.encode(fieldKey, forKey: .fieldKey)
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
