import Foundation

public class RetentionPoliciesManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Retrieves all of the retention policies for an enterprise.
    ///
    /// - Parameters:
    ///   - queryParams: Query parameters of getRetentionPolicies method
    ///   - headers: Headers of getRetentionPolicies method
    /// - Returns: The `RetentionPolicies`.
    /// - Throws: The `GeneralError`.
    public func getRetentionPolicies(queryParams: GetRetentionPoliciesQueryParams = GetRetentionPoliciesQueryParams(), headers: GetRetentionPoliciesHeaders = GetRetentionPoliciesHeaders()) async throws -> RetentionPolicies {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["policy_name": Utils.Strings.toString(value: queryParams.policyName), "policy_type": Utils.Strings.toString(value: queryParams.policyType), "created_by_user_id": Utils.Strings.toString(value: queryParams.createdByUserId), "fields": Utils.Strings.toString(value: queryParams.fields), "limit": Utils.Strings.toString(value: queryParams.limit), "marker": Utils.Strings.toString(value: queryParams.marker)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policies")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RetentionPolicies.deserialize(from: response.data!)
    }

    /// Creates a retention policy.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createRetentionPolicy method
    ///   - headers: Headers of createRetentionPolicy method
    /// - Returns: The `RetentionPolicy`.
    /// - Throws: The `GeneralError`.
    public func createRetentionPolicy(requestBody: CreateRetentionPolicyRequestBody, headers: CreateRetentionPolicyHeaders = CreateRetentionPolicyHeaders()) async throws -> RetentionPolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policies")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RetentionPolicy.deserialize(from: response.data!)
    }

    /// Retrieves a retention policy.
    ///
    /// - Parameters:
    ///   - retentionPolicyId: The ID of the retention policy.
    ///     Example: "982312"
    ///   - queryParams: Query parameters of getRetentionPolicyById method
    ///   - headers: Headers of getRetentionPolicyById method
    /// - Returns: The `RetentionPolicy`.
    /// - Throws: The `GeneralError`.
    public func getRetentionPolicyById(retentionPolicyId: String, queryParams: GetRetentionPolicyByIdQueryParams = GetRetentionPolicyByIdQueryParams(), headers: GetRetentionPolicyByIdHeaders = GetRetentionPolicyByIdHeaders()) async throws -> RetentionPolicy {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policies/")\(retentionPolicyId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RetentionPolicy.deserialize(from: response.data!)
    }

    /// Updates a retention policy.
    ///
    /// - Parameters:
    ///   - retentionPolicyId: The ID of the retention policy.
    ///     Example: "982312"
    ///   - requestBody: Request body of updateRetentionPolicyById method
    ///   - headers: Headers of updateRetentionPolicyById method
    /// - Returns: The `RetentionPolicy`.
    /// - Throws: The `GeneralError`.
    public func updateRetentionPolicyById(retentionPolicyId: String, requestBody: UpdateRetentionPolicyByIdRequestBody = UpdateRetentionPolicyByIdRequestBody(), headers: UpdateRetentionPolicyByIdHeaders = UpdateRetentionPolicyByIdHeaders()) async throws -> RetentionPolicy {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policies/")\(retentionPolicyId)", method: "PUT", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RetentionPolicy.deserialize(from: response.data!)
    }

    /// Permanently deletes a retention policy.
    ///
    /// - Parameters:
    ///   - retentionPolicyId: The ID of the retention policy.
    ///     Example: "982312"
    ///   - headers: Headers of deleteRetentionPolicyById method
    /// - Throws: The `GeneralError`.
    public func deleteRetentionPolicyById(retentionPolicyId: String, headers: DeleteRetentionPolicyByIdHeaders = DeleteRetentionPolicyByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policies/")\(retentionPolicyId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

}
