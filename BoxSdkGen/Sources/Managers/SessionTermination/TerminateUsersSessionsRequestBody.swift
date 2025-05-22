import Foundation

public class TerminateUsersSessionsRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case userIds = "user_ids"
        case userLogins = "user_logins"
    }

    /// A list of user IDs
    public let userIds: [String]

    /// A list of user logins
    public let userLogins: [String]

    /// Initializer for a TerminateUsersSessionsRequestBody.
    ///
    /// - Parameters:
    ///   - userIds: A list of user IDs
    ///   - userLogins: A list of user logins
    public init(userIds: [String], userLogins: [String]) {
        self.userIds = userIds
        self.userLogins = userLogins
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userIds = try container.decode([String].self, forKey: .userIds)
        userLogins = try container.decode([String].self, forKey: .userLogins)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userIds, forKey: .userIds)
        try container.encode(userLogins, forKey: .userLogins)
    }

}
