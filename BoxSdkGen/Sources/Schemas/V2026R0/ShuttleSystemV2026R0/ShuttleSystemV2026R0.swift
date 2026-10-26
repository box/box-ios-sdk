import Foundation

/// A standard representation of a shuttle system. A shuttle system describes a
/// source or destination that Shuttle can migrate content to or from, along
/// with its current connection state.
public class ShuttleSystemV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case systemType = "system_type"
        case state
        case type
        case label
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for the shuttle system.
    public let id: String

    /// The display name of the shuttle system.
    public let name: String

    /// Identifies the kind of source or destination this system represents, for
    /// example `box`, `windows`, `sharepoint`, or `amazon_s3`. New system types
    /// are added over time, so clients must tolerate values they do not
    /// recognize rather than treating this as a fixed set.
    public let systemType: String

    /// The current connection state of the shuttle system.
    public let state: ShuttleSystemV2026R0StateField

    /// The value will always be `shuttle_system`.
    public let type: ShuttleSystemV2026R0TypeField

    /// A server-computed display label for the system.
    public let label: String?

    /// Initializer for a ShuttleSystemV2026R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shuttle system.
    ///   - name: The display name of the shuttle system.
    ///   - systemType: Identifies the kind of source or destination this system represents, for
    ///     example `box`, `windows`, `sharepoint`, or `amazon_s3`. New system types
    ///     are added over time, so clients must tolerate values they do not
    ///     recognize rather than treating this as a fixed set.
    ///   - state: The current connection state of the shuttle system.
    ///   - type: The value will always be `shuttle_system`.
    ///   - label: A server-computed display label for the system.
    public init(id: String, name: String, systemType: String, state: ShuttleSystemV2026R0StateField, type: ShuttleSystemV2026R0TypeField = ShuttleSystemV2026R0TypeField.shuttleSystem, label: String? = nil) {
        self.id = id
        self.name = name
        self.systemType = systemType
        self.state = state
        self.type = type
        self.label = label
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        systemType = try container.decode(String.self, forKey: .systemType)
        state = try container.decode(ShuttleSystemV2026R0StateField.self, forKey: .state)
        type = try container.decode(ShuttleSystemV2026R0TypeField.self, forKey: .type)
        label = try container.decodeIfPresent(String.self, forKey: .label)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(systemType, forKey: .systemType)
        try container.encode(state, forKey: .state)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(label, forKey: .label)
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
