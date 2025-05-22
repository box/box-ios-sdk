import Foundation

public class CreateUserRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case login
        case isPlatformAccessOnly = "is_platform_access_only"
        case role
        case language
        case isSyncEnabled = "is_sync_enabled"
        case jobTitle = "job_title"
        case phone
        case address
        case spaceAmount = "space_amount"
        case trackingCodes = "tracking_codes"
        case canSeeManagedUsers = "can_see_managed_users"
        case timezone
        case isExternalCollabRestricted = "is_external_collab_restricted"
        case isExemptFromDeviceLimits = "is_exempt_from_device_limits"
        case isExemptFromLoginVerification = "is_exempt_from_login_verification"
        case status
        case externalAppUserId = "external_app_user_id"
    }

    /// The name of the user
    public let name: String

    /// The email address the user uses to log in
    /// 
    /// Required, unless `is_platform_access_only`
    /// is set to `true`.
    public let login: String?

    /// Specifies that the user is an app user.
    public let isPlatformAccessOnly: Bool?

    /// The user’s enterprise role
    public let role: CreateUserRequestBodyRoleField?

    /// The language of the user, formatted in modified version of the
    /// [ISO 639-1](/guides/api-calls/language-codes) format.
    public let language: String?

    /// Whether the user can use Box Sync
    public let isSyncEnabled: Bool?

    /// The user’s job title
    public let jobTitle: String?

    /// The user’s phone number
    public let phone: String?

    /// The user’s address
    public let address: String?

    /// The user’s total available space in bytes. Set this to `-1` to
    /// indicate unlimited storage.
    public let spaceAmount: Int64?

    /// Tracking codes allow an admin to generate reports from the
    /// admin console and assign an attribute to a specific group
    /// of users. This setting must be enabled for an enterprise before it
    /// can be used.
    public let trackingCodes: [TrackingCode]?

    /// Whether the user can see other enterprise users in their
    /// contact list
    public let canSeeManagedUsers: Bool?

    /// The user's timezone
    public let timezone: String?

    /// Whether the user is allowed to collaborate with users outside
    /// their enterprise
    public let isExternalCollabRestricted: Bool?

    /// Whether to exempt the user from enterprise device limits
    public let isExemptFromDeviceLimits: Bool?

    /// Whether the user must use two-factor authentication
    public let isExemptFromLoginVerification: Bool?

    /// The user's account status
    public let status: CreateUserRequestBodyStatusField?

    /// An external identifier for an app user, which can be used to look
    /// up the user. This can be used to tie user IDs from external
    /// identity providers to Box users.
    public let externalAppUserId: String?

    /// Initializer for a CreateUserRequestBody.
    ///
    /// - Parameters:
    ///   - name: The name of the user
    ///   - login: The email address the user uses to log in
    ///     
    ///     Required, unless `is_platform_access_only`
    ///     is set to `true`.
    ///   - isPlatformAccessOnly: Specifies that the user is an app user.
    ///   - role: The user’s enterprise role
    ///   - language: The language of the user, formatted in modified version of the
    ///     [ISO 639-1](/guides/api-calls/language-codes) format.
    ///   - isSyncEnabled: Whether the user can use Box Sync
    ///   - jobTitle: The user’s job title
    ///   - phone: The user’s phone number
    ///   - address: The user’s address
    ///   - spaceAmount: The user’s total available space in bytes. Set this to `-1` to
    ///     indicate unlimited storage.
    ///   - trackingCodes: Tracking codes allow an admin to generate reports from the
    ///     admin console and assign an attribute to a specific group
    ///     of users. This setting must be enabled for an enterprise before it
    ///     can be used.
    ///   - canSeeManagedUsers: Whether the user can see other enterprise users in their
    ///     contact list
    ///   - timezone: The user's timezone
    ///   - isExternalCollabRestricted: Whether the user is allowed to collaborate with users outside
    ///     their enterprise
    ///   - isExemptFromDeviceLimits: Whether to exempt the user from enterprise device limits
    ///   - isExemptFromLoginVerification: Whether the user must use two-factor authentication
    ///   - status: The user's account status
    ///   - externalAppUserId: An external identifier for an app user, which can be used to look
    ///     up the user. This can be used to tie user IDs from external
    ///     identity providers to Box users.
    public init(name: String, login: String? = nil, isPlatformAccessOnly: Bool? = nil, role: CreateUserRequestBodyRoleField? = nil, language: String? = nil, isSyncEnabled: Bool? = nil, jobTitle: String? = nil, phone: String? = nil, address: String? = nil, spaceAmount: Int64? = nil, trackingCodes: [TrackingCode]? = nil, canSeeManagedUsers: Bool? = nil, timezone: String? = nil, isExternalCollabRestricted: Bool? = nil, isExemptFromDeviceLimits: Bool? = nil, isExemptFromLoginVerification: Bool? = nil, status: CreateUserRequestBodyStatusField? = nil, externalAppUserId: String? = nil) {
        self.name = name
        self.login = login
        self.isPlatformAccessOnly = isPlatformAccessOnly
        self.role = role
        self.language = language
        self.isSyncEnabled = isSyncEnabled
        self.jobTitle = jobTitle
        self.phone = phone
        self.address = address
        self.spaceAmount = spaceAmount
        self.trackingCodes = trackingCodes
        self.canSeeManagedUsers = canSeeManagedUsers
        self.timezone = timezone
        self.isExternalCollabRestricted = isExternalCollabRestricted
        self.isExemptFromDeviceLimits = isExemptFromDeviceLimits
        self.isExemptFromLoginVerification = isExemptFromLoginVerification
        self.status = status
        self.externalAppUserId = externalAppUserId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        login = try container.decodeIfPresent(String.self, forKey: .login)
        isPlatformAccessOnly = try container.decodeIfPresent(Bool.self, forKey: .isPlatformAccessOnly)
        role = try container.decodeIfPresent(CreateUserRequestBodyRoleField.self, forKey: .role)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        isSyncEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSyncEnabled)
        jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        spaceAmount = try container.decodeIfPresent(Int64.self, forKey: .spaceAmount)
        trackingCodes = try container.decodeIfPresent([TrackingCode].self, forKey: .trackingCodes)
        canSeeManagedUsers = try container.decodeIfPresent(Bool.self, forKey: .canSeeManagedUsers)
        timezone = try container.decodeIfPresent(String.self, forKey: .timezone)
        isExternalCollabRestricted = try container.decodeIfPresent(Bool.self, forKey: .isExternalCollabRestricted)
        isExemptFromDeviceLimits = try container.decodeIfPresent(Bool.self, forKey: .isExemptFromDeviceLimits)
        isExemptFromLoginVerification = try container.decodeIfPresent(Bool.self, forKey: .isExemptFromLoginVerification)
        status = try container.decodeIfPresent(CreateUserRequestBodyStatusField.self, forKey: .status)
        externalAppUserId = try container.decodeIfPresent(String.self, forKey: .externalAppUserId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(login, forKey: .login)
        try container.encodeIfPresent(isPlatformAccessOnly, forKey: .isPlatformAccessOnly)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(isSyncEnabled, forKey: .isSyncEnabled)
        try container.encodeIfPresent(jobTitle, forKey: .jobTitle)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(spaceAmount, forKey: .spaceAmount)
        try container.encodeIfPresent(trackingCodes, forKey: .trackingCodes)
        try container.encodeIfPresent(canSeeManagedUsers, forKey: .canSeeManagedUsers)
        try container.encodeIfPresent(timezone, forKey: .timezone)
        try container.encodeIfPresent(isExternalCollabRestricted, forKey: .isExternalCollabRestricted)
        try container.encodeIfPresent(isExemptFromDeviceLimits, forKey: .isExemptFromDeviceLimits)
        try container.encodeIfPresent(isExemptFromLoginVerification, forKey: .isExemptFromLoginVerification)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(externalAppUserId, forKey: .externalAppUserId)
    }

}
