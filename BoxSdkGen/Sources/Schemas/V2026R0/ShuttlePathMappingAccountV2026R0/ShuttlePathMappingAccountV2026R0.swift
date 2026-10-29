import Foundation

/// The account that owns an account-scoped path mapping location.
public class ShuttlePathMappingAccountV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
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


    /// The platform-native identifier of the account. `null` when the system
    /// does not provide one.
    @CodableTriState public private(set) var id: String?

    /// The email address of the account. `null` when unknown.
    @CodableTriState public private(set) var email: String?

    /// The display name of the account. `null` when unknown.
    @CodableTriState public private(set) var name: String?

    /// Initializer for a ShuttlePathMappingAccountV2026R0.
    ///
    /// - Parameters:
    ///   - id: The platform-native identifier of the account. `null` when the system
    ///     does not provide one.
    ///   - email: The email address of the account. `null` when unknown.
    ///   - name: The display name of the account. `null` when unknown.
    public init(id: TriStateField<String> = nil, email: TriStateField<String> = nil, name: TriStateField<String> = nil) {
        self._id = CodableTriState(state: id)
        self._email = CodableTriState(state: email)
        self._name = CodableTriState(state: name)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
