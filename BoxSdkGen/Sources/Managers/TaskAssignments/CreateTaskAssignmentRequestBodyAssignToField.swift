import Foundation

public class CreateTaskAssignmentRequestBodyAssignToField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case login
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The ID of the user to assign to the
    /// task.
    /// 
    /// To specify a user by their email
    /// address use the `login` parameter.
    public let id: String?

    /// The email address of the user to assign to the task.
    /// To specify a user by their user ID please use the `id` parameter.
    public let login: String?

    /// Initializer for a CreateTaskAssignmentRequestBodyAssignToField.
    ///
    /// - Parameters:
    ///   - id: The ID of the user to assign to the
    ///     task.
    ///     
    ///     To specify a user by their email
    ///     address use the `login` parameter.
    ///   - login: The email address of the user to assign to the task.
    ///     To specify a user by their user ID please use the `id` parameter.
    public init(id: String? = nil, login: String? = nil) {
        self.id = id
        self.login = login
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        login = try container.decodeIfPresent(String.self, forKey: .login)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
