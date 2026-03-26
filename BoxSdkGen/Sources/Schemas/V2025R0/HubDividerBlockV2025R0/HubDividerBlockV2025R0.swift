import Foundation

/// A divider block in the Box Hub Document.
public class HubDividerBlockV2025R0: HubDocumentBlockV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of this block. The value is always `divider`.
    public let type: HubDividerBlockV2025R0TypeField

    /// Initializer for a HubDividerBlockV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this block.
    ///   - parentId: The unique identifier of the parent block. Null for direct children of the page.
    ///   - type: The type of this block. The value is always `divider`.
    public init(id: String, parentId: TriStateField<String> = nil, type: HubDividerBlockV2025R0TypeField = HubDividerBlockV2025R0TypeField.divider) {
        self.type = type

        super.init(id: id, parentId: parentId)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(HubDividerBlockV2025R0TypeField.self, forKey: .type)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
