import Foundation

public protocol Authentication {
    func retrieveToken(networkSession: NetworkSession?) async throws -> AccessToken

    func refreshToken(networkSession: NetworkSession?) async throws -> AccessToken

    func retrieveAuthorizationHeader(networkSession: NetworkSession?) async throws -> String

    func revokeToken(networkSession: NetworkSession?) async throws

    func downscopeToken(scopes: [String], resource: String?, sharedLink: String?, networkSession: NetworkSession?) async throws -> AccessToken

}
