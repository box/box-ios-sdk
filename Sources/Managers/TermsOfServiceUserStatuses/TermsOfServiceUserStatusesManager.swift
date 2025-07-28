import Foundation

public class TermsOfServiceUserStatusesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves an overview of users and their status for a
    /// terms of service, including Whether they have accepted
    /// the terms and when.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getTermsOfServiceUserStatuses method
    ///   - headers: Headers of getTermsOfServiceUserStatuses method
    /// - Returns: The `TermsOfServiceUserStatuses`.
    /// - Throws: The `GeneralError`.
    public func getTermsOfServiceUserStatuses(queryParams: GetTermsOfServiceUserStatusesQueryParams, headers: GetTermsOfServiceUserStatusesHeaders = GetTermsOfServiceUserStatusesHeaders()) async throws -> TermsOfServiceUserStatuses {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["tos_id": Utils.Strings.toString(value: queryParams.tosId), "user_id": Utils.Strings.toString(value: queryParams.userId)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/terms_of_service_user_statuses")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TermsOfServiceUserStatuses.deserialize(from: response.data!)
    }

    /// Sets the status for a terms of service for a user.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createTermsOfServiceStatusForUser method
    ///   - headers: Headers of createTermsOfServiceStatusForUser method
    /// - Returns: The `TermsOfServiceUserStatus`.
    /// - Throws: The `GeneralError`.
    public func createTermsOfServiceStatusForUser(requestBody: CreateTermsOfServiceStatusForUserRequestBody, headers: CreateTermsOfServiceStatusForUserHeaders = CreateTermsOfServiceStatusForUserHeaders()) async throws -> TermsOfServiceUserStatus {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/terms_of_service_user_statuses")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TermsOfServiceUserStatus.deserialize(from: response.data!)
    }

    /// Updates the status for a terms of service for a user.
    ///
    /// - Parameters:
    ///   - termsOfServiceUserStatusId: The ID of the terms of service status.
    ///     Example: "324234"
    ///   - requestBody: Request body of updateTermsOfServiceStatusForUserById method
    ///   - headers: Headers of updateTermsOfServiceStatusForUserById method
    /// - Returns: The `TermsOfServiceUserStatus`.
    /// - Throws: The `GeneralError`.
    public func updateTermsOfServiceStatusForUserById(termsOfServiceUserStatusId: String, requestBody: UpdateTermsOfServiceStatusForUserByIdRequestBody, headers: UpdateTermsOfServiceStatusForUserByIdHeaders = UpdateTermsOfServiceStatusForUserByIdHeaders()) async throws -> TermsOfServiceUserStatus {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/terms_of_service_user_statuses/")\(termsOfServiceUserStatusId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try TermsOfServiceUserStatus.deserialize(from: response.data!)
    }

}
