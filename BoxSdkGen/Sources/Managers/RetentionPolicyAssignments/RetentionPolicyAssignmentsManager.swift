import Foundation

public class RetentionPolicyAssignmentsManager {
    public let auth: Authentication?

    public let networkSession: NetworkSession

    public init(auth: Authentication? = nil, networkSession: NetworkSession = NetworkSession()) {
        self.auth = auth
        self.networkSession = networkSession
    }

    /// Returns a list of all retention policy assignments associated with a specified
    /// retention policy.
    ///
    /// - Parameters:
    ///   - retentionPolicyId: The ID of the retention policy.
    ///     Example: "982312"
    ///   - queryParams: Query parameters of getRetentionPolicyAssignments method
    ///   - headers: Headers of getRetentionPolicyAssignments method
    /// - Returns: The `RetentionPolicyAssignments`.
    /// - Throws: The `GeneralError`.
    public func getRetentionPolicyAssignments(retentionPolicyId: String, queryParams: GetRetentionPolicyAssignmentsQueryParams = GetRetentionPolicyAssignmentsQueryParams(), headers: GetRetentionPolicyAssignmentsHeaders = GetRetentionPolicyAssignmentsHeaders()) async throws -> RetentionPolicyAssignments {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["type": Utils.Strings.toString(value: queryParams.type), "fields": Utils.Strings.toString(value: queryParams.fields), "marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policies/")\(retentionPolicyId)\("/assignments")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RetentionPolicyAssignments.deserialize(from: response.data!)
    }

    /// Assigns a retention policy to an item.
    ///
    /// - Parameters:
    ///   - requestBody: Request body of createRetentionPolicyAssignment method
    ///   - headers: Headers of createRetentionPolicyAssignment method
    /// - Returns: The `RetentionPolicyAssignment`.
    /// - Throws: The `GeneralError`.
    public func createRetentionPolicyAssignment(requestBody: CreateRetentionPolicyAssignmentRequestBody, headers: CreateRetentionPolicyAssignmentHeaders = CreateRetentionPolicyAssignmentHeaders()) async throws -> RetentionPolicyAssignment {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policy_assignments")", method: "POST", headers: headersMap, data: try requestBody.serialize(), contentType: "application/json", responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RetentionPolicyAssignment.deserialize(from: response.data!)
    }

    /// Retrieves a retention policy assignment
    ///
    /// - Parameters:
    ///   - retentionPolicyAssignmentId: The ID of the retention policy assignment.
    ///     Example: "1233123"
    ///   - queryParams: Query parameters of getRetentionPolicyAssignmentById method
    ///   - headers: Headers of getRetentionPolicyAssignmentById method
    /// - Returns: The `RetentionPolicyAssignment`.
    /// - Throws: The `GeneralError`.
    public func getRetentionPolicyAssignmentById(retentionPolicyAssignmentId: String, queryParams: GetRetentionPolicyAssignmentByIdQueryParams = GetRetentionPolicyAssignmentByIdQueryParams(), headers: GetRetentionPolicyAssignmentByIdHeaders = GetRetentionPolicyAssignmentByIdHeaders()) async throws -> RetentionPolicyAssignment {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["fields": Utils.Strings.toString(value: queryParams.fields)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policy_assignments/")\(retentionPolicyAssignmentId)", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try RetentionPolicyAssignment.deserialize(from: response.data!)
    }

    /// Removes a retention policy assignment
    /// applied to content.
    ///
    /// - Parameters:
    ///   - retentionPolicyAssignmentId: The ID of the retention policy assignment.
    ///     Example: "1233123"
    ///   - headers: Headers of deleteRetentionPolicyAssignmentById method
    /// - Throws: The `GeneralError`.
    public func deleteRetentionPolicyAssignmentById(retentionPolicyAssignmentId: String, headers: DeleteRetentionPolicyAssignmentByIdHeaders = DeleteRetentionPolicyAssignmentByIdHeaders()) async throws {
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policy_assignments/")\(retentionPolicyAssignmentId)", method: "DELETE", headers: headersMap, responseFormat: ResponseFormat.noContent, auth: self.auth, networkSession: self.networkSession))
    }

    /// Returns a list of files under retention for a retention policy assignment.
    ///
    /// - Parameters:
    ///   - retentionPolicyAssignmentId: The ID of the retention policy assignment.
    ///     Example: "1233123"
    ///   - queryParams: Query parameters of getFilesUnderRetentionPolicyAssignment method
    ///   - headers: Headers of getFilesUnderRetentionPolicyAssignment method
    /// - Returns: The `FilesUnderRetention`.
    /// - Throws: The `GeneralError`.
    public func getFilesUnderRetentionPolicyAssignment(retentionPolicyAssignmentId: String, queryParams: GetFilesUnderRetentionPolicyAssignmentQueryParams = GetFilesUnderRetentionPolicyAssignmentQueryParams(), headers: GetFilesUnderRetentionPolicyAssignmentHeaders = GetFilesUnderRetentionPolicyAssignmentHeaders()) async throws -> FilesUnderRetention {
        let queryParamsMap: [String: String] = Utils.Dictionary.prepareParams(map: ["marker": Utils.Strings.toString(value: queryParams.marker), "limit": Utils.Strings.toString(value: queryParams.limit)])
        let headersMap: [String: String] = Utils.Dictionary.prepareParams(map: Utils.Dictionary.merge([:], headers.extraHeaders))
        let response: FetchResponse = try await self.networkSession.networkClient.fetch(options: FetchOptions(url: "\(self.networkSession.baseUrls.baseUrl)\("/2.0/retention_policy_assignments/")\(retentionPolicyAssignmentId)\("/files_under_retention")", method: "GET", params: queryParamsMap, headers: headersMap, responseFormat: ResponseFormat.json, auth: self.auth, networkSession: self.networkSession))
        return try FilesUnderRetention.deserialize(from: response.data!)
    }

}
