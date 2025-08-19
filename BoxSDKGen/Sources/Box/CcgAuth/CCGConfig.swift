import Foundation

public class CCGConfig {
    /// Box API key used for identifying the application the user is authenticating with
    public let clientId: String

    /// Box API secret used for making auth requests.
    public let clientSecret: String

    /// The ID of the Box Developer Edition enterprise.
    public let enterpriseId: String?

    /// The user id to authenticate. This value is not required. But if it is provided, then the user will be auto-authenticated at the time of the first API call.
    public let userId: String?

    /// Object responsible for storing token. If no custom implementation provided,the token will be stored in memory.
    public let tokenStorage: TokenStorage

    /// Initializer for a CCGConfig.
    ///
    /// - Parameters:
    ///   - clientId: Box API key used for identifying the application the user is authenticating with
    ///   - clientSecret: Box API secret used for making auth requests.
    ///   - enterpriseId: The ID of the Box Developer Edition enterprise.
    ///   - userId: The user id to authenticate. This value is not required. But if it is provided, then the user will be auto-authenticated at the time of the first API call.
    ///   - tokenStorage: Object responsible for storing token. If no custom implementation provided,the token will be stored in memory.
    public init(clientId: String, clientSecret: String, enterpriseId: String? = nil, userId: String? = nil, tokenStorage: TokenStorage = InMemoryTokenStorage()) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.enterpriseId = enterpriseId
        self.userId = userId
        self.tokenStorage = tokenStorage
    }

}
