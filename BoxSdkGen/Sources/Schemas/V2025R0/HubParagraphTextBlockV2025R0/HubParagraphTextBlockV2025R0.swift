import Foundation

/// A paragraph block in the Box Hub Document.
public class HubParagraphTextBlockV2025R0: HubDocumentBlockV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case fragment
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// Text content of the block. Includes rich text formatting.
    public let fragment: String

    /// The type of this block. The value is always `paragraph`.
    public let type: HubParagraphTextBlockV2025R0TypeField

    /// Initializer for a HubParagraphTextBlockV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this block.
    ///   - fragment: Text content of the block. Includes rich text formatting.
    ///   - parentId: The unique identifier of the parent block. Null for direct children of the page.
    ///   - type: The type of this block. The value is always `paragraph`.
    public init(id: String, fragment: String, parentId: TriStateField<String> = nil, type: HubParagraphTextBlockV2025R0TypeField = HubParagraphTextBlockV2025R0TypeField.paragraph) {
        self.fragment = fragment
        self.type = type

        super.init(id: id, parentId: parentId)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fragment = try container.decode(String.self, forKey: .fragment)
        type = try container.decode(HubParagraphTextBlockV2025R0TypeField.self, forKey: .type)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fragment, forKey: .fragment)
        try container.encode(type, forKey: .type)
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
