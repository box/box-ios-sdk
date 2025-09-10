import Foundation

public class SignTemplateAdditionalInfoField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case nonEditable = "non_editable"
        case required
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
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
