import Foundation

/// A subject discovered on the source migration system, such as a user or
/// group.
public class ShuttleSubjectV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case email
        case name
        case roles
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether this subject is a user or a group.
    public let type: ShuttleSubjectV2026R0TypeField

    /// The platform-native identifier of the subject. `null` when the system
    /// does not provide one.
    @CodableTriState public private(set) var id: String?

    /// The email address of the subject. `null` when unknown.
    @CodableTriState public private(set) var email: String?

    /// The display name of the subject. `null` when unknown.
    @CodableTriState public private(set) var name: String?

    /// Roles this subject holds on the source. `null` when no roles are known.
    @CodableTriState public private(set) var roles: [ShuttleSubjectRoleV2026R0]?

    /// Initializer for a ShuttleSubjectV2026R0.
    ///
    /// - Parameters:
    ///   - type: Whether this subject is a user or a group.
    ///   - id: The platform-native identifier of the subject. `null` when the system
    ///     does not provide one.
    ///   - email: The email address of the subject. `null` when unknown.
    ///   - name: The display name of the subject. `null` when unknown.
    ///   - roles: Roles this subject holds on the source. `null` when no roles are known.
    public init(type: ShuttleSubjectV2026R0TypeField, id: TriStateField<String> = nil, email: TriStateField<String> = nil, name: TriStateField<String> = nil, roles: TriStateField<[ShuttleSubjectRoleV2026R0]> = nil) {
        self.type = type
        self._id = CodableTriState(state: id)
        self._email = CodableTriState(state: email)
        self._name = CodableTriState(state: name)
        self._roles = CodableTriState(state: roles)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ShuttleSubjectV2026R0TypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        roles = try container.decodeIfPresent([ShuttleSubjectRoleV2026R0].self, forKey: .roles)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _id.state, forKey: .id)
        try container.encode(field: _email.state, forKey: .email)
        try container.encode(field: _name.state, forKey: .name)
        try container.encode(field: _roles.state, forKey: .roles)
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
