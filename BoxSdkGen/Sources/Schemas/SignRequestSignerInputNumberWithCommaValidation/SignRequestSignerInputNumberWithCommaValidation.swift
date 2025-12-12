import Foundation

/// Specifies the number with comma formatting rules for a text field input by the signer.
/// If set, this validation is mandatory.
public class SignRequestSignerInputNumberWithCommaValidation: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case validationType = "validation_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Validates that the text input uses a number format with a comma as the decimal separator (for example, 1,23).
    public let validationType: SignRequestSignerInputNumberWithCommaValidationValidationTypeField?

    /// Initializer for a SignRequestSignerInputNumberWithCommaValidation.
    ///
    /// - Parameters:
    ///   - validationType: Validates that the text input uses a number format with a comma as the decimal separator (for example, 1,23).
    public init(validationType: SignRequestSignerInputNumberWithCommaValidationValidationTypeField? = nil) {
        self.validationType = validationType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        validationType = try container.decodeIfPresent(SignRequestSignerInputNumberWithCommaValidationValidationTypeField.self, forKey: .validationType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(validationType, forKey: .validationType)
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
