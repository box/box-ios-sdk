import Foundation

public class UpdateClassificationRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case enumOptionKey
        case data
        case op
        case fieldKey
    }

    /// The original label of the classification to change.
    public let enumOptionKey: String

    /// The details of the updated classification.
    public let data: UpdateClassificationRequestBodyDataField

    /// The type of change to perform on the classification
    /// object.
    public let op: UpdateClassificationRequestBodyOpField

    /// Defines classifications 
    /// available in the enterprise.
    public let fieldKey: UpdateClassificationRequestBodyFieldKeyField

    /// Initializer for a UpdateClassificationRequestBody.
    ///
    /// - Parameters:
    ///   - enumOptionKey: The original label of the classification to change.
    ///   - data: The details of the updated classification.
    ///   - op: The type of change to perform on the classification
    ///     object.
    ///   - fieldKey: Defines classifications 
    ///     available in the enterprise.
    public init(enumOptionKey: String, data: UpdateClassificationRequestBodyDataField, op: UpdateClassificationRequestBodyOpField = UpdateClassificationRequestBodyOpField.editEnumOption, fieldKey: UpdateClassificationRequestBodyFieldKeyField = UpdateClassificationRequestBodyFieldKeyField.boxSecurityClassificationKey) {
        self.enumOptionKey = enumOptionKey
        self.data = data
        self.op = op
        self.fieldKey = fieldKey
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enumOptionKey = try container.decode(String.self, forKey: .enumOptionKey)
        data = try container.decode(UpdateClassificationRequestBodyDataField.self, forKey: .data)
        op = try container.decode(UpdateClassificationRequestBodyOpField.self, forKey: .op)
        fieldKey = try container.decode(UpdateClassificationRequestBodyFieldKeyField.self, forKey: .fieldKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enumOptionKey, forKey: .enumOptionKey)
        try container.encode(data, forKey: .data)
        try container.encode(op, forKey: .op)
        try container.encode(fieldKey, forKey: .fieldKey)
    }

}
