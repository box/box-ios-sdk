import Foundation

public class DeveloperTokenConfig {
    public let clientId: String?

    public let clientSecret: String?

    public init(clientId: String? = nil, clientSecret: String? = nil) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

}
