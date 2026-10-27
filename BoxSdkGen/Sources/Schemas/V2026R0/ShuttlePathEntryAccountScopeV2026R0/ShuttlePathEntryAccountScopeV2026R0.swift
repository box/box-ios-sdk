import Foundation

/// The mapping scope of a path entry that lives under a user or service
/// account. `type` is the discriminator. The remaining fields are the
/// account itself, flattened onto this object — they are not a nested
/// `account` wrapper. `id` here is the account identifier, not the path
/// entry `id`. Copy these fields onto `account` when creating an
/// account-scoped path mapping.
public class ShuttlePathEntryAccountScopeV2026R0: Codable, RawJSONReadable {
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


    /// The value will always be `account`.
    public let type: ShuttlePathEntryAccountScopeV2026R0TypeField

    /// The platform-native identifier of the account that owns this entry.
    /// `null` when the system does not provide one. This is not the path
    /// entry `id`. Maps to `account.id` on an account-scoped path mapping
    /// location.
    @CodableTriState public private(set) var id: String?

    /// The email of the account that owns this entry. This is a
    /// system-native identifier and is not always an RFC 5322 address.
    /// `null` when unknown. Maps to `account.email` on an account-scoped
    /// path mapping location.
    @CodableTriState public private(set) var email: String?

    /// The display name of the account that owns this entry. `null` when
    /// unknown. Maps to `account.name` on an account-scoped path mapping
    /// location.
    @CodableTriState public private(set) var name: String?

    /// Initializer for a ShuttlePathEntryAccountScopeV2026R0.
    ///
    /// - Parameters:
    ///   - type: The value will always be `account`.
    ///   - id: The platform-native identifier of the account that owns this entry.
    ///     `null` when the system does not provide one. This is not the path
    ///     entry `id`. Maps to `account.id` on an account-scoped path mapping
    ///     location.
    ///   - email: The email of the account that owns this entry. This is a
    ///     system-native identifier and is not always an RFC 5322 address.
    ///     `null` when unknown. Maps to `account.email` on an account-scoped
    ///     path mapping location.
    ///   - name: The display name of the account that owns this entry. `null` when
    ///     unknown. Maps to `account.name` on an account-scoped path mapping
    ///     location.
    public init(type: ShuttlePathEntryAccountScopeV2026R0TypeField = ShuttlePathEntryAccountScopeV2026R0TypeField.account, id: TriStateField<String> = nil, email: TriStateField<String> = nil, name: TriStateField<String> = nil) {
        self.type = type
        self._id = CodableTriState(state: id)
        self._email = CodableTriState(state: email)
        self._name = CodableTriState(state: name)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ShuttlePathEntryAccountScopeV2026R0TypeField.self, forKey: .type)
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
