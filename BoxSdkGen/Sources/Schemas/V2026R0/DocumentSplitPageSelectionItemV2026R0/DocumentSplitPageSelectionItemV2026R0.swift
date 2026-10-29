import Foundation

/// A single output file definition within a page selection request. Each item
/// produces one PDF containing the pages specified by its segments array.
public class DocumentSplitPageSelectionItemV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case segments
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// An ordered list of page segments to include in this output file. Each
    /// segment specifies either a single page or a contiguous page range.
    public let segments: [DocumentSplitPageSelectionSegmentV2026R0]

    /// Optional name for the output file (without extension). When omitted the
    /// system generates a sequential name based on the source file name.
    public let name: String?

    /// Initializer for a DocumentSplitPageSelectionItemV2026R0.
    ///
    /// - Parameters:
    ///   - segments: An ordered list of page segments to include in this output file. Each
    ///     segment specifies either a single page or a contiguous page range.
    ///   - name: Optional name for the output file (without extension). When omitted the
    ///     system generates a sequential name based on the source file name.
    public init(segments: [DocumentSplitPageSelectionSegmentV2026R0], name: String? = nil) {
        self.segments = segments
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        segments = try container.decode([DocumentSplitPageSelectionSegmentV2026R0].self, forKey: .segments)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(segments, forKey: .segments)
        try container.encodeIfPresent(name, forKey: .name)
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
