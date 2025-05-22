import Foundation

public class SignRequestsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Cancels a sign request.
    ///
    /// - Parameters:
    ///   - signRequestId: The ID of the signature request
    ///     Example: "33243242"
    ///   - headers: Headers of cancelSignRequest method
    /// - Returns: The `SignRequest`.
    /// - Throws: The `GeneralError`.
    public func cancelSignRequest(signRequestId: String, headers: CancelSignRequestHeaders = CancelSignRequestHeaders()) async throws -> SignRequest {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/sign_requests/")\(signRequestId)\("/cancel")", method: "POST", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SignRequest.deserialize(from: response.data!)
    }

    /// Resends a signature request email to all outstanding signers.
    ///
    /// - Parameters:
    ///   - signRequestId: The ID of the signature request
    ///     Example: "33243242"
    ///   - headers: Headers of resendSignRequest method
    /// - Throws: The `GeneralError`.
    public func resendSignRequest(signRequestId: String, headers: ResendSignRequestHeaders = ResendSignRequestHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/sign_requests/")\(signRequestId)\("/resend")", method: "POST", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Gets a sign request by ID.
    ///
    /// - Parameters:
    ///   - signRequestId: The ID of the signature request
    ///     Example: "33243242"
    ///   - headers: Headers of getSignRequestById method
    /// - Returns: The `SignRequest`.
    /// - Throws: The `GeneralError`.
    public func getSignRequestById(signRequestId: String, headers: GetSignRequestByIdHeaders = GetSignRequestByIdHeaders()) async throws -> SignRequest {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/sign_requests/")\(signRequestId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SignRequest.deserialize(from: response.data!)
    }

    /// Gets signature requests created by a user. If the `sign_files` and/or
    /// `parent_folder` are deleted, the signature request will not return in the list.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getSignRequests method
    ///   - headers: Headers of getSignRequests method
    /// - Returns: The `SignRequests`.
    /// - Throws: The `GeneralError`.
    public func getSignRequests(queryParams: GetSignRequestsQueryParams = GetSignRequestsQueryParams(), headers: GetSignRequestsHeaders = GetSignRequestsHeaders()) async throws -> SignRequests {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit), "senders": Utils.Strings.toString(value: queryParams.senders), "shared_requests": Utils.Strings.toString(value: queryParams.sharedRequests)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/sign_requests")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SignRequests.deserialize(from: response.data!)
    }

    /// Creates a signature request. This involves preparing a document for signing and
    /// sending the signature request to signers.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createSignRequest method
    ///   - headers: Headers of createSignRequest method
    /// - Returns: The `SignRequest`.
    /// - Throws: The `GeneralError`.
    public func createSignRequest(requestBody: SignRequestCreateRequest, headers: CreateSignRequestHeaders = CreateSignRequestHeaders()) async throws -> SignRequest {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/sign_requests")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try SignRequest.deserialize(from: response.data!)
    }

}
