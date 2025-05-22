import Foundation

/// A full representation of a user, as can be returned from any
/// user API endpoint.
public class UserFull: User {
    
    override func setRawData(_ rawData: [String: Any]?) {
        self._rawData = rawData
    }
    
    //
    private var _rawData: [String: Any]?
    
    //
    public override var rawData: [String: Any]? {
        return _rawData
    }
    
    //
    private enum CodingKeys: String, CodingKey {
        case role
        case trackingCodes = "tracking_codes"
        case canSeeManagedUsers = "can_see_managed_users"
        case isSyncEnabled = "is_sync_enabled"
        case isExternalCollabRestricted = "is_external_collab_restricted"
        case isExemptFromDeviceLimits = "is_exempt_from_device_limits"
        case isExemptFromLoginVerification = "is_exempt_from_login_verification"
        case enterprise
        case myTags = "my_tags"
        case hostname
        case isPlatformAccessOnly = "is_platform_access_only"
        case externalAppUserId = "external_app_user_id"
    }
    
    /// The user’s enterprise role
    public let role: UserFullRoleField?
    
    /// Tracking codes allow an admin to generate reports from the
    /// admin console and assign an attribute to a specific group
    /// of users. This setting must be enabled for an enterprise
    /// before it can be used.
    public let trackingCodes: [TrackingCode]?
    
    /// Whether the user can see other enterprise users in their contact list
    public let canSeeManagedUsers: Bool?
    
    /// Whether the user can use Box Sync
    public let isSyncEnabled: Bool?
    
    /// Whether the user is allowed to collaborate with users outside their
    /// enterprise
    public let isExternalCollabRestricted: Bool?
    
    /// Whether to exempt the user from Enterprise device limits
    public let isExemptFromDeviceLimits: Bool?
    
    /// Whether the user must use two-factor authentication
    public let isExemptFromLoginVerification: Bool?
    
    public let enterprise: UserFullEnterpriseField?
    
    /// Tags for all files and folders owned by the user. Values returned
    /// will only contain tags that were set by the requester.
    public let myTags: [String]?
    
    /// The root (protocol, subdomain, domain) of any links that need to be
    /// generated for the user
    public let hostname: String?
    
    /// Whether the user is an App User
    public let isPlatformAccessOnly: Bool?
    
    /// An external identifier for an app user, which can be used to look up
    /// the user. This can be used to tie user IDs from external identity
    /// providers to Box users.
    public let externalAppUserId: String?
    
    /// Initializer for a UserFull.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this user
    ///   - type: `user`
    ///   - name: The display name of this user
    ///   - login: The primary email address of this user
    ///   - createdAt: When the user object was created
    ///   - modifiedAt: When the user object was last modified
    ///   - language: The language of the user, formatted in modified version of the
    ///     [ISO 639-1](/guides/api-calls/language-codes) format.
    ///   - timezone: The user's timezone
    ///   - spaceAmount: The user’s total available space amount in bytes
    ///   - spaceUsed: The amount of space in use by the user
    ///   - maxUploadSize: The maximum individual file size in bytes the user can have
    ///   - status: The user's account status
    ///   - jobTitle: The user’s job title
    ///   - phone: The user’s phone number
    ///   - address: The user’s address
    ///   - avatarUrl: URL of the user’s avatar image
    ///   - notificationEmail: An alternate notification email address to which email
    ///     notifications are sent. When it's confirmed, this will be
    ///     the email address to which notifications are sent instead of
    ///     to the primary email address.
    ///   - role: The user’s enterprise role
    ///   - trackingCodes: Tracking codes allow an admin to generate reports from the
    ///     admin console and assign an attribute to a specific group
    ///     of users. This setting must be enabled for an enterprise
    ///     before it can be used.
    ///   - canSeeManagedUsers: Whether the user can see other enterprise users in their contact list
    ///   - isSyncEnabled: Whether the user can use Box Sync
    ///   - isExternalCollabRestricted: Whether the user is allowed to collaborate with users outside their
    ///     enterprise
    ///   - isExemptFromDeviceLimits: Whether to exempt the user from Enterprise device limits
    ///   - isExemptFromLoginVerification: Whether the user must use two-factor authentication
    ///   - enterprise:
    ///   - myTags: Tags for all files and folders owned by the user. Values returned
    ///     will only contain tags that were set by the requester.
    ///   - hostname: The root (protocol, subdomain, domain) of any links that need to be
    ///     generated for the user
    ///   - isPlatformAccessOnly: Whether the user is an App User
    ///   - externalAppUserId: An external identifier for an app user, which can be used to look up
    ///     the user. This can be used to tie user IDs from external identity
    ///     providers to Box users.
    public init(id: String, type: UserBaseTypeField = UserBaseTypeField.user, name: String? = nil, login: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, language: String? = nil, timezone: String? = nil, spaceAmount: Int64? = nil, spaceUsed: Int64? = nil, maxUploadSize: Int64? = nil, status: UserStatusField? = nil, jobTitle: String? = nil, phone: String? = nil, address: String? = nil, avatarUrl: String? = nil, notificationEmail: TriStateField<UserNotificationEmailField> = nil, role: UserFullRoleField? = nil, trackingCodes: [TrackingCode]? = nil, canSeeManagedUsers: Bool? = nil, isSyncEnabled: Bool? = nil, isExternalCollabRestricted: Bool? = nil, isExemptFromDeviceLimits: Bool? = nil, isExemptFromLoginVerification: Bool? = nil, enterprise: UserFullEnterpriseField? = nil, myTags: [String]? = nil, hostname: String? = nil, isPlatformAccessOnly: Bool? = nil, externalAppUserId: String? = nil) {
        self.role = role
        self.trackingCodes = trackingCodes
        self.canSeeManagedUsers = canSeeManagedUsers
        self.isSyncEnabled = isSyncEnabled
        self.isExternalCollabRestricted = isExternalCollabRestricted
        self.isExemptFromDeviceLimits = isExemptFromDeviceLimits
        self.isExemptFromLoginVerification = isExemptFromLoginVerification
        self.enterprise = enterprise
        self.myTags = myTags
        self.hostname = hostname
        self.isPlatformAccessOnly = isPlatformAccessOnly
        self.externalAppUserId = externalAppUserId
        
        super.init(id: id, type: type, name: name, login: login, createdAt: createdAt, modifiedAt: modifiedAt, language: language, timezone: timezone, spaceAmount: spaceAmount, spaceUsed: spaceUsed, maxUploadSize: maxUploadSize, status: status, jobTitle: jobTitle, phone: phone, address: address, avatarUrl: avatarUrl, notificationEmail: notificationEmail)
    }
    
    required public init(from decoder: Decoder) throws {
        
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decodeIfPresent(UserFullRoleField.self, forKey: .role)
        trackingCodes = try container.decodeIfPresent([TrackingCode].self, forKey: .trackingCodes)
        canSeeManagedUsers = try container.decodeIfPresent(Bool.self, forKey: .canSeeManagedUsers)
        isSyncEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSyncEnabled)
        isExternalCollabRestricted = try container.decodeIfPresent(Bool.self, forKey: .isExternalCollabRestricted)
        isExemptFromDeviceLimits = try container.decodeIfPresent(Bool.self, forKey: .isExemptFromDeviceLimits)
        isExemptFromLoginVerification = try container.decodeIfPresent(Bool.self, forKey: .isExemptFromLoginVerification)
        enterprise = try container.decodeIfPresent(UserFullEnterpriseField.self, forKey: .enterprise)
        myTags = try container.decodeIfPresent([String].self, forKey: .myTags)
        hostname = try container.decodeIfPresent(String.self, forKey: .hostname)
        isPlatformAccessOnly = try container.decodeIfPresent(Bool.self, forKey: .isPlatformAccessOnly)
        externalAppUserId = try container.decodeIfPresent(String.self, forKey: .externalAppUserId)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(trackingCodes, forKey: .trackingCodes)
        try container.encodeIfPresent(canSeeManagedUsers, forKey: .canSeeManagedUsers)
        try container.encodeIfPresent(isSyncEnabled, forKey: .isSyncEnabled)
        try container.encodeIfPresent(isExternalCollabRestricted, forKey: .isExternalCollabRestricted)
        try container.encodeIfPresent(isExemptFromDeviceLimits, forKey: .isExemptFromDeviceLimits)
        try container.encodeIfPresent(isExemptFromLoginVerification, forKey: .isExemptFromLoginVerification)
        try container.encodeIfPresent(enterprise, forKey: .enterprise)
        try container.encodeIfPresent(myTags, forKey: .myTags)
        try container.encodeIfPresent(hostname, forKey: .hostname)
        try container.encodeIfPresent(isPlatformAccessOnly, forKey: .isPlatformAccessOnly)
        try container.encodeIfPresent(externalAppUserId, forKey: .externalAppUserId)
        try super.encode(to: encoder)
    }
    
}

