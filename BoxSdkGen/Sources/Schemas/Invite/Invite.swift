import Foundation

/// An invite for a user to an enterprise.
public class Invite: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case invitedTo = "invited_to"
        case actionableBy = "actionable_by"
        case invitedBy = "invited_by"
        case status
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case autoRollInAt = "auto_roll_in_at"
        case isAutoRollIn = "is_auto_roll_in"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this invite.
    public let id: String

    /// The value will always be `invite`.
    public let type: InviteTypeField

    /// A representation of a Box enterprise.
    public let invitedTo: InviteInvitedToField?

    public let actionableBy: UserMini?

    public let invitedBy: UserMini?

    /// The status of the invite.
    public let status: String?

    /// When the invite was created.
    public let createdAt: Date?

    /// When the invite was modified.
    public let modifiedAt: Date?

    /// The date and time when the user is added to the enterprise
    /// automatically, or `null` if the user has to accept the invite.
    @CodableTriState public private(set) var autoRollInAt: Date?

    /// Whether the user is added to the enterprise automatically, without
    /// having to accept the invite. When `true`, `auto_roll_in_at` contains
    /// the date and time of the roll-in.
    public let isAutoRollIn: Bool?

    /// Initializer for a Invite.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this invite.
    ///   - type: The value will always be `invite`.
    ///   - invitedTo: A representation of a Box enterprise.
    ///   - actionableBy: 
    ///   - invitedBy: 
    ///   - status: The status of the invite.
    ///   - createdAt: When the invite was created.
    ///   - modifiedAt: When the invite was modified.
    ///   - autoRollInAt: The date and time when the user is added to the enterprise
    ///     automatically, or `null` if the user has to accept the invite.
    ///   - isAutoRollIn: Whether the user is added to the enterprise automatically, without
    ///     having to accept the invite. When `true`, `auto_roll_in_at` contains
    ///     the date and time of the roll-in.
    public init(id: String, type: InviteTypeField = InviteTypeField.invite, invitedTo: InviteInvitedToField? = nil, actionableBy: UserMini? = nil, invitedBy: UserMini? = nil, status: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, autoRollInAt: TriStateField<Date> = nil, isAutoRollIn: Bool? = nil) {
        self.id = id
        self.type = type
        self.invitedTo = invitedTo
        self.actionableBy = actionableBy
        self.invitedBy = invitedBy
        self.status = status
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self._autoRollInAt = CodableTriState(state: autoRollInAt)
        self.isAutoRollIn = isAutoRollIn
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(InviteTypeField.self, forKey: .type)
        invitedTo = try container.decodeIfPresent(InviteInvitedToField.self, forKey: .invitedTo)
        actionableBy = try container.decodeIfPresent(UserMini.self, forKey: .actionableBy)
        invitedBy = try container.decodeIfPresent(UserMini.self, forKey: .invitedBy)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        modifiedAt = try container.decodeDateTimeIfPresent(forKey: .modifiedAt)
        autoRollInAt = try container.decodeDateTimeIfPresent(forKey: .autoRollInAt)
        isAutoRollIn = try container.decodeIfPresent(Bool.self, forKey: .isAutoRollIn)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(invitedTo, forKey: .invitedTo)
        try container.encodeIfPresent(actionableBy, forKey: .actionableBy)
        try container.encodeIfPresent(invitedBy, forKey: .invitedBy)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: modifiedAt, forKey: .modifiedAt)
        try container.encodeDateTime(field: _autoRollInAt.state, forKey: .autoRollInAt)
        try container.encodeIfPresent(isAutoRollIn, forKey: .isAutoRollIn)
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
