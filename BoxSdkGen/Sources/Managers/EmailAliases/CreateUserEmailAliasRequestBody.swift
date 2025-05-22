import Foundation

public class CreateUserEmailAliasRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case email
    }

    /// The email address to add to the account as an alias.
    /// 
    /// Note: The domain of the email alias needs to be registered
    ///  to your enterprise.
    /// See the [domain verification guide](
    ///   https://support.box.com/hc/en-us/articles/4408619650579-Domain-Verification
    ///   ) for steps to add a new domain.
    public let email: String

    /// Initializer for a CreateUserEmailAliasRequestBody.
    ///
    /// - Parameters:
    ///   - email: The email address to add to the account as an alias.
    ///     
    ///     Note: The domain of the email alias needs to be registered
    ///      to your enterprise.
    ///     See the [domain verification guide](
    ///       https://support.box.com/hc/en-us/articles/4408619650579-Domain-Verification
    ///       ) for steps to add a new domain.
    public init(email: String) {
        self.email = email
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
    }

}
