import Foundation

public class ExternalUsersManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Delete external users from current user enterprise. This will remove each
    /// external user from all invited collaborations within the current enterprise.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createExternalUserSubmitDeleteJobV2025R0 method
    ///   - headers: Headers of createExternalUserSubmitDeleteJobV2025R0 method
    /// - Returns: The `ExternalUsersSubmitDeleteJobResponseV2025R0`.
    /// - Throws: The `GeneralError`.
    public func createExternalUserSubmitDeleteJobV2025R0(requestBody: ExternalUsersSubmitDeleteJobRequestV2025R0, headers: CreateExternalUserSubmitDeleteJobV2025R0Headers = CreateExternalUserSubmitDeleteJobV2025R0Headers()) async throws -> ExternalUsersSubmitDeleteJobResponseV2025R0 {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge(["box-version": Utils.Strings.toString(value: headers.boxVersion)], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/external_users/submit_delete_job")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try ExternalUsersSubmitDeleteJobResponseV2025R0.deserialize(from: response.data!)
    }

}
