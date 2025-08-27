import Foundation

public class InvitesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Invites an existing external user to join an enterprise.
    /// 
    /// The existing user can not be part of another enterprise and
    /// must already have a Box account. Once invited, the user will receive an
    /// email and are prompted to accept the invitation within the
    /// Box web application.
    /// 
    /// This method requires the "Manage An Enterprise" scope enabled for
    /// the application, which can be enabled within the developer console.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createInvite method
    ///   - queryParams: Query parameters of createInvite method
    ///   - headers: Headers of createInvite method
    /// - Returns: The `Invite`.
    /// - Throws: The `GeneralError`.
    public func createInvite(requestBody: CreateInviteRequestBody, queryParams: CreateInviteQueryParams = CreateInviteQueryParams(), headers: CreateInviteHeaders = CreateInviteHeaders()) async throws -> Invite {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/invites")", method: "POST", params: queryParamsMap, headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Invite.deserialize(from: response.data!)
    }

    /// Returns the status of a user invite.
    ///
    /// - Parameters:
    ///   - inviteId: The ID of an invite.
    ///     Example: "213723"
    ///   - queryParams: Query parameters of getInviteById method
    ///   - headers: Headers of getInviteById method
    /// - Returns: The `Invite`.
    /// - Throws: The `GeneralError`.
    public func getInviteById(inviteId: String, queryParams: GetInviteByIdQueryParams = GetInviteByIdQueryParams(), headers: GetInviteByIdHeaders = GetInviteByIdHeaders()) async throws -> Invite {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/invites/")\(inviteId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try Invite.deserialize(from: response.data!)
    }

}
