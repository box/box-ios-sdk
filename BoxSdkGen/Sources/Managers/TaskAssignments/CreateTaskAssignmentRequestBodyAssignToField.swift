import Foundation

public class CreateTaskAssignmentRequestBodyAssignToField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case login
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

}
