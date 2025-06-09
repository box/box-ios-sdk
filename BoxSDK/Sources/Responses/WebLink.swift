import Foundation

/// Object that points to URLs. These objects are also known as bookmarks within the Box web application.
public class WebLink: BoxModel {

    /// Web link permissions
    public struct Permissions: BoxInnerModel {
        /// Can rename web link
        public let canRename: Bool?
        /// Can delete web link
        public let canDelete: Bool?
        /// Can comment on web link
        public let canComment: Bool?
        /// Can share web link
        public let canShare: Bool?
        /// Can set share access for web link
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
    /// A unique ID for use with the events.
    public let sequenceId: String?
    /// The entity tag of this web link. Used with If-Match headers.
    public let etag: String?
    /// The name of this web link.
    public let name: String?
    /// The URL this web link points to.
    public let url: URL?
    /// The user who created this web link
    public let createdBy: User?
    /// When this web link was created
    public let createdAt: Date?
    /// When this web link was last updated
    public let modifiedAt: Date?
    /// The parent object the web link belongs to.
    public let parent: Folder?
    /// The description accompanying the web link. This is visible within the Box web application.
    public let description: String?
    /// Status of the web link
    public let itemStatus: ItemStatus?
    /// When this web link was last moved to the trash
    public let trashedAt: Date?
    /// When this web link will be permanently deleted.
    public let purgedAt: Date?
    /// The shared link object for this web link. Is nil if no shared link has been created.
    public let sharedLink: SharedLink?
    /// The path of folders to this link, starting at the root
    public let pathCollection: PathCollection?
    /// The user who last modified this web link
    public let modifiedBy: User?
    /// The user who owns this web link
    public let ownedBy: User?
    /// Web link permissions
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
