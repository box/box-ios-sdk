import Foundation

public class LegalHoldPoliciesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves a list of legal hold policies that belong to
    /// an enterprise.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getLegalHoldPolicies method
    ///   - headers: Headers of getLegalHoldPolicies method
    /// - Returns: The `LegalHoldPolicies`.
    /// - Throws: The `GeneralError`.
    public func getLegalHoldPolicies(queryParams: GetLegalHoldPoliciesQueryParams = GetLegalHoldPoliciesQueryParams(), headers: GetLegalHoldPoliciesHeaders = GetLegalHoldPoliciesHeaders()) async throws -> LegalHoldPolicies {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["policy_name": Utils.Strings.toString(value: queryParams.policyName), "fields": Utils.Strings.toString(value: queryParams.fields), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policies")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try LegalHoldPolicies.deserialize(from: response.data!)
    }

    /// Create a new legal hold policy.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createLegalHoldPolicy method
    ///   - headers: Headers of createLegalHoldPolicy method
    /// - Returns: The `LegalHoldPolicy`.
    /// - Throws: The `GeneralError`.
    public func createLegalHoldPolicy(requestBody: CreateLegalHoldPolicyRequestBody, headers: CreateLegalHoldPolicyHeaders = CreateLegalHoldPolicyHeaders()) async throws -> LegalHoldPolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policies")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try LegalHoldPolicy.deserialize(from: response.data!)
    }

    /// Retrieve a legal hold policy.
    ///
    /// - Parameters:
    ///   - legalHoldPolicyId: The ID of the legal hold policy
    ///     Example: "324432"
    ///   - headers: Headers of getLegalHoldPolicyById method
    /// - Returns: The `LegalHoldPolicy`.
    /// - Throws: The `GeneralError`.
    public func getLegalHoldPolicyById(legalHoldPolicyId: String, headers: GetLegalHoldPolicyByIdHeaders = GetLegalHoldPolicyByIdHeaders()) async throws -> LegalHoldPolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policies/")\(legalHoldPolicyId)", method: "GET", headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try LegalHoldPolicy.deserialize(from: response.data!)
    }

    /// Update legal hold policy.
    ///
    /// - Parameters:
    ///   - legalHoldPolicyId: The ID of the legal hold policy
    ///     Example: "324432"
    ///   - requestBody: Request body of updateLegalHoldPolicyById method
    ///   - headers: Headers of updateLegalHoldPolicyById method
    /// - Returns: The `LegalHoldPolicy`.
    /// - Throws: The `GeneralError`.
    public func updateLegalHoldPolicyById(legalHoldPolicyId: String, requestBody: UpdateLegalHoldPolicyByIdRequestBody = UpdateLegalHoldPolicyByIdRequestBody(), headers: UpdateLegalHoldPolicyByIdHeaders = UpdateLegalHoldPolicyByIdHeaders()) async throws -> LegalHoldPolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policies/")\(legalHoldPolicyId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try LegalHoldPolicy.deserialize(from: response.data!)
    }

    /// Delete an existing legal hold policy.
    /// 
    /// This is an asynchronous process. The policy will not be
    /// fully deleted yet when the response returns.
    ///
    /// - Parameters:
    ///   - legalHoldPolicyId: The ID of the legal hold policy
    ///     Example: "324432"
    ///   - headers: Headers of deleteLegalHoldPolicyById method
    /// - Throws: The `GeneralError`.
    public func deleteLegalHoldPolicyById(legalHoldPolicyId: String, headers: DeleteLegalHoldPolicyByIdHeaders = DeleteLegalHoldPolicyByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/legal_hold_policies/")\(legalHoldPolicyId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
