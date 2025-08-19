import Foundation

/// A hub collaboration object grants a user or group access 
/// to a hub with permissions defined by a specific role.
public class HubCollaborationV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case hub
        case accessibleBy = "accessible_by"
        case role
        case status
        case acceptanceRequirementsStatus = "acceptance_requirements_status"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this collaboration.
    public let id: String

    /// The value will always be `hub_collaboration`.
    public let type: HubCollaborationV2025R0TypeField

    public let hub: HubBaseV2025R0?

    public let accessibleBy: HubAccessGranteeV2025R0?

    /// The level of access granted to hub.
    /// Possible values are `editor`, `viewer`, and `co-owner`.
    public let role: String?

    /// The status of the collaboration invitation. If the status
    /// is `pending`, `login` and `name` return an empty string.
    public let status: HubCollaborationV2025R0StatusField?

    public let acceptanceRequirementsStatus: HubCollaborationV2025R0AcceptanceRequirementsStatusField?

    /// Initializer for a HubCollaborationV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this collaboration.
    ///   - type: The value will always be `hub_collaboration`.
    ///   - hub: 
    ///   - accessibleBy: 
    ///   - role: The level of access granted to hub.
    ///     Possible values are `editor`, `viewer`, and `co-owner`.
    ///   - status: The status of the collaboration invitation. If the status
    ///     is `pending`, `login` and `name` return an empty string.
    ///   - acceptanceRequirementsStatus: 
    public init(id: String, type: HubCollaborationV2025R0TypeField = HubCollaborationV2025R0TypeField.hubCollaboration, hub: HubBaseV2025R0? = nil, accessibleBy: HubAccessGranteeV2025R0? = nil, role: String? = nil, status: HubCollaborationV2025R0StatusField? = nil, acceptanceRequirementsStatus: HubCollaborationV2025R0AcceptanceRequirementsStatusField? = nil) {
        self.id = id
        self.type = type
        self.hub = hub
        self.accessibleBy = accessibleBy
        self.role = role
        self.status = status
        self.acceptanceRequirementsStatus = acceptanceRequirementsStatus
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(HubCollaborationV2025R0TypeField.self, forKey: .type)
        hub = try container.decodeIfPresent(HubBaseV2025R0.self, forKey: .hub)
        accessibleBy = try container.decodeIfPresent(HubAccessGranteeV2025R0.self, forKey: .accessibleBy)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        status = try container.decodeIfPresent(HubCollaborationV2025R0StatusField.self, forKey: .status)
        acceptanceRequirementsStatus = try container.decodeIfPresent(HubCollaborationV2025R0AcceptanceRequirementsStatusField.self, forKey: .acceptanceRequirementsStatus)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(hub, forKey: .hub)
        try container.encodeIfPresent(accessibleBy, forKey: .accessibleBy)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(acceptanceRequirementsStatus, forKey: .acceptanceRequirementsStatus)
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
