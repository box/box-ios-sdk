import Foundation

/// A Box user or group that a source subject is mapped to.
public class ShuttleTargetSubjectV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case email
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether the Box target is a user or a group.
    public let type: ShuttleTargetSubjectV2026R0TypeField

    /// The Box user or group ID. `null` when the mapping was not created
    /// through this API and is identified by email (user) or name (group)
    /// instead. Skip is represented by `target: null`, not a missing `id`.
    /// Create and update always send `id`.
    @CodableTriState public private(set) var id: String?

    /// The email address of the target. `null` when unknown.
    @CodableTriState public private(set) var email: String?

    /// The display name of the target. `null` when unknown.
    @CodableTriState public private(set) var name: String?

    /// Initializer for a ShuttleTargetSubjectV2026R0.
    ///
    /// - Parameters:
    ///   - type: Whether the Box target is a user or a group.
    ///   - id: The Box user or group ID. `null` when the mapping was not created
    ///     through this API and is identified by email (user) or name (group)
    ///     instead. Skip is represented by `target: null`, not a missing `id`.
    ///     Create and update always send `id`.
    ///   - email: The email address of the target. `null` when unknown.
    ///   - name: The display name of the target. `null` when unknown.
    public init(type: ShuttleTargetSubjectV2026R0TypeField, id: TriStateField<String> = nil, email: TriStateField<String> = nil, name: TriStateField<String> = nil) {
        self.type = type
        self._id = CodableTriState(state: id)
        self._email = CodableTriState(state: email)
        self._name = CodableTriState(state: name)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ShuttleTargetSubjectV2026R0TypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _id.state, forKey: .id)
        try container.encode(field: _email.state, forKey: .email)
        try container.encode(field: _name.state, forKey: .name)
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
