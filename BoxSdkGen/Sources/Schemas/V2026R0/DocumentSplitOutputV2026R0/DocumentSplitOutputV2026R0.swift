import Foundation

/// The set of files produced by a completed Document Split job.
public class DocumentSplitOutputV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case generatedFiles = "generated_files"
        case splitDefinition = "split_definition"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// References to the files that were created by the split.
    public let generatedFiles: [FileReferenceV2026R0]?

    /// The page ranges that Box produced for a `smart` split. Each entry
    /// corresponds to one generated file with the inclusive page range
    /// `[start, end]`. Omitted or `null` for `manual` splits, where the
    /// caller-supplied ranges are available in `split_input.split_definition`.
    /// Omitted for `page_selection` splits, where the caller-supplied page
    /// layout is available in `split_input.page_selection`.
    @CodableTriState public private(set) var splitDefinition: [DocumentSplitPageRangeV2026R0]?

    /// Initializer for a DocumentSplitOutputV2026R0.
    ///
    /// - Parameters:
    ///   - generatedFiles: References to the files that were created by the split.
    ///   - splitDefinition: The page ranges that Box produced for a `smart` split. Each entry
    ///     corresponds to one generated file with the inclusive page range
    ///     `[start, end]`. Omitted or `null` for `manual` splits, where the
    ///     caller-supplied ranges are available in `split_input.split_definition`.
    ///     Omitted for `page_selection` splits, where the caller-supplied page
    ///     layout is available in `split_input.page_selection`.
    public init(generatedFiles: [FileReferenceV2026R0]? = nil, splitDefinition: TriStateField<[DocumentSplitPageRangeV2026R0]> = nil) {
        self.generatedFiles = generatedFiles
        self._splitDefinition = CodableTriState(state: splitDefinition)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        generatedFiles = try container.decodeIfPresent([FileReferenceV2026R0].self, forKey: .generatedFiles)
        splitDefinition = try container.decodeIfPresent([DocumentSplitPageRangeV2026R0].self, forKey: .splitDefinition)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(generatedFiles, forKey: .generatedFiles)
        try container.encode(field: _splitDefinition.state, forKey: .splitDefinition)
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
