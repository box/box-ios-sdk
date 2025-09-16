import Foundation

/// A standard representation of a Box Hub, as returned from any
/// Box Hubs API endpoints by default.
public class HubV2025R0: HubBaseV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdBy = "created_by"
        case updatedBy = "updated_by"
        case viewCount = "view_count"
        case isAiEnabled = "is_ai_enabled"
        case isCollaborationRestrictedToEnterprise = "is_collaboration_restricted_to_enterprise"
        case canNonOwnersInvite = "can_non_owners_invite"
        case canSharedLinkBeCreated = "can_shared_link_be_created"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The title given to the Box Hub.
    public let title: String?

    /// The description of the Box Hub. First 200 characters are returned.
    public let description: String?

    /// The date and time when the folder was created. This value may
    /// be `null` for some folders such as the root folder or the trash
    /// folder.
    public let createdAt: Date?

    /// The date and time when the Box Hub was last updated.
    public let updatedAt: Date?

    public let createdBy: UserMiniV2025R0?

    public let updatedBy: UserMiniV2025R0?

    /// The number of views for the Box Hub.
    public let viewCount: Int?

    /// Indicates if AI features are enabled for the Box Hub.
    public let isAiEnabled: Bool?

    /// Indicates if collaboration is restricted to the enterprise.
    public let isCollaborationRestrictedToEnterprise: Bool?

    /// Indicates if non-owners can invite others to the Box Hub.
    public let canNonOwnersInvite: Bool?

    /// Indicates if a shared link can be created for the Box Hub.
    public let canSharedLinkBeCreated: Bool?

    /// Initializer for a HubV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier that represent a Box Hub.
    ///     
    ///     The ID for any Box Hub can be determined
    ///     by visiting a Box Hub in the web application
    ///     and copying the ID from the URL. For example,
    ///     for the URL `https://*.app.box.com/hubs/123`
    ///     the `hub_id` is `123`.
    ///   - type: The value will always be `hubs`.
    ///   - title: The title given to the Box Hub.
    ///   - description: The description of the Box Hub. First 200 characters are returned.
    ///   - createdAt: The date and time when the folder was created. This value may
    ///     be `null` for some folders such as the root folder or the trash
    ///     folder.
    ///   - updatedAt: The date and time when the Box Hub was last updated.
    ///   - createdBy: 
    ///   - updatedBy: 
    ///   - viewCount: The number of views for the Box Hub.
    ///   - isAiEnabled: Indicates if AI features are enabled for the Box Hub.
    ///   - isCollaborationRestrictedToEnterprise: Indicates if collaboration is restricted to the enterprise.
    ///   - canNonOwnersInvite: Indicates if non-owners can invite others to the Box Hub.
    ///   - canSharedLinkBeCreated: Indicates if a shared link can be created for the Box Hub.
    public init(id: String, type: HubBaseV2025R0TypeField = HubBaseV2025R0TypeField.hubs, title: String? = nil, description: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, createdBy: UserMiniV2025R0? = nil, updatedBy: UserMiniV2025R0? = nil, viewCount: Int? = nil, isAiEnabled: Bool? = nil, isCollaborationRestrictedToEnterprise: Bool? = nil, canNonOwnersInvite: Bool? = nil, canSharedLinkBeCreated: Bool? = nil) {
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.createdBy = createdBy
        self.updatedBy = updatedBy
        self.viewCount = viewCount
        self.isAiEnabled = isAiEnabled
        self.isCollaborationRestrictedToEnterprise = isCollaborationRestrictedToEnterprise
        self.canNonOwnersInvite = canNonOwnersInvite
        self.canSharedLinkBeCreated = canSharedLinkBeCreated

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        updatedAt = try container.decodeDateTimeIfPresent(forKey: .updatedAt)
        createdBy = try container.decodeIfPresent(UserMiniV2025R0.self, forKey: .createdBy)
        updatedBy = try container.decodeIfPresent(UserMiniV2025R0.self, forKey: .updatedBy)
        viewCount = try container.decodeIfPresent(Int.self, forKey: .viewCount)
        isAiEnabled = try container.decodeIfPresent(Bool.self, forKey: .isAiEnabled)
        isCollaborationRestrictedToEnterprise = try container.decodeIfPresent(Bool.self, forKey: .isCollaborationRestrictedToEnterprise)
        canNonOwnersInvite = try container.decodeIfPresent(Bool.self, forKey: .canNonOwnersInvite)
        canSharedLinkBeCreated = try container.decodeIfPresent(Bool.self, forKey: .canSharedLinkBeCreated)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeDateTimeIfPresent(field: updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(updatedBy, forKey: .updatedBy)
        try container.encodeIfPresent(viewCount, forKey: .viewCount)
        try container.encodeIfPresent(isAiEnabled, forKey: .isAiEnabled)
        try container.encodeIfPresent(isCollaborationRestrictedToEnterprise, forKey: .isCollaborationRestrictedToEnterprise)
        try container.encodeIfPresent(canNonOwnersInvite, forKey: .canNonOwnersInvite)
        try container.encodeIfPresent(canSharedLinkBeCreated, forKey: .canSharedLinkBeCreated)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
