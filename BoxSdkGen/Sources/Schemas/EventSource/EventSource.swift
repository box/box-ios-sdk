import Foundation

/// The source file or folder that triggered an event in
/// the event stream.
public class EventSource: Codable {
    private enum CodingKeys: String, CodingKey {
        case itemType = "item_type"
        case itemId = "item_id"
        case itemName = "item_name"
        case classification
        case parent
        case ownedBy = "owned_by"
    }

    /// The type of the item that the event
    /// represents. Can be `file` or `folder`.
    /// 
    public let itemType: EventSourceItemTypeField

    /// The unique identifier that represents the
    /// item.
    /// 
    public let itemId: String

    /// The name of the item.
    /// 
    public let itemName: String

    /// The object containing classification information for the item that
    /// triggered the event. This field will not appear if the item does not
    /// have a classification set.
    public let classification: EventSourceClassificationField?

    @CodableTriState public private(set) var parent: FolderMini?

    public let ownedBy: UserMini?

    /// Initializer for a EventSource.
    ///
    /// - Parameters:
    ///   - itemType: The type of the item that the event
    ///     represents. Can be `file` or `folder`.
    ///     
    ///   - itemId: The unique identifier that represents the
    ///     item.
    ///     
    ///   - itemName: The name of the item.
    ///     
    ///   - classification: The object containing classification information for the item that
    ///     triggered the event. This field will not appear if the item does not
    ///     have a classification set.
    ///   - parent: 
    ///   - ownedBy: 
    public init(itemType: EventSourceItemTypeField, itemId: String, itemName: String, classification: EventSourceClassificationField? = nil, parent: TriStateField<FolderMini> = nil, ownedBy: UserMini? = nil) {
        self.itemType = itemType
        self.itemId = itemId
        self.itemName = itemName
        self.classification = classification
        self._parent = CodableTriState(state: parent)
        self.ownedBy = ownedBy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemType = try container.decode(EventSourceItemTypeField.self, forKey: .itemType)
        itemId = try container.decode(String.self, forKey: .itemId)
        itemName = try container.decode(String.self, forKey: .itemName)
        classification = try container.decodeIfPresent(EventSourceClassificationField.self, forKey: .classification)
        parent = try container.decodeIfPresent(FolderMini.self, forKey: .parent)
        ownedBy = try container.decodeIfPresent(UserMini.self, forKey: .ownedBy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(itemType, forKey: .itemType)
        try container.encode(itemId, forKey: .itemId)
        try container.encode(itemName, forKey: .itemName)
        try container.encodeIfPresent(classification, forKey: .classification)
        try container.encode(field: _parent.state, forKey: .parent)
        try container.encodeIfPresent(ownedBy, forKey: .ownedBy)
    }

}
