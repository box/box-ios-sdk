import Foundation

/// An app item association represents an association between a file or
/// folder and an app item. Associations between a folder and an app item
/// cascade down to all descendants of the folder.
public class AppItemAssociation: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case appItem = "app_item"
        case item
        case type
    }

    /// The unique identifier for this app item association.
    public let id: String

    public let appItem: AppItem

    public let item: FileBaseOrFolderBaseOrWebLinkBase

    /// `app_item_association`
    public let type: AppItemAssociationTypeField

    /// Initializer for a AppItemAssociation.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this app item association.
    ///   - appItem: 
    ///   - item: 
    ///   - type: `app_item_association`
    public init(id: String, appItem: AppItem, item: FileBaseOrFolderBaseOrWebLinkBase, type: AppItemAssociationTypeField = AppItemAssociationTypeField.appItemAssociation) {
        self.id = id
        self.appItem = appItem
        self.item = item
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        appItem = try container.decode(AppItem.self, forKey: .appItem)
        item = try container.decode(FileBaseOrFolderBaseOrWebLinkBase.self, forKey: .item)
        type = try container.decode(AppItemAssociationTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(appItem, forKey: .appItem)
        try container.encode(item, forKey: .item)
        try container.encode(type, forKey: .type)
    }

}
