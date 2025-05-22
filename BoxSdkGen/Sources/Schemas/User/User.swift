import Foundation

/// A standard representation of a user, as returned from any
/// user API endpoints by default
public class User: UserMini, RawJSONStorage {
    func setRawData(_ rawData: [String : Any]?) {
        
    }
    
    var abc:[String: Any]? = nil
    private var _rawData: [String: Any]?
    public var rawData: [String: Any]? {
        return _rawData
    }
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case language
        case timezone
        case spaceAmount = "space_amount"
        case spaceUsed = "space_used"
        case maxUploadSize = "max_upload_size"
        case status
        case jobTitle = "job_title"
        case phone
        case address
        case avatarUrl = "avatar_url"
        case notificationEmail = "notification_email"
    }

    /// When the user object was created
    public let createdAt: Date?

    /// When the user object was last modified
    public let modifiedAt: Date?

    /// The language of the user, formatted in modified version of the
    /// [ISO 639-1](/guides/api-calls/language-codes) format.
    public let language: String?

    /// The user's timezone
    public let timezone: String?

    /// The user’s total available space amount in bytes
    public let spaceAmount: Int64?

    /// The amount of space in use by the user
    public let spaceUsed: Int64?

    /// The maximum individual file size in bytes the user can have
    public let maxUploadSize: Int64?

    /// The user's account status
    public let status: UserStatusField?

    /// The user’s job title
    public let jobTitle: String?

    /// The user’s phone number
    public let phone: String?

    /// The user’s address
    public let address: String?

    /// URL of the user’s avatar image
    public let avatarUrl: String?

    /// An alternate notification email address to which email
    /// notifications are sent. When it's confirmed, this will be
    /// the email address to which notifications are sent instead of
    /// to the primary email address.
    @CodableTriState public private(set) var notificationEmail: UserNotificationEmailField?

    /// Initializer for a User.
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
    public init(id: String, type: UserBaseTypeField = UserBaseTypeField.user, name: String? = nil, login: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, language: String? = nil, timezone: String? = nil, spaceAmount: Int64? = nil, spaceUsed: Int64? = nil, maxUploadSize: Int64? = nil, status: UserStatusField? = nil, jobTitle: String? = nil, phone: String? = nil, address: String? = nil, avatarUrl: String? = nil, notificationEmail: TriStateField<UserNotificationEmailField> = nil) {
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.language = language
        self.timezone = timezone
        self.spaceAmount = spaceAmount
        self.spaceUsed = spaceUsed
        self.maxUploadSize = maxUploadSize
        self.status = status
        self.jobTitle = jobTitle
        self.phone = phone
        self.address = address
        self.avatarUrl = avatarUrl
        self._notificationEmail = CodableTriState(state: notificationEmail)

        super.init(id: id, type: type, name: name, login: login)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        timezone = try container.decodeIfPresent(String.self, forKey: .timezone)
        spaceAmount = try container.decodeIfPresent(Int64.self, forKey: .spaceAmount)
        spaceUsed = try container.decodeIfPresent(Int64.self, forKey: .spaceUsed)
        maxUploadSize = try container.decodeIfPresent(Int64.self, forKey: .maxUploadSize)
        status = try container.decodeIfPresent(UserStatusField.self, forKey: .status)
        jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        notificationEmail = try container.decodeIfPresent(UserNotificationEmailField.self, forKey: .notificationEmail)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(timezone, forKey: .timezone)
        try container.encodeIfPresent(spaceAmount, forKey: .spaceAmount)
        try container.encodeIfPresent(spaceUsed, forKey: .spaceUsed)
        try container.encodeIfPresent(maxUploadSize, forKey: .maxUploadSize)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(jobTitle, forKey: .jobTitle)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(avatarUrl, forKey: .avatarUrl)
        try container.encode(field: _notificationEmail.state, forKey: .notificationEmail)
        try super.encode(to: encoder)
    }

}
