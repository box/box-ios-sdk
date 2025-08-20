import Foundation

public class HubCollaborationCreateRequestV2025R0AccessibleByField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case login
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of collaborator to invite.
    /// Possible values are `user` or `group`.
    public let type: String

    /// The ID of the user or group.
    /// 
    /// Alternatively, use `login` to specify a user by email
    /// address.
    public let id: String?

    /// The email address of the user who gets access to the item.
    /// 
    /// Alternatively, use `id` to specify a user by user ID.
    public let login: String?

    /// Initializer for a HubCollaborationCreateRequestV2025R0AccessibleByField.
    ///
    /// - Parameters:
    ///   - type: The type of collaborator to invite.
    ///     Possible values are `user` or `group`.
    ///   - id: The ID of the user or group.
    ///     
    ///     Alternatively, use `login` to specify a user by email
    ///     address.
    ///   - login: The email address of the user who gets access to the item.
    ///     
    ///     Alternatively, use `id` to specify a user by user ID.
    public init(type: String, id: String? = nil, login: String? = nil) {
        self.type = type
        self.id = id
        self.login = login
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        login = try container.decodeIfPresent(String.self, forKey: .login)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(login, forKey: .login)
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
