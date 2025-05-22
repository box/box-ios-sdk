import Foundation

public class UpdateUserByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case enterprise
        case notify
        case name
        case login
        case role
        case language
        case isSyncEnabled = "is_sync_enabled"
        case jobTitle = "job_title"
        case phone
        case address
        case trackingCodes = "tracking_codes"
        case canSeeManagedUsers = "can_see_managed_users"
        case timezone
        case isExternalCollabRestricted = "is_external_collab_restricted"
        case isExemptFromDeviceLimits = "is_exempt_from_device_limits"
        case isExemptFromLoginVerification = "is_exempt_from_login_verification"
        case isPasswordResetRequired = "is_password_reset_required"
        case status
        case spaceAmount = "space_amount"
        case notificationEmail = "notification_email"
        case externalAppUserId = "external_app_user_id"
    }

    /// Set this to `null` to roll the user out of the enterprise
    /// and make them a free user
    @CodableTriState public private(set) var enterprise: String?

    /// Whether the user should receive an email when they
    /// are rolled out of an enterprise
    public let notify: Bool?

    /// The name of the user
    public let name: String?

    /// The email address the user uses to log in
    /// 
    /// Note: If the target user's email is not confirmed, then the
    /// primary login address cannot be changed.
    public let login: String?

    /// The user’s enterprise role
    public let role: UpdateUserByIdRequestBodyRoleField?

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

    /// Whether the user is required to reset their password
    public let isPasswordResetRequired: Bool?

    /// The user's account status
    public let status: UpdateUserByIdRequestBodyStatusField?

    /// The user’s total available space in bytes. Set this to `-1` to
    /// indicate unlimited storage.
    public let spaceAmount: Int64?

    /// An alternate notification email address to which email
    /// notifications are sent. When it's confirmed, this will be
    /// the email address to which notifications are sent instead of
    /// to the primary email address.
    /// 
    /// Set this value to `null` to remove the notification email.
    @CodableTriState public private(set) var notificationEmail: UpdateUserByIdRequestBodyNotificationEmailField?

    /// An external identifier for an app user, which can be used to look
    /// up the user. This can be used to tie user IDs from external
    /// identity providers to Box users.
    /// 
    /// Note: In order to update this field, you need to request a token
    /// using the application that created the app user.
    public let externalAppUserId: String?

    /// Initializer for a UpdateUserByIdRequestBody.
    ///
    /// - Parameters:
    ///   - enterprise: Set this to `null` to roll the user out of the enterprise
    ///     and make them a free user
    ///   - notify: Whether the user should receive an email when they
    ///     are rolled out of an enterprise
    ///   - name: The name of the user
    ///   - login: The email address the user uses to log in
    ///     
    ///     Note: If the target user's email is not confirmed, then the
    ///     primary login address cannot be changed.
    ///   - role: The user’s enterprise role
    ///   - language: The language of the user, formatted in modified version of the
    ///     [ISO 639-1](/guides/api-calls/language-codes) format.
    ///   - isSyncEnabled: Whether the user can use Box Sync
    ///   - jobTitle: The user’s job title
    ///   - phone: The user’s phone number
    ///   - address: The user’s address
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
    ///   - isPasswordResetRequired: Whether the user is required to reset their password
    ///   - status: The user's account status
    ///   - spaceAmount: The user’s total available space in bytes. Set this to `-1` to
    ///     indicate unlimited storage.
    ///   - notificationEmail: An alternate notification email address to which email
    ///     notifications are sent. When it's confirmed, this will be
    ///     the email address to which notifications are sent instead of
    ///     to the primary email address.
    ///     
    ///     Set this value to `null` to remove the notification email.
    ///   - externalAppUserId: An external identifier for an app user, which can be used to look
    ///     up the user. This can be used to tie user IDs from external
    ///     identity providers to Box users.
    ///     
    ///     Note: In order to update this field, you need to request a token
    ///     using the application that created the app user.
    public init(enterprise: TriStateField<String> = nil, notify: Bool? = nil, name: String? = nil, login: String? = nil, role: UpdateUserByIdRequestBodyRoleField? = nil, language: String? = nil, isSyncEnabled: Bool? = nil, jobTitle: String? = nil, phone: String? = nil, address: String? = nil, trackingCodes: [TrackingCode]? = nil, canSeeManagedUsers: Bool? = nil, timezone: String? = nil, isExternalCollabRestricted: Bool? = nil, isExemptFromDeviceLimits: Bool? = nil, isExemptFromLoginVerification: Bool? = nil, isPasswordResetRequired: Bool? = nil, status: UpdateUserByIdRequestBodyStatusField? = nil, spaceAmount: Int64? = nil, notificationEmail: TriStateField<UpdateUserByIdRequestBodyNotificationEmailField> = nil, externalAppUserId: String? = nil) {
        self._enterprise = CodableTriState(state: enterprise)
        self.notify = notify
        self.name = name
        self.login = login
        self.role = role
        self.language = language
        self.isSyncEnabled = isSyncEnabled
        self.jobTitle = jobTitle
        self.phone = phone
        self.address = address
        self.trackingCodes = trackingCodes
        self.canSeeManagedUsers = canSeeManagedUsers
        self.timezone = timezone
        self.isExternalCollabRestricted = isExternalCollabRestricted
        self.isExemptFromDeviceLimits = isExemptFromDeviceLimits
        self.isExemptFromLoginVerification = isExemptFromLoginVerification
        self.isPasswordResetRequired = isPasswordResetRequired
        self.status = status
        self.spaceAmount = spaceAmount
        self._notificationEmail = CodableTriState(state: notificationEmail)
        self.externalAppUserId = externalAppUserId
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterprise = try container.decodeIfPresent(String.self, forKey: .enterprise)
        notify = try container.decodeIfPresent(Bool.self, forKey: .notify)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        login = try container.decodeIfPresent(String.self, forKey: .login)
        role = try container.decodeIfPresent(UpdateUserByIdRequestBodyRoleField.self, forKey: .role)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        isSyncEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSyncEnabled)
        jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        trackingCodes = try container.decodeIfPresent([TrackingCode].self, forKey: .trackingCodes)
        canSeeManagedUsers = try container.decodeIfPresent(Bool.self, forKey: .canSeeManagedUsers)
        timezone = try container.decodeIfPresent(String.self, forKey: .timezone)
        isExternalCollabRestricted = try container.decodeIfPresent(Bool.self, forKey: .isExternalCollabRestricted)
        isExemptFromDeviceLimits = try container.decodeIfPresent(Bool.self, forKey: .isExemptFromDeviceLimits)
        isExemptFromLoginVerification = try container.decodeIfPresent(Bool.self, forKey: .isExemptFromLoginVerification)
        isPasswordResetRequired = try container.decodeIfPresent(Bool.self, forKey: .isPasswordResetRequired)
        status = try container.decodeIfPresent(UpdateUserByIdRequestBodyStatusField.self, forKey: .status)
        spaceAmount = try container.decodeIfPresent(Int64.self, forKey: .spaceAmount)
        notificationEmail = try container.decodeIfPresent(UpdateUserByIdRequestBodyNotificationEmailField.self, forKey: .notificationEmail)
        externalAppUserId = try container.decodeIfPresent(String.self, forKey: .externalAppUserId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _enterprise.state, forKey: .enterprise)
        try container.encodeIfPresent(notify, forKey: .notify)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(login, forKey: .login)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(isSyncEnabled, forKey: .isSyncEnabled)
        try container.encodeIfPresent(jobTitle, forKey: .jobTitle)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(trackingCodes, forKey: .trackingCodes)
        try container.encodeIfPresent(canSeeManagedUsers, forKey: .canSeeManagedUsers)
        try container.encodeIfPresent(timezone, forKey: .timezone)
        try container.encodeIfPresent(isExternalCollabRestricted, forKey: .isExternalCollabRestricted)
        try container.encodeIfPresent(isExemptFromDeviceLimits, forKey: .isExemptFromDeviceLimits)
        try container.encodeIfPresent(isExemptFromLoginVerification, forKey: .isExemptFromLoginVerification)
        try container.encodeIfPresent(isPasswordResetRequired, forKey: .isPasswordResetRequired)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(spaceAmount, forKey: .spaceAmount)
        try container.encode(field: _notificationEmail.state, forKey: .notificationEmail)
        try container.encodeIfPresent(externalAppUserId, forKey: .externalAppUserId)
    }

}
