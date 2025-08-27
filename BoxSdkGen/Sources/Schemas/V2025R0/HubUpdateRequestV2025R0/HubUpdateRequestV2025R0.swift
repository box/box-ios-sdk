import Foundation

/// Request schema for updating an existing Hub.
public class HubUpdateRequestV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case isAiEnabled = "is_ai_enabled"
        case isCollaborationRestrictedToEnterprise = "is_collaboration_restricted_to_enterprise"
        case canNonOwnersInvite = "can_non_owners_invite"
        case canSharedLinkBeCreated = "can_shared_link_be_created"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Title of the Hub. It cannot be empty and should be less than 50 characters.
    public let title: String?

    /// Description of the Hub.
    public let description: String?

    /// Indicates if AI features are enabled for the Hub.
    public let isAiEnabled: Bool?

    /// Indicates if collaboration is restricted to the enterprise.
    public let isCollaborationRestrictedToEnterprise: Bool?

    /// Indicates if non-owners can invite others to the Hub.
    public let canNonOwnersInvite: Bool?

    /// Indicates if a shared link can be created for the Hub.
    public let canSharedLinkBeCreated: Bool?

    /// Initializer for a HubUpdateRequestV2025R0.
    ///
    /// - Parameters:
    ///   - title: Title of the Hub. It cannot be empty and should be less than 50 characters.
    ///   - description: Description of the Hub.
    ///   - isAiEnabled: Indicates if AI features are enabled for the Hub.
    ///   - isCollaborationRestrictedToEnterprise: Indicates if collaboration is restricted to the enterprise.
    ///   - canNonOwnersInvite: Indicates if non-owners can invite others to the Hub.
    ///   - canSharedLinkBeCreated: Indicates if a shared link can be created for the Hub.
    public init(title: String? = nil, description: String? = nil, isAiEnabled: Bool? = nil, isCollaborationRestrictedToEnterprise: Bool? = nil, canNonOwnersInvite: Bool? = nil, canSharedLinkBeCreated: Bool? = nil) {
        self.title = title
        self.description = description
        self.isAiEnabled = isAiEnabled
        self.isCollaborationRestrictedToEnterprise = isCollaborationRestrictedToEnterprise
        self.canNonOwnersInvite = canNonOwnersInvite
        self.canSharedLinkBeCreated = canSharedLinkBeCreated
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isAiEnabled = try container.decodeIfPresent(Bool.self, forKey: .isAiEnabled)
        isCollaborationRestrictedToEnterprise = try container.decodeIfPresent(Bool.self, forKey: .isCollaborationRestrictedToEnterprise)
        canNonOwnersInvite = try container.decodeIfPresent(Bool.self, forKey: .canNonOwnersInvite)
        canSharedLinkBeCreated = try container.decodeIfPresent(Bool.self, forKey: .canSharedLinkBeCreated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(isAiEnabled, forKey: .isAiEnabled)
        try container.encodeIfPresent(isCollaborationRestrictedToEnterprise, forKey: .isCollaborationRestrictedToEnterprise)
        try container.encodeIfPresent(canNonOwnersInvite, forKey: .canNonOwnersInvite)
        try container.encodeIfPresent(canSharedLinkBeCreated, forKey: .canSharedLinkBeCreated)
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
