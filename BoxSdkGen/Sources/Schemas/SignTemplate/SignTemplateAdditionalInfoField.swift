import Foundation

public class SignTemplateAdditionalInfoField: Codable {
    private enum CodingKeys: String, CodingKey {
        case nonEditable = "non_editable"
        case required
    }

    /// Non editable fields.
    public let nonEditable: [SignTemplateAdditionalInfoNonEditableField]?

    /// Required fields.
    public let required: SignTemplateAdditionalInfoRequiredField?

    /// Initializer for a SignTemplateAdditionalInfoField.
    ///
    /// - Parameters:
    ///   - nonEditable: Non editable fields.
    ///   - required: Required fields.
    public init(nonEditable: [SignTemplateAdditionalInfoNonEditableField]? = nil, required: SignTemplateAdditionalInfoRequiredField? = nil) {
        self.nonEditable = nonEditable
        self.required = required
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nonEditable = try container.decodeIfPresent([SignTemplateAdditionalInfoNonEditableField].self, forKey: .nonEditable)
        required = try container.decodeIfPresent(SignTemplateAdditionalInfoRequiredField.self, forKey: .required)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(nonEditable, forKey: .nonEditable)
        try container.encodeIfPresent(required, forKey: .required)
    }

}
