import Foundation

/// Defines the level of access to the item by its shared link.
public enum SharedLinkAccess: BoxEnum {
    /// Anyone with the link can access.
    case open
    /// People in your company can access.
    case company
    /// People in this folder can access.
    case collaborators
    /// Custom value for enum values not yet implemented by the SDK
    case customValue(String)

    public init(_ value: String) {
        switch value {
        case "open":
            self = .open
        case "company":
            self = .company
        case "collaborators":
            self = .collaborators
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .open:
            return "open"
        case .company:
            return "company"
        case .collaborators:
            return "collaborators"
        case let .customValue(value):
            return value
        }
    }
}

/// Provides direct, read-only access to files or folder on Box using a URL
public class SharedLink: BoxModel {

    /// Permission for a user accessing item by shared link
    public struct Permissions: BoxInnerModel {
        /// Whether the shared link allows previewing. For shared links on folders, this also applies to any items in the folder.
        public let canPreview: Bool?
        /// Whether the shared link allows downloads. For shared links on folders, this also applies to any items in the folder.
        public let canDownload: Bool?
    }

    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// The URL to access the item on Box. If entered in a browser, this URL will display the item in Box's preview UI.
    /// If a custom URL is set this field will return the custom URL, but the original URL will also continue to work.
    public let url: URL?
    /// The "direct Link" URL to download the item. If entered in a browser, this URL will trigger a download of the item.
    /// This URL includes the file extension so that the file will be saved with the right file type.
    public let downloadURL: URL?
    /// The "Custom URL" that can also be used to preview the item on Box.
    /// Custom URLs can only be created or modified in the Box Web application.
    public let vanityURL: URL?
    /// The effective access level for the shared link. This can be lower than the value in the access field
    /// if the enterprise settings restrict the allowed access levels.
    public let effectiveAccess: String?
    /// Actual permissions that are allowed by the shared link, taking into account enterprise and user settings.
    public let effectivePermission: String?
    /// Whether the shared link has a password set.
    public let isPasswordEnabled: Bool?
    /// The date-time that this link will become disabled. This field can only be set by users with paid accounts.
    public let unsharedAt: Date?
    /// The number of times the item has been downloaded.
    public let downloadCount: Int?
    /// The number of times the item has been previewed.
    public let previewCount: Int?
    /// The access level specified when the shared link was created.
    public let access: SharedLinkAccess?
    /// Permissions for download and preview of the item.
    public let permissions: Permissions?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        url = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url")
        downloadURL = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "download_url")
        vanityURL = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "vanity_url")
        effectiveAccess = try BoxJSONDecoder.optionalDecode(json: json, forKey: "effective_access")
        effectivePermission = try BoxJSONDecoder.optionalDecode(json: json, forKey: "effective_permission")
        isPasswordEnabled = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_password_enabled")
        unsharedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "unshared_at")
        downloadCount = try BoxJSONDecoder.optionalDecode(json: json, forKey: "download_count")
        previewCount = try BoxJSONDecoder.optionalDecode(json: json, forKey: "preview_count")
        access = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "access")
        permissions = try BoxJSONDecoder.optionalDecode(json: json, forKey: "permissions")
    }
}
