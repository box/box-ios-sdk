import Foundation

/// Specifies the custom validation rules for a text field input by the signer.
/// If set, this validation is mandatory.
public class SignRequestSignerInputCustomValidation: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case customRegex = "custom_regex"
        case customErrorMessage = "custom_error_message"
        case validationType = "validation_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Regular expression used for validation.
    @CodableTriState public private(set) var customRegex: String

    /// Error message shown if input fails custom regular expression validation.
    @CodableTriState public private(set) var customErrorMessage: String

    /// Defines the validation format for the text input as custom.
    /// A custom regular expression is used for validation.
    public let validationType: SignRequestSignerInputCustomValidationValidationTypeField

    /// Initializer for a SignRequestSignerInputCustomValidation.
    ///
    /// - Parameters:
    ///   - customRegex: Regular expression used for validation.
    ///   - customErrorMessage: Error message shown if input fails custom regular expression validation.
    ///   - validationType: Defines the validation format for the text input as custom.
    ///     A custom regular expression is used for validation.
    public init(customRegex: TriStateField<String>, customErrorMessage: TriStateField<String>, validationType: SignRequestSignerInputCustomValidationValidationTypeField = SignRequestSignerInputCustomValidationValidationTypeField.custom) {
        self._customRegex = CodableTriState(state: customRegex)
        self._customErrorMessage = CodableTriState(state: customErrorMessage)
        self.validationType = validationType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        customRegex = try container.decodeIfPresent(String.self, forKey: .customRegex)
        customErrorMessage = try container.decodeIfPresent(String.self, forKey: .customErrorMessage)
        validationType = try container.decode(SignRequestSignerInputCustomValidationValidationTypeField.self, forKey: .validationType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _customRegex.state, forKey: .customRegex)
        try container.encode(field: _customErrorMessage.state, forKey: .customErrorMessage)
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
