import Foundation

/// Request body for creating a new Hub collaboration.
public class HubCollaborationCreateRequestV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case hub
        case accessibleBy = "accessible_by"
        case role
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Hubs reference.
    public let hub: HubCollaborationCreateRequestV2025R0HubField

    /// The user or group who gets access to the item.
    public let accessibleBy: HubCollaborationCreateRequestV2025R0AccessibleByField

    /// The level of access granted to hub.
    /// Possible values are `editor`, `viewer`, and `co-owner`.
    public let role: String

    /// Initializer for a HubCollaborationCreateRequestV2025R0.
    ///
    /// - Parameters:
    ///   - hub: Hubs reference.
    ///   - accessibleBy: The user or group who gets access to the item.
    ///   - role: The level of access granted to hub.
    ///     Possible values are `editor`, `viewer`, and `co-owner`.
    public init(hub: HubCollaborationCreateRequestV2025R0HubField, accessibleBy: HubCollaborationCreateRequestV2025R0AccessibleByField, role: String) {
        self.hub = hub
        self.accessibleBy = accessibleBy
        self.role = role
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hub = try container.decode(HubCollaborationCreateRequestV2025R0HubField.self, forKey: .hub)
        accessibleBy = try container.decode(HubCollaborationCreateRequestV2025R0AccessibleByField.self, forKey: .accessibleBy)
        role = try container.decode(String.self, forKey: .role)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hub, forKey: .hub)
        try container.encode(accessibleBy, forKey: .accessibleBy)
        try container.encode(role, forKey: .role)
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
