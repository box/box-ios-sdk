import Foundation

public class UpdateMetadataTemplateRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case op
        case data
        case fieldKey
        case fieldKeys
        case enumOptionKey
        case enumOptionKeys
        case multiSelectOptionKey
        case multiSelectOptionKeys
    }

    /// The type of change to perform on the template. Some
    /// of these are hazardous as they will change existing templates.
    public let op: UpdateMetadataTemplateRequestBodyOpField

    /// The data for the operation. This will vary depending on the
    /// operation being performed.
    public let data: [String: AnyCodable]?

    /// For operations that affect a single field this defines the key of
    /// the field that is affected.
    public let fieldKey: String?

    /// For operations that affect multiple fields this defines the keys
    /// of the fields that are affected.
    public let fieldKeys: [String]?

    /// For operations that affect a single `enum` option this defines
    /// the key of the option that is affected.
    public let enumOptionKey: String?

    /// For operations that affect multiple `enum` options this defines
    /// the keys of the options that are affected.
    public let enumOptionKeys: [String]?

    /// For operations that affect a single multi select option this
    /// defines the key of the option that is affected.
    public let multiSelectOptionKey: String?

    /// For operations that affect multiple multi select options this
    /// defines the keys of the options that are affected.
    public let multiSelectOptionKeys: [String]?

    /// Initializer for a UpdateMetadataTemplateRequestBody.
    ///
    /// - Parameters:
    ///   - op: The type of change to perform on the template. Some
    ///     of these are hazardous as they will change existing templates.
    ///   - data: The data for the operation. This will vary depending on the
    ///     operation being performed.
    ///   - fieldKey: For operations that affect a single field this defines the key of
    ///     the field that is affected.
    ///   - fieldKeys: For operations that affect multiple fields this defines the keys
    ///     of the fields that are affected.
    ///   - enumOptionKey: For operations that affect a single `enum` option this defines
    ///     the key of the option that is affected.
    ///   - enumOptionKeys: For operations that affect multiple `enum` options this defines
    ///     the keys of the options that are affected.
    ///   - multiSelectOptionKey: For operations that affect a single multi select option this
    ///     defines the key of the option that is affected.
    ///   - multiSelectOptionKeys: For operations that affect multiple multi select options this
    ///     defines the keys of the options that are affected.
    public init(op: UpdateMetadataTemplateRequestBodyOpField, data: [String: AnyCodable]? = nil, fieldKey: String? = nil, fieldKeys: [String]? = nil, enumOptionKey: String? = nil, enumOptionKeys: [String]? = nil, multiSelectOptionKey: String? = nil, multiSelectOptionKeys: [String]? = nil) {
        self.op = op
        self.data = data
        self.fieldKey = fieldKey
        self.fieldKeys = fieldKeys
        self.enumOptionKey = enumOptionKey
        self.enumOptionKeys = enumOptionKeys
        self.multiSelectOptionKey = multiSelectOptionKey
        self.multiSelectOptionKeys = multiSelectOptionKeys
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        op = try container.decode(UpdateMetadataTemplateRequestBodyOpField.self, forKey: .op)
        data = try container.decodeIfPresent([String: AnyCodable].self, forKey: .data)
        fieldKey = try container.decodeIfPresent(String.self, forKey: .fieldKey)
        fieldKeys = try container.decodeIfPresent([String].self, forKey: .fieldKeys)
        enumOptionKey = try container.decodeIfPresent(String.self, forKey: .enumOptionKey)
        enumOptionKeys = try container.decodeIfPresent([String].self, forKey: .enumOptionKeys)
        multiSelectOptionKey = try container.decodeIfPresent(String.self, forKey: .multiSelectOptionKey)
        multiSelectOptionKeys = try container.decodeIfPresent([String].self, forKey: .multiSelectOptionKeys)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(op, forKey: .op)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(fieldKey, forKey: .fieldKey)
        try container.encodeIfPresent(fieldKeys, forKey: .fieldKeys)
        try container.encodeIfPresent(enumOptionKey, forKey: .enumOptionKey)
        try container.encodeIfPresent(enumOptionKeys, forKey: .enumOptionKeys)
        try container.encodeIfPresent(multiSelectOptionKey, forKey: .multiSelectOptionKey)
        try container.encodeIfPresent(multiSelectOptionKeys, forKey: .multiSelectOptionKeys)
    }

}
