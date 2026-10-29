import Foundation

/// A page selection segment that includes an inclusive page range from the
/// source document.
public class DocumentSplitPageSelectionPageRangeV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case start
        case end
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The first page (inclusive) included in this segment.
    public let start: Int

    /// The last page (inclusive) included in this segment.
    public let end: Int

    /// Discriminator. Must be `page_range` for this variant.
    public let type: DocumentSplitPageSelectionPageRangeV2026R0TypeField

    /// Initializer for a DocumentSplitPageSelectionPageRangeV2026R0.
    ///
    /// - Parameters:
    ///   - start: The first page (inclusive) included in this segment.
    ///   - end: The last page (inclusive) included in this segment.
    ///   - type: Discriminator. Must be `page_range` for this variant.
    public init(start: Int, end: Int, type: DocumentSplitPageSelectionPageRangeV2026R0TypeField = DocumentSplitPageSelectionPageRangeV2026R0TypeField.pageRange) {
        self.start = start
        self.end = end
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        start = try container.decode(Int.self, forKey: .start)
        end = try container.decode(Int.self, forKey: .end)
        type = try container.decode(DocumentSplitPageSelectionPageRangeV2026R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
        try container.encode(type, forKey: .type)
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
