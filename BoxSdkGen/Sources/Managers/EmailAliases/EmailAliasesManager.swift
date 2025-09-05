import Foundation

public class EmailAliasesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves all email aliases for a user. The collection
    /// does not include the primary login for the user.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - headers: Headers of getUserEmailAliases method
    /// - Returns: The `EmailAliases`.
    /// - Throws: The `GeneralError`.
    public func getUserEmailAliases(userId: String, headers: GetUserEmailAliasesHeaders = GetUserEmailAliasesHeaders()) async throws -> EmailAliases {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)\("/email_aliases")", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try EmailAliases.deserialize(from: response.data!)
    }

    /// Adds a new email alias to a user account..
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - requestBody: Request body of createUserEmailAlias method
    ///   - headers: Headers of createUserEmailAlias method
    /// - Returns: The `EmailAlias`.
    /// - Throws: The `GeneralError`.
    public func createUserEmailAlias(userId: String, requestBody: CreateUserEmailAliasRequestBody, headers: CreateUserEmailAliasHeaders = CreateUserEmailAliasHeaders()) async throws -> EmailAlias {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)\("/email_aliases")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try EmailAlias.deserialize(from: response.data!)
    }

    /// Removes an email alias from a user.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///     Example: "12345"
    ///   - emailAliasId: The ID of the email alias.
    ///     Example: "23432"
    ///   - headers: Headers of deleteUserEmailAliasById method
    /// - Throws: The `GeneralError`.
    public func deleteUserEmailAliasById(userId: String, emailAliasId: String, headers: DeleteUserEmailAliasByIdHeaders = DeleteUserEmailAliasByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/users/")\(userId)\("/email_aliases/")\(emailAliasId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
