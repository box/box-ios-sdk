import Foundation

/// Request body for updating an existing Hub collaboration.
public class HubCollaborationUpdateRequestV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case role
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The level of access granted to hub.
    /// Possible values are `editor`, `viewer`, and `co-owner`.
    public let role: String?

    /// Initializer for a HubCollaborationUpdateRequestV2025R0.
    ///
    /// - Parameters:
    ///   - role: The level of access granted to hub.
    ///     Possible values are `editor`, `viewer`, and `co-owner`.
    public init(role: String? = nil) {
        self.role = role
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decodeIfPresent(String.self, forKey: .role)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(role, forKey: .role)
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
