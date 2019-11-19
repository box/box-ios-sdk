import Foundation

/// Object that points to URLs. These objects are also known as bookmarks within the Box web application.
public class WebLink: BoxModel {

    /// Web link permissions
    public struct Permissions: BoxInnerModel {
        public let canRename: Bool?
        public let canDelete: Bool?
        public let canComment: Bool?
        public let canShare: Bool?
        public let canSetShareAccess: Bool?
    }

    // MARK: - BoxModel

    private static var resourceType: String = "web_link"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    public let sequenceId: String?
    public let etag: String?
    /// The name of this web link.
    public let name: String?
    /// The URL this web link points to.
    public let url: URL?
    public let createdBy: User?
    public let createdAt: Date?
    public let modifiedAt: Date?
    /// The parent object the web link belongs to.
    public let parent: Folder?
    /// The description accompanying the web link. This is visible within the Box web application.
    public let description: String?
    public let itemStatus: ItemStatus?
    public let trashedAt: Date?
    public let purgedAt: Date?
    public let sharedLink: SharedLink?
    public let pathCollection: PathCollection?
    public let modifiedBy: User?
    public let ownedBy: User?
    public let permissions: Permissions?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == WebLink.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [WebLink.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        sequenceId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "sequence_id")
        etag = try BoxJSONDecoder.optionalDecode(json: json, forKey: "etag")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        url = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url")
        createdBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "created_by")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        parent = try BoxJSONDecoder.optionalDecode(json: json, forKey: "parent")
        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
        itemStatus = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "item_status")
        trashedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "trashed_at")
        purgedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "purged_at")
        sharedLink = try BoxJSONDecoder.optionalDecode(json: json, forKey: "shared_link")
        pathCollection = try BoxJSONDecoder.optionalDecode(json: json, forKey: "path_collection")
        modifiedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "modified_by")
        ownedBy = try BoxJSONDecoder.optionalDecode(json: json, forKey: "owned_by")
        permissions = try BoxJSONDecoder.optionalDecode(json: json, forKey: "permissions")
    }
}
