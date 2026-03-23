import Foundation

/// An operation to perform on a Box Hub item.
public class HubItemOperationV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case action
        case item
        case parentId = "parent_id"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The action to perform on a Box Hub item.
    public let action: HubItemOperationV2025R0ActionField

    public let item: HubItemReferenceV2025R0

    /// The ID of the parent block to add the item to. Must be an Item List block. If not provided, the item will be added to the first page's first Item List block.
    public let parentId: String?

    /// Initializer for a HubItemOperationV2025R0.
    ///
    /// - Parameters:
    ///   - action: The action to perform on a Box Hub item.
    ///   - item: 
    ///   - parentId: The ID of the parent block to add the item to. Must be an Item List block. If not provided, the item will be added to the first page's first Item List block.
    public init(action: HubItemOperationV2025R0ActionField, item: HubItemReferenceV2025R0, parentId: String? = nil) {
        self.action = action
        self.item = item
        self.parentId = parentId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decode(HubItemOperationV2025R0ActionField.self, forKey: .action)
        item = try container.decode(HubItemReferenceV2025R0.self, forKey: .item)
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(item, forKey: .item)
        try container.encodeIfPresent(parentId, forKey: .parentId)
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
