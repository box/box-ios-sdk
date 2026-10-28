import Foundation

/// A page selection segment that includes a single page from the source
/// document.
public class DocumentSplitPageSelectionSinglePageV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case page
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// A single page number to include.
    public let page: Int

    /// Discriminator. Must be `single_page` for this variant.
    public let type: DocumentSplitPageSelectionSinglePageV2026R0TypeField

    /// Initializer for a DocumentSplitPageSelectionSinglePageV2026R0.
    ///
    /// - Parameters:
    ///   - page: A single page number to include.
    ///   - type: Discriminator. Must be `single_page` for this variant.
    public init(page: Int, type: DocumentSplitPageSelectionSinglePageV2026R0TypeField = DocumentSplitPageSelectionSinglePageV2026R0TypeField.singlePage) {
        self.page = page
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        type = try container.decode(DocumentSplitPageSelectionSinglePageV2026R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
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
