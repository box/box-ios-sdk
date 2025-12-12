import Foundation

/// Specifies the date formatting rules used in Europe for a text field input by the signer. 
/// If set, this validation is mandatory. 
/// The date format follows `DD/MM/YYYY` pattern.
public class SignRequestSignerInputDateEuValidation: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case validationType = "validation_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Validates that the text input uses the European date format `DD/MM/YYYY`.
    public let validationType: SignRequestSignerInputDateEuValidationValidationTypeField?

    /// Initializer for a SignRequestSignerInputDateEuValidation.
    ///
    /// - Parameters:
    ///   - validationType: Validates that the text input uses the European date format `DD/MM/YYYY`.
    public init(validationType: SignRequestSignerInputDateEuValidationValidationTypeField? = nil) {
        self.validationType = validationType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        validationType = try container.decodeIfPresent(SignRequestSignerInputDateEuValidationValidationTypeField.self, forKey: .validationType)
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
