import Foundation

/// Validation rules for creating a Document Split job using caller-supplied page
/// ranges.
public class DocumentSplitCreateRequestManualV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case splitDefinition = "split_definition"
        case splitType = "split_type"
        case version
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Page ranges that define the split. Each entry produces one output file
    /// containing the inclusive page range `[start, end]`.
    public let splitDefinition: [DocumentSplitPageRangeV2026R0]

    /// Discriminator. Must be `manual` for this variant.
    public let splitType: DocumentSplitCreateRequestManualV2026R0SplitTypeField

    /// The version of the manual split input format. Omitted or `v_1` is the
    /// legacy `split_definition` format. Existing clients may omit this field.
    public let version: DocumentSplitCreateRequestManualV2026R0VersionField?

    /// Initializer for a DocumentSplitCreateRequestManualV2026R0.
    ///
    /// - Parameters:
    ///   - splitDefinition: Page ranges that define the split. Each entry produces one output file
    ///     containing the inclusive page range `[start, end]`.
    ///   - splitType: Discriminator. Must be `manual` for this variant.
    ///   - version: The version of the manual split input format. Omitted or `v_1` is the
    ///     legacy `split_definition` format. Existing clients may omit this field.
    public init(splitDefinition: [DocumentSplitPageRangeV2026R0], splitType: DocumentSplitCreateRequestManualV2026R0SplitTypeField = DocumentSplitCreateRequestManualV2026R0SplitTypeField.manual, version: DocumentSplitCreateRequestManualV2026R0VersionField? = nil) {
        self.splitDefinition = splitDefinition
        self.splitType = splitType
        self.version = version
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        splitDefinition = try container.decode([DocumentSplitPageRangeV2026R0].self, forKey: .splitDefinition)
        splitType = try container.decode(DocumentSplitCreateRequestManualV2026R0SplitTypeField.self, forKey: .splitType)
        version = try container.decodeIfPresent(DocumentSplitCreateRequestManualV2026R0VersionField.self, forKey: .version)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(splitDefinition, forKey: .splitDefinition)
        try container.encode(splitType, forKey: .splitType)
        try container.encodeIfPresent(version, forKey: .version)
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
