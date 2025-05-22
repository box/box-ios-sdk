import Foundation

/// A collection of items, including files and folders.
/// 
/// Currently, the only collection available
/// is the `favorites` collection.
/// 
/// The contents of a collection can be explored in a
/// similar way to which the contents of a folder is
/// explored.
public class Collection: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case collectionType = "collection_type"
    }

    /// The unique identifier for this collection.
    public let id: String?

    /// `collection`
    public let type: CollectionTypeField?

    /// The name of the collection.
    public let name: CollectionNameField?

    /// The type of the collection. This is used to
    /// determine the proper visual treatment for
    /// collections.
    public let collectionType: CollectionCollectionTypeField?

    /// Initializer for a Collection.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this collection.
    ///   - type: `collection`
    ///   - name: The name of the collection.
    ///   - collectionType: The type of the collection. This is used to
    ///     determine the proper visual treatment for
    ///     collections.
    public init(id: String? = nil, type: CollectionTypeField? = nil, name: CollectionNameField? = nil, collectionType: CollectionCollectionTypeField? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.collectionType = collectionType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(CollectionTypeField.self, forKey: .type)
        name = try container.decodeIfPresent(CollectionNameField.self, forKey: .name)
        collectionType = try container.decodeIfPresent(CollectionCollectionTypeField.self, forKey: .collectionType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(collectionType, forKey: .collectionType)
    }

}
