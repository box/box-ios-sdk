import Foundation

/// A mini representation of a user, as can be returned when nested within other
/// resources.
public class UserMiniV2025R0: UserBaseV2025R0 {
    private enum CodingKeys: String, CodingKey {
        case name
        case login
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// The display name of this user.
    public let name: String?

    /// The primary email address of this user.
    public let login: String?

    /// Initializer for a UserMiniV2025R0.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this user.
    ///   - type: The value will always be `user`.
    ///   - name: The display name of this user.
    ///   - login: The primary email address of this user.
    public init(id: String, type: UserBaseV2025R0TypeField = UserBaseV2025R0TypeField.user, name: String? = nil, login: String? = nil) {
        self.name = name
        self.login = login

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        login = try container.decodeIfPresent(String.self, forKey: .login)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(login, forKey: .login)
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
