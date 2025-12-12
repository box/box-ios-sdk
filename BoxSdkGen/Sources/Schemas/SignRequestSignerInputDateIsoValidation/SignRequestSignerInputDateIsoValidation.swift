import Foundation

/// Specifies the ISO date formatting rules for a text field input by the signer. 
/// If set, this validation is mandatory. 
/// The date format follows `YYYY-MM-DD` pattern.
public class SignRequestSignerInputDateIsoValidation: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case validationType = "validation_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Validates that the text input uses the ISO date format `YYYY-MM-DD`.
    public let validationType: SignRequestSignerInputDateIsoValidationValidationTypeField?

    /// Initializer for a SignRequestSignerInputDateIsoValidation.
    ///
    /// - Parameters:
    ///   - validationType: Validates that the text input uses the ISO date format `YYYY-MM-DD`.
    public init(validationType: SignRequestSignerInputDateIsoValidationValidationTypeField? = nil) {
        self.validationType = validationType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        validationType = try container.decodeIfPresent(SignRequestSignerInputDateIsoValidationValidationTypeField.self, forKey: .validationType)
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
