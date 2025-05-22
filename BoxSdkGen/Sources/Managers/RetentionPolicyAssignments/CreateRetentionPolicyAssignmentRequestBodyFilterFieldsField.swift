import Foundation

public class CreateRetentionPolicyAssignmentRequestBodyFilterFieldsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case field
        case value
    }

    /// The metadata attribute key id.
    public let field: String?

    /// The metadata attribute field id. For value, only
    /// enum and multiselect types are supported.
    public let value: String?

    /// Initializer for a CreateRetentionPolicyAssignmentRequestBodyFilterFieldsField.
    ///
    /// - Parameters:
    ///   - field: The metadata attribute key id.
    ///   - value: The metadata attribute field id. For value, only
    ///     enum and multiselect types are supported.
    public init(field: String? = nil, value: String? = nil) {
        self.field = field
        self.value = value
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        field = try container.decodeIfPresent(String.self, forKey: .field)
        value = try container.decodeIfPresent(String.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(field, forKey: .field)
        try container.encodeIfPresent(value, forKey: .value)
    }

}
