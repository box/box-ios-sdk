import Foundation

/// Input created by a Signer on a Template
public class TemplateSignerInput: SignRequestPrefillTag {
    private enum CodingKeys: String, CodingKey {
        case pageIndex = "page_index"
        case type
        case contentType = "content_type"
        case isRequired = "is_required"
        case documentId = "document_id"
        case dropdownChoices = "dropdown_choices"
        case groupId = "group_id"
        case coordinates
        case dimensions
        case label
        case readOnly = "read_only"
    }

    /// Index of page that the input is on.
    public let pageIndex: Int64

    /// Type of input
    public let type: TemplateSignerInputTypeField?

    /// Content type of input
    public let contentType: TemplateSignerInputContentTypeField?

    /// Whether or not the input is required.
    public let isRequired: Bool?

    /// Document identifier.
    @CodableTriState public private(set) var documentId: String?

    /// When the input is of the type `dropdown` this values will be filled with all the dropdown options.
    @CodableTriState public private(set) var dropdownChoices: [String]?

    /// When the input is of type `radio` they can be grouped to gather with this identifier.
    @CodableTriState public private(set) var groupId: String?

    /// Where the input is located on a page.
    public let coordinates: TemplateSignerInputCoordinatesField?

    /// The size of the input.
    public let dimensions: TemplateSignerInputDimensionsField?

    /// The label field is used especially for text, attachment, radio, and checkbox type inputs.
    @CodableTriState public private(set) var label: String?

    /// Whether this input was defined as read-only(immutable by signers) or not
    public let readOnly: Bool?

    /// Initializer for a TemplateSignerInput.
    ///
    /// - Parameters:
    ///   - pageIndex: Index of page that the input is on.
    ///   - documentTagId: This references the ID of a specific tag contained in a file of the signature request.
    ///   - textValue: Text prefill value
    ///   - checkboxValue: Checkbox prefill value
    ///   - dateValue: Date prefill value
    ///   - type: Type of input
    ///   - contentType: Content type of input
    ///   - isRequired: Whether or not the input is required.
    ///   - documentId: Document identifier.
    ///   - dropdownChoices: When the input is of the type `dropdown` this values will be filled with all the dropdown options.
    ///   - groupId: When the input is of type `radio` they can be grouped to gather with this identifier.
    ///   - coordinates: Where the input is located on a page.
    ///   - dimensions: The size of the input.
    ///   - label: The label field is used especially for text, attachment, radio, and checkbox type inputs.
    ///   - readOnly: Whether this input was defined as read-only(immutable by signers) or not
    public init(pageIndex: Int64, documentTagId: TriStateField<String> = nil, textValue: TriStateField<String> = nil, checkboxValue: TriStateField<Bool> = nil, dateValue: TriStateField<Date> = nil, type: TemplateSignerInputTypeField? = nil, contentType: TemplateSignerInputContentTypeField? = nil, isRequired: Bool? = nil, documentId: TriStateField<String> = nil, dropdownChoices: TriStateField<[String]> = nil, groupId: TriStateField<String> = nil, coordinates: TemplateSignerInputCoordinatesField? = nil, dimensions: TemplateSignerInputDimensionsField? = nil, label: TriStateField<String> = nil, readOnly: Bool? = nil) {
        self.pageIndex = pageIndex
        self.type = type
        self.contentType = contentType
        self.isRequired = isRequired
        self._documentId = CodableTriState(state: documentId)
        self._dropdownChoices = CodableTriState(state: dropdownChoices)
        self._groupId = CodableTriState(state: groupId)
        self.coordinates = coordinates
        self.dimensions = dimensions
        self._label = CodableTriState(state: label)
        self.readOnly = readOnly

        super.init(documentTagId: documentTagId, textValue: textValue, checkboxValue: checkboxValue, dateValue: dateValue)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageIndex = try container.decode(Int64.self, forKey: .pageIndex)
        type = try container.decodeIfPresent(TemplateSignerInputTypeField.self, forKey: .type)
        contentType = try container.decodeIfPresent(TemplateSignerInputContentTypeField.self, forKey: .contentType)
        isRequired = try container.decodeIfPresent(Bool.self, forKey: .isRequired)
        documentId = try container.decodeIfPresent(String.self, forKey: .documentId)
        dropdownChoices = try container.decodeIfPresent([String].self, forKey: .dropdownChoices)
        groupId = try container.decodeIfPresent(String.self, forKey: .groupId)
        coordinates = try container.decodeIfPresent(TemplateSignerInputCoordinatesField.self, forKey: .coordinates)
        dimensions = try container.decodeIfPresent(TemplateSignerInputDimensionsField.self, forKey: .dimensions)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        readOnly = try container.decodeIfPresent(Bool.self, forKey: .readOnly)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageIndex, forKey: .pageIndex)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(contentType, forKey: .contentType)
        try container.encodeIfPresent(isRequired, forKey: .isRequired)
        try container.encode(field: _documentId.state, forKey: .documentId)
        try container.encode(field: _dropdownChoices.state, forKey: .dropdownChoices)
        try container.encode(field: _groupId.state, forKey: .groupId)
        try container.encodeIfPresent(coordinates, forKey: .coordinates)
        try container.encodeIfPresent(dimensions, forKey: .dimensions)
        try container.encode(field: _label.state, forKey: .label)
        try container.encodeIfPresent(readOnly, forKey: .readOnly)
        try super.encode(to: encoder)
    }

}
