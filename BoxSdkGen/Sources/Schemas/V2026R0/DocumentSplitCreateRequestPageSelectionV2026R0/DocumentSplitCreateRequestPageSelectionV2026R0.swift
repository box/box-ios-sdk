import Foundation

/// Validation rules for creating a Document Split job using non-linear page
/// selections. Each item produces one output file from the declared page
/// segments.
public class DocumentSplitCreateRequestPageSelectionV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case pageSelection = "page_selection"
        case splitType = "split_type"
        case version
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    public let pageSelection: DocumentSplitPageSelectionV2026R0

    /// Discriminator. Must be `page_selection` for this variant.
    public let splitType: DocumentSplitCreateRequestPageSelectionV2026R0SplitTypeField

    /// The version of the page selection input format. Optional. When provided
    /// must be `v_2`.
    public let version: DocumentSplitCreateRequestPageSelectionV2026R0VersionField?

    /// Initializer for a DocumentSplitCreateRequestPageSelectionV2026R0.
    ///
    /// - Parameters:
    ///   - pageSelection: 
    ///   - splitType: Discriminator. Must be `page_selection` for this variant.
    ///   - version: The version of the page selection input format. Optional. When provided
    ///     must be `v_2`.
    public init(pageSelection: DocumentSplitPageSelectionV2026R0, splitType: DocumentSplitCreateRequestPageSelectionV2026R0SplitTypeField = DocumentSplitCreateRequestPageSelectionV2026R0SplitTypeField.pageSelection, version: DocumentSplitCreateRequestPageSelectionV2026R0VersionField? = nil) {
        self.pageSelection = pageSelection
        self.splitType = splitType
        self.version = version
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageSelection = try container.decode(DocumentSplitPageSelectionV2026R0.self, forKey: .pageSelection)
        splitType = try container.decode(DocumentSplitCreateRequestPageSelectionV2026R0SplitTypeField.self, forKey: .splitType)
        version = try container.decodeIfPresent(DocumentSplitCreateRequestPageSelectionV2026R0VersionField.self, forKey: .version)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pageSelection, forKey: .pageSelection)
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
