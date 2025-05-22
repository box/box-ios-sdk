import Foundation

/// User of the Box application.
public class User: BoxModel {

    /// A custom values set by the user's admin to track user's activity.
    public struct TrackingCode: BoxInnerModel {
        /// Code name
        public let name: String
        /// Code value
        public let value: String
    }

    // MARK: - BoxModel

    private static var resourceType: String = "user"
    /// Box item type
    public var type: String
    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Identifier
    public let id: String
    /// The name of the user.
    public let name: String?
    /// The email address the user uses to log in.
    public let login: String?
    /// When the user object was created.
    public let createdAt: Date?
    /// When the user object was last modified.
    public let modifiedAt: Date?
    /// The user's preferred language.
    public let language: String?
    /// The user's timezone.
    public let timezone: String?
    /// The user’s total available space amount in bytes.
    public let spaceAmount: Int?
    /// The amount of space in use by the user.
    public let spaceUsed: Int?
    /// The maximum individual file size in bytes the user can have.
    public let maxUploadSize: Int?
    /// User's status.
    public let status: UserStatus?
    /// The user’s job title.
    public let jobTitle: String?
    /// The user’s phone number.
    public let phone: String?
    /// The user’s address.
    public let address: String?
    /// URL of the user’s avatar image.
    public let avatarUrl: URL?
    /// The user’s enterprise role.
    public let role: String?
    /// An array of key/value pairs set by the user’s admin.
    public let trackingCodes: [TrackingCode]?
    /// Whether the user can see other enterprise users in their contact list.
    public let canSeeManagedUsers: Bool?
    /// Whether the user can use Box Sync.
    public let isSyncEnabled: Bool?
    /// Whether the user is allowed to collaborate with users outside her enterprise.
    public let isExternalCollabRestricted: Bool?
    /// Whether to exempt the user from Enterprise device limits.
    public let isExemptFromDeviceLimits: Bool?
    /// Whether the user must use two-factor authentication.
    public let isExemptFromLoginVerification: Bool?
    /// Mini representation of the user’s enterprise.
    public let enterprise: Enterprise?
    /// Tags for all files and folders owned by the user. Values returned will only contain tags that were set by the requester.
    public let myTags: [String]?
    /// The root (protocol, subdomain, domain) of any links that need to be generated for the user.
    public let hostname: String?
    /// Whether the user is an App User.
    public let isPlatformAccessOnly: Bool?
    /// External app user ID.
    public let externalAppUserId: String?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        guard let itemType = json["type"] as? String else {
            throw BoxCodingError(message: .typeMismatch(key: "type"))
        }

        guard itemType == User.resourceType else {
            throw BoxCodingError(message: .valueMismatch(key: "type", value: itemType, acceptedValues: [User.resourceType]))
        }

        rawData = json
        type = itemType

        id = try BoxJSONDecoder.decode(json: json, forKey: "id")
        name = try BoxJSONDecoder.optionalDecode(json: json, forKey: "name")
        login = try BoxJSONDecoder.optionalDecode(json: json, forKey: "login")
        createdAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "created_at")
        modifiedAt = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "modified_at")
        language = try BoxJSONDecoder.optionalDecode(json: json, forKey: "language")
        timezone = try BoxJSONDecoder.optionalDecode(json: json, forKey: "timezone")
        spaceAmount = try BoxJSONDecoder.optionalDecode(json: json, forKey: "space_amount")
        spaceUsed = try BoxJSONDecoder.optionalDecode(json: json, forKey: "space_used")
        maxUploadSize = try BoxJSONDecoder.optionalDecode(json: json, forKey: "max_upload_size")
        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
        jobTitle = try BoxJSONDecoder.optionalDecode(json: json, forKey: "job_title")
        phone = try BoxJSONDecoder.optionalDecode(json: json, forKey: "phone")
        address = try BoxJSONDecoder.optionalDecode(json: json, forKey: "address")
        avatarUrl = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "avatar_url")
        role = try BoxJSONDecoder.optionalDecode(json: json, forKey: "role")
        canSeeManagedUsers = try BoxJSONDecoder.optionalDecode(json: json, forKey: "can_see_managed_users")
        isSyncEnabled = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_sync_enabled")
        isExternalCollabRestricted = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_external_collab_restricted")
        isExemptFromDeviceLimits = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_exempt_from_device_limits")
        isExemptFromLoginVerification = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_exempt_from_login_verification")
        enterprise = try BoxJSONDecoder.optionalDecode(json: json, forKey: "enterprise")
        myTags = try BoxJSONDecoder.optionalDecode(json: json, forKey: "my_tags")
        hostname = try BoxJSONDecoder.optionalDecode(json: json, forKey: "hostname")
        isPlatformAccessOnly = try BoxJSONDecoder.optionalDecode(json: json, forKey: "is_platform_access_only")
        trackingCodes = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "tracking_codes")
        externalAppUserId = try BoxJSONDecoder.optionalDecode(json: json, forKey: "external_app_user_id")
    }
}
