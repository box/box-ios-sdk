import Foundation

/// Input created by a Signer on a Sign Request.
public class SignRequestSignerInput: SignRequestPrefillTag {
    private enum CodingKeys: String, CodingKey {
        case pageIndex = "page_index"
        case type
        case contentType = "content_type"
        case readOnly = "read_only"
        case validation
        case reason
        case isValidated = "is_validated"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// Index of page that the input is on.
    public let pageIndex: Int64

    /// Type of input.
    public let type: SignRequestSignerInputTypeField?

    /// Content type of input.
    public let contentType: SignRequestSignerInputContentTypeField?

    /// Indicates whether this input is read-only (cannot be modified by signers).
    public let readOnly: Bool?

    /// Specifies the formatting rules that signers must follow for text field inputs.
    /// If set, this validation is mandatory.
    public let validation: SignRequestSignerInputValidation?

    /// The reason for the signer's input, applicable to signature or initial content types
    /// in a `cfr11` request flow. The value is `null` when not applicable.
    @CodableTriState public private(set) var reason: String?

    /// Indicates whether the signer's input has been validated through re-authentication.
    /// Applicable only for signature or initial content types in a `cfr11` request flow.
    /// The value is `null` for standard request flows or non-applicable input types.
    @CodableTriState public private(set) var isValidated: Bool?

    /// Initializer for a SignRequestSignerInput.
    ///
    /// - Parameters:
    ///   - pageIndex: Index of page that the input is on.
    ///   - documentTagId: This references the ID of a specific tag contained in a file of the signature request.
    ///   - textValue: Text prefill value.
    ///   - checkboxValue: Checkbox prefill value.
    ///   - dateValue: Date prefill value.
    ///   - type: Type of input.
    ///   - contentType: Content type of input.
    ///   - readOnly: Indicates whether this input is read-only (cannot be modified by signers).
    ///   - validation: Specifies the formatting rules that signers must follow for text field inputs.
    ///     If set, this validation is mandatory.
    ///   - reason: The reason for the signer's input, applicable to signature or initial content types
    ///     in a `cfr11` request flow. The value is `null` when not applicable.
    ///   - isValidated: Indicates whether the signer's input has been validated through re-authentication.
    ///     Applicable only for signature or initial content types in a `cfr11` request flow.
    ///     The value is `null` for standard request flows or non-applicable input types.
    public init(pageIndex: Int64, documentTagId: TriStateField<String> = nil, textValue: TriStateField<String> = nil, checkboxValue: TriStateField<Bool> = nil, dateValue: TriStateField<Date> = nil, type: SignRequestSignerInputTypeField? = nil, contentType: SignRequestSignerInputContentTypeField? = nil, readOnly: Bool? = nil, validation: SignRequestSignerInputValidation? = nil, reason: TriStateField<String> = nil, isValidated: TriStateField<Bool> = nil) {
        self.pageIndex = pageIndex
        self.type = type
        self.contentType = contentType
        self.readOnly = readOnly
        self.validation = validation
        self._reason = CodableTriState(state: reason)
        self._isValidated = CodableTriState(state: isValidated)

        super.init(documentTagId: documentTagId, textValue: textValue, checkboxValue: checkboxValue, dateValue: dateValue)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageIndex = try container.decode(Int64.self, forKey: .pageIndex)
        type = try container.decodeIfPresent(SignRequestSignerInputTypeField.self, forKey: .type)
        contentType = try container.decodeIfPresent(SignRequestSignerInputContentTypeField.self, forKey: .contentType)
        readOnly = try container.decodeIfPresent(Bool.self, forKey: .readOnly)
        validation = try container.decodeIfPresent(SignRequestSignerInputValidation.self, forKey: .validation)
        reason = try container.decodeIfPresent(String.self, forKey: .reason)
        isValidated = try container.decodeIfPresent(Bool.self, forKey: .isValidated)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageIndex, forKey: .pageIndex)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(contentType, forKey: .contentType)
        try container.encodeIfPresent(readOnly, forKey: .readOnly)
        try container.encodeIfPresent(validation, forKey: .validation)
        try container.encode(field: _reason.state, forKey: .reason)
        try container.encode(field: _isValidated.state, forKey: .isValidated)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
