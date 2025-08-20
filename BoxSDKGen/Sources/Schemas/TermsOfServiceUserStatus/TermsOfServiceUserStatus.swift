import Foundation

/// The association between a Terms of Service and a user.
public class TermsOfServiceUserStatus: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case tos
        case user
        case isAccepted = "is_accepted"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this terms of service user status.
    public let id: String

    /// The value will always be `terms_of_service_user_status`.
    public let type: TermsOfServiceUserStatusTypeField

    public let tos: TermsOfServiceBase?

    public let user: UserMini?

    /// If the user has accepted the terms of services.
    public let isAccepted: Bool?

    /// When the legal item was created.
    public let createdAt: Date?

    /// When the legal item was modified.
    public let modifiedAt: Date?

    /// Initializer for a TermsOfServiceUserStatus.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this terms of service user status.
    ///   - type: The value will always be `terms_of_service_user_status`.
    ///   - tos: 
    ///   - user: 
    ///   - isAccepted: If the user has accepted the terms of services.
    ///   - createdAt: When the legal item was created.
    ///   - modifiedAt: When the legal item was modified.
    public init(id: String, type: TermsOfServiceUserStatusTypeField = TermsOfServiceUserStatusTypeField.termsOfServiceUserStatus, tos: TermsOfServiceBase? = nil, user: UserMini? = nil, isAccepted: Bool? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil) {
        self.id = id
        self.type = type
        self.tos = tos
        self.user = user
        self.isAccepted = isAccepted
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(TermsOfServiceUserStatusTypeField.self, forKey: .type)
        tos = try container.decodeIfPresent(TermsOfServiceBase.self, forKey: .tos)
        user = try container.decodeIfPresent(UserMini.self, forKey: .user)
        isAccepted = try container.decodeIfPresent(Bool.self, forKey: .isAccepted)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(tos, forKey: .tos)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(isAccepted, forKey: .isAccepted)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
