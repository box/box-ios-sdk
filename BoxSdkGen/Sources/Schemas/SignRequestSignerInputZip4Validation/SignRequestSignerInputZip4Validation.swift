import Foundation

/// Specifies the validation rules for a text field input by the signer.
/// If set, this validation is mandatory.
public class SignRequestSignerInputZip4Validation: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case validationType = "validation_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Validates that the text input is a ZIP+4 code.
    public let validationType: SignRequestSignerInputZip4ValidationValidationTypeField

    /// Initializer for a SignRequestSignerInputZip4Validation.
    ///
    /// - Parameters:
    ///   - validationType: Validates that the text input is a ZIP+4 code.
    public init(validationType: SignRequestSignerInputZip4ValidationValidationTypeField = SignRequestSignerInputZip4ValidationValidationTypeField.zip4) {
        self.validationType = validationType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        validationType = try container.decode(SignRequestSignerInputZip4ValidationValidationTypeField.self, forKey: .validationType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(validationType, forKey: .validationType)
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
