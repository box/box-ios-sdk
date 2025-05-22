import Foundation

/// Prefill tags are used to prefill placeholders with signer input data. Only
/// one value field can be included.
public class SignRequestPrefillTag: Codable {
    private enum CodingKeys: String, CodingKey {
        case documentTagId = "document_tag_id"
        case textValue = "text_value"
        case checkboxValue = "checkbox_value"
        case dateValue = "date_value"
    }

    /// This references the ID of a specific tag contained in a file of the signature request.
    @CodableTriState public private(set) var documentTagId: String?

    /// Text prefill value
    @CodableTriState public private(set) var textValue: String?

    /// Checkbox prefill value
    @CodableTriState public private(set) var checkboxValue: Bool?

    /// Date prefill value
    @CodableTriState public private(set) var dateValue: Date?

    /// Initializer for a SignRequestPrefillTag.
    ///
    /// - Parameters:
    ///   - documentTagId: This references the ID of a specific tag contained in a file of the signature request.
    ///   - textValue: Text prefill value
    ///   - checkboxValue: Checkbox prefill value
    ///   - dateValue: Date prefill value
    public init(documentTagId: TriStateField<String> = nil, textValue: TriStateField<String> = nil, checkboxValue: TriStateField<Bool> = nil, dateValue: TriStateField<Date> = nil) {
        self._documentTagId = CodableTriState(state: documentTagId)
        self._textValue = CodableTriState(state: textValue)
        self._checkboxValue = CodableTriState(state: checkboxValue)
        self._dateValue = CodableTriState(state: dateValue)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentTagId = try container.decodeIfPresent(String.self, forKey: .documentTagId)
        textValue = try container.decodeIfPresent(String.self, forKey: .textValue)
        checkboxValue = try container.decodeIfPresent(Bool.self, forKey: .checkboxValue)
        dateValue = try container.decodeDateIfPresent(forKey: .dateValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _documentTagId.state, forKey: .documentTagId)
        try container.encode(field: _textValue.state, forKey: .textValue)
        try container.encode(field: _checkboxValue.state, forKey: .checkboxValue)
        try container.encodeDate(field: _dateValue.state, forKey: .dateValue)
    }

}
