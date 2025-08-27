import Foundation

public class OAuthConfig {
    public let clientId: String

    public let clientSecret: String

    public let tokenStorage: TokenStorage

    public init(clientId: String, clientSecret: String, tokenStorage: TokenStorage = InMemoryTokenStorage()) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.tokenStorage = tokenStorage
    }

}
